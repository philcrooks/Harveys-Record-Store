# RESTful code for the artists pages

# NEW
get '/artists/new' do
  # Show the user a form to enter artist details
  @action = "/artists"
  @button_text = "Create Artist"
  @genre = Artist.genre()
  @artist = EmptyArtist.new()
  @heading = "New Artist"
  erb( :"artists/form" )
end

# CREATE
post '/artists' do
  # The user has POSTed the stock NEW form
  artist = Artist.new( params )
  if !Artist.exists?( artist )
    artist.genre.downcase!
    artist.save
    redirect( to( "/artists" ) )
  else
    @message = "<b>#{artist.name}</b> already exists in the database"
    @goto = "/artists/new"
    erb( :error )
  end
end

# INDEX
get '/artists' do
  # The user wants to see all the stock
  @artists = Artist.all
  erb( :"artists/index")
end

# SHOW
# get '/artists/:id' do
#   # The user wants to see the details for one artist
#   id = params['id'].to_i
#   if Artist.id_range.member?( id )
#     @artist = Artist.by_id( id )
#     erb ( :"artists/show")
#   end
# end

# EDIT
get '/artists/:id/edit' do
  # Show the user a form to edit an artist
  # Use the same form as the NEW page
  @artist = Artist.by_id( params['id'].to_i )
  if @artist
    @action = "/artists/#{@artist.id}"
    @button_text = "Update Artist"
    @genre = Artist.genre()
    @heading = "Edit Artist"
    erb( :"artists/form" )
  else
    halt 404, "Artist not found"
  end
end

# UPDATE
post '/artists/:id' do
  artist = Artist.new( params )
  if !Artist.exists?( artist )
    artist.update
    redirect( to( "/artists" ) )
  else
    @message = "<b>#{artist.name}</b> already exists in the database"
    @goto = "/artists/#{artist.id}/edit"
    erb( :error )
  end
end

# DELETE
post '/artists/:id/delete' do
  artist = Artist.by_id( params['id'].to_i )
  if artist
    Artist.destroy( artist.id )
    redirect( to( "/artists" ) )
  else
    halt 404, "Artist not found"
  end
end