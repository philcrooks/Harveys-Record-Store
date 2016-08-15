# RESTful code for the artists pages

# NEW
get '/artists/new' do
  # Show the user a form to enter artist details
  @action = "/artists"
  @button_text = "Create Artist"
  @genre = Artist.genre()
  @artist = EmptyArtist.new()
  erb( :"artists/form" )
end

# CREATE
post '/artists' do
  # The user has POSTed the stock NEW form
  @artist = Artist.new( params )
  @artist.genre.downcase!
  @artist.save
  erb( :"artists/create" )
end

# INDEX
get '/artists' do
  # The user wants to see all the stock
  @artists = Artist.all
  erb( :"artists/index")
end

# SHOW
get '/artists/:id' do
  # The user wants to see the details for one artist
  id = params['id'].to_i
  if Artist.id_range.member?( id )
    @artist = Artist.by_id( id )
    erb ( :"artists/show")
  end
end

# EDIT
get '/artists/:id/edit' do
  # Show the user a form to edit an artist
  # Use the same form as the NEW page
  id = params['id'].to_i
  if Artist.id_range.member?( id )
    @action = "/artists/#{id}"
    @button_text = "Update Artist"
    @genre = Artist.genre()
    @artist = Artist.by_id( id )
    erb( :"artists/form" )
  end
end

# UPDATE
post '/artists/:id' do
  @artist = Artist.new( params )
  @artist.update
  redirect( to( "/artists/#{@artist.id}" ) )
end

# DELETE
# post '/artists/:id/delete' do
#   if Artist.id_range.member?( id )
#     Artist.destroy( params['id'].to_i )
#     redirect( to( "/artists" ) )
#   end
# end