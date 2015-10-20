import csv
import pymongo

print(pymongo.version)

def to_number(s):
    s = s.strip()
    s = s.replace(',', '.')
    return float(s) if s else 0.0

with open('data.csv', 'r') as file:
    reader = csv.reader(file, delimiter=';', quotechar='"')
    next(reader)

    client = pymongo.MongoClient()
    database = client.dietmaster
    food = database.food

    for row in reader:
        record = {
            'name': row[1].lower(),
            'group': row[2].lower(),
            'water': to_number(row[4]),
            'energy': to_number(row[5]),
            'protein': to_number(row[6]),
            'lipid': to_number(row[7]),
            'carbohydrate': to_number(row[8]),
            'gi': to_number(row[3]),
        }

        food.insert(record)