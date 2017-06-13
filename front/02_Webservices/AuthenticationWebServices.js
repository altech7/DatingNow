'use strict';

function init(provider) {
    var authenticationHelpers = require('../01_Commons/authenticationHelpers');
    var clientProvider = require('../03_DataAcessLayer/ClientProvider');

    var _signup = function (req, res) {
        clientProvider.signup(req.body.email, req.body.pseudo, req.body.password, function (err, client) {
            if (err) {
                console.error(err);
                res.status((err.statusHttp ? err.statusHttp : 500)).send({
                    error: err.message
                });
            } else {
                res.status((200))
                    .send(client);
            }
        });
    };

    var _getUserAuthenticated = function (req, res) {
        res.send(req.user);
    };

    var _getChallenge = function (req, res) {
        authenticationHelpers.getChallenge(req.body.email, function (err, randomString) {
            if (err) {
                console.error(err);
                res.status((err.statusHttp ? err.statusHttp : 500)).send({
                    error: err.message
                });
            } else {
                res.status((200))
                    .send({randomString: randomString});
            }
        });
    };

    var _verifyChallenge = function (req, res) {
        authenticationHelpers.verifyChallenge(req.body.email, req.body.challenge, function (err, client) {
            if (err) {
                console.error(err);
                res.status((err.statusHttp ? err.statusHttp : 500)).send({
                    error: err.message
                });
            } else {
                res.status(200)
                    .send(client);
            }
        });
    };

    provider.post("/signup", _signup);
    provider.post("/getChallenge", _getChallenge);
    provider.post("/verifyChallenge", _verifyChallenge);
    provider.get('/isAuthenticated', authenticationHelpers.ensureAuthorized, _getUserAuthenticated);
};

module.exports = init;