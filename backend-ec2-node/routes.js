'use strict'

import {Auth} from './auth'
import * as handlers from './pages'

export let routes = [
    ['/', handlers.Index, Auth.check],
    ['/login', handlers.Login]
]