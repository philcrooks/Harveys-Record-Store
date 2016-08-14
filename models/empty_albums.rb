require_relative( 'albums' )

class EmptyAlbum < Album

  def initialize()
    super( {} )
  end

  def save()
    # Can't save an empty album
    return nil
  end

end