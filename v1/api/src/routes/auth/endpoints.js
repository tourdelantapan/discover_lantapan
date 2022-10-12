"use strict";
var Handlers = require("./handlers"),
  internals = {};

internals.endpoints = [
  {
    method: ["GET"],
    path: "/profile",
    options: {
      handler: Handlers.profile,
      auth: {
        mode: "try",
      },
    },
  },
  {
    method: ["POST"],
    path: "/login",
    handler: Handlers.login,
    config: {
      auth: false,
    },
  },
  {
    method: ["POST"],
    path: "/signup",
    handler: Handlers.signup,
    config: {
      auth: false,
    },
  },
  {
    method: ["GET"],
    path: "/generate-otp",
    handler: Handlers.generate_otp,
    config: {
      auth: false,
    },
  },
  {
    method: ["GET"],
    path: "/confirm-otp/{pin}",
    handler: Handlers.confirm_pin,
    config: {
      auth: false,
    },
  },
];

module.exports = internals;
