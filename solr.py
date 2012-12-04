from pysolr import Solr
import argparse
from datetime import datetime

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
for line in f.readlines():
    cols = line.rstrip('\n').split('\t')
    output = {}
    for col, header in zip(cols, headers):
        # print header
        # print col
        if header == 'tweet':
            output[header] = col.decode('utf-8')
        elif header == 'date_time':
            # sun oct 21 11:02:56 pdt 2012
            newTime = datetime.strptime(col,'%a %b %d %H:%M:%S %Z %Y')
            # print newTime.isoformat()
            output[header] = newTime.isoformat() + 'Z'
        elif header == 'geoloc':
            cleanCol = col.replace('geolocation{latitude=','').replace('longitude=','').replace('}','').replace(', ',',')
            # print cleanCol
            if cleanCol != 'null':
                output[header] = cleanCol
        else:
            output[header] = col
    data.append(output)

    # update the index every 10000 documents (reduces overhead)
    if i > (10000*index):
        conn.add(data)
        data = []
        index = index + 1
    i = i + 1

if data:
    conn.add(data)