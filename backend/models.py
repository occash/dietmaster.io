import time
import webapp2_extras.appengine.auth.models

from google.appengine.ext import ndb

from webapp2_extras import security

class User(webapp2_extras.appengine.auth.models.User):

    def set_password(self, raw_password):
        self.password = security.generate_password_hash(raw_password, length=12)

    @classmethod
    def get_by_token(cls, user_id, token, subject='auth'):
        token_key = cls.token_model.get_key(user_id, subject, token)
        user_key = ndb.Key(cls, user_id)

        # Use get_multi() to save a RPC call.
        valid_token, user = ndb.get_multi([token_key, user_key])
        if valid_token and user:
            timestamp = int(time.mktime(valid_token.created.timetuple()))
            return user, timestamp

        return None, None

    @classmethod
    def create_refresh_token(cls, user_id):
        entity = cls.token_model.create(user_id, 'refresh')
        return entity.token

    @classmethod
    def validate_refresh_token(cls, user_id, token):
        return cls.validate_token(user_id, 'refresh', token)

    @classmethod
    def delete_refresh_token(cls, user_id, token):
        cls.token_model.get_key(user_id, 'refresh', token).delete()

class internal(ndb.Model):
    createdAt = ndb.DateTimeProperty(auto_now_add=True, indexed=False)
    creator = ndb.KeyProperty(kind='User', indexed=False)
    updatedAt = ndb.DateTimeProperty(auto_now=True, indexed=False)
    updater = ndb.KeyProperty(kind='User', indexed=False)

class group(internal):
    name = ndb.StringProperty(indexed=False)
    description = ndb.StringProperty(indexed=False)

class product(ndb.Model):
    name = ndb.StringProperty(indexed=False)
    calories = ndb.FloatProperty(indexed=False)
    carbohydrate = ndb.FloatProperty(indexed=False)
    fat = ndb.FloatProperty(indexed=False)
    gi = ndb.FloatProperty(indexed=False)
    protein = ndb.FloatProperty(indexed=False)