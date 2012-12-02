from pysolr import Solr
import argparse

# take in a file name
parser = argparse.ArgumentParser()
parser.add_argument('-f', help = 'inputfile')
args=parser.parse_args()

# open the file
f = open(args.f,'r')


# initialize solr and clear the index
conn = Solr('http://127.0.0.1:8983/solr/')
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
        output[header] = col
    data.append(output)
    if i > (10000*index):
        conn.add(data)
        data = []
        index = index + 1
    i = i + 1

if data:
    conn.add(data)