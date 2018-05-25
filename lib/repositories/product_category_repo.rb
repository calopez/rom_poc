module Persistence
  module Repo
    class ProductCategory < ROM::Repository
      # using Sequel::S
      def add(name, parent_id:)
        category.transaction do
          category
            .changeset(:create, name: name)
            .map(:add_timestamps).commit.tap do |child|
            parent_id ||= child.id
            categories.changeset(
              :create, categories.generate(
                parent_id: parent_id,
                child_id:  child.id
              ).to_a
            ).commit
          end
        end
      end

      def update(id, name)
        category.by_pk(id).changeset(:update, name: name).commit
      end

      def remove(id)
        category.transaction do
          ids = categories.descendants(parent_id: id).pluck(:descendant)
          # removing a leaf only would need pass `id` instead of `ids`
          categories.where(descendant: ids).changeset(:delete).commit
          category.by_pk(id).changeset(:delete).commit
        end
      end

      def tree
        dict = categories.tree.to_a.each_with_object({}) do |row, struct|
          struct[String(row.node)] = row.descendants.split('.')
        end
        parent = categories.parent.one.ancestor
        parse_tree(dict, parent.to_s)
      end

      private

      def categories
        product_category_tree
      end

      def category
        product_categories
      end

      def parse_tree(dict, root, tree = {})
        path = dict.fetch(root, [])
        tree[root] = { id: root, name: category_map[root], children: [] }
        path.each do |child|
          tree[root][:children].push(parse_tree(dict, child, tree))
          # perhaps make the sum here
        end
        tree[root]
      end

      # @return e.g {56=>"All",  57=>"Physical", .. }
      def category_map
        category.all.to_a.each_with_object({}) do |categories, acc|
          acc[String(categories.id)] = categories.name
        end
      end
    end
  end
end
