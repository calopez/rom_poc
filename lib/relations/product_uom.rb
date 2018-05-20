require 'rom'
require 'rom-sql'

module Persistence
  module Relations
    class ProductUom < ROM::Relation[:sql]
      schema(:product_uom) do
        associations do
          belongs_to :product_uom_categories, as: :category
        end
        attribute :id, Types::Serial
        attribute :category_id, Types::Int
        attribute :name, Types::String
        # CHECK (factor <> 0)
        attribute :factor, Types::Decimal.constrained(not_eql: 0)
        # CHECK (rounding > 0)
        attribute :rounding, Types::Decimal.constrained(gt: 0)
        attribute :active, Types::True | Types::False
        attribute :uom_type, Types::String
        use :timestamps
      end
    end
  end
end