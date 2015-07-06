#!/usr/bin/env python

users = {
    '$schema': 'http://json-schema.org/draft-04/schema#',
    'type': 'object',
    'properties': {
        'email': {
            'type': 'string',
            'format': 'email'
        },
        'username': {
            'type': 'string',
            'pattern': '^[a-zA-Z0-9_.-]+$'
        },
        'password': {
            'type': 'string',
            'minLength': 3,
            'maxLength': 21
        },
        'neck': {
            'type': 'number'
        },
        'lifestyle': {
            'type': 'integer'
        },
        'height': {
            'type': 'number'
        },
        'weight': {
            'type': 'number'
        },
        'gender': {
            'type': 'boolean'
        },
        'hip': {
            'type': 'number'
        },
        'birthdate': {
            'type': 'string',
            'format': 'datetime'
        },
        'lastName': {
            'type': 'string'
        },
        'diabetic': {
            'type': 'boolean'
        },
        'abdomen': {
            'type': 'number'
        },
        'firstName': {
            'type': 'string'
        },
    },
    'required': ['email', 'username', 'password'],
    "additionalProperties": False
}