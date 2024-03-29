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
        if (req.user)
            res.render('app', {user: req.user.username})
        else
            res.render('index')
    }
}

export class Signin {  
    get (req, res) {
        res.render('signin')
    }
}

export class Signup {  
    get (req, res) {
        res.render('signup')
    }
}

export class Terms {  
    get (req, res) {
        res.render('terms')
    }
}

export class Privacy {  
    get (req, res) {
        res.render('privacy')
    }
}