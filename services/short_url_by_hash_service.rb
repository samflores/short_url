require_relative '../config/db_connection'
require 'hashids'

class ShortUrlByHashService
  def initialize(page_hash)
    @page_hash = page_hash
  end

  def find
    page = DB[:pages].where(id: @page_hash).first
    
    page[:target_url]
  end
end