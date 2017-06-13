'use strict';

function init(provider) {
    var authenticationHelpers = require('../01_Commons/authenticationHelpers');
    var noteProvider = require('../03_DataAcessLayer/NoteProvider');

    var _findAllByPeopleDating = function (req, res) {
        noteProvider.findAllByPeopleDating(req.params.peopleDatingId, function (err, notes) {
            if (err) {
                res.status((err.statusHttp ? err.statusHttp : 500)).send({error: err.message});
            } else {
                res.status(200).send(notes);
            }
        });
    };

    var _saveOrUpdate = function (req, res) {
        noteProvider.saveOrUpdate(req.body.id, req.body.dateOfSharing, req.body.note, req.body.peopleDatingId, req.body.clientId, req.body.pseudo, function (err, note) {
            if (err) {
                console.error(err);
                res.status((err.statusHttp ? err.statusHttp : 500)).send({
                    error: err.message
                });
            } else {
                res.status((200))
                    .send({token: note});
            }
        });
    };

    provider.post("/note/share", _saveOrUpdate);
    provider.get("/note/find/peopleDating/:peopleDatingId", _findAllByPeopleDating);
};

module.exports = init;