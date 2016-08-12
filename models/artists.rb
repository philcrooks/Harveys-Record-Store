require_relative( '../db/db_interface' )

class Artist
  TABLE = "artists"

  attr_reader :id
  attr_accessor :name, :genre

  def save()
    @id = DbInterface.insert(TABLE, self)
    return @id
  end

  def update()
    return DbInterface.update(TABLE, self)
  end

  def initialize( options )
    @id = options['id'].to_i
    @name = options['name']
    @genre = options['genre']
  end

  def self.all()
    artists = DbInterface.select( TABLE )
    return artists.map { |a| Artist.new( a ) }
  end

  def self.by_id( id )
    artists = DbInterface.select( TABLE, id )
    return Artist.new( artists.first )
  end

  def self.destroy( id = nil )
    DbInterface.delete( TABLE, id )
    return nil
  end
end