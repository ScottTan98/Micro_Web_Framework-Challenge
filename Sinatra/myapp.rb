require 'sinatra'

# route to upload picture 
post '/pictures' do
    if params[:picture].nil?
        halt 400, 'Bad request: Please upload a picture file.'
    end

    # check if the uploaded file is a picture
    if !['image/jpeg', 'image/jpg', 'image/png', 'image/gif'].include?(params[:picture][:type])
        halt 400, 'Bad request: Please upload a valid picture file.'
    end 

    # generate a filename for the picture 
    filename = params[:picture][:filename]
    name = params[:picture]

    # save the picture file to disk
    File.open("public/#{filename}", 'wb') do |f|
        f.write(params[:picture][:tempfile].read)
    end

    result = {"Permanent link" => "#{request.base_url}/pictures/#{filename}"}
    return result.to_json
end 

# route to view the uploaded picture 
get '/pictures/:filename' do

    # check if the requested file exists
    if !File.exist?("public/#{params[:filename]}")
        halt 404, 'File not found'
    end

    # return the requested file
    send_file "public/#{params[:filename]}"
end