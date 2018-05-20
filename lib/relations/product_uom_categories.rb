require 'rom'
require 'rom-sql'
require 'dry-types'

module Persistence
  module Relations
    class ProductUomCategories < ROM::Relation[:sql]
      schema(:product_uom_categories) do
        #  if I do not change the name of the dataset to :product_uom_categories, I get this error:
        # ROM::ElementNotFoundError: :product_uom_categories doesn't exist in ROM::RelationRegistry registry
        associations do
          has_many :product_uom, as: :uom
        end
        attribute :id, Types::Serial
        attribute :name, Types::String
        use :timestamps
        # timestamps :created_at, :updated_at # not needed
      end
    end
  end
end

