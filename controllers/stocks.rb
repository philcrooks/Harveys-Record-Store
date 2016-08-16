# RESTful code for the stock pages
# Stock control is the raison d'etre of the application so other classes may not need as rich as rich a feature set.

# NEW
get '/stocks/new' do
  # Show the user a form to enter stock details
  album_id = 0
  album_id = params['album'].to_i if params['album']
  @album = EmptyAlbum.new
  @albums = []
  if album_id > 0
    @album = Album.by_id(album_id)
    @artist = Artist.by_id(@album.artist_id)
    @albums = Album.by_artist(@album.artist_id)
  end
  erb( :"stocks/new" )
end

# CREATE
post '/stocks' do
  # The user has POSTed the stock NEW form
  stock = Stock.new( params )
  stock.save
  @stock = LinkedStock.new(stock)
  erb( :"stocks/show" )
end

# INDEX
get '/stocks' do
  # The user wants to see all the stock
  # There will probably be multiple ways of viewing an index
  @heading = "Stock List"
  index_type = params['index']
  if index_type == "flat"
    @stocks = Stock.all.map{ | s | LinkedStock.new( s ) }.sort
    erb( :"stocks/flatindex")
  else
    erb( :"stocks/nestedindex")
  end
end

# SHOW
get '/stocks/:id' do
  # The user wants to see the details for one stock entry
  stock = Stock.by_id( params['id'].to_i )
  if stock
    @stock = LinkedStock.new(stock)
    erb ( :"stocks/show")
  else
    halt 404, "Stock not found"
  end
end

# EDIT
get '/stocks/:id/edit' do
  # Show the user a form to edit stock details
  # Use the same form as the NEW page
  stock = Stock.by_id( params['id'].to_i )
  if stock
    @stock = LinkedStock.new(stock)
    erb( :"stocks/edit" )
  else
    halt 404, "Stock not found"
  end
end

# UPDATE
post '/stocks/:id' do
  @stock = Stock.new( params )
  @stock.update
  redirect( to( "/stocks/#{@stock.id}" ) )
end

# DELETE
post '/stocks/:id/delete' do
  stock = Stock.by_id( params['id'].to_i )
  if stock
    Stock.destroy( stock.id )
    redirect( to( "/stocks?index=flat" ) )
  else
    halt 404, "Stock not found"
  end
end