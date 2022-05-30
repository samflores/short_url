require_relative '../config/db_connection'
require 'hashids'

class CreateShortUrlService
  def initialize(url)
    @url = url
  end

  def create
    page_id = DB[:pages].insert(target_url: @url)
    
    Hashids.new('salt').encode(page_id)
  end
end