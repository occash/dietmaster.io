"use strict"

let express = require('express')
let ect = require('ect');
let config = require('./config.json')

// Basic setup
let app = express()
let renderer = ect({ watch: true, root: __dirname + '/views', ext: '.ect'})

app.set('view engine', 'ect');
app.engine('ect', renderer.render);
app.use(express.static('web'));

// Serve
app.get('/', function (req, res) {
    res.render('index');
});

app.listen(config.port, config.host, function () {
    console.log(config.name + ' started at ' + config.host + ':' + config.port);
});