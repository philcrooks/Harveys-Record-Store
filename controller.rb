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
  stocks = Stock.attention_needed()
  @stocks = stocks.map{ | s | LinkedStock.new( s ) }.sort
  erb( :"stocks/flatindex")
end