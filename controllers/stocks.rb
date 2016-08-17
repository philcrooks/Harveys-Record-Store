# RESTful code for the stock pages
# Stock control is the raison d'etre of the application so other classes may not need as rich as rich a feature set.

# NEW
get '/stocks/new' do
  # Show the user a form to enter stock details
  album_id = 0
  album_id = params['album'].to_i if params['album']
  if album_id > 0
    @album = Album.by_id(album_id)
    @artist = Artist.by_id(@album.artist_id)
    @albums = Album.by_artist(@album.artist_id)
  else
    # This code will stop a crash but won't be very useful without an artist
    @album = EmptyAlbum.new
    @artist = EmptyArtist.new
    @albums = []
  end
  erb( :"stocks/new" )
end

# CREATE
post '/stocks' do
  # The user has POSTed the stock NEW form
  stock = Stock.new( params )
  if !Stock.exists?(stock)
    stock.save
    # @stock = LinkedStock.new(stock)
    redirect( to( "/albums" ) )
  else
    # Want to tell the user of their mistake and take them back to the /stocks/new page
    album = Album.by_id(stock.album_id)
    artist = Artist.by_id(album.artist_id)
    @message = "The <b>#{stock.format}</b> album <b>#{album.name}</b> by <b>#{artist.name}</b> already exists in the database."
    @goto = "/albums"
    erb( :error )
  end
end

# INDEX
get '/stocks' do
  # The user wants to see all the stock
  # There will probably be multiple ways of viewing an index
  @heading = "Stock List"
  index_type = params['index']
  if index_type == "flat"
    @stocks = Stock.all.map{ | s | LinkedStock.new( s ) }.sort
    @origin = "stocks"
    erb( :"stocks/flatindex")
  else
    erb( :"stocks/nestedindex")
  end
end

# SHOW
get '/stocks/:id' do
  # The user wants to see the details for one stock entry
  # Assume the user wants to delete it
  stock = Stock.by_id( params['id'].to_i )
  if stock
    @stock = LinkedStock.new(stock)
    erb ( :"stocks/delete")
  else
    halt 404, "Stock not found"
  end
end

# EDIT
get '/stocks/:id/edit' do
  # Show the user a form to edit stock details
  # Use the same form as the NEW page
  @origin = params['origin']
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
  origin = params['origin']
  stock = Stock.new( params )
  stock.update
  redirect( to( "/#{origin}?index=flat" ) )
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