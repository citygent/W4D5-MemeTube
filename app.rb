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
  video = @db.exec(sql).first
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
get '/videos/:id/edit' do
  sql = "SELECT * FROM videos WHERE id = #{params['id']}"
  @video = @db.exec(sql).first
  @header = "Edit Entry #{@video['title']}"
  erb :edit
end

#UPDATE - post, route to change fields in db
post '/videos/:id' do
  sql = "UPDATE videos SET title = '#{params['title']}', description = '#{params['description']}' WHERE id = #{params['id']}"
  @db.exec(sql)
  redirect to "videos/#{params['id']}"
end

#DELETE - post, route that deletes rows in db
post '/videos/:id/delete' do
  sql = "DELETE FROM videos WHERE id = #{params['id']}"
  @db.exec(sql)
  redirect to '/videos'
end
