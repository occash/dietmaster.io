import urllib2
import csv
import re
from BeautifulSoup import BeautifulSoup
import sys
from google import google

'''base_url = 'http://skipthepie.org/'

proxy = urllib2.ProxyHandler({'http': '124.200.38.46:8118'})
opener = urllib2.build_opener(proxy)
urllib2.install_opener(opener)'''

#skip = 0

# Open initial file
with open('basic.csv', 'rb') as csvfile:
    spamreader = csv.reader(csvfile, delimiter=';', quotechar='|')

    # Open result file
    with open('basic_gi.csv', 'wb') as newfile:
        spamwriter = csv.writer(newfile, delimiter=';', quotechar='|')

        counter = 0

        for row in spamreader:
            '''counter = counter + 1
            if counter < skip:
                continue'''

            print 'Writing ' + row[0]
            gi = '0'

            try:
                results = google.search('site:skipthepie.org ' + row[0])
                url = 'https://www.google.com' + results[1].cached

                request = urllib2.Request(url)
                request.add_header(
                    "User-Agent", "Mozilla/5.001 (windows; U; NT4.0; en-US; rv:1.0) Gecko/25250101")
                html = urllib2.urlopen(request).read()
                soup = BeautifulSoup(html)

                # Find product GI
                gresult = soup.find('td', { 'class': 'left' })
                gtable = gresult.table
                grows = gtable.findAll('td', { 'class': 'innerRight' })
                gi = grows[7].text.encode('utf-8')

            except Exception as e:
                print str(e)

            newrow = row
            newrow.append(gi)
            spamwriter.writerow(newrow)

            print 'Done'
