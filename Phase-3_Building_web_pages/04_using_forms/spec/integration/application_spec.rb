require "spec_helper"
require "rack/test"
require_relative '../../app'

def reset_tables
  seed_album = File.read('spec/seeds/albums_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(seed_album)

  seed_artist = File.read('spec/seeds/artists_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(seed_artist)
end

describe Application do
  before(:each) do 
    reset_tables
  end

  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  context "GET /album/new" do
    it "should validate album parameters" do
      response = post(
        '/albums',
        invalid_artist_title: 'OK Computer',
        another_invalid_thing: 123
      )

      expect(response.status).to eq(400)
    end

    it "returns the albums form page" do
      response = get('/album/new')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Add an album</h1>')
      expect(response.body).to include('<form action="/albums" method="POST">')
      expect(response.body).to include('<input type="text" name="title" />')
      expect(response.body).to include('<input type="text" name="release_year" />')
      expect(response.body).to include('<input type="text" name="artist_id" />')
    end
  end

  context 'GET /album/:id' do
    it 'returns info of album 1' do
      response = get('/album/1')

      expect(response.status).to eq(200)
      expect(response.body).to include('Doolittle')
      expect(response.body).to include('Artist: Pixies')
    end
  end

  context "GET /albums" do
    it 'Gets a list of albums' do
      response = get("/albums")

      expect(response.status).to eq(200)
      expect(response.body).to include('<a href="/album/2">Title: Surfer Rosa</a>')
      expect(response.body).to include('<a href="/album/3">Title: Waterloo</a>')
      expect(response.body).to include('<a href="/album/4">Title: Super Trouper</a>')
    end
  end

  context "POST /albums" do
    it 'creates a new album' do
      response = post("/albums", title: "Voyage", release_year: "2022", artist_id: "2")

      expect(response.status).to eq(200)
      expect(response.body).to eq("")

      response = get("/albums")
      expect(response.body).to include("Voyage")
    end
  end

  context "GET /artists" do
    it 'Gets a list of artists' do
      response = get("/artists")

      expect(response.status).to eq(200)
      expect(response.body).to include('<a href="/artist/1">Name: Pixies</a>')
      expect(response.body).to include('<a href="/artist/2">Name: ABBA</a>')
      expect(response.body).to include('<a href="/artist/3">Name: Taylor Swift</a>')
    end
  end

  context "GET artist/:id" do
    it "returns html page with details of artist" do
      response = get("/artist/1")

      expect(response.status).to eq(200)
      expect(response.body).to include('Name: Pixies')
      expect(response.body).to include('Genre: Rock')
    end
  end

  context "GET /artist/new" do
    it "returns a form page for adding new artist"do
      response = get("/artist/new")

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Add an artist</h1>')
      expect(response.body).to include('<form action="/artists" method="POST">')
      expect(response.body).to include('<input type="text" name="name" />')
      expect(response.body).to include('<input type="text" name="genre" />')
    end
  end

  context "POST /artists" do
    it 'Creates a new artist' do
      response = post("/artists", name: "Wild nothing", genre: "Indie")

      expect(response.status).to eq(200)
      expect(response.body).to eq("")

      response = get("/artists")
      expect(response.body).to include("Wild nothing")
    end
  end
end