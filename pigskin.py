# imports
import sqlite3
from contextlib import closing
from flask import Flask, request, session, redirect, url_for, \
     abort, render_template, flash, jsonify
from pysolr import Solr
import json

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
    results = conn.search('cat:"/@/"')
    for result in results:
        print result['name']

    docs = [
            {'id': 'testdoc.5', 'cat': ['poetry', 'science'], 'name': 'document 5', 'text': u''},
            {'id': 'testdoc.6', 'cat': ['science-fiction',], 'name': 'document 6', 'text': u''},
        ]

    conn.add(docs)
    results = conn.search('science')
    for result in results:
        print result

    return render_template('search.html', results=docs)

@app.route("/searchsolr")
def searchsolr():
    query = request.args.get('query','')
    print query
    conn = Solr('http://127.0.0.1:8983/solr/')
    
    # rows='10' on default
    results = conn.search("tweet:"+query, wt='python', sort="fb_weight desc")

    data = []
    tweets = {}
    for result in results:
        data.append(result)
    tweets["tweets"] = data
    tweets['totalHits'] = results.hits
    # print data    # data = jsonify({'bar': ('baz', query, 1.0, 2)})
    return jsonify(tweets)

@app.route("/about/")
def about():
    return "about.html"

if __name__ == "__main__":
    app.run();
