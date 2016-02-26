"use strict"

let parser = require('body-parser')
let ect = require('ect');
let express = require('express')
let passport = require('passport')
let session = require('express-session')

let config = require('./config.json')

let LocalStrategy = require('passport-local') 

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

let occash = {
    id: 'trololo',
    username: 'occash',
    password: '1'
}

// Setup passport
passport.serializeUser(function(user, done) {
    done(null, user.id);
});
 
passport.deserializeUser(function(id, done) {
    let err = 'error'
    let user = null
    
    if (id == occash.id) {
        err = null
        user = occash
    }
        
    done(err, user)
});

passport.use('login', new LocalStrategy(
    {passReqToCallback: true},
    function (req, username, password, done) {
        console.log('trololo')
        
        let err = 'error'
        let user = null
        
        if (username == occash.username &&
            password == occash.password) {
            err = null
            user = occash
        }
            
        done(err, user)
    }
))

let auth = function (req, res, next) {
    if (req.isAuthenticated())
        return next()
        
    res.redirect('/login')
}

// Serve
app.get('/', auth, function (req, res) {
    res.render('index', {user: req.user.username})
})

app.get('/login', function (req, res) {
    res.render('login')
})

app.post('/login', passport.authenticate('login', {
    successRedirect: '/',
    failureRedirect: '/login',
    failureFlash: false 
}))

app.use(function(req, res, next){
    res.status(404);

    // respond with html page
    if (req.accepts('html')) {
        res.render('404', { url: req.url });
        return;
    }

    // respond with json
    if (req.accepts('json')) {
        res.send({error: 'Not found'});
        return;
    }

    // default to plain-text. send()
    res.type('txt').send('Not found');
});

app.listen(config.port, config.host, function () {
    console.log(config.name + ' started at ' + config.host + ':' + config.port)
})