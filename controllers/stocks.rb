# RESTful code for the stock pages
# Stock control is the raison d'etre of the application so other classes may not need as rich as rich a feature set.

# NEW
get '/stocks/new' do
  # Show the user a form to enter stock details
  artist_id = 0
  artist_id = params['artist'].to_i if params['artist']
  @artist = ""
  @albums = []
  if artist_id > 0
    @artist = Artist.by_id(artist_id)
    @albums = Album.by_artist(artist_id)
  end
  erb( :"stocks/new" )
end

# CREATE
post '/stocks' do
  # The user has POSTed the stock NEW form
  @stock = Stock.new( params )
  @stock.save
  erb( :"stocks/create" )
end

# INDEX
get '/stocks' do
  # The user wants to see all the stock
  # There will probably be multiple ways of viewing an index
  index_type = params['index']
  if index_type == "flat"
    erb( :"stocks/flatindex")
  else
    erb( :"stocks/nestedindex")
  end

end

# SHOW
get '/stocks/:id' do
  # The user wants to see the details for one stock entry
  id = params['id'].to_i
  @stock = stock.by_id( id )
  erb ( :"stocks/show")
end

# EDIT
get '/stocks/:id/edit' do
  # Show the user a form to edit stock details
  # Use the same form as the NEW page
  id = params['id'].to_i
  @action = "/stocks/#{id}"
  @stock = Stock.by_id( id )
  erb( :"stocks/edit" )
end

# UPDATE
post '/stocks/:id' do
  @stock = Stock.new( params )
  @stock.update
  redirect( to( "/stocks/#{@stock.id}" ) )
end

# DELETE
post '/stocks/:id/delete' do
  Stock.destroy( params['id'] )
  redirect( to( "/stocks" ) )
end