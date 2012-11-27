# imports
import sqlite3
from contextlib import closing
from flask import Flask, request, session, redirect, url_for, \
     abort, render_template, flash
from pysolr import Solr

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

@app.route("/search/")
def search():
    # do stuff with solr here. 
    print "im doing stuff"
    conn = Solr('http://127.0.0.1:8983/solr/')
    results = conn.search('tweet:"/@/"')
    for result in results:
        print result['name']

    docs = [
            {'id': 'testdoc.5', 'cat': ['poetry', 'science'], 'name': 'document 5', 'text': u''},
            {'id': 'testdoc.6', 'cat': ['science-fiction',], 'name': 'document 6', 'text': u''},
        ]

    conn.add(docs)
    results = conn.search('cat:"science"')
    for result in results:
        print result['name']

    return render_template('search.html')


@app.route("/about/")
def about():
    return "about.html"

if __name__ == "__main__":
    app.run();
