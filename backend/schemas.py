#!/usr/bin/env python

class UsersHandler:
    POST = {
        '$schema': 'http://json-schema.org/draft-04/schema#',
        'type': 'object',
        'properties': {
            'email': {
                'type': 'string',
                'pattern': '^[A-Za-z0-9\.\+_-]+@[A-Za-z0-9\._-]+\.[a-zA-Z]*$'
            },
            'username': {
                'type': 'string',
                'pattern': '^[a-zA-Z0-9_.-]+$'
            },
            'password': {
                'type': 'string',
                'minLength': 3,
                'maxLength': 21
            }
        },
        'required': ['email', 'username', 'password'],
        "additionalProperties": False
    }