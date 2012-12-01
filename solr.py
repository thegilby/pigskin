from pysolr import Solr

f = open('indexed_tweets_w1J.csv','r')

conn = Solr('http://127.0.0.1:8983/solr/')
# clear the index
conn.delete(q='*:*')

headers = []
data = []

for header in f.readline().rstrip('\n').split('\t'):
    headers.append(header)

# print headers
i = 0
for line in f.readlines():
    cols = line.rstrip('\n').split('\t')
    output = {}
    for col, header in zip(cols, headers):
        # print header
        # print col
        output[header] = col
    data.append(output)
    if i > 1000:
        conn.add(data)
        data = []
    i = i + 1
