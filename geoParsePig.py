import json
teams = [
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

headers = [
    'date_time',
    'tweet',
    'geoloc',
    'fb_weight',
    'fb_assoc'
]

results = {}
for team in teams:
    array = []
    for index in range(0,57):
        try:
            f = open('/Users/andrewchao/Dropbox/berkeley/290-twitter/geoloc/geoloc_all_' + team + '/part-m-000' + str(index).zfill(2), 'r')
            for line in f.readlines():
                cols = line.rstrip('\n').split('\t')
                data = {}
                for col, header in zip(cols, headers):
                    if header == 'geoloc':
                        cleanCol = col.replace('geolocation{latitude=','').replace('longitude=','').replace('}','').replace(', ',',')
                        data[str(header)] = cleanCol
                    else:
                        data[str(header)] = col
                array.append(data)
        except:
            print "file not found"
    results[team] = array

w = open("geoloc.json", 'w')
w.write(json.dumps(results,indent=4))




