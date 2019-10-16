import os
from extract_text.extract_text import *
from flask import Flask, request, redirect, url_for, flash
from werkzeug.utils import secure_filename

UPLOAD_FOLDER = 'uploads'
app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
app.secret_key = os.urandom(24)

#allowed_file adapted from http://flask.palletsprojects.com/en/1.1.x/patterns/fileuploads/
ALLOWED_EXTENSIONS = {'txt', 'pdf', 'png', 'jpg', 'jpeg', 'gif'}
def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@app.route('/', methods=['GET','POST'])
def index():
    if request.method == 'POST':
        if 'file' not in request.files:
            flash('No file part')
            print('file not in request.files')
            return redirect('/failure')
        file = request.files['file']
        #print(file)
        if file.filename == '':
            flash('/failure')
            print('no file name')
            return redirect(request.url)
        if file and allowed_file(file.filename):
            filename = secure_filename(file.filename)
            file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
            test_image = ImageReader(os.path.join(app.config['UPLOAD_FOLDER'], filename))
            text = ExtractText(test_image.image)
            #print(text.extract_text())
            return text.extract_text()
        else:
            print('File not valid')
            return redirect('failure')
    return 'Hello'
@app.route('/success')
def uploaded():
    return 'File successfully uploaded'

@app.route('/failure')
def fail():
    return 'File not uploaded successfully'

if __name__ == '__main__':
    app.run()