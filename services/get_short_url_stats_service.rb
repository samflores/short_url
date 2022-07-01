class GetShortUrlStatsService
  def initialize(page_hash)
    @page = ShortUrlByHashService.new(page_hash).find
  end

  def get_stats
    visits_count = PageVisit.where(page_id: @page.id).count

    recent_visits = PageVisit
      .where(page_id: @page.id)
      .limit(3)
      .order(Sequel.desc(:visited_at))
      .map { |row| row[:visited_at] }
    
    {
      target_url: @page.target_url,
      visits_count: visits_count,
      recent_visits: recent_visits
    }
  end 
end