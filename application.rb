require_relative './config/environment'

require 'sinatra'
require 'sinatra/reloader' unless ENVIRONMENT == 'production'

require_relative './services/create_short_url_service'
require_relative './services/short_url_by_hash_service'

get '/' do
  erb :new
end

post '/create' do
  url = params['target_url']

  @page_id = CreateShortUrlService.new(url).create

  erb :created
end

get '/:id' do
  id = params['id']

  @page = ShortUrlByHashService.new(id).find

  redirect @page
end
