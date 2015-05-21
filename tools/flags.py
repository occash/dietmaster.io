import urllib2
import csv

base_url = 'http://uxrepo.com/static/icon-sets/free-flags/svg/square-country-%s-flag.svg'

with open('D:/GoogleDrive/DietMaster/ccodes2.csv', 'rb') as csvfile:
    spamreader = csv.reader(csvfile, delimiter=';', quotechar='|')
    for row in spamreader:
        ccode = row[1].strip().lower()
        url = base_url % ccode
        try:
            response = urllib2.urlopen(url)
            svg = response.read()
        except:
            continue
        with open('flags/%s.svg' % ccode, 'w') as svgfile:
            svgfile.write(svg)