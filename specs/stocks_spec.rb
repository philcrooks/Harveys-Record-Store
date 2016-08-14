require('minitest/autorun')
require('minitest/rg')
require_relative('../models/stocks')
require_relative('../models/albums')
require_relative('../models/artists')

class TestStocks < Minitest::Test
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
    @stock1 = Stock.new( { 'album_id' => @album1.id, 'format' => 'cd', 'stock_level' => 5, 'threshold' => 5, 'buy_price' => 5.00, 'sell_price' => 7.50 } )
    @stock1.save
    @stock2 = Stock.new( { 'album_id' => @album1.id, 'format' => 'vinyl', 'stock_level' => 2, 'threshold' => 3, 'buy_price' => 7.00, 'sell_price' => 15.00 } )
    @stock2.save
    @stock3 = Stock.new( { 'album_id' => @album2.id, 'format' => 'cd', 'stock_level' => 5, 'threshold' => 5, 'buy_price' => 5.00, 'sell_price' => 10.00 } )
    @stock3.save
    @stock4 = Stock.new( { 'album_id' => @album3.id, 'format' => 'cd', 'stock_level' => 1, 'threshold' => 2, 'buy_price' => 7.00, 'sell_price' => 10.00 } )
  end

  def test_01_stock_initalize
    # Make sure that all the fields can be read
    assert_equal(@album3.id, @stock4.album_id)
    assert_equal('cd', @stock4.format)
    assert_equal(1, @stock4.stock_level)
    assert_equal(2, @stock4.threshold)
    assert_equal(7.00, @stock4.buy_price)
    assert_equal(10.00, @stock4.sell_price)
    assert_equal(0, @stock4.id)
  end

  def test_02_stock_save
    assert_equal(true, @stock1.id > 0)
  end

  def test_03_stock_retrieve
    assert_equal(3, Stock.all.count)
  end

  def test_04_stock_update
    # Test that all fields can be updated (except id)
    stock = Stock.all.last
    stock.album_id = @stock4.album_id
    stock.format = @stock4.format
    stock.stock_level = @stock4.stock_level
    stock.threshold = @stock4.threshold
    stock.buy_price = @stock4.buy_price
    stock.sell_price = @stock4.sell_price
    id = stock.id
    stock.update
    stock = Stock.all.last
    assert_equal(id stock.id)
    assert_equal(@stock4.album_id, stock.album_id)
    assert_equal(@stock4.format, stock.format)
    assert_equal(@stock4.stock_level, stock.stock_level)
    assert_equal(@stock4.threshold, stock.threshold)
    assert_equal(@stock4.buy_price, stock.buy_price)
    assert_equal(@stock4.sell_price, stock.sell_price)
  end

  def test_05_stock_retrieve_by_id

  end

  def test_09_stock_destroy

  end

  # Extensions to standard CRUD

  def test_06_stock_by_album
  end

  def test_07_stock_by_artist
  end

  def test_08_stock_by_genre
  end

  def test_99
    requests = SqlRunner.requests
    requests.each { | r | puts r }
  end

end