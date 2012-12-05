# All API search queries should be constructed through this file.
# This is essential a wrapper for our specific data set

from pysolr import Solr
from datetime import datetime, timedelta

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



    def getTweetsPerSecond(self, date='2012-10-21T10:00:00', column='football'):
        result = {}
        startdate = datetime.strptime(date,'%Y-%m-%dT%H:%M:%S')
        enddate = startdate + timedelta(seconds=60*60*13) # 13 hrs later
        
        params = {  'facet.field' : ['fb_assoc'],
                    'facet.range' : ['date_time'],
                    'facet.range.start' : date + 'Z',
                    'facet.range.end' : enddate.isoformat() + 'Z',
                    'facet.range.gap':'+1000MILLISECOND',
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
    def getTweetsPerSecondPerTeam(self, team, date):
        result = {}
        startdate = datetime.strptime(date,'%Y-%m-%dT%H:%M:%S')
        enddate = startdate + timedelta(seconds=60*60*13) # 13 hrs later
        
        params = {'facet.range' : ['date_time'],
                    'facet.range.start' : date + 'Z',
                    'facet.range.end' : enddate.isoformat() + 'Z',
                    'facet.range.gap':'+1000MILLISECOND',
                    'facet.mincount' : '1',
                    'facet.sort' : 'index'
                    }

        dataset = self.conn.search("fb_weight:[2 TO *]",fq='fb_assoc:'+team,
            facet='on', ** params)

        print dataset.hits
        counts = dataset.facets['facet_ranges']['date_time']['counts']
        result = convertToDict(counts)

        return result


def outputScript():
    index = FootballIndex()# write out multiple json files

    # football
    for team in team_abbrev:
        tweets = index.getTweetsPerSecondPerTeam(team,'2012-10-21T10:00:00')
        f = open("tweetsPerSecond_" + team + ".json","w")
        f.write(json.dumps(tweets,indent=4))
    return

# Helper
def convertToDict(countList):
    result = {}
    for key, value in zip(countList[::2],countList[1::2]):
        result[key] = value
    return result
