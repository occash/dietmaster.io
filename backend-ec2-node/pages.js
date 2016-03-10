'use strict'

export function default404 (req, res, next) {
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
}

export class Index {
    get (req, res) {
        res.render('index', {user: req.user.username})
    }
}

export class Login {  
    get (req, res) {
        res.render('login')
    }
}