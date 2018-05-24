require "bundler/setup"
require 'sqlite3'
require 'rom'
require 'rom-sql'

class Accounts < ROM::Relation[:sql]
  schema(:accounts, infer: true) do
    attribute :code, Types::String
    associations do
      has_many :user_accounts
      has_many :users, through: :user_accounts
    end
  end
end

class Users < ROM::Relation[:sql]
  schema(:users, infer: true) do
    associations do
      has_many :user_accounts
      has_many :accounts, through: :user_accounts
    end
  end

  class Accounts < ROM::Relation[:sql]
    schema(:user_accounts, infer: true) do
      associations do
        belongs_to :accounts
        belongs_to :users
      end
    end
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

      create_table :accounts do
        primary_key :id
        string :code, null: false
      end

      create_table :user_accounts do
        foreign_key :user_id, :users
        foreign_key :account_id, :accounts
        primary_key %i[user_id account_id], name: :user_accounts_pk
      end
    end
  end
  migration.apply(gateway.connection, :up)

  config.register_relation Accounts
  config.register_relation Users
  config.register_relation Users::Accounts
end

def rom
  ROM_ENV
end

# rom.relations[:accounts].join(:users).select(:id).dataset.sql
# issue https://github.com/rom-rb/rom-sql/issues/279
# should generate:
# ---------------
# "SELECT `accounts`.`id`
# FROM `accounts`
# INNER JOIN `user_accounts` ON (`accounts`.`id` = `user_accounts`.`account_id`)
# INNER JOIN `users` ON (`user_accounts`.`user_id` = `users`.`id`) ORDER BY `accounts`.`id`"