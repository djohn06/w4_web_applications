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

  context 'GET /albums/:id' do
    xit 'returns info of album 1' do
      response = get('/albums/1')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Doolittle</h1>')
      expect(response.body).to include('<h1>Artist: Pixies</h1>')
    end
  end

  context "GET /albums" do
    xit 'Gets a list of albums' do
      response = get("/albums")

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Title: Surfer Rosa</h1>')
      expect(response.body).to include('<h1>Rleased: 1988</h1>')
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
      expect(response.body).to eq("Pixies, ABBA, Taylor Swift, Nina Simone")
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