require 'rom'
require 'rom-sql'

module Persistence
  module Relations
    class ProductCategories < ROM::Relation[:sql]
      schema(:product_categories, infer: true) do
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

      def all
        select(:id, :name)
      end

    end
  end
end
