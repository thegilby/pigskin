'''
Team Hashtags
Grab tweets by a team and grab hashtags
'''
import tweepy

CONSUMER_KEY = 'Z8WSUWYeqM50xqvFM6RA'
CONSUMER_SECRET = 'bgK6lGYPCc3tZHxJtSXGeNftyxje0uwzu3gfonzU'
ACCESS_TOKEN = '261549959-PTQfNHLF4e12q7Vy5TGydLMwYZhxZbTeziRMZlZE'
ACCESS_TOKEN_SECRET = 'juRejtsBaitG8xCDc1wnJLi1r8tsz0rMJjN4PvdM'

auth = tweepy.auth.OAuthHandler(CONSUMER_KEY, CONSUMER_SECRET)
auth.set_access_token(ACCESS_TOKEN, ACCESS_TOKEN_SECRET)
api = tweepy.API(auth)

hashfile = open('teamhashes.txt', 'w')
teamnames = ['buffalobills','MiamiDolphins','Patriots','nyjets','Ravens','Bengals','OfficialBrowns','steelers','HoustonTexans','nflcolts','jaguars','tennesseetitans','Denver_Broncos','kcchiefs','RAIDERS','chargers','dallascowboys','Giants','Eagles','Redskins','ChicagoBears','DetroitLionsNFL','packers','VikingsFootball','Atlanta_Falcons','Panthers','Saints','TBBuccaneers','AZCardinals','STLouisRams','49ers','Seahawks']

teamhashes = []
uniqueteamhashes = []

# Grab all of the hashtags from the last 200 tweets of official team twitter accounts
for team in teamnames:
  tweets = api.user_timeline(screen_name=team, count=200, include_entities='true')
  for tweet in tweets:
    hashtags = tweet.entities['hashtags']
    for hashtag in hashtags:
      teamhashes.append(hashtag['text'])

# keep unique hashtags (lowercase)
for teamhash in teamhashes:
  hashlower = teamhash.lower()
  if hashlower not in uniqueteamhashes:
    uniqueteamhashes.append(hashlower)

# write to a file
for element in uniqueteamhashes:
  hashfile.write(element + '\n')