# Micro_Web_Framework-Challenge-ServiceRocket (Scott Tan)

For the assessment of this challenge, I will be choose the Sinatra for Ruby to create the project/service.

This is a simple web application built using using Sinatra framework that allow users to upload and view images.
It supports upload single picture/image in common file format e.g. `'.png'`, `'.jpg'`, `'.jpeg'`, and `'.gif'` as well as multiple images by zip file.
Every uploaded images are stored on the server and can be accessed via permanent link that generated everytime user upload images/pictures.

### Video Demostration: https://youtu.be/_cm1GPBhtWY

# Installation

To run this application locally, you will need to have Ruby and Sinara gem installed on your system.
You may clone the this repository & follow these steps below to ge started:

1. After you clone this resposity to local machine, you will have a file called **Gemfile** for install the required gems:

```
bundle install
```

2. Run the Sinatra application:

```
ruby myapp.rb
```

3. Access the application by opening a web browser and visiting **http://localhost:4567**.

# Usage

Once the application/service is up and running, you may start uoloading pictures using the following steps:

1. Upload a single image/picture:

   - Send a `POST` request to `/pictures` with the `picture` parameter set to the image file uou want to upload.
   - After the image is upload successfully, the application will generate a permanent link that you can use to view the uploaded image.

2. Upload multiple pictures:

   - Send a `POST` request to `/pictures` with the `zipfile` parameter set to a zip file containing the images you want to upload.
   - After the zip file is upload successfully, the application will generate a list of permenant link for each uploaded image that you can use to view them.

3. Auto Generate Thumbnails:
   - If the uploaded image is more than 128px by 128px, the application will auto generate the extra two thumbnails which one 32px wide and ther other 64px wide. All the files that generated will indicate with the new suffix `_size_32` or `_size_64`.

# Routes

In this service/application will the routes below:

- `GET /`: Return a message to user with instructions on how to use the service.
- `POST /pictures`: Handles the upload images. Accepts either a single image file (`picture` parameter) or a zip file containing multiple images (`zipfile` parameter).

# Testing

This application uses RSpec and Rack::Test for testing. To run the tests, navigate to the project directory in your terminal and run `rspec app_spec.rb`.

### Story 1

Tests for upload and accesing a single picture file.

- POST /pictures:
  - return 400 error if no file is uploaded
  - return 400 error if an invalid file type is uploaded
  - uploads a valid picture file and returns a URL to the picture
- GET /pictures/:filename:
  - return 404 error if file does not exist
  - returns the file if it exists

### Story 2.1

Tests for uploading and accessing a zip file containing multiple picture files.

- POST /pictures:
  - return 400 error if an invalid zip file type is uploaded
  - uploads a valid zip file and returns a URL to the picture

<br />
There is some error for the story 2.2 which is `generates thumbnails of the uploaded picture`, the code is commented out and currently not cannot be run.

# Dependencies

This applicaiton depends on the following Ruby gems & dependencies:

- `sinatra`: Web framework for building the application/service.
- `zip`: Allows the application to extract images from zip files.
- `rmagick`: Ruby image processing gem to manipulate images, in this project will be generate the thumbnails.
- `imagemagick`: software suite that will be use with `rmagick` for image processing.

# License

This project is licensed under the MIT License.
