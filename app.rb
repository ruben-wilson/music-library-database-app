# file: app.rb
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
  get "/albums" do 
    repo = AlbumRepository.new
    @albums = repo.all
    return erb(:albums_all)
  end 

  get '/albums/new' do 
    return erb(:new_albums)
  end 

  post '/albums/added' do
    repo = AlbumRepository.new
    album = Album.new
    album.title = params[:title]
    @album_title = album.title
    album.release_year = params[:release_year]
    album.artist_id = params[:artist_id]
    repo.create(album)
    return erb(:album_added)
  end

  post "/albums" do 
    repo = AlbumRepository.new
    album = Album.new
    album.title = params[:title]
    album.release_year = params[:release_year]
    album.artist_id = params[:artist_id]
    repo.create(album)
    return nil
  end 
  
  post "/artists" do 
    repo = ArtistRepository.new
    artist = Artist.new
    artist.name = params[:name]
    repo.create(artist)
    return nil
  end 

  get "/artists" do 
    repo = ArtistRepository.new
    @artists = repo.all
    return erb(:artists_all)
  end
  
  get "/artists/new" do
    return erb(:new_artists)
  end

  post "/artists/added" do
    repo = ArtistRepository.new
    artist = Artist.new
    artist.name = params[:name]
    @artist_name = artist.name
    artist.genre = params[:genre]
    repo.create(artist)
    return erb(:artist_added)
  end 

  get "/albums/:id" do
    repo = AlbumRepository.new
    album_to_find = params[:id]
    album = repo.find(album_to_find.to_i)
    @album_title = album.title
    @album_release_year = album.release_year
    @album_artist_id = album.artist_id
    return erb(:id_albums)
  end

  get "/artists/:id" do
    repo = ArtistRepository.new
    artist_to_find = params[:id]
    artist = repo.find(artist_to_find.to_i)
    @artist_name = artist.name
    @artist_genre = artist.genre
    return erb(:id_artists)
  end


end