require 'sinatra'
require 'sinatra/reloader' if development?
require 'pry'
require 'pg'

before do 
  @db = PG.connect(dbname: 'memetube', host: 'localhost')
end

after do
  @db.close
end

#Home/Lander
get '/' do
  redirect '/videos'
end

#INDEX - get, list all videos PAGE
get '/videos' do
  @header = 'Vidz'
  sql = 'SELECT * FROM videos'
  @videos = @db.exec(sql)
  erb :index
end

#NEW - get, returns a form PAGE
get '/videos/new' do
  @header = 'Submit Vidz'
  erb :new
end

#CREATE - post, route to create vid on database, redirects to show
post '/videos' do
  sql = "INSERT INTO videos(title, description, url, date_added, views) VALUES ('#{params['title']}','#{params['description']}','#{params['url']}','NOW','0') returning *"
  video = @db.exec(sql).first['id']
  redirect to "/videos/#{video['id']}"
end

#SHOW - get, a showcase video PAGE with edit link and delete functionality
get '/videos/:id' do
  sql = "SELECT * FROM videos WHERE id = #{params[:id]}"
  @video = @db.exec(sql).first
  # binding.pry
  @header = @video['title']
  erb :show
end

#EDIT - route within show page? KISS: get PAGE with route to UPDATE
#UPDATE - post, route to change fields in db
#DELETE - post, route thaat deletes rows in db

