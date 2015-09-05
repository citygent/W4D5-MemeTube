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
  sql = 'SELECT * FROM videos'
  @videos = @db.exec(sql)
  erb :index
end

#NEW - get, returns a form PAGE
#CREATE - post, route to create vid on database, redirects to show
#SHOW - get, a showcase video PAGE with edit link and delete functionality
#EDIT - route within show page? KISS: get PAGE with route to UPDATE
#UPDATE - post, route to change fields in db
#DELETE - post, route thaat deletes rows in db

