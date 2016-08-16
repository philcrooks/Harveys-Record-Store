# RESTful code for the artists pages

# NEW
get '/albums/new' do
  # Show the user a form to enter artist details
  artist_id = 0
  artist_id = params['artist'].to_i if params['artist']
  @artists = artist_id > 0 ? [Artist.by_id(artist_id)] : Artist.all
  @action = "/albums"
  @heading = "New Album"
  @button_text = "Create"
  @album = EmptyAlbum.new()
  erb( :"albums/form" )
end

# CREATE
post '/albums' do
  # The user has POSTed the stock NEW form
  album = Album.new( params )
  if !Album.exists?(album)
    album.save
    redirect( to( "/albums" ) )
  else
    artist = Artist.by_id(album.artist_id)
    @message = "The album <b>#{album.name}</b> by <b>#{artist.name}</b> already exists in the database."
    @goto = "/albums/new"
    erb( :error )
  end
end

# INDEX
get '/albums' do
  # The user wants to see all the stock
  @albums = Album.all
  erb( :"albums/index")
end

# SHOW
# get '/albums/:id' do
#   # The user wants to see the details for one artist
#   id = params['id'].to_i
#   if Album.id_range.member?( id )
#     @album = Album.by_id( id )
#     @artist = Artist.by_id( @album.artist_id )
#     erb ( :"albums/show")
#   end
# end

# EDIT
get '/albums/:id/edit' do
  # Show the user a form to edit an artist
  # Use the same form as the NEW page
  @album = Album.by_id( params['id'].to_i )
  if @album 
    @action = "/albums/#{@album.id}"
    @button_text = "Update"
    @artists = Artist.all
    @heading = "Edit Album"
    erb( :"albums/form" )
  else
    halt 404, "Album not found"
  end
end

# UPDATE
post '/albums/:id' do
  album = Album.new( params )
  if !Album.exists?(album)
    album.update
    redirect( to( "/albums" ) )
  else
    artist = Artist.by_id(album.artist_id)
    @message = "The album <b>#{album.name}</b> by <b>#{artist.name}</b> already exists in the database."
    @goto = "/albums/#{album.id}/edit"
    erb( :error )
  end
end

# DELETE
post '/albums/:id/delete' do
  album = Album.by_id( params['id'].to_i )
  if album
    Album.destroy( album.id )
    redirect( to( "/albums" ) )
  else
    halt 404, "Album not found"
  end
end