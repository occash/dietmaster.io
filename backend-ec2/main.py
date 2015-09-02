#!/usr/bin/env python
# -*- coding: utf8 -*- 

import yaml

import logging
import logging.config

from motor import MotorClient
from pymongo.son_manipulator import SONManipulator, AutoReference

from tornado.web import Application
from tornado.log import enable_pretty_logging
from tornado.ioloop import IOLoop

from routes import routes
from models import Models
from mail import MailWorker

def main():
    # Read config
    with open("config.yaml", 'r') as ymlfile:
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
        database = client.local

        # Setup database & collections
        Models.init(database)
        Models.create_index()
    except:
        logging.info('Cannot connect to database')
        exit(1)

    logging.info('Connected to database at %s:%s', dbconfig['address'], dbconfig['port'])

    # Login to mail server   
    try:
        mail = MailWorker(emailconfig)
    except:
        logging.info('Cannot start mail worker')
        exit(2)
    
    logging.info('Mail worker started')

    # Create Tornado application
    application = Application(
        routes,
        autoreload=webconfig['autoreload'],
        debug=webconfig['debug'],
        database=database,
        mail=mail
    )

    # Enable Torando logging
    enable_pretty_logging()

    try:
        application.listen(webconfig['port'], webconfig['address'])
    except:
        logging.info('Cannot start web server')
        exit(3)

    logging.info('Listen on %s:%s', webconfig['address'], webconfig['port'])

    # Start IO loop
    IOLoop.current().start()

if __name__ == '__main__':
    main()