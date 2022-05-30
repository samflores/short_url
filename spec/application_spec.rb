require_relative './integration_helper'

describe 'URL Shortener' do
  it 'creates a new page' do

    hasher = MiniTest::Mock.new
    def hasher.encode(_)
      'AB'
    end

    Hashids.stub(:new, hasher) do
      visit '/'
      fill_in 'target_url', with: 'http://google.com'
      click_button 'Encurtar'
    end

    page.must_have_content 'http://localhost:4567/AB'
  end
end
