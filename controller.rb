require('sinatra')
require('sinatra/contrib/all')
require_relative('models/artists')
require_relative('models/empty_artists')
require_relative('models/albums')
require_relative('models/empty_albums')
require_relative('controllers/artists')
require_relative('controllers/albums')
require('pry-byebug')

# get '/' do
#   redirect( to( "/artists" ))
# end