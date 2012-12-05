# imports
import sqlite3
from contextlib import closing
from flask import Flask, request, session, redirect, url_for, \
     abort, render_template, flash, jsonify
from pysolr import Solr
import json
from pigsearch import FootballIndex

# configuration
DEBUG = True
SECRET_KEY = 'development key'

# create application
app = Flask('pigskin', static_url_path='/pigskin/static')
# app = Flask(__name__)
app.config.from_object(__name__)

# Rest of app
#index
@app.route("/")
def home():
    return render_template('index.html')

#week
@app.route("/week/<int:week>/")
def week(week=None):
    return render_template('week.html', week=week)

#teams
@app.route("/teams/")
@app.route("/teams/<team>/")
def team(team=None):
    if team:
        return render_template('team_single.html', team=team)
    else:
        return render_template('teams.html')

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
    football = FootBallIndex()
    # rows='10' on default
    results = football.search(query)
    # print data    # data = jsonify({'bar': ('baz', query, 1.0, 2)})
    return jsonify(results)

@app.route("/about/")
def about():
    return "about.html"

if __name__ == "__main__":
    # app.run(app.config.get('SERVER_NAME'), app.config.get('SERVER_PORT'));
    app.run(port=61001);
