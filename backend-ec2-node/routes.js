'use strict'

import {Auth} from './auth'
import * as handlers from './pages'

export let routes = [
    ['/', handlers.Index],
    ['/signin', handlers.Signin],
    ['/signup', handlers.Signup],
    ['/terms', handlers.Terms],
    ['/privacy', handlers.Privacy]
]