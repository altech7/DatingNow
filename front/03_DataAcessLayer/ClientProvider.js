'use strict';

(function init() {
    var User = require('../04_MODELS/User');
    var bcrypt = require('bcrypt-nodejs');
    var jwt = require('jsonwebtoken');
    var sqlite3 = require('sqlite3').verbose();
    var db = new sqlite3.Database('datingnow');

    UserProvider.prototype.update = _update;
    UserProvider.prototype.save = _save;
    UserProvider.prototype.findById = _findById;
    UserProvider.prototype.findByEmailAndPseudo = _findByEmailAndPseudo;
    UserProvider.prototype.findByEmailAndPassword = _findByEmailAndPassword;
    UserProvider.prototype.findByEmail = _findByEmail;
    UserProvider.prototype.signinByEmail = _signinByEmail;
    UserProvider.prototype.signup = _signup;

    function UserProvider() {
    }

    function _save(json, callback) {
        db.run("INSERT INTO Client(email,password,pseudo) VALUES($email,$password,$pseudo)", {
            $email: json.email,
            $password: json.password,
            $pseudo: json.pseudo

        }, function (statement) {
            if (statement == null) {
                _findById(this.lastID, function (err, user) {
                    return callback(err, user);
                });
            }
        });
    };

    function _findByEmailAndPassword(email, password, callback) {
        db.get("SELECT * FROM Client WHERE email = $email", {
                $email: email
            },
            function (err, userFinded) {
                if (err) {
                    // call your callback with the error
                    return callback(err);
                }
                if (!userFinded) {
                    return callback({
                        statusHttp: 404,
                        message: 'User not found.'
                    });
                }
                if (!bcrypt.compareSync(password, userFinded.password)) {
                    return callback({
                        statusHttp: 404,
                        message: 'User not authenticated.'
                    });
                }

                return callback(null, userFinded);
            });
    };

    function _findById(id, callback) {
        db.get("SELECT * FROM Client WHERE id = $id", {
                $id: id
            },
            function (err, userFinded) {
                if (err) {
                    // call your callback with the error
                    return callback(err);
                }
                if (!userFinded) {
                    return callback({
                        statusHttp: 404,
                        message: 'User not found.'
                    });
                }

                return callback(null, userFinded);
            });
    };

    function _findById(id, callback) {
        db.get("SELECT * FROM Client WHERE id = $id", {
                $id: id
            },
            function (err, clientFinded) {
                if (err) {
                    // call your callback with the error
                    return callback(err);
                }
                if (!clientFinded) {
                    return callback({
                        statusHttp: 404,
                        message: 'Client not found.'
                    });
                }

                return callback(null, clientFinded);
            });
    };

    function _findByEmail(email, callback) {
        db.get("SELECT * FROM Client WHERE email = $email", {
                $email: email
            },
            function (err, userFinded) {
                if (err) {
                    // call your callback with the error
                    return callback(err);
                }
                if (!userFinded) {
                    return callback({
                        statusHttp: 404,
                        message: 'User not found.'
                    });
                }

                return callback(null, userFinded);
            });
    };

    function _findByEmailAndPseudo(email, pseudo, callback) {
        db.get("SELECT * FROM Client WHERE email = $email AND pseudo = $pseudo", {
                $email: email,
                $pseudo: pseudo
            },
            function (err, userFinded) {
                if (err) {
                    // call your callback with the error
                    return callback(err);
                }

                return callback(null, userFinded);
            });
    };

    function _update(id, challenge, callback) {
        db.run("UPDATE Client SET challenge = $challenge WHERE id = $id", {
            $id: id,
            $challenge: challenge
        }, function (err, userUpdated) {
            if (err) {
                return callback(err);
            }

            return callback(null, userUpdated);
        });
    }

    function _signinByEmail(email, callback) {

        this.findByEmail(email, function (err, userFinded) {
            if (err) {
                return callback(err);
            }
            try {
                var token = jwt.sign(userFinded, process.env.JWT_SECRET, {
                    expiresIn: "86400000" // expires in 24 hours
                });
                return callback(err, token);
            } catch (err) {
                err.statusHttp = 500;
                return callback(err);
            }
        });
    };

    function _signup(email, pseudo, password, callback) {

        try {
            _findByEmailAndPseudo(email, pseudo, function (err, clientAlreadyExisting) {
                if (clientAlreadyExisting) {
                    var error = new Error();
                    error.message = 'This client is already present';
                    error.statusHttp = 500;
                    return callback(error);
                }

                //var password = bcrypt.hashSync(password, bcrypt.genSaltSync(8), null);
                var user = {
                    password: password, email: email, pseudo: pseudo
                };

                _save(user, function (err, userSaved) {
                    return callback(err, userSaved);
                });
            });
        } catch (err) {
            err.statusHttp = 500;
            return callback(err);
        }
    };

    module.exports = new UserProvider();
})();