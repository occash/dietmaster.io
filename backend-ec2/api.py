#!/usr/bin/env python
# -*- coding: utf8 -*- 

from tornado.web import RequestHandler, HTTPError
from tornado.gen import coroutine

from bson.json_util import loads, dumps

class BaseHandler(RequestHandler):

    def parse_body(self):
        body = self.request.body
        body = body.decode('utf-8')
        return None if not body else loads(body)

    def write_error(self, status_code, **kwargs):
        if status_code == 500:
            self.write('Internal server error')

        if 'message' in kwargs:
            self.write(kwargs['message'])

class UsersHandler(BaseHandler):

    @coroutine
    def get(self):
        database = self.settings['database']
        users = database.users
        options = QueryOptions(self)

        cursor = users.find(options.query)
        cursor = cursor.limit(options.limit)
        cursor = cursor.skip(options.offset)

        if options.count:
            result = yield cursor.count(with_limit_and_skip=True)
            json_users = { 'count': result }
        else:
            result = yield cursor.to_list(None)
            json_users = { 'results': result }

        self.finish(dumps(json_users))

    @coroutine
    def post(self):
        user_body = self.parse_body()
        print(user_body)
        '''try:
            user_body = self.parse_body()
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

            self.write(dumps(user_body))
        except SchemaError:
            self.error(500, 'Invalid JSON schema')
        except ValidationError:
            self.error(400, 'JSON body not valid')
        except OperationFailure:
            self.error(400, 'Object could not be saved')'''

class LoginHandler(BaseHandler):
    
    @coroutine
    def post(self):
        username = self.get_argument('username', None)
        password = self.get_argument('password', None)

        if not username or not password:
            raise HTTPError(403, 'No credentials supplied')

        database = self.settings['database']
        users = database['internal.users']
        tokens = database['internal.tokens']

        user = yield users.find_one({'_id': username})
        if not user:
            raise HTTPError(403, 'User not found')

        salt = user['salt']
        rawpassword = password.encode('utf-8')
        hexpass = hashlib.sha256(salt + rawpassword).digest()

        if not hexpass == user['password']:
            raise HTTPError(403, 'Wrong password')

        token = yield tokens.find_one({'_id': username})
        if not token:
            bearer = hashlib.sha1(os.urandom(128)).hexdigest()
            refresh = hashlib.sha1(os.urandom(128)).hexdigest()
            expires = datetime.utcnow() + timedelta(days=7)

            token = {
                '_id': username,
                'access_token': bearer,
                'refresh_token': refresh,
                'expires_in': expires
            }

            yield tokens.save(token)

        self.set_secure_cookie('token', token['access_token'], expires_days=7)

class LogoutHandler(BaseHandler):

    @coroutine
    def post(self):
        self.clear_all_cookies()

class ResetHandler(BaseHandler):

    @coroutine
    def post(self):
        pass