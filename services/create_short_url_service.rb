# frozen_string_literal: true

require_relative '../models/page'
require 'hashids'

class CreateShortUrlService
  class InvalidPageError < StandardError
    attr_reader :errors

    def initialize(msg, errors)
      @errors = errors
      super(msg)
    end
  end

  def initialize(url)
    @url = url
  end

  def create
    page = Page.new(target_url: @url)

    raise InvalidPageError.new('Invalid', page.errors) unless page.valid?

    page.save_changes

    Hashids.new('salt').encode(page.id)
  end
end
