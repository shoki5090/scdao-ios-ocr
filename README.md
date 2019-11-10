# scdao-ios-ocr

# How to run:

1. Install tesseract on your computer following the instructions: https://github.com/tesseract-ocr/tesseract
2. Clone our repository to your computer
3. Install the required python libraries: 'pip install -r requirements.txt'
4. Run app.py to run the server
5. The '/' route currently accepts POST requests with image files
6. To send a post request with an image via the terminal for testing: 'curl -F "file=@{Your file} localhost:5000"