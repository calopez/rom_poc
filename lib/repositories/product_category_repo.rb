module Persistence
  module Repo
    class ProductCategory < ROM::Repository
      # using Sequel::S
      def create(descendant_name, ancestor_id: nil)
        category.transaction(rollback: :always) do
          descendant = category.create(descendant_name)
          ancestor_id ||= descendant.id
          tree.changeset(
            :create, tree.generate_descendant(ancestor_id, descendant.id).to_a
          ).map(:add_timestamps).commit
          # .associate(descendant) generate duplicate pk error
          # with associate(descendant) it should return the category with its nested associations
          categories.combine(:subcategories).where(id: descendant.id).to_a
        end
      end

      def index
        res = tree.dataset.select {
          [
            path_length,
            ancestor.as(:node),
            Sequel.string_agg(Sequel.cast_string(:descendant), '.').as(:descendants)
          ]
        }.where(path_length: 1).group(:path_length, :ancestor).unordered
        # res struct
        # e.g [{:path_length=>1, :node=>59, :descendants=>"60.61"},
        #      {:path_length=>1, :node=>56, :descendants=>"57.59"},
        #      {:path_length=>1, :node=>61, :descendants=>"62.65"},
        #      {:path_length=>1, :node=>57, :descendants=>"58"}]

        dict = res.each_with_object({}) do |row, struct|
          struct[row[:node].to_s] = row[:descendants]
        end
        # dict struct
        # e.g {"59"=>"60.61", "56"=>"57.59", "61"=>"62.65", "57"=>"58"}
        generate_tree(dict, '56')
      end

      private

      def tree
        product_category_tree
      end

      def category
        product_categories
      end

      def generate_tree(dict, root, tree = {})
        path = dict.fetch(root, '').split('.')
        tree[root] = { id: root, name: category_map[root], children: [] }
        path.each do |child|
          tree[root][:children].push(generate_tree(dict, child, tree))
          # perhaps make the sum here
        end
        tree[root]
      end

      # @return e.g {56=>"All",  57=>"Physical", .. }
      def category_map
        category.all.to_a.each_with_object({}) do |acc, cat|
          acc[cat[:id].to_s] = cat[:name]
        end
      end
    end # end-class
  end
end
