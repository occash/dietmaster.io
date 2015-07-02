#!/usr/bin/env python

from base import BaseHandler


class VerifyHandler(BaseHandler):

    def get(self, *args, **kwargs):
        user = None

        id = kwargs['id']
        token = kwargs['token']

        user, ts = self.user_model.get_by_auth_token(int(id), token, 'signup')

        if not user:
            logging.info('Could not find any user with id "%s" signup token "%s"',
                id, token)
            self.abort(404)
    
        # store user data in the session
        #self.auth.set_session(self.auth.store.user_to_dict(user), remember=True)

        # remove signup token, we don't want users to come back with an old link
        self.user_model.delete_signup_token(user.get_id(), token)

        if not user.verified:
            user.verified = True
            user.put()

        self.response.write('User email address has been verified.')
