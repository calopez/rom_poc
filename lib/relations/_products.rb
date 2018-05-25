require 'rom'
require 'rom-sql'

module Persistence
  module Relations
    class Products < ROM::Relation[:sql]
      schema(:products, infer: true) do
        associations do
          belongs_to :suppliers
        end
      end

      def listing
        select(:id, :description, :price).order(:id)
      end

      def with_suppliers
        combine(:suppliers)
      end
    end
  end
end
