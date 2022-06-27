# frozen_string_literal: true

require_relative '../models/page'
require 'hashids'

class ShortUrlByHashService
  class PageNotFoundError < StandardError; end

  def initialize(page_hash)
    @page_hash = page_hash
  end

  def find
    page = Page[page_id]

    raise PageNotFoundError if page.nil?

    page
  end

  private

  def page_id
    Hashids.new('salt').decode(@page_hash).first
  end
end
