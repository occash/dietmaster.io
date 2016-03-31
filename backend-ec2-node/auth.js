'use strict'

const mongodb = require('mongodb');
const crypto = require('crypto')
const utf8 = require('utf8')

//namespace
const ObjectID = mongodb.ObjectID

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
            /*let hash = crypto.createHash('sha256');
            let salt = user.private.salt.buffer
            let rawpass = new Buffer(password, 'utf8')
            let pass = user.private.password.buffer
            
            console.log(Buffer.concat([salt, rawpass]))
            
            hash.update(Buffer.concat([salt, rawpass]))
            let hexpass = hash.digest()
            
            console.log(pass)
            console.log(hexpass)
            
            if (hexpass == pass)
                done(null, user)
            else
                done('Incorrect password', null)*/
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