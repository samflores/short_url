# frozen_string_literal: true

require_relative 'unit_helper'

require 'rack/test'
require 'capybara/dsl'
require 'capybara/minitest'
require 'capybara/minitest/spec'
require 'database_cleaner-sequel'

require_relative '../application'

Capybara.app = Sinatra::Application
DatabaseCleaner[:sequel].strategy = :transaction

module Minitest
  class Spec
    include Capybara::DSL
    include Capybara::Minitest::Assertions

    before :each do
      DatabaseCleaner[:sequel].start
    end

    after :each do
      DatabaseCleaner[:sequel].clean
    end
  end
end
