#!/usr/bin/env python
# -*- coding: utf8 -*-

from json import load
from jsonschema import validate

class InternalModel:

    def __init__(self, collection, schema):
        super(InternalModel, self).__init__()
        self.collection = collection
        self.index = schema['index']
        self.ttl = schema['ttl']

    def create_index(self):
        # Create ttl index
        for id in self.ttl:
            self.collection.create_index(id, 
                                    background=True, 
                                    expireAfterSeconds=0)

        # Create ascending index
        for id in self.index:
            self.collection.create_index(id, 
                                    background=True)

class Model(InternalModel):
    def __init__(self, collection, schema):
        super(Model, self).__init__(collection, schema)
        self.schema = schema['schema']

    def validate(self, json):
        validate(json, self.schema)

class Models:
    users = None
    usergroups = None
    objects = {}
    internal = {}

    def init(database):
        # Build internal model
        with open('models/internal.json', 'r') as file:
             models = load(file)

             for name in models:
                 model = models[name]
                 schema = InternalModel(database['internal.' + name], model)
                 Models.internal[name] = schema

        # Build user model
        with open('models/users.json', 'r') as file:
             models = load(file)
             Models.users = Model(database.users, models['users'])
             Models.usergroups = Model(database.usergroups, models['usergroups'])

        # Build objects model
        with open('models/objects.json', 'r') as file:
             models = load(file)

             for name in models:
                 model = models[name]
                 schema = Model(database['objects.' + name], model)
                 Models.objects[name] = schema

    def create_index():
        Models.users.create_index()
        Models.usergroups.create_index()

        for name in Models.internal:
            model = Models.internal[name]
            model.create_index()

        for name in Models.objects:
            model = Models.objects[name]
            model.create_index()
