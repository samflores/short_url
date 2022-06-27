require_relative '../unit_helper'
require_relative '../../services/track_visit_service'
require_relative '../../models/page'
require_relative '../../models/page_visit'

describe TrackVisitService do
  it 'creates an entry in PageVists table' do
    page = Page.create(target_url: 'http://other-test.com')

    prev_count = PageVisit.count
    TrackVisitService.new(page).track
    _(PageVisit.count).must_equal(prev_count + 1)
  end
end
