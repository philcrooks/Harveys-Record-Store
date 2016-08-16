require('minitest/autorun')
require('minitest/rg')
require_relative('../models/artists')
require_relative('../db/sql_runner')

# Tests for CRUD functionality in the artists model
# The artist is the simplets model with no dependency on any other table
# This test should be run first as other test will depend on it.

class TestArtists < Minitest::Test
  # def self.test_order
  #  :alpha
  # end

  def setup
    Artist.destroy()  # delete everything before the test
    @artist1 = Artist.new( { "name" => "The Beatles", "genre" => "popular" })
    @artist2 = Artist.new( { "name" => "Muddy Waters", "genre" => "blues" })
    @artist3 = Artist.new( { "name" => "T.Rex", "genre" => "popular" })
    @artist1.save
    @artist2.save
  end
  
  def test_01_artist_initialize
    # Test an artist can been created and fields can be accessed
    assert_equal("T.Rex", @artist3.name)
    assert_equal("popular", @artist3.genre)
    assert_equal(0, @artist3.id)
  end

  def test_02_artist_save
    assert_equal(true, @artist1.id > 0)
    assert_equal(@artist1.id + 1, @artist2.id)
  end

  def test_03_artist_retrieve
    artists = Artist.all
    assert_equal(2, artists.count)
    artist = artists.last
    assert_equal(@artist2.id, artist.id)
    assert_equal(@artist2.name, artist.name)
    assert_equal(@artist2.genre, artist.genre)
  end

  def test_04_artist_update
    @artist1.genre = "pop"
    @artist1.name = "The Rolling Stones"
    @artist1.update
    artist = Artist.all.last
    assert_equal("pop", artist.genre)
    assert_equal("The Rolling Stones", artist.name)
  end

  def test_05_artist_retrieve_by_id
    id = @artist2.id
    artist = Artist.by_id( id )
    assert_equal(id, artist.id)
  end

  def test_06_artist_delete
    @artist1.delete()
    @artist2.delete()
    artists = Artist.all
    assert_equal(0, artists.count)
  end

  def test_07_artist_genre_list
    genre = Artist.genre()
    # genre.sort!
    assert_equal(2, genre.count)
    assert_equal("blues", genre[0])
    assert_equal("popular", genre[1])
  end

  def test_08_artist_by_genre
    artists = Artist.by_genre("popular")
    assert_equal(1, artists.count)
    assert_equal("The Beatles", artists.first.name)
  end

  def test_09_artist_exists
    assert_equal(true, Artist.exists?(@artist1.name))
    assert_equal(false, Artist.exists?("Coldplay"))
  end

  # def test_99
  #   requests = SqlRunner.requests
  #   requests.each { | r | puts r }
  # end
end