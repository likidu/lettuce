# -*- coding: utf-8 -*-
# For local testing
# http://flask.pocoo.org/docs/patterns/fileuploads/
import os
from flask import Flask, request
from werkzeug.utils import secure_filename


UPLOAD_FOLDER = 'uploads/'
ALLOWED_EXTENSIONS = ['sqlite', 'png']

app = Flask(__name__)
app.config['DEBUG'] = True
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

@app.route("/", methods=['GET', 'POST'])
def upload_file():
	if request.method == 'POST':
		file = request.files['file']
		if file and _allowed_file(file.filename):
			filename = secure_filename(file.filename)
			file.save(os.path.join(os.getcwd(), app.config['UPLOAD_FOLDER'], filename))
			return "Uploaded %s", filename
	return "Test upload db"


def _allowed_file(filename):
	return '.' in filename and filename.rsplit('.', 1)[1] in ALLOWED_EXTENSIONS


if __name__ == "__main__":
    app.run()