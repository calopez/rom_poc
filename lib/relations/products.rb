require 'rom'
require 'rom-sql'

module Persistence
  module Relations
    class Products < ROM::Relation[:sql]
      schema(:products, infer: true) do
        associations do
          has_one :product_category
        end
      end
    end
  end
end