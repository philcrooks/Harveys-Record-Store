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

  def delete()
    @id = Artist.destroy(@id) if @id
    return @id
  end

  def compare_name()
    name = @name.downcase
    return name[4..-1] if name.start_with?("the ")
    return name[1..-1] if name.start_with?("a ")
    return name
  end

  def <=>( neighbour )
    # This should eventually deal with artist names that start with 'The' etc
    return compare_name <=> neighbour.compare_name
  end

  def initialize( options )
    @id = options['id'].to_i
    @name = options['name']
    @genre = options['genre']
  end

  def self.all()
    artists = DbInterface.select( TABLE )
    return artists.map{ |a| Artist.new( a ) }.sort
  end

  def self.by_id( id )
    artists = DbInterface.select( TABLE, id )
    return nil if artists.count == 0
    return Artist.new( artists.first )
  end

  def self.destroy( id = nil )
    DbInterface.delete( TABLE, id )
    return nil
  end

  def self.genre()
    sql = "SELECT DISTINCT genre FROM #{TABLE}"
    genre = SqlRunner.run( sql )
    return genre.map{ | g | g['genre'] }.sort
  end

  def self.by_genre( genre )
    artists = DbInterface.select(TABLE, genre, "genre")
    return artists.map{ |a| Artist.new( a )}.sort
  end

  # def self.id_range()
  #   return DbInterface.id_range( TABLE )
  # end

  def self.exists?( artist )
    sql = "SELECT COUNT(*) AS count FROM artists WHERE name = '%s'" % [artist.name.gsub("'", "''")]
    result = SqlRunner.run( sql )
    return result.first['count'].to_i > 0
  end
end