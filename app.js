// this is the entry point to run the built application in production.
'use strict';

var server = require('./dist/server/express');

var options = {
  port: process.env.PORT || 8000,
};

server.use(server.express.static(__dirname + '/dist/app'));

server.listen(options.port, function() {
  console.log('Web server started on ' + options.hostname + ':' + options.port + ' using the built app in "dist"');
});