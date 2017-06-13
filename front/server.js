var env = process.env.NODE_ENV || "development";
var dbConfig = require('./config/database.json')[env];
var express = require('express');
var app = express();
var endpointConfig = require('./config/endpoint.json')[env];
var http = require('http');
var morgan = require('morgan');
var bodyParser = require('body-parser');
var jwt = require('jsonwebtoken');
var cors = require('cors');
var fs = require("fs");
var sqlite3 = require('sqlite3').verbose();
var db = new sqlite3.Database('datingnow');

// configuration ==============================================================
app.set('port', process.env.PORT || endpointConfig.portNumber);
process.env.JWT_SECRET = 'appdatingnow';
//app.use(cookieParser()); // read cookies (needed for auth)
app.use(bodyParser.json());// get information from html forms
app.use(bodyParser.urlencoded({extended: true}));
// options ====================================================================
app.use(morgan('dev'));
// very request to the console
app.use(cors({credentials: true, origin: true}));

// WS
require('./routing')(app, jwt);
require('./02_Webservices/AuthenticationWebServices')(app);
require('./02_Webservices/NotesWebServices')(app);

//// Run server ==================================================================
db.serialize(function () {
    db.run("PRAGMA foreign_keys = ON");
    db.run("CREATE TABLE IF NOT EXISTS Client (id INTEGER PRIMARY KEY AUTOINCREMENT, email TEXT, password TEXT, pseudo TEXT, challenge TEXT)");
    db.run("CREATE TABLE IF NOT EXISTS Note (id INTEGER PRIMARY KEY AUTOINCREMENT, note TEXT, dateOfSharing DATE, peopleDatingId INTEGER, pseudo TEXT, clientId INTEGER, FOREIGN KEY(clientId) REFERENCES Client(id))");
});

app.listen(app.get('port'));

