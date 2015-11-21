import re
import csv
import pymongo

def to_number(s):
    s = s.strip()
    s = s.replace(',', '.')
    return float(s) if s else 0.0

with open('abbrev.csv', 'r') as abbrev_file:
    abbrev_reader = csv.reader(abbrev_file, delimiter=';', quotechar='"')

    abbrevs = {}
    for row in abbrev_reader:
        abbrevs[row[1]] = row[0]

    with open('data.csv', 'r') as data_file:
        data_reader = csv.reader(data_file, delimiter=';', quotechar='"')
        next(data_reader)

        client = pymongo.MongoClient()
        database = client.dietmaster
        food = database.food

        regex = r'\b(%s)\b' % '|'.join(abbrevs.keys())
        pattern = re.compile(regex)
        # TODO: replace W/ and WO/
        for row in data_reader:
            full_name = pattern.sub(lambda x: abbrevs[x.group()], row[1])
            full_name = full_name.title()
            attributes = full_name.split(',')
            short_name = attributes[0]

            record = {
                'fullname': full_name,
                'name': short_name,
                'attributes': attributes,
                'group': row[3].title(),
                'water': to_number(row[5]),
                'energy': to_number(row[6]),
                'protein': to_number(row[7]),
                'lipid': to_number(row[8]),
                'carbohydrate': to_number(row[10]),
                'gi': to_number(row[4]),
            }

            try:
                food.insert(record)
            except:
                pass