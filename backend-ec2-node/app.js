'use strict'

// Imports
const parser = require('body-parser')
const ect = require('ect');
const express = require('express')
const passport = require('passport')
const session = require('express-session')
const mongodb = require('mongodb');

import {Auth} from './auth'
import {default404} from './pages'
import {routes} from './routes'

// Namespace
const LocalStrategy = require('passport-local')
const MongoClient = mongodb.MongoClient

// Config
const config = require('./config.json')
const secret = 'Luke, I am your father'


function setup (app, routes) {
    for (let route of routes) {
        let path = route[0]
        let Handler = route[1]
        let middle = route.length > 2 ? route[2] : []
        
        var handler = new Handler()        
        if ('get' in handler)
            app.get(path, middle, handler['get'])
        
        if ('post' in handler)
            app.get(path, middle, handler['post'])
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

    passport.use('signin', new LocalStrategy(
        {passReqToCallback: true},
        Auth.signin
    ))
    
    passport.use('signup', new LocalStrategy(
        {passReqToCallback: true},
        Auth.signup
    ))

    // Serve
    setup(app, routes)

    app.post('/signin', passport.authenticate('signin', {
        successRedirect: '/',
        failureRedirect: '/signin',
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