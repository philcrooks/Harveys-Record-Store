require_relative( 'artists' )

class EmptyArtist < Artist

  def initialize()
    super( {} )
  end

  def save()
    # Can't save an empty artist
    return nil
  end

end