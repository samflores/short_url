# frozen_string_literal: true

require_relative './config/environment'

require 'sinatra'
require 'sinatra/flash'
require 'sinatra/reloader' unless ENVIRONMENT == 'production'
require 'date'

require_relative './models/page_visit'
require_relative './services/create_short_url_service'
require_relative './services/short_url_by_hash_service'
require_relative './services/track_visit_service'
require_relative './services/get_short_url_stats_service'

configure do
  enable :sessions
  set :session_secret, 'sekret'
  register Sinatra::Flash
end

get '/' do
  erb :new
end

post '/create' do
  url = params['target_url']

  @page_id = CreateShortUrlService.new(url).create

  erb :created
rescue CreateShortUrlService::InvalidPageError => e
  flash[:error_title] = 'Unable to create link'
  e.errors.full_messages.each do |message|
    flash[:error_details] = message
  end
  redirect '/'
end

get '/:id' do
  id = params['id']

  @page = ShortUrlByHashService.new(id).find

  TrackVisitService.new(@page).track

  redirect @page.target_url
rescue ShortUrlByHashService::PageNotFoundError
  flash[:error_title] = 'Unable to locate link'
  redirect '/'
end

get '/:page_hash/stats' do
  @page_hash = params['page_hash']

  @stats = GetShortUrlStatsService.new(@page_hash).get_stats

  if @stats[:visits_count] > 0
    @visits_message = "Visits: #{@stats[:visits_count]}"
  else 
    @visits_message = "This link has no visits yet"
  end

  erb :stats
end
