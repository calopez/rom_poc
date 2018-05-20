require 'rom'
require 'rom-sql'
require 'sequel'
require_relative '../../container'

require_relative './../../lib/relations/product_uom_categories'
require_relative './../../lib/relations/product_uom'
require_relative './../../lib/relations/products'
require_relative './../../lib/relations/product_categories'
require_relative './../../lib/repositories/product_category_repo'
require_relative './../../lib/commands/create_uom_category'

Sequel.extension :core_refinements

config = ROM::Configuration.new(
  :sql,
  'postgres://karlosandres@localhost:5432/todo_development',
  extensions: %i[error_sql pg_array pg_json]
)
# rom_config.plugin :sql, relations: :instrumentation do |plugin_config|
#   plugin_config.notifications = notifications
# end

config.plugin :sql, relations: :auto_restrictions
config.plugin :sql, relations: :pg_explain

# config.plugin :sql, commands: :timestamps
# config.plugin :sql, relations: :timestamps

# container.register "db", rom_config.gateways[:default].connection

# lib = File.expand_path('../../lib', __dir__)
# config.auto_registration(lib, namespace: 'Persistence')

config.register_relation(Persistence::Relations::ProductUom)
config.register_relation(Persistence::Relations::ProductUomCategories)
config.register_relation(Persistence::Relations::ProductCategories)
config.register_relation(Persistence::Relations::Products)
config.register_command(Persistence::Commands::CreateUomCategory)

ROM_ENV = ROM.container(config)

Container.register(:rom, ROM_ENV)

def rom
  ROM_ENV
end

def repo
   Persistence::Repo::ProductCategory.new(rom)
end

def categories
   rom.relations[:product_categories]
end

