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

    # Clear the albums table - if this fails the tests will fail
    Album.destroy()

    # Create some albums for the tests
    @album1 = Album.new( { "name" => "Abbey Road", "artist_id" => @artist1.id } )
    @album1.save
    @album2 = Album.new( { "name" => "The Beatles", "artist_id" => @artist1.id } )
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
  end

  def test_03_album_retrieve
  end

  def test_04_album_update
  end

  def test_05_album_retrieve_by_id
  end

  def test_06_album_destroy
  end
end