# frozen_string_literal: true

require 'sequel'
require_relative './environment'

DB = Sequel.connect(
  adapter: :sqlite,
  database: "db/#{ENVIRONMENT}.db"
)
