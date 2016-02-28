'use strict'

// Imports
let parser = require('body-parser')
let ect = require('ect');
let express = require('express')
let passport = require('passport')
let session = require('express-session')
let mongodb = require('mongodb');

import * as Auth from './auth'
import * as Pages from './pages'

// Namespace
let LocalStrategy = require('passport-local')
let MongoClient = mongodb.MongoClient

let config = require('./config.json')

async function main() {
    // Basic setup
    let app = express()
    let renderer = ect({ watch: true, root: __dirname + '/views', ext: '.ect'})

    app.use(parser.urlencoded({extended: true}))

    app.set('view engine', 'ect');
    app.engine('ect', renderer.render);
    app.use(express.static('web'));

    app.use(session({secret: 'random'}))
    app.use(passport.initialize())
    app.use(passport.session())

    let db = await MongoClient.connect(config.mongo)
    
    Auth.init(db)

    // Setup passport
    passport.serializeUser(Auth.serialize)
    passport.deserializeUser(Auth.deserialize)

    passport.use('login', new LocalStrategy(
        {passReqToCallback: true},
        Auth.login
    ))

    // Serve
    app.get('/', Auth.check, Pages.index)
    app.get('/login', Pages.login)

    app.post('/login', passport.authenticate('login', {
        successRedirect: '/',
        failureRedirect: '/login',
        failureFlash: false 
    }))

    app.use(Pages.default404)

    app.listen(config.port, config.host, function () {
        console.log(config.name + ' started at ' + config.host + ':' + config.port)
    })
}

main()