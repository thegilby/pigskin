from pysolr import Solr
import argparse
from datetime import datetime, timedelta

# helper
def isInt(string):
    try: 
        int(string)
        return True
    except ValueError:
        return False

# take in a file name
parser = argparse.ArgumentParser()
parser.add_argument('-f', help = 'inputfile')
parser.add_argument('-ca', help = 'clear the index', action='store_true')
args=parser.parse_args()

# open the file
f = open(args.f,'r')


# initialize solr and clear the index
conn = Solr('http://127.0.0.1:8080/solr/')
if args.ca:
    conn.delete(q='*:*')

# get the labels
headers = []
for header in f.readline().rstrip('\n').split('\t'):
    headers.append(header)


data = []
i = 0
index = 1
for lineno, line in enumerate(f, start=1):
    cols = line.rstrip('\n').split('\t')
    output = {}
    validRow = True
    for col, header in zip(cols, headers):
        if header == 'id' or header == 'fb_weight':
            # check if row has valid id
            if not isInt(col):
                validRow = False
            output[header] = col
        elif header == 'tweet':
            output[header] = col.decode('utf-8')
        elif header == 'date_time':
            # sun oct 21 11:02:56 pdt 2012
            try:
                newTime = datetime.strptime(col,'%a %b %d %H:%M:%S %Z %Y') + timedelta(seconds=60*60*8)
                output[header] = newTime.isoformat() + 'Z'
            except:
                # print col
                print lineno
                validRow = False
            # print newTime.isoformat()
        elif header == 'fb_assoc':
            output[header] = col.strip().split(' ')
        elif header == 'geoloc':
            try:
                cleanCol = col.replace('geolocation{latitude=','').replace('longitude=','').replace('}','').replace(', ',',')
                # print cleanCol
                if cleanCol != 'null':
                    output[header] = cleanCol
            except:
                print lineno
                validRow = False
        else:
            output[header] = col
    if validRow:
        data.append(output)

    # update the index every 10000 documents (reduces overhead)
    if i > (10000*index):
        conn.add(data)
        data = []
        index = index + 1
    i = i + 1

if data:
    conn.add(data)