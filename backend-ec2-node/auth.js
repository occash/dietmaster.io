'use strict'

let mongodb = require('mongodb');
let ObjectID = mongodb.ObjectID

let users = null

export async function init (db) {
    users = await db.collection('users')
}

export function serialize (user, done) {
    done(null, user._id)
}

export async function deserialize (id, done) {
    try {
        let user = await users.findOne({_id: new ObjectID(id)})
        done(null, user)
    } catch (err) {
        done(err, null)
    }
}

export async function login (req, username, password, done) {
    try {
        let user = await users.findOne({username: username})
        done(null, user)
    } catch (err) {
        done(err, null)
    }
}

export async function signup (req, username, password, done) {
    try {
        let user = await users.findOne({username: username})
        done(null, user)
    } catch (err) {
        done(err, null)
    }
}

export function check (req, res, next) {
    if (req.isAuthenticated())
        return next()
        
    res.redirect('/login')
}