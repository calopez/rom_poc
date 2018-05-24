require "bundler/setup"
require 'sqlite3'
require 'rom'
require 'rom-sql'

class User < ROM::Relation[:sql]
  schema(:users, infer: true) do
    associations do has_one :address end
  end
end

class Address < ROM::Relation[:sql]
  schema(:addresses, infer: true) do
    associations do belongs_to :user end
  end
end

ROM_ENV = ROM.container(:sql, 'sqlite::memory') do |config|
  gateway = config.gateways[:default]
  migration = gateway.migration do
    change do
      create_table :users do
        primary_key :id
        string :name, null: false
      end

      create_table :addresses do
        primary_key :id
        string :address_line_1, null: false
        foreign_key :user_id, :users
      end
    end
  end

  migration.apply(gateway.connection, :up)
  config.register_relation User
  config.register_relation Address
end

def rom
  ROM_ENV
end

ADDR = rom.relations[:addresses]
USR = rom.relations[:users]

def address
  ADDR
end

def user
  USR
end

user.transaction do
  u = user.changeset(:create, name: 'carlos').commit
  a = address.changeset(:create, address_line_1: 'Maxella 89 Av').associate(u, :users).commit
end

# rom.relations[:accounts].join(:users).select(:id).dataset.sql
# issue https://github.com/rom-rb/rom-sql/issues/279
# should generate:
# ---------------
# "SELECT `accounts`.`id`
# FROM `accounts`
# INNER JOIN `user_accounts` ON (`accounts`.`id` = `user_accounts`.`account_id`)
# INNER JOIN `users` ON (`user_accounts`.`user_id` = `users`.`id`) ORDER BY `accounts`.`id`"