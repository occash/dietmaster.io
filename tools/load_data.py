import csv
import pymongo

print(pymongo.version)

with open('data.csv', 'r') as file:
    reader = csv.DictReader(file, delimiter=';', quotechar='|')

    client = pymongo.MongoClient()
    database = client.dietmaster
    food = database.food

    for row in reader:
        if None in row:
            del row[None]
        food.insert(row)