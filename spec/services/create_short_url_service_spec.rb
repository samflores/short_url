# frozen_string_literal: true

require_relative '../unit_helper'
require_relative '../../services/create_short_url_service'

describe CreateShortUrlService do
  describe 'with valid argument' do
    it 'creates a page' do
      hasher = MiniTest::Mock.new
      hasher.expect(:encode, 'AB', [Integer])

      Hashids.stub(:new, hasher) do
        service = CreateShortUrlService.new('http://test.com')

        result = service.create

        _(result).must_equal 'AB'
      end
    end
  end

  describe 'with a nil argument' do
    it 'raises an exception' do
      service = CreateShortUrlService.new(nil)

      _ { service.create }.must_raise CreateShortUrlService::InvalidPageError
    end
  end
end
