# require 'rom-sql'
# require 'rom/sql/rake_task'
#
# namespace :db do
#   task :setup do
#     configuration = ROM::Configuration.new(:sql, 'postgresql://andrii:postgres@localhost:5432/chat_app_dev')
#     # configuration.auto_registration('/path/to/lib')
#     ROM::SQL::RakeSupport.env = ROM.container(configuration)
#   end
# end

# Alternativa:
# ROM::SQL::RakeSupport.env = ROM::Configuration.new(:sql, ENV['DATABASE_URL'])
require 'rom'
require 'rom-sql'
require 'rom/sql/rake_task'

namespace :db do
  task :setup do
    rom_container = ROM.container(
        :sql,
        'postgres://karlosandres@localhost:5432/todo_development',
        extensions: %i[error_sql pg_array pg_json]
        ) do |config|
      # rom_config.plugin :sql, relations: :instrumentation do |plugin_config|
      #   plugin_config.notifications = notifications
      # end
      config.plugin :sql, relations: :auto_restrictions
      config.plugin :sql, relations: :pg_explain
    end
    ROM::SQL::RakeSupport.env = rom_container
  end
end