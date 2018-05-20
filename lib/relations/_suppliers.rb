require 'rom'
require 'rom-sql'

# $LOAD_PATH.unshift(File.expand_path('.', __FILE__))
module Persistence
  module Relations
    class Suppliers < ROM::Relation[:sql]
      schema(:suppliers, infer: true) do
        associations do
          has_many :products
        end
      end

      def listing
        select(:id, :name).order(:name)
      end
    end
  end
end

