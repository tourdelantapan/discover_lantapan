"use strict";

var internals = {};

// Endpoints
let Auth = require("../routes/auth/endpoints");
let Places = require("../routes/places/endpoints");

internals.routes = [...Auth.endpoints, ...Places.endpoints];

internals.init = function (server) {
  server.route(internals.routes);
};

module.exports = internals;
