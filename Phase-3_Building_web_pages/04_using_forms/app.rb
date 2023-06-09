require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/album_repository'
require_relative 'lib/artist_repository'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/album_repository'
    also_reload 'lib/artist_repository'
  end

  get "/" do
    return erb(:index)
  end

  get "/albums" do
    album = AlbumRepository.new

    @albums = album.all

    return erb(:all_albums)
  end

  get '/album/new' do
    return erb(:new_album)
  end

  get '/album/:id' do
    repo = AlbumRepository.new
    artist_repo = ArtistRepository.new

    @album = repo.find(params[:id])
    @artist = artist_repo.find(@album.artist_id)

    return erb(:album)
  end

  post "/albums" do
    if invalid_request_parameters?
      status 400
      return ''
    end

    repo = AlbumRepository.new
    new_album = Album.new
    new_album.title = params[:title]
    new_album.release_year = params[:release_year]
    new_album.artist_id = params[:artist_id]

    repo.create(new_album)
    return ""
  end

  get "/artists" do
    repo = ArtistRepository.new
    
    @artists = repo.all

    return erb(:all_artists)
  end

  get "/artist/new" do
    return erb(:new_artist)
  end

  get "/artist/:id" do
    repo = ArtistRepository.new

    @artist = repo.find(params[:id])

    return erb(:artist)
  end

  post "/artists" do
    repo = ArtistRepository.new
    new_artist = Artist.new
    new_artist.name = params[:name]
    new_artist.genre = params[:genre]

    repo.create(new_artist)
    return ""
  end

  def invalid_request_parameters?
    return (params[:title] == nil || 
      params[:release_year] == nil || 
      params[:artist_id] == nil)
    end
end