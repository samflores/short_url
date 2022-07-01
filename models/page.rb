# frozen_string_literal: true

require_relative '../config/db_connection'

class Page < Sequel::Model
  plugin :validation_helpers
  one_to_many :page_visits

  def validate
    super
    validates_presence [:target_url]
  end
end
