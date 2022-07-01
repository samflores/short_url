# frozen_string_literal: true

require_relative './integration_helper'
require_relative '../config/db_connection'

describe 'URL Shortener' do
  describe 'page creation' do
    describe 'with valid URL' do
      it 'creates a new page' do
        hasher = MiniTest::Mock.new
        hasher.expect(:encode, 'AB', [Integer])

        Hashids.stub(:new, hasher) do
          visit '/'
          fill_in 'target_url', with: 'http://google.com'
          click_button 'Encurtar'
        end

        page.must_have_content 'http://localhost:4567/AB'
      end
    end

    describe 'with blank URL' do
      it 'shows an error message' do
        visit '/'
        fill_in 'target_url', with: ''
        click_button 'Encurtar'
        page.must_have_content 'target_url is not present'
      end
    end
  end

  describe 'page loading' do
    describe 'when the page is found' do
      it 'redirects to the target url' do
        model = Page.create(target_url: 'http://other-test.com')

        hasher = MiniTest::Mock.new
        hasher.expect(:decode, [model.id], ['AB'])

        Hashids.stub(:new, hasher) do
          visit '/AB'
        end

        page.must_have_current_path 'http://other-test.com'
      end

      it 'registers that the page was visited' do
        page = Page.create(target_url: 'http://other-test.com')
        page_id = page.id

        hasher = MiniTest::Mock.new
        hasher.expect(:decode, [page.id], ['AB'])

        Hashids.stub(:new, hasher) do
          prev_count = PageVisit.where(page_id: page_id).count
          visit '/AB'
          _(PageVisit.where(page_id: page_id).count).must_equal(prev_count + 1)
        end
      end
    end

    describe 'when there is not a page associated with the link' do
      it 'shows an error page' do
        hasher = MiniTest::Mock.new
        hasher.expect(:decode, [42], ['XY'])

        Hashids.stub(:new, hasher) do
          visit '/XY'
        end

        page.must_have_content 'Unable to locate link'
      end
    end

  end

  describe 'page stats' do
    describe 'when the page is found' do
      describe 'and has no visits yet' do
        it 'display a no visits message' do
          model = Page.create(target_url: 'http://other-test.com')
  
          hasher = MiniTest::Mock.new
          hasher.expect(:decode, [model.id], ['AB'])
  
          Hashids.stub(:new, hasher) do
            visit '/AB/stats'
          end
  
          page.must_have_content 'Target: http://other-test.com'
          page.must_have_content 'This link has no visits yet'
        end
      end

      describe 'and has some stats' do
        it '' do
          model = Page.create(target_url: 'http://other-test.com')
  
          hasher = MiniTest::Mock.new
          hasher.expect(:decode, [model.id], ['AB'])

          TrackVisitService.new(model).track
  
          Hashids.stub(:new, hasher) do
            visit '/AB/stats'
          end
  
          page.must_have_content 'Target: http://other-test.com'
          page.must_have_content 'Visits: 1'
        end
      end
    end

    describe 'when there is not a page associated with the link' do
    end
  end
end
