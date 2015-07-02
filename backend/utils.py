#!/usr/bin/env python

import calendar, datetime

# Default JSON serializer
def default(obj):
    if isinstance(obj, datetime.datetime):
        return obj.isoformat()

    return str(obj)