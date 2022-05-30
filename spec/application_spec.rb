require_relative './integration_helper'
require_relative '../config/db_connection'

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

  it 'redirects to the target url' do
    page_id = DB[:pages].insert(target_url: 'http://test.com')
    
    hasher = MiniTest::Mock.new
    def hasher.decode(_)
      page_id
    end

    Hashids.stub(:new, hasher) do
      visit "/#{page_id}"
    end

    page.must_have_current_path 'http://test.com'
  end
end
