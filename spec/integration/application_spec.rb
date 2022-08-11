require "spec_helper"
require "rack/test"
require_relative '../../app'

 def reset_albums_table
  seed_sql = File.read('spec/seeds/music_library.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(seed_sql)
end

RSpec.describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods
  before(:all) do 
    reset_albums_table
  end
  let(:app) { Application.new }
  context "GET /" do 
    it "returns home page with hrefs to albums and artists" do
      response = get("/")

      expect(response.status).to eq(200)
      expect(response.body).to include("<h1>Welcome to my Music Databsase</h1>")
    end 
  end 

  context "GET /albums" do 
    it "returns all albums" do 
      response = get('/albums')

      expect(response.body).to include("<a href='/albums/1'>Doolittle<br />")
      expect(response.body).to include("<a href='/albums/12'>Ring Ring<br />")
    end 
  end
   context "POST /albums" do 
      it "returns 200 ok" do 
  
      response = post("/albums", 'title=new_album,release_year=1997,artist_id=2')

      expect(response.status).to eq(200)
    end
  end
    context "GET /artists" do 
      it "returns 200 ok" do

      response = get('/artists')

      expect(response.status).to eq(200)
      expect(response.body).to include("<a href='/artists/4'>Nina Simone<br />")
    end
  end
    context "GET /artists/:id" do 
      it "returns page matching artist id" do 
        response = get("/artists/1")
        
        expect(response.status).to eq(200)
        expect(response.body).to include(" <h1> Pixies</h1>")
      end 
    end 
    context "GET /albums/:id" do
      it "returns the album 'doolittle' from database" do 
        response = get("/albums/1")

        expect(response.status).to eq(200)
        expect(response.body).to include("<h1> Doolittle</h1>")
        expect(response.body).to include("<p>\n      artist_id: 1\n    </p>\n")
      end
      it "returns the album 'Surfer Rosa' from database" do 
        response = get("/albums/2") 

        expect(response.status).to eq(200)
        expect(response.body).to include("<h1> Surfer Rosa</h1>")
        expect(response.body).to include("<p>\n      artist_id: 1\n    </p>\n")
      end
      it "returns the album 'Waterloo' from database" do 
        response = get("/albums/3")

        expect(response.status).to eq(200)
        expect(response.body).to include("<h1> Waterloo</h1>")
        expect(response.body).to include("<p>\n      artist_id: 2\n    </p>\n")
      end
    end
    context "GET /albums/new" do
      it "returns a form" do 
        response = get('/albums/new')
        

        expect(response.status).to eq(200)
        expect(response.body).to include('<form action="/albums/added" method="POST">')
        expect(response.body).to include('<input type="text" name="title"><br/>')
        expect(response.body).to include('<label> Release year: </label>')
        expect(response.body).to include('<input type="text" name="release_year"><br/>')
        expect(response.body).to include('<input type="submit" value="Add Artist"/>')

      end
    end
    context "POST /albums/added" do 
      it "returns confrirmation that the album 'new_album' has been added" do
        response = post('/albums/added',title:"new_ablum",release_year:"1999",artist_id:"22")
        response2 = get('/albums')


        expect(response.status).to eq(200)
        expect(response.body).to include("<h1> Album 'new_ablum' has ben added</h1>")
        expect(response2.body).to include("new_album")
      end 
       it "returns confrirmation that the album 'new_album2' has been added " do
        response = post('/albums/added',title:"new_ablum2",release_year:"1998",artist_id:"21")


        expect(response.status).to eq(200)
        expect(response.body).to include("<h1> Album 'new_ablum2' has ben added</h1>")
      end 
    end
    context "GET /artists/new" do 
      it "returns a form" do 
        response = get("/artists/new")

        expect(response.status).to eq(200)
        expect(response.body).to include('<form action="/artists/added" method="POST">')
        expect(response.body).to include('<input type="text" name="name"/><br/>')
        expect(response.body).to include('<input type="submit"/>')
      end 
    end
    context "POST /artists/added" do 
      it "returns a confirmation that 'new_artist' has been added" do
        response = post('/artists/added',name:"new_artist",genre:"pop")

        expect(response.status).to eq(200)
        expect(response.body).to include("new_artist has been added")
      end 
      it "adds album to database and its presents on all page: '/artists' "do 
        response = get('/artists')

        expect(response.body).to include("new_artist")
    end
      it "returns a confirmation that 'new_artist2' has been added" do
        response = post('/artists/added',name:"new_artist2",genre:"pop")

        expect(response.status).to eq(200)
        expect(response.body).to include("new_artist2 has been added")
      end 
      it "adds album to database and its presents on all page: '/artists' "do 
        response = get('/artists')

        expect(response.body).to include("new_artist2")
    end 
  end 

end
