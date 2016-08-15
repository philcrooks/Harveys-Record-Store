require_relative( 'artists' )
require_relative( 'albums' )
# require_relative( 'stocks' )

class LinkedStock

  attr_reader :stock, :album, :artist

  def <=>( neighbour )
    result = @artist <=> neighbour.artist
    result = @album <=> neighbour.album if result == 0
    result = @stock.format <=> neighbour.stock.format if result == 0
    return result
  end

  def initialize( stock )
    @stock = stock
    @album = Album.by_id(@stock.album_id)
    @artist = Artist.by_id(@album.artist_id)
  end
end