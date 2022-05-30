require_relative '../unit_helper'
require_relative '../../services/short_url_by_hash_service'

describe ShortUrlByHashService do
  it 'creates a page' do
    page_id = DB[:pages].insert(target_url: 'http://test.com')
    
    hasher = MiniTest::Mock.new
    def hasher.decode(_)
      page_id
    end

    Hashids.stub(:new, hasher) do
      result = ShortUrlByHashService.new(page_id).find
      
      _(result).must_equal "http://test.com"
    end
  end
end
