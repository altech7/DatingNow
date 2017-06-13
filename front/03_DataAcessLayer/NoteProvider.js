'use strict';

(function init() {
        var User = require('../04_MODELS/User');
        var DatesHelper = require('../01_Commons/DatesHelper');
        var clientProvider = require('../03_DataAcessLayer/ClientProvider');
        var bcrypt = require('bcrypt-nodejs');
        var jwt = require('jsonwebtoken');
        var moment = require('moment');
        var sqlite3 = require('sqlite3').verbose();
        var db = new sqlite3.Database('datingnow');

        NoteProvider.prototype.findAllByPeopleDating = _findAllByPeopleDating;
        NoteProvider.prototype.findById = _findById;
        NoteProvider.prototype.save = _save;
        NoteProvider.prototype.update = _update;
        NoteProvider.prototype.saveOrUpdate = _saveOrUpdate;

        function NoteProvider() {
        }

        function _update(id, dateOfSharing, note, peopleDatingId, clientId, pseudo, callback) {
            db.run("UPDATE Note SET note = $note, dateOfSharing = $dateOfSharing, peopleDatingId = $peopleDatingId WHERE id = $id ", {
                $id: id,
                $clientId: clientId,
                $note: note,
                $dateOfSharing: dateOfSharing,
                $peopleDatingId: peopleDatingId,
                $pseudo: pseudo
            }, function (statement) {
                if (statement == null) {
                    _findById(id, function (err, note) {
                        return callback(err, note);
                    });
                }
            });
        }

        function _save(dateOfSharing, note, peopleDatingId, clientId, pseudo, callback) {
            db.run("INSERT INTO Note(note,dateOfSharing,peopleDatingId,clientId,pseudo) VALUES($note,$dateOfSharing,$peopleDatingId,$clientId,$pseudo)", {
                $note: note,
                $dateOfSharing: dateOfSharing,
                $peopleDatingId: peopleDatingId,
                $clientId: clientId,
                $pseudo: pseudo
            }, function (statement) {
                if (statement == null) {
                    _findById(this.lastID, function (err, note) {
                        return callback(err, note);
                    });
                }
            });
        }

        function _saveOrUpdate(id, dateOfSharing, note, peopleDatingId, clientId, pseudo, callback) {
            dateOfSharing = DatesHelper.fromDateStringUrlToDate(dateOfSharing);
            if (id !== "nil") {
                _findById(id, function (err, note) {
                    if (err) {
                        return callback(err);
                    }
                    if (note) {
                        _update(id, dateOfSharing, note, peopleDatingId, clientId, pseudo, function (err, noteSaved) {
                            if (err) {
                                return callback(err);
                            }
                            return callback(err, noteSaved);
                        });
                    }
                });
            } else {
                _save(dateOfSharing, note, peopleDatingId, clientId, pseudo, function (err, noteSaved) {
                    if (err) {
                        return callback(err);
                    }
                    return callback(err, noteSaved);
                })
            };
        }

        function _findById(id, callback) {
            db.get("SELECT * FROM Note WHERE id = $id", {
                    $id: id
                },
                function (err, noteFinded) {
                    if (err) {
                        // call your callback with the error
                        return callback(err);
                    }
                    if (!noteFinded) {
                        return callback({
                            statusHttp: 404,
                            message: 'Not not found.'
                        });
                    }

                    return callback(null, noteFinded);
                });
        };

        function _findAllByPeopleDating(peopleDatingId, callback) {
            db.all("SELECT * FROM Note WHERE peopleDatingId = $peopleDatingId", {
                    $peopleDatingId: peopleDatingId
                },
                function (err, rows) {
                    if (err) {
                        return callback(err);
                    }

                    var notes = new Array();
                    rows.forEach(function (row) {
                        var time = new Date().getTime();
                        row.dateOfSharing = new Date(time);
                        notes.push({
                            clientId: row.clientId,
                            peopleDatingId: row.peopleDatingId,
                            dateOfSharing: moment(row.dateOfSharing).format("DD-MM-YYYY"),
                            note: row.note,
                            pseudo: row.pseudo
                        });
                    });

                    return callback(null, notes);
                });
        };

        module.exports = new NoteProvider();
    })
();