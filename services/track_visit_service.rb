require_relative '../models/page'

class TrackVisitService
  def initialize(page)
    @page = page
  end

  def track
    PageVisit.create(visited_at: DateTime.now, page_id: @page.id)
  end
end
