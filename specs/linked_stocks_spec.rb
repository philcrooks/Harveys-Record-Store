require('minitest/autorun')
require('minitest/rg')
require_relative('../models/stocks')
require_relative('../models/linked_stocks')
require_relative('../models/albums')
require_relative('../models/artists')
require_relative('../db/sql_runner')

class TestLinkedStocks < Minitest::Test
  def setup
    # Need to setup some artists that the Albums can use.
    # The Artist class should be tested first to make sure this code works.
    Artist.destroy()
    @artist1 = Artist.new( { "name" => "The Beatles", "genre" => "popular" })
    @artist1.save
    @artist2 = Artist.new( { "name" => "Muddy Waters", "genre" => "blues" })
    @artist2.save

    # Need to setup some albums that the Stock table can use.
    # The Album class should be tested prior to this to make sure this code will work.
    Album.destroy()
    @album1 = Album.new( { "name" => "Abbey Road", "artist_id" => @artist1.id } )
    @album1.save
    @album2 = Album.new( { "name" => "The Beatles", "artist_id" => @artist1.id } )
    @album2.save
    @album3 = Album.new( { "name" => "Electric Mud", "artist_id" => @artist2.id } )
    @album3.save

    # Create stock for the stock tests. Relying on destroy and save working

    Stock.destroy()
    @stock1 = Stock.new( { 'album_id' => @album1.id, 'format' => 'CD', 'stock_level' => 5, 'threshold' => 5, 'buy_price' => 5.00, 'sell_price' => 7.50 } )
    @stock1.save
    @stock2 = Stock.new( { 'album_id' => @album1.id, 'format' => 'LP', 'stock_level' => 2, 'threshold' => 3, 'buy_price' => 7.00, 'sell_price' => 15.00 } )
    @stock2.save
    @stock3 = Stock.new( { 'album_id' => @album2.id, 'format' => 'CD', 'stock_level' => 5, 'threshold' => 5, 'buy_price' => 5.00, 'sell_price' => 10.00 } )
    @stock3.save
    @stock4 = Stock.new( { 'album_id' => @album3.id, 'format' => 'CD', 'stock_level' => 1, 'threshold' => 2, 'buy_price' => 7.00, 'sell_price' => 10.00 } )
    @linked_stocks = []
    @linked_stocks << LinkedStock.new(@stock1)
    @linked_stocks << LinkedStock.new(@stock2)
    @linked_stocks << LinkedStock.new(@stock3)
    @linked_stocks << LinkedStock.new(@stock4)
  end

  def test_01_linked_stock_initalize
    # Make sure that all the fields can be read
    assert_equal(@stock1, @linked_stocks.first.stock)
    assert_equal(@album1.name , @linked_stocks.first.album.name)
    assert_equal(@artist1.name, @linked_stocks.first.artist.name)
  end

  def test_02_linked_stock_sort
    stocks = @linked_stocks.sort
    assert_equal("Muddy Waters", stocks[0].artist.name)
    assert_equal("Abbey Road", stocks[1].album.name)
    assert_equal("CD", stocks[1].stock.format)
    assert_equal("Abbey Road", stocks[2].album.name)
    assert_equal("LP", stocks[2].stock.format)
    assert_equal("The Beatles", stocks[3].album.name)
  end
end  
