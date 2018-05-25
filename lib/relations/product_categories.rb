require 'rom'
require 'rom-sql'

module Persistence
  module Relations
    class ProductCategories < ROM::Relation[:sql]
      schema(:product_categories, infer: true) do
        # attribute :id, Types::ForeignKey(:product_category_tree)
        associations do
          has_many :products
          has_many :product_category_tree,
                   as:      :subcategories,
                   foreign_key: :ancestor
          has_many :product_category_tree,
                   as:        :parent_categories,
                   foreign_key: :descendant
        end
      end

      def path_to(category_id)
        assoc(:ancestors)
          .select(self[:name], :ancestor)
          .where(descendant: category_id)
      end
      # categories.assoc(:ancestors).select{ [`product_categories.name`,  ancestor] }
      # .where{ { ancestor: product_categories[:id]} }.to_a
      #
      # Example
      # categories.assoc(:ancestors)
      # .where{
      # (product_category_tree[:path_length] > product_categories[:id])
      # |
      # (product_category_tree[:ancestor] =~ 9)
      # }.to_a
      # categories.assoc(:subcategories)
      # .where{ (id =~ 65) & (product_category_tree[:ancestor] !~ product_category_tree[:descendant] ) }


      # Using multiple FROM tables and setting conditions in the WHERE clause is an old-school way of joining tables:
      # DB.from(:albums, :artists).where{{artists[:id]=>albums[:artist_id]}}
      # # SELECT * FROM albums, artists WHERE (artists.id = albums.artist_id)
      def all
        select(:id, :name)
      end

    end
  end
end

# rom.relations[:product_uom_categories]
# .command(:create, result: :many)
# .call([{ name: 'weight' }, { name: 'working time' }])
#
# changeset = rom.relations[:product_uom_categories]
#                 .changeset(:create, [{name: 'weight'}, {name: 'working_time'}])
#                 .map(:add_timestamps)
# changeset.commit