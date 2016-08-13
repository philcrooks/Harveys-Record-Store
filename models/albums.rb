require_relative('../db/db_interface')

class Album
  TABLE = "albums"

  attr_reader( :id, :name, :artist_id )

  def save()
    return DbInterface.insert( TABLE, self )
  end

  def update()
    return DbInterface.update( TABLE, self )
  end

  def delete()
    @id = Album.destroy(@id)
    return @id
  end

  def initialize( options )
    @id = options['id'].to_i
    @name = options['name']
    @artist_id = options['artist_id'].to_i
  end

  def self.all()
    albums = DbInterface.select( TABLE ) 
    return albums.map { |a| Album.new( a ) }
  end

  def self.by_id ( id )
    albums = DbInterface.select( TABLE, id ) 
    return Album.new(albums.first)
  end

  def self.by_artist( id )
    albums = DbInterface.select( TABLE, id, "artist_id" ) 
    return albums.map { |a| Album.new( a ) }
  end

  def self.destroy( id = nil )
    DbInterface.delete( TABLE, id )
    return nil
  end

end