from multiprocessing import Process, Queue

from smtplib import SMTP, SMTPException

from email.message import EmailMessage
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.utils import formataddr

import logging

from template import Template

class MailWorker():

    def __init__(self, config):
        self.queue = Queue()
        self.process = Process(target=self.main, args=(config, self.queue))
        self.process.start()

    def main(self, config, queue):
        # Setup templates
        template = Template('mail')

        #Setup smtp
        try:
            mail = SMTP(config['address'], config['port'])
            if config['login']:
                mail.ehlo()
                mail.starttls()
                mail.login(config['user'], config['password'])
        except SMTPException:
            logging.info('Cannot connect to smtp server at %s:%s', config['address'], config['port'])
            
        logging.info('Connected to smtp server at %s:%s', config['address'], config['port'])

        # Process messages
        while True:
            params = queue.get()

            if isinstance(params['to'], list):
                recipints = ', '.join(params['to'])
            else:
                recipints = params['to']

            message = MIMEMultipart('alternative')
            message['Subject'] = params['subject']
            message['From'] = formataddr((params['sender'], params['from']))
            message['To'] = recipints

            plain = MIMEText(template.render(params['template'] + '.txt', **params['args']), 'plain')
            html = MIMEText(template.render(params['template'] + '.html', **params['args']), 'html')

            message.attach(plain)
            message.attach(html)

            mail.send_message(message)

    def send(self, sendername, sender, reciever, subject, template, **kwargs):
        message = {
            'sender': sendername,
            'from': sender,
            'to': reciever,
            'subject': subject,
            'template': template,
            'args': kwargs
        }

        self.queue.put(message)