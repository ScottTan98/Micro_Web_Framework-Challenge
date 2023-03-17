require 'sinatra'
require 'zip'

# route to upload picture 
post '/pictures' do
    if params[:picture].nil? && params[:zipfile].nil?
        halt 400, 'Bad request: Please upload a picture file.'
    end

    # check if the uploaded file is a picture
    if params[:picture] && !['image/jpeg', 'image/jpg', 'image/png', 'image/gif'].include?(params[:picture][:type])
        halt 400, 'Bad request: Please upload a valid picture file.'
    end 

    #check if the uploaded file is a zip file 
    if params[:zipfile] && params[:zipfile][:type] != 'application/zip'
        halt 400, 'Bad request: Please upload a valid zip file.'
    end

    # generate a filename for the picture 
    if params[:picture]
        filename = params[:picture][:filename]

    # save the picture file to disk
        File.open("public/#{filename}", 'wb') do |f|
            f.write(params[:picture][:tempfile].read)

        end
        result = {"Permanent link" => "#{request.base_url}/pictures/#{filename}"}
        return result.to_json
    
    # Handle Zip file
    elsif params[:zipfile]
        # Extract pictures from the ZIP file
        filenames = []
        Zip::File.open(params[:zipfile][:tempfile]) do |zip_file|
            for picture in zip_file
                #recheck again is the zip file all is contain picture type
                if picture.file? && ['.jpeg', '.jpg', '.png', '.gif'].include?(File.extname(picture.name).downcase)
                    filename = picture.name
                    # replace the picture when there is the same picture name
                    File.delete("public/#{filename}") if File.exist?("public/#{filename}")
                    picture.extract("public/#{filename}")
                    filenames.append("#{request.base_url}/pictures/#{filename}")
                end 
            end
            #loop through the filenames and print permanent link
            result = []
            for filename in filenames
                result.append({"Permanent link" => "#{filename}"})
            end
            return result.to_json
        end
    end
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