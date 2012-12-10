# imports
import sqlite3
from contextlib import closing
from flask import Flask, request, session, redirect, url_for, \
     abort, render_template, flash, jsonify
from pysolr import Solr
import json
import pigsearch

# configuration
DEBUG = True
SECRET_KEY = 'development key'

# create application
app = Flask('pigskin')
# app = Flask(__name__)
app.config.from_object(__name__)

# Rest of app
#index
@app.route("/")
def home():
    f = open('allFootballTweetsAndNon.json','r')
    data = json.load(f)
    geo = open('geoloc.json','r')
    geoData = json.load(geo)
    return render_template('index.html', data=data, geo=geoData)

#week
@app.route("/week/<week>/")
@app.route("/week/<week>/matchup/<matchup>/")
def week(week=None, matchup=None):
    if matchup:
        teams = matchup.split("_")
        teamData = {}
        topTen = {}
        for team in teams:
            data = open('tweetsPerMinute_'+team+'.json','r')
            teamData[team] = json.load(data)
        for team in teams:
            data2 = open('top_ten_wk_'+week+'_'+team+'.json','r')
            topTen[team] = json.load(data2)
        # print teamData
        return render_template('matchup.html', week=week, matchup=matchup, teamData=teamData, topTen=topTen)
    else:
        teams = ["ari","atl","bal","buf","car","chi","cin","cle","dal","den","det","gb","hou","ind","jac","kc","mia","min","ne","no","nyg","nyj","oak","phi","pit","sd","sea","sf","stl","tb","ten","was"]
        teamData = {}
        for team in teams:
            data = open('tweetsPerMinute_'+team+'.json','r')
            teamData[team] = json.load(data)
        data = open('trendingTopics.json','r')
        trendingTopics = json.load(data)
        return render_template('week.html', week=week, teamData=teamData, trendingTopics=trendingTopics)

#teams
@app.route("/teams/")
@app.route("/teams/<team>/")
def team(team=None):
    if team:
        teamCount = {}
        data = open('teamCount_'+team+'.json','r')
        teamCount = json.load(data)
        teamCounts = json.load(open('teamCounts.json','r'))
        geo = open('geoloc.json','r')
        geoData = json.load(geo)
        return render_template('team.html', team=team, teamCount=teamCount, teamCounts=teamCounts, geo=geoData)
    else:
        return render_template('teams.html')

@app.route("/search/")
def search():
    # do stuff with solr here.
    print "im doing stuff"

    football = pigsearch.FootballIndex()
    # print football.getAllTweetsPerTeam()
    # print football.getTweetsPerSecond()
    # print football.getTweetsPerSecondPerTeam('sf','2012-10-21T10:00:00')
    # print football.getFootballTweetsPerWeek()
    # print football.getNonFootballTweetsPerWeek()
    print json.dumps(football.getTopTweetsForTeamWeek('sf',pigsearch.weeks[1]))
    return render_template('search.html')

@app.route("/searchsolr")
def searchsolr():
    query = request.args.get('query','')
    print query
    football = pigsearch.FootballIndex()
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
