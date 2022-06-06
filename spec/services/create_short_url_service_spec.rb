# frozen_string_literal: true

require_relative '../unit_helper'
require_relative '../../services/create_short_url_service'

describe CreateShortUrlService do
  it 'creates a page' do
    hasher = MiniTest::Mock.new
    def hasher.encode(_)
      'AB'
    end

    Hashids.stub(:new, hasher) do
      service = CreateShortUrlService.new('http://test.com')

      result = service.create

      _(result).must_equal 'AB'
    end
  end
end
