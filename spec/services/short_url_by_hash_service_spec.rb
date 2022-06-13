# frozen_string_literal: true

require_relative '../unit_helper'
require_relative '../../services/short_url_by_hash_service'

describe ShortUrlByHashService do
  it 'locates the target URL' do
    page = Page.create(target_url: 'http://test.com')

    hasher = MiniTest::Mock.new
    hasher.expect(:decode, [page.id], ['AB'])

    Hashids.stub(:new, hasher) do
      result = ShortUrlByHashService.new('AB').find

      _(result).must_equal 'http://test.com'
    end
  end
end
