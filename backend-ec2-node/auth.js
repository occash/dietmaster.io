'use strict'

let mongodb = require('mongodb');
let ObjectID = mongodb.ObjectID

let _users = null

export class Auth {  
    static set users (users) {
        _users = users
    }
    
    static get users () {
        return _users
    }
    
    static async serialize (user, done) {
        done(null, user._id)
    }
    
    static async deserialize (id, done) {
        try {
            let user = await _users.findOne({_id: new ObjectID(id)})
            done(null, user)
        } catch (err) {
            done(err, null)
        }
    }
    
    static async signin (req, username, password, done) {
        try {
            let user = await _users.findOne({username: username})
            done(null, user)
        } catch (err) {
            done(err, null)
        }
    }

    static async signup (req, username, password, done) {
        try {
            let user = await _users.findOne({username: username})
            done(null, user)
        } catch (err) {
            done(err, null)
        }
    }

    static async check (req, res, next) {
        if (req.isAuthenticated())
            return next()
            
        res.redirect('/signin')
    }
}