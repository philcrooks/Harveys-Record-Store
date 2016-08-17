require_relative( '../db/db_interface' )
require( 'pry-byebug' )

class Stock
  TABLE = "stocks"

  attr_reader :id
  attr_accessor :album_id, :format, :stock_level, :threshold, :buy_price, :sell_price

  def save()
    @id = DbInterface.insert(TABLE, self)
    return @id
  end

  def update()
    return DbInterface.update(TABLE, self)
  end

  def delete()
    @id = Stock.destroy( @id ) if @id
    return @id
  end

  def no_stock?()
    return @stock_level == 0
  end

  def low_stock?()
    return @stock_level <= @threshold
  end

  def initialize( options )
    @id = options['id'].to_i
    @album_id = options['album_id'].to_i
    @format = options['format']
    @stock_level = options['stock_level'].to_i
    @threshold = options['threshold'].to_i
    @buy_price = options['buy_price'].to_f
    @sell_price = options['sell_price'].to_f
  end

  def self.all()
    stock = DbInterface.select( TABLE )
    return stock.map { |s| Stock.new( s ) }
  end

  def self.by_id( id )
    stock = DbInterface.select( TABLE, id )
    return nil if stock.count == 0
    return Stock.new( stock.first )
  end

  def self.by_album( album_id )
    stock = DbInterface.select( TABLE, album_id, "album_id" )
    return stock.map { |s| Stock.new( s ) }
  end

  def self.destroy( id = nil )
    DbInterface.delete( TABLE, id )
    return nil
  end

  def self.by_artist( artist_id, format = nil )
    sql = "SELECT s.* FROM stocks s INNER JOIN albums a ON s.album_id = a.id WHERE a.artist_id = #{artist_id}"
    sql += " AND s.format = '#{format}'" if format
    sql += " ORDER BY a.name"
    stock = SqlRunner.run( sql )
    return stock.map { | s | Stock.new( s ) }
  end

  def self.by_genre( genre )
    sql = "SELECT s.* FROM stocks s INNER JOIN albums al ON s.album_id = al.id INNER JOIN artists ar ON al.artist_id = ar.id WHERE ar.genre = '%s'" % [genre.gsub("'", "''")]
    stock = SqlRunner.run( sql )
    return stock.map { | s | Stock.new( s ) }
  end

  def self.formats_by_artist( artist_id )
    sql = "SELECT DISTINCT s.format FROM stocks s INNER JOIN albums a ON s.album_id = a.id WHERE a.artist_id = #{artist_id}"
    stock = SqlRunner.run( sql )
    return stock.map{ | s | s['format'] }.sort
  end

  def self.attention_needed()
    return Stock.all.select { | s | s.stock_level <= s.threshold }
  end

  def self.exists?( stock )
    sql = "SELECT COUNT(*) AS count FROM stocks WHERE album_id = #{stock.album_id} AND format = '#{stock.format}'"
    result = SqlRunner.run( sql )
    return result.first['count'].to_i > 0
  end

  def self.analytics ( stocks )
    return nil if stocks.count == 0
    stock_level = stocks.inject(0) { | total, s | total += s.stock_level }
    buy_for = stocks.inject(0) { | total, s | total += s.stock_level * s.buy_price }
    sell_for = stocks.inject(0) { | total, s | total += s.stock_level * s.sell_price }
    margin = (sell_for == 0) ? 0 : (((sell_for - buy_for) * 100.0) / sell_for).round(2)
    return {level: stock_level, value: sell_for - buy_for, margin: margin }
  end
end