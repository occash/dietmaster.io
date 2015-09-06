#!/usr/bin/env python
# -*- coding: utf8 -*- 

from models import Models

class UsersController:

    def create_user(self):
        Models.users.validate(user_body)

        database = self.settings['database']
        users = database.users
        internal_users = database.internal.users

        raw_password = user_body.pop('password')
        add_date_internal(user_body)

        user_id = yield users.save(user_body)

        salt = os.urandom(24)
        raw_password = raw_password.encode('utf-8')
        password = hashlib.sha256(salt + raw_password).digest()
        username = user_body['username']
        verify_token = hashlib.sha1(os.urandom(128)).hexdigest()

        internal_body = {
            '_id': username,
            'salt': salt,
            'password': password,
            'verified': False,
            'token': verify_token,
            'usergroups': []
        }

        yield internal_users.save(internal_body)

        mail = self.settings['mail']
        mail.send(
            'DietMaster',
            'support@dietmaster.io',
            user_body['email'],
            'Account verification',
            'verify',
            user=username,
            url='https://dietmaster.io/verify/%s-%s' % (username, verify_token)
        )