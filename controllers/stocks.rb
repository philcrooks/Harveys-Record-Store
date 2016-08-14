# RESTful code for the stock pages
# Stock control is the raison d'etre of the application so other classes may not need as rich as rich a feature set.

# NEW
get '/stocks/new' do
  # Show the user a form to enter stock details
  @action = "/stocks"
  erb( :"stocks/form" )
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
  @stock = Stock.all
  erb( :"stocks/index")
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
  erb( :"stocks/form" )
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