# imports
import sqlite3
from contextlib import closing
from flask import Flask, request, session, redirect, url_for, \
     abort, render_template, flash

# configuration
DEBUG = True
SECRET_KEY = 'development key'

# create application
app = Flask(__name__)
app.config.from_object(__name__)

# Rest of app
@app.route("/")
def home():
    return render_template('index.html')

@app.route("/about/")
def about():
    return "about.html"

if __name__ == "__main__":
    app.run();
