require 'rom'
require 'rom-sql'

module Persistence
  module Relations
    class ProductCategories < ROM::Relation[:sql]
      schema(:product_categories, infer: true)
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