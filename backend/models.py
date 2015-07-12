import time

import webapp2_extras.appengine.auth.models
from google.appengine.api import search
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

    def to_dict(self):
        result = super(User, self).to_dict()
        result['id'] = self.key.id()
        result.pop('password')
        return result

class BaseModel(ndb.Model):

    def to_dict(self):
        result = super(BaseModel, self).to_dict()
        result['id'] = self.key.id()
        return result

    def build_suggestions(self, str):
        suggestions = []
        for word in str.split():
            prefix = ""
            for letter in word:
                prefix += letter
                suggestions.append(prefix)
        return ' '.join(suggestions)

    def _post_put_hook(self, future):
        fields = []
        for iname in self.__class__.index:
            ivalue = getattr(self, iname, None)
            ivalue = self.build_suggestions(ivalue)
            sindex = search.TextField(name=iname, value=ivalue)
            fields.append(sindex)

        doc = search.Document(doc_id=str(self.key.id()), fields=fields)
        search.Index(self.__class__.__name__).put(doc)
 
    @classmethod
    def _post_delete_hook(cls, key, future):
        search.Index(cls.__name__).delete(str(key.id()))

class InternalModel(BaseModel):

    createdAt = ndb.DateTimeProperty(auto_now_add=True, indexed=False)
    creator = ndb.KeyProperty(kind='User', indexed=False)
    updatedAt = ndb.DateTimeProperty(auto_now=True, indexed=False)
    updater = ndb.KeyProperty(kind='User', indexed=False)

class group(InternalModel):

    name = ndb.StringProperty(indexed=False)
    description = ndb.StringProperty(indexed=False)

class product(BaseModel):

    index = ['name']

    name = ndb.StringProperty(indexed=False)
    calories = ndb.FloatProperty(indexed=False)
    carbohydrate = ndb.FloatProperty(indexed=False)
    fat = ndb.FloatProperty(indexed=False)
    gi = ndb.FloatProperty(indexed=False)
    protein = ndb.FloatProperty(indexed=False)