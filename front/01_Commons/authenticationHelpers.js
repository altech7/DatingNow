'use strict';

(function init() {
    var jwt = require('jsonwebtoken');
    var crypto = require('crypto');
    var randomstring = require('randomstring');
    var clientProvider = require('../03_DataAcessLayer/ClientProvider');

    function AuthenticationsHelpers() {
    }

    AuthenticationsHelpers.prototype.getChallenge = function (email, callback) {
        clientProvider.findByEmail(email, function (err, clientFinded) {
            if (err) {
                return callback(err);
            }
            try {
                if (!clientFinded) {
                    return callback({
                        statusHttp: 404,
                        message: 'Client not found.'
                    });
                }

                //if (clientFinded.challenge) {
                    var randomString = randomstring.generate();
                    clientFinded.challenge = crypto
                        .createHash('md5')
                        .update(randomString + clientFinded.email + clientFinded.password)
                        .digest("hex");

                    clientProvider.update(clientFinded.id, clientFinded.challenge,
                        function (statement) {
                            if (statement == null) {
                                return callback(null, randomString);
                            }
                        });
                //}

            } catch (err) {
                err.statusHttp = 500;
                return callback(err);
            }
        });
    };

    AuthenticationsHelpers.prototype.verifyChallenge = function (email, challenge, callback) {
        clientProvider.findByEmail(email, function (err, clientFinded) {
            if (err) {
                return callback(err);
            }
            try {
                if (!clientFinded) {
                    return callback({
                        statusHttp: 404,
                        message: 'Client not found.'
                    });
                }

                if (clientFinded.challenge === challenge) {
                    /*
                     var token = jwt.sign(clientFinded, process.env.JWT_SECRET, {
                     expiresIn: "86400000" // expires in 24 hours
                     });
                     return callback({
                     statusHttp: 200,
                     token: token
                     });*/
                    return callback(null, clientFinded);
                }

                return callback({
                    statusHttp: 404,
                    message : "invalid credentials"
                });

            } catch (err) {
                err.statusHttp = 500;
                return callback(err);
            }
        });
    };

    AuthenticationsHelpers.prototype.ensureAuthorized = function (req, res, next) {
        var bearerToken;
        var bearerHeader = req.headers["authorization"];
        if (bearerHeader !== undefined) {
            var bearer = bearerHeader.split(" ");
            bearerToken = bearer[1];
            jwt.verify(bearerToken, process.env.JWT_SECRET, function (err, decoded) {
                if (err) {
                    res.status(400);
                    return res.json({success: false, message: 'Failed to authenticate token. (err : ' + err + ')'});
                } else {
                    // if everything is good, save to request for use in other routes
                    console.log(decoded);
                    req.user = decoded;
                    next();
                }
            });
        } else {
            res.status(403).send({
                success: false,
                message: 'No token provided.'
            });
        }
    };

    module.exports = new AuthenticationsHelpers();
})();