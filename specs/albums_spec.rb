require('minitest/autorun')
require('minitest/rg')
require_relative('../models/albums')
require_relative('../models/artists')

# Tests for CRUD functionality in the albums model

class TestAlbums < Minitest::Test
  def setup
    # Need to setup some artists that the Albums can use.
    # The Artist class should be tested first to make sure this code works.
    Artist.destroy()
    @artist1 = Artist.new( { "name" => "The Beatles", "genre" => "popular" })
    @artist1.save
    @artist2 = Artist.new( { "name" => "Muddy Waters", "genre" => "blues" })
    @artist2.save

    # Clear the albums table - if this fails the tests will fail
    Album.destroy()

    # Create some albums for the tests
    @album1 = Album.new( { "name" => "Abbey Road", "artist_id" => @artist1.id } )
    @album1.save
    @album2 = Album.new( { "name" => "The Beatles' White Album", "artist_id" => @artist1.id } )
    @album2.save
    @album3 = Album.new( { "name" => "Let It Be", "artist_id" => @artist1.id } )
  end

  def test_01_album_initalize
    # Make sure that all the fields can be read
    assert_equal("Let It Be", @album3.name)
    assert_equal(@artist1.id, @album3.artist_id)
    assert_equal(0, @album3.id)
  end

  def test_02_album_save
    assert_equal(true, @album1.id > 0)
    assert_equal(@album1.id + 1, @album2.id)
  end

  def test_03_album_retrieve
    assert_equal(2, Album.all.count)
  end

  def test_04_album_update
    # Test that all fields can be updated (except id)
    album = Album.all.last
    assert_equal("The Beatles' White Album", album.name)
    album.name = "Electric Mud"
    album.artist_id = @artist2.id
    album.update
    album = Album.all.last
    assert_equal("Electric Mud", album.name)
  end

  def test_05_album_retrieve_by_id
    id = @album2.id
    album = Album.by_id( id )
    assert_equal(id, album.id)
  end

  def test_06_albums_by_artist
    albums = Album.by_artist(@artist1.id)
    assert_equal(@artist1.id, albums.first.artist_id)
    assert_equal(2, albums.count)
  end

  def test_07_album_destroy
    @album1.delete
    @album2.delete
    assert_equal(0, Album.all.count)
  end
end