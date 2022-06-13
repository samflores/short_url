# frozen_string_literal: true

require_relative '../config/db_connection'

class Page < Sequel::Model
  plugin :validation_helpers

  def validate
    super
    validates_presence [:target_url]
  end
end
