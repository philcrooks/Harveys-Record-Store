require('sinatra')
require('sinatra/contrib/all')
require_relative('models/artists')
require_relative('models/empty_artists')
require_relative('controllers/artists')
require('pry-byebug')

# get '/' do
#   redirect( to( "/artists" ))
# end