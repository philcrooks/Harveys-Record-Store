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
    @id = Stock.destroy( @id )
    return @id
  end

  def initialize ( options )
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
    return Stock.new( stock.first )
  end

  def self.destroy( id = nil )
    DbInterface.delete( TABLE, id )
    return nil
  end
end