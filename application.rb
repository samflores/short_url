require 'sinatra'
require 'sequel'

DB = Sequel.connect(
  adapter: :sqlite,
  database: 'db/development.db'
)

get '/' do
  erb :new
end

post '/create' do
  url = params['target_url']
  @page_id = DB[:pages].insert(target_url: url)
  erb :created
end

get '/:id' do
  id = params['id']
  @page = DB[:pages].where(id: id).first
  redirect @page[:target_url]
end
