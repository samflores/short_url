environment = ENV.fetch('RACK_ENV', 'development')

require 'sinatra'
require 'sinatra/reloader' unless environment == 'production'
require 'sequel'
require 'hashids'

DB = Sequel.connect(
  adapter: :sqlite,
  database: "db/#{environment}.db"
)

class Application < Sinatra::Application
  get '/' do
    erb :new
  end

  post '/create' do
    url = params['target_url']
    @page_id = DB[:pages].insert(target_url: url)
    @page_id = Hashids.new('salt').encode(@page_id)
    erb :created
  end

  get '/:id' do
    id = params['id']
    @page = DB[:pages].where(id: id).first
    redirect @page[:target_url]
  end
end
