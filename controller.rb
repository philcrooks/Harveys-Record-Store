require('sinatra')
require('sinatra/contrib/all')
require_relative('models/artists')
require_relative('models/empty_artists')
require_relative('models/albums')
require_relative('models/empty_albums')
require_relative('models/stocks')
require_relative('models/linked_stocks')
require_relative('controllers/artists')
require_relative('controllers/albums')
require_relative('controllers/stocks')
require('pry-byebug')

get '/' do
  redirect( to( '/home' ) )
end

get '/home' do
  @heading = "Low Stock"
  stocks = Stock.attention_needed()
  @stocks = stocks.map{ | s | LinkedStock.new( s ) }.sort
  @origin = "home"
  erb( :"stocks/flatindex")
end