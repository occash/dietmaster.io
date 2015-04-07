import urllib2
import BeautifulSoup
import csv,codecs,cStringIO

class UnicodeWriter:
    def __init__(self, f, dialect=csv.excel, encoding="utf-8-sig", **kwds):
        self.queue = cStringIO.StringIO()
        self.writer = csv.writer(self.queue, dialect=dialect, **kwds)
        self.stream = f
        self.encoder = codecs.getincrementalencoder(encoding)()
    def writerow(self, row):
        '''writerow(unicode) -> None
        This function takes a Unicode string and encodes it to the output.
        '''
        self.writer.writerow([s.encode("utf-8") for s in row])
        data = self.queue.getvalue()
        data = data.decode("utf-8")
        data = self.encoder.encode(data)
        self.stream.write(data)
        self.queue.truncate(0)

    def writerows(self, rows):
        for row in rows:
            self.writerow(row)

baseUrl = 'http://www.foreignword.com/countries/'
response = urllib2.urlopen(baseUrl + 'English.htm')
html = response.read()
soup = BeautifulSoup.BeautifulSoup(html)

with open('country_tr.csv', 'wb') as csvfile:
    writer = UnicodeWriter(csvfile, delimiter=';', quotechar='|', quoting=csv.QUOTE_MINIMAL)

    for el in soup.findAll('tr'):
        code = el.findAll('td')
        link = el.find('a', href=True)
        if len(code) > 1 and hasattr(link, 'text'):
            
            row = [code[0].text]
            
            response = urllib2.urlopen(baseUrl + link['href'])
            html = response.read()
            cs = BeautifulSoup.BeautifulSoup(html)
            
            for cel in cs.findAll('tr'):
                tr = cel.findAll('td')
                row.append(tr[1].text)
                
            writer.writerow(row)