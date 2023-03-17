ENV['APP_ENV'] = 'test'

require 'rack/test'
require 'test/unit'
require_relative 'myapp'
require 'rspec'
require 'zip'


RSpec.describe 'The Picture Upload App' do
    include Rack::Test::Methods
  
    def app
      Sinatra::Application
    end
  
    # Test for the POST route (Story 1)
    describe 'POST /pictures' do
      it 'return 400 error if no file is uploaded' do
        post '/pictures'
        expect(last_response.status).to eq(400)
        expect(last_response.body).to eq('Bad request: Please upload a picture file.')
      end
  
      it 'return 400 error if an invalid file type is uploaded' do
        post '/pictures', { picture: Rack::Test::UploadedFile.new('public/test/test.txt', 'text/plain') }
        expect(last_response.status).to eq(400)
        expect(last_response.body).to eq('Bad request: Please upload a valid picture file.')
      end
  
      it 'uploads a valid picture file and returns a URL to the picture' do
        post '/pictures', { picture: Rack::Test::UploadedFile.new('public/test/test.jpg', 'image/jpg') }
        expect(last_response.status).to eq(200)
        expect(last_response.body).to eq('{"Permanent link":"http://example.org/pictures/test.jpg"}')
      end
    end

    # Test for the GET route (Story 1)
    describe 'GET /pictures/:filename' do
      it 'return 404 error if file does not exist' do
        get '/pictures/sample.jpg'
        expect(last_response.status).to eq(404)
        expect(last_response.body).to eq('File not found')
      end
  
      it 'returns the file if it exists' do
        post '/pictures', { picture: Rack::Test::UploadedFile.new('public/test/test.jpg', 'image/jpg') }
        filename = "test.jpg"
  
        get "/pictures/#{filename}"
        expect(last_response.status).to eq(200)
      end
     end

    # Test for the POST route Story 2.1
    describe 'POST /pictures' do

      it 'return 400 error if an invalid zip file type is uploaded' do
        post '/pictures', { zipfile: Rack::Test::UploadedFile.new('public/test/test.txt', 'text/plain') }
        expect(last_response.status).to eq(400)
        expect(last_response.body).to eq('Bad request: Please upload a valid zip file.')
      end

      # it 'uploads a valid zip file and returns a URL to the picture' do
      #   file_path = File.join(File.dirname(__FILE__),'public/test/test1.zip')
      #   post '/pictures', { zipfile: Rack::Test::UploadedFile.new(file_path, 'application/zip') }
      #   expect(last_response.status).to eq(200)
      #   expect(last_response.body).to eq('[{"Permanent link":"http://example.org/pictures/test1.jpg"}]')
      # end
    end

    # Test for the POST route Story 2.2 (ERROR)
    # describe 'POST /pictures' do
    #   it 'generates thumbnails of the uploaded picture' do
    #     file_path = File.join(File.dirname(__FILE__), 'public/test/test.jpg')
    #     file = Rack::Test::UploadedFile.new(file_path, 'image/jpeg')
    #     post '/pictures', picture: file

    #     expect(last_response).to be_ok
    #     expect(File.exist?('public/test.jpg')).to be true
    #     expect(File.exist?('public/test_size_64.jpg')).to be true
    #     expect(File.exist?('public/test_size_32.jpg')).to be true
    #   end
    # end

  end

