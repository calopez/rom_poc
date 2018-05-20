require 'rom'
require 'rom-sql'
require 'rom/plugins/command/timestamps'
module Persistence
  module Commands
    class CreateUomCategory < ROM::Commands::Create[:sql]
      relation :product_uom_categories
      register_as :create_uom_category
      use :timestamps
      timestamps :created_at, :updated_at # needed
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

