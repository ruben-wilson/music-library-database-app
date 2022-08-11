# {{ METHOD }} {{ PATH}} Route Design Recipe

_Copy this design recipe template to test-drive a Sinatra route._

## 1. Design the Route Signature

You'll need to include:
  * the HTTP method
  * the path
  * any query parameters (passed in the URL)
  * or body parameters (passed in the request body)

## 2. Design the Response

The route might return different responses, depending on the result.

For example, a route for a specific blog post (by its ID) might return `200 OK` if the post exists, but `404 Not Found` if the post is not found in the database.

Your response might return plain text, JSON, or HTML code. 

_Replace the below with your own design. Think of all the different possible responses your route will return._

```html
<!-- EXAMPLE -->
<!-- Response when the post is found: 200 OK -->

<html>
  <head></head>
  <body>
    <h1>Post title</h1>
    <div>Post content</div>
  </body>
</html>
```

```html
<!-- EXAMPLE -->
<!-- Response when the post is not found: 404 Not Found -->

<html>
  <head></head>
  <body>
    <h1>Sorry!</h1>
    <div>We couldn't find this post. Have a look at the homepage?</div>
  </body>
</html>
```

## 3. Write Examples

_Replace these with your own design._

```ruby
# 1 
# Returns all albums as csv string 
# Request:
GET /albums

# Expected response (200 OK)
# Expected response ("Surfer Rosa,  Waterloo,  Super Trouper,  Bossanova,  Lover,  Folklore,  I Put a Spell on You,  Baltimore,  Here Comes the Sun,  Fodder on My Wings,  Ring Ring")

# 2
# creates a new album in data base 
# Request:
POST /albums 

# Body paramaters: 
# pramas=title, release_year, artist_id

# Expected response: (200 OK)
# Expected response: (nil)

# 3
# Request:
POST /artists

# With body parameters:
name=Wild nothing
genre=Indie

# Expected response (200 OK)
(No content)

# 4
# Request:
GET /artists

# Expected response (200 OK)
# Expected response (Pixies, ABBA, Taylor Swift, Nina Simone, Wild nothing)


# 5 
# Request:
GET /albums/id:

# Parameters:
# id for the album they want to find

# Expected response: for(id=1)
#  'doolittle'

```

## 4. Encode as Tests Examples

```ruby
# EXAMPLE
# file: spec/integration/application_spec.rb

require "spec_helper"

describe Application do
  include Rack::Test::Methods

  let(:app) { Application.new }
   
      context "GET /albums" do
      it "returns 200 ok" do

      response = get('/albums')
      
      expect(response.status).to eq(200)
      expect(response.body).to eq('??')
    end

      context "POST /albums" do 
      it "returns 200 ok" do 
  
      response = get("/albums", 'params=new_album,1997,2')

      expect(response.status).to eq(200)
    end

    context "POST /artists" do 
      it "returns 200 ok" do 
  
      response = get("/artist", 'params=new_album')

      expect(response.status).to eq(200)
    end
  end
    context "GET /artists" do
      it "returns 200 ok" do

      response = get('/artists')
      
      expect(response.status).to eq(200)
      expect(response.body).to eq('??')
    end
  end
    context "GET /albums/id=" do
      it "returns the album 'doolittle' from database" do 
        response = get("/albums/id=1")

        expect(response).to eq(200)
        expect(response).to include
        ("<h1> doolittle <h1>")
      end
    end 


  end
end
```

## 5. Implement the Route

Write the route and web server code to implement the route behaviour.