# All API search queries should be constructed through this file.
# This is essential a wrapper for our specific data set

from pysolr import Solr

# column_name data_type
# date_time     date
# username      text
# tweet         text
# geoloc        location
# hashtags      text
# fb_weight     int
# fb_assoc      text

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

    def getTweetsPerSecond(self, date, column='all'):
        result = {}
        # if column == 'all':
        return result   


        

