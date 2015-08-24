#!/usr/bin/env python

from google.appengine.api import mail

from base import BaseHandler
from models import User

class WorkerHandler(BaseHandler):

    def post(self):
        id = self.request.get('id')
        user_id = int(id)

        user = User.get_by_id(user_id)

        if not user:
            return

        username = user.auth_ids[0]
        email = user.email

        token = self.user_model.create_signup_token(user_id)

        # Prepare verification url
        verification_url = self.uri_for(
            'verify', 
            id=user_id,
            token=token,
            _full=True
        )

        # Prepare email
        message = mail.EmailMessage(
            sender = 'noreply@dietmaster.com',
            subject = 'Your account has been approved'
        )

        params = {
            'user': username,
            'url': verification_url
        }

        message.to = email
        message.html = self.render("email.html", params)

        message.send()