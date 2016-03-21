'use strict'

// Imports
let parser = require('body-parser')
let ect = require('ect');
let express = require('express')
let passport = require('passport')
let session = require('express-session')
let mongodb = require('mongodb');

import {Auth} from './auth'
import {default404} from './pages'
import {routes} from './routes'

// Namespace
let LocalStrategy = require('passport-local')
let MongoClient = mongodb.MongoClient

// Config
let config = require('./config.json')
let secret = 'Luke, I am your father'

function create (handler, method) {
    let _handler = handler
    return _handler[method]
}

function setup (app, routes) {
    for (let route of routes) {
        let path = route[0]
        let Handler = route[1]
        let middle = route.length > 2 ? route[2] : []
        
        var handler = new Handler()        
        if ('get' in handler) {
            let actual = create(handler, 'get')
            app.get(path, middle, actual)
        }
        
        if ('post' in handler) {
            let actual = create(handler, 'post')
            app.get(path, middle, actual)
        }
    }
}

export async function main() {
    // Basic setup
    let app = express()
    let renderer = ect({ watch: true, root: __dirname + '/views', ext: '.ect'})

    app.use(parser.urlencoded({extended: true}))
    app.use(parser.json())

    app.set('view engine', 'ect');
    app.engine('ect', renderer.render);
    app.use(express.static('web'));

    app.use(session({secret: secret, resave: true, saveUninitialized: true}))
    app.use(passport.initialize())
    app.use(passport.session())

    let db = await MongoClient.connect(config.mongo)
    
    Auth.users = await db.collection('users')

    // Setup passport
    passport.serializeUser(Auth.serialize)
    passport.deserializeUser(Auth.deserialize)

    passport.use('login', new LocalStrategy(
        {passReqToCallback: true},
        Auth.login
    ))
    
    passport.use('signup', new LocalStrategy(
        {passReqToCallback: true},
        Auth.signup
    ))

    // Serve
    setup(app, routes)

    app.post('/login', passport.authenticate('login', {
        successRedirect: '/',
        failureRedirect: '/login',
        failureFlash: false 
    }))
    
    app.post('/signup', passport.authenticate('signup', {
        successRedirect: '/',
        failureRedirect: '/signup',
        failureFlash: false 
    }))

    // Default page
    app.use(default404)

    // Start server
    app.listen(config.port, config.host, function () {
        console.log(config.name + ' started at ' + config.host + ':' + config.port)
    })
}