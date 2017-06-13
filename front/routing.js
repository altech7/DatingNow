var userProvider = require('./03_DataAcessLayer/ClientProvider');
var authenticationHelpers = require('./01_Commons/authenticationHelpers');

module.exports = function (provider) {
    var publicDir = __dirname + '/public/',
        css = publicDir,
        js = publicDir,
        fonts = publicDir,
        nodeModulesDir = __dirname + '/node_modules/';


    provider.get(['*/nm/*'],
        function (req, res) {
            var urlOfFile = req.originalUrl.split('/nm/')[1];
            res.sendFile(nodeModulesDir + urlOfFile);
        }
    );

    provider.get(['*.css', '!*/node_modules/*'], function (req, res) {
            res.sendFile(css + req.originalUrl);
        }
    );

    provider.get(['*.woff', '*.ttf', '*.woff2'], function (req, res) {
            res.sendFile(fonts + req.path);
        }
    );
};
