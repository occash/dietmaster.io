#!/usr/bin/env python
# -*- coding: utf8 -*- 

import yaml
import json

import logging
import logging.config

from motor import MotorClient
from pymongo.son_manipulator import SONManipulator, AutoReference

from tornado.web import Application
from tornado.log import enable_pretty_logging
from tornado.ioloop import IOLoop

from routes import routes
from mail import MailWorker

COOKIE_SECRET = '24a57703-270d-439a-a22d-d6580972a1d7'

def init_db(database):
    # Load json model
    with open('config/model.json', 'r') as file:
        documents = json.load(file)

        # Create index for every document
        for name, indexes in documents.items():
            document = database[name]

            # Apply indexes
            for name, index in indexes.items():
                document.create_index(name, **index)

def init_schema():
    with open('config/schema.json', 'r') as file:
        schema = json.load(file)
        return schema

def main():
    # Read config
    config_file = 'config/debug.yaml' if __debug__ else 'config/config.yaml'
    with open(config_file, 'r') as ymlfile:
        config = yaml.load(ymlfile)

    logconfig = config['logging']
    dbconfig = config['database']
    webconfig = config['web']
    emailconfig = config['email']

    # Configure logging
    logging.config.dictConfig(config['logging'])

    # Connect to database
    try:
        client = MotorClient(dbconfig['address'], dbconfig['port'])
        IOLoop.current().run_sync(client.server_info)
        database = client.dietmaster

        # Setup database & collections
        init_db(database)
    except:
        logging.error('Cannot connect to database')
        exit(1)

    logging.info('Connected to database at %s:%s', dbconfig['address'], dbconfig['port'])

    # Login to mail server   
    try:
        mail = MailWorker(emailconfig)
    except:
        logging.error('Cannot start mail worker')
        exit(2)
    
    logging.info('Mail worker started')

    # Create Tornado application
    application = Application(
        routes,
        autoreload=webconfig['autoreload'],
        debug=webconfig['debug'],
        cookie_secret=COOKIE_SECRET,
        database=database,
        schema=init_schema(),
        mail=mail
    )

    # Enable Torando logging
    enable_pretty_logging()

    try:
        application.listen(webconfig['port'], webconfig['address'])
    except:
        logging.error('Cannot start web server')
        exit(3)

    logging.info('Listen on %s:%s', webconfig['address'], webconfig['port'])

    # Start IO loop
    IOLoop.current().start()

if __name__ == '__main__':
    main()