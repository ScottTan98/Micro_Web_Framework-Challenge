require 'rack/test'
require_relative 'myapp'


RSpec.describe 'The Picture Upload App' do
    include Rack::Test::Methods
  
    def app
      Sinatra::Application
    end
  
    # Test for the POST route
    describe 'POST /pictures' do
      it 'return 400 error if no file is uploaded' do
        post '/pictures'
        expect(last_response.status).to eq(400)
        expect(last_response.body).to eq('Bad request: Please upload a picture file.')
      end
  
      it 'return 400 error if an invalid file type is uploaded' do
        post '/pictures', { picture: Rack::Test::UploadedFile.new('public/test.txt', 'text/plain') }
        expect(last_response.status).to eq(400)
        expect(last_response.body).to eq('Bad request: Please upload a valid picture file.')
      end
  
      it 'uploads a valid picture file and returns a URL to the picture' do
        post '/pictures', { picture: Rack::Test::UploadedFile.new('public/test.jpg', 'image/jpg') }
        expect(last_response.status).to eq(200)
      end
    end
    
    # Test for the GET route
    describe 'GET /pictures/:filename' do
      it 'return 404 error if file does not exist' do
        get '/pictures/sample.jpg'
        expect(last_response.status).to eq(404)
        expect(last_response.body).to eq('File not found')
      end
  
      it 'returns the file if it exists' do
        post '/pictures', { picture: Rack::Test::UploadedFile.new('public/test.jpg', 'image/jpeg') }
        filename = "test.jpg"
  
        get "/pictures/#{filename}"
        expect(last_response.status).to eq(200)
        expect(last_response.headers['Content-Type']).to eq('image/jpeg')
      end
    end
  end
