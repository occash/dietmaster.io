import urllib2
import csv
import re
from BeautifulSoup import BeautifulSoup
import sys

base_url = 'http://skipthepie.org'
search_url = 'http://skipthepie.org/?q=%s'

abbrev = {}
pattern = None

proxy = urllib2.ProxyHandler({'http': '124.202.172.10:8118'})
opener = urllib2.build_opener(proxy)
urllib2.install_opener(opener)

skip = 174 + 584 + 11

# Load abbreviations
with open('abbrev.csv', mode='r') as infile:
    reader = csv.reader(infile, delimiter=';', quotechar='|')
    abbrev = { rows[1]:rows[0] for rows in reader }
    pattern = re.compile(r'\b(' + '|'.join(abbrev.keys()) + r')\b')

# Open initial file
with open('descrp.csv', 'rb') as csvfile:
    spamreader = csv.reader(csvfile, delimiter=';', quotechar='|')

    # Open result file
    with open('descrp_gi.csv', 'wb') as newfile:
        spamwriter = csv.writer(newfile, delimiter=';', quotechar='|')

        counter = 0

        for row in spamreader:
            counter = counter + 1
            if counter < skip:
                continue

            pname = row[1].strip()
            pname = pattern.sub(lambda x: abbrev[x.group()], pname)
            pname = pname.lower()
            oname = pname.title()
            pname = pname.replace(', ', '+')
            pname = pname.replace(' ', '+')
            url = search_url % pname

            print 'Writing ' + oname

            '''gi = '0'
            group = 'Other'

            try:
                response = urllib2.urlopen(url)
                html = response.read()
                soup = BeautifulSoup(html)

                # Search product
                result = soup.findAll('div', { 'class': 'head' })
                if result is not None:
                    first = result[0]
                    link = first.a['href']
                    link = base_url + link

                    response = urllib2.urlopen(link)
                    ghtml = response.read()
                    gsoup = BeautifulSoup(ghtml)

                    # Find product group
                    gresult = gsoup.find('div', { 'class': 'main' })
                    ga = gresult.findAll('a')
                    group = ga[1].text.encode('utf-8')

                    # Find product GI
                    gresult = gsoup.find('td', { 'class': 'left' })
                    gtable = gresult.table
                    grows = gtable.findAll('td', { 'class': 'innerRight' })
                    gi = grows[7].text.encode('utf-8')
            except Exception as e:
                print str(e)'''

            newrow = row
            newrow.append(oname)
            #newrow.append(group)
            #newrow.append(gi)
            spamwriter.writerow(newrow)

            print 'Done'
