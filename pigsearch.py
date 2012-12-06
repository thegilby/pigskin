# All API search queries should be constructed through this file.
# This is essential a wrapper for our specific data set

from pysolr import Solr
from datetime import datetime, timedelta
import time

import json

# column_name data_type
# date_time     date
# username      text
# tweet         text
# geoloc        location
# hashtags      text
# fb_weight     int
# fb_assoc      text

team_abbrev = [
    'buf',
    'mia',
    'ne',
    'nyj',
    'bal',
    'cin',
    'cle',
    'pit',
    'hou',
    'ind',
    'jac',
    'ten',
    'den',
    'kc',
    'oak',
    'sd',
    'dal',
    'nyg',
    'phi',
    'was',
    'chi',
    'det',
    'gb',
    'min',
    'atl',
    'car',
    'no',
    'tb',
    'ari',
    'stl',
    'sf',
    'sea'
]

weeks = [
    "2012-10-21T10:00:00",
    "2012-10-28T10:00:00",
    "2012-11-4T10:00:00",
    "2012-11-11T10:00:00",
    "2012-11-18T10:00:00",
    "2012-11-25T10:00:00",
    "2012-12-2T10:00:00",
]


class FootballIndex:
    
    def __init__(self):
        self.conn = Solr('http://127.0.0.1:8080/solr/')

    # returns the top 10 tweets
    # and the totalHits in the query
    def search(self, query,column='tweet'):
        results = self.conn.search(column + ":" + query, wt='python', sort="fb_weight desc")

        data = []
        tweets = {}
        for result in results:
            data.append(result)
        tweets["tweets"] = data
        tweets['totalHits'] = results.hits
        return tweets



    def getTweetsPerMinute(self, date='2012-10-21T10:00:00', column='football'):
        result = {}
        startdate = datetime.strptime(date,'%Y-%m-%dT%H:%M:%S')
        enddate = startdate + timedelta(seconds=60*60*13) # 13 hrs later
        
        params = {  'facet.field' : ['fb_assoc'],
                    'facet.range' : ['date_time'],
                    'facet.range.start' : date + 'Z',
                    'facet.range.end' : enddate.isoformat() + 'Z',
                    'facet.range.gap':'+60000MILLISECOND',
                    'facet.mincount' : '1',
                    'facet.sort' : 'index'
                    }
        
        counts = {}
        if column == 'all':
            dataset = self.conn.search("*:*",facet='on',
                ** params)
            print dataset.hits
            counts = dataset.facets['facet_ranges']['date_time']['counts']
            result = convertToDict(counts)
        elif column == 'football':

            dataset = self.conn.search("fb_weight:[2 TO *]",facet='on',
                ** params)
            for data in dataset:
                print data
            print dataset.hits
            print dataset.facets['facet_fields']
            counts = dataset.facets['facet_ranges']['date_time']['counts']
            result = convertToDict(counts)

        return result

    # returns a dictionary of teamname:count
    def getAllTweetsPerTeam(self):
        params = {  'facet.field' : ['fb_assoc'],
                    'facet.sort' : 'index'
                    }
        dataset = self.conn.search("fb_weight:[2 TO *]",facet='on',
                ** params)
        
        return convertToDict(dataset.facets['facet_fields']['fb_assoc'])

    # Get tweets per second for a given team on a given day.
    # Input:
    #   team - official abbreviated teamname
    #   date - %Y-%m-%dT%H:%M:%S format 2012-10-21T10:00:00
    # returns a dictionary of teamname:count
    def getTweetsPerMinutePerTeam(self, team, date):
        result = {}
        startdate = datetime.strptime(date,'%Y-%m-%dT%H:%M:%S')
        enddate = startdate + timedelta(seconds=60*60*13) # 13 hrs later
        
        params = {'facet.range' : ['date_time'],
                    'facet.range.start' : date + 'Z',
                    'facet.range.end' : enddate.isoformat() + 'Z',
                    'facet.range.gap':'+60000MILLISECOND',
                    # 'facet.mincount' : '1',
                    'facet.sort' : 'index'
                    }

        dataset = self.conn.search("fb_weight:[2 TO *]",fq='fb_assoc:'+team,
            facet='on', ** params)

        print dataset.hits
        counts = dataset.facets['facet_ranges']['date_time']['counts']
        # print counts
        result = convertToDict(counts)

        return result

    def getFootballTweetsPerWeek(self):
        result = {}
        startdate = datetime.strptime(weeks[0],'%Y-%m-%dT%H:%M:%S')
        enddate = datetime.strptime(weeks[-1],'%Y-%m-%dT%H:%M:%S') + timedelta(seconds=60*60*13) # 13 hrs later
        
        params = {'facet.range' : ['date_time'],
                    'facet.range.start' : weeks[0] + 'Z',
                    'facet.range.end' : enddate.isoformat() + 'Z',
                    'facet.range.gap':'+1DAY',
                    # 'facet.mincount' : '1',
                    'facet.sort' : 'index'
                    }

        dataset = self.conn.search("fb_weight:[2 TO *]",
            facet='on', ** params)

        print dataset.hits
        counts = dataset.facets['facet_ranges']['date_time']['counts']
        result = convertToDict(counts)

        return result

    def getNonFootballTweetsPerWeek(self):
        result = {}
        startdate = datetime.strptime(weeks[0],'%Y-%m-%dT%H:%M:%S')
        enddate = datetime.strptime(weeks[-1],'%Y-%m-%dT%H:%M:%S') + timedelta(seconds=60*60*13) # 13 hrs later
        
        params = {'facet.range' : ['date_time'],
                    'facet.range.start' : weeks[0] + 'Z',
                    'facet.range.end' : enddate.isoformat() + 'Z',
                    'facet.range.gap':'+1DAY',
                    # 'facet.mincount' : '1',
                    'facet.sort' : 'index'
                    }

        dataset = self.conn.search("fb_weight:[* TO 1]",
            facet='on', ** params)

        print dataset.hits
        counts = dataset.facets['facet_ranges']['date_time']['counts']
        result = convertToDict(counts)

        return result

def outputAllTweets():
    index = FootballIndex()
    results = {}
    results['nonfootball'] = index.getNonFootballTweetsPerWeek()
    results['football'] = index.getFootballTweetsPerWeek()
    f = open("allFootballTweetsAndNon.json",'w')
    print results
    f.write(json.dumps(results,indent=4))
    return

def outputScript():
    index = FootballIndex()# write out multiple json files
    output = {}
    # tweets per second per team
    for team in team_abbrev:
        f = open("tweetsPerMinute_" + team + ".json","w")

        for week, i in zip(weeks, range(7,14)):
            print team
            print week
            print i
            tweets = index.getTweetsPerMinutePerTeam(team,week)
            output[i] = tweets 
            # print output
        
        f.write(json.dumps(output,indent=4))

    return

# Helper
def convertToDict(countList):
    result = []
    for t, value in zip(countList[::2],countList[1::2]):
        result.append({'x':convertToEpochTime(t), 'y':value})

    # print result
    return result

def convertToEpochTime(t):
    timestamp = datetime.strptime(t,'%Y-%m-%dT%H:%M:%SZ')
    return int(time.mktime(timestamp.timetuple()))
