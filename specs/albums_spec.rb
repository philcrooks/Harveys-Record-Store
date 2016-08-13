require('minitest/autorun')
require('minitest/rg')
require_relative('../models/albums')
require_relative('../models/artists')

# Tests for CRUD functionality in the albums model

class TestAlbums < Minitest::Test
  def setup
    # Need to setup some artists that the Albums can use
    @artist1 = Artist.new( { "name" => "The Beatles", "genre" => "popular" })
    @artist1.save
    @artist2 = Artist.new( { "name" => "Muddy Waters", "genre" => "blues" })
    @artist2.save
    @artist3 = Artist.new( { "name" => "T.Rex", "genre" => "popular" })
    @artist3.save

    # Clear the albums table - if this fails the tests will fail
    Album.destroy()

    # Create some albums for the tests
    @album1 = Album.new( { "name" => "Abbey Road", "artist_id" => @artist1.id })

    id serial4 primary key,
    name varchar(255),
    artist_id int4 references artists(id) on delete cascade

  end

  def test_01_album_initalize
    # Make sure that all the fields can be read
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