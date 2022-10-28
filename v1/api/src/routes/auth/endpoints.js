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
  {
    method: "GET",
    path: "/user/email-reset-password",
    handler: Handlers.email_reset_password,
    config: {
      auth: false,
    },
  },
  {
    method: ["GET"],
    path: "/user/reset-password-form/{token}",
    handler: Handlers.reset_password_form,
    config: {
      auth: false,
    },
  },
  {
    method: ["POST"],
    path: "/user/initiate-password-reset/{userId}",
    handler: Handlers.initiate_password_reset,
    config: {
      auth: false,
    },
  },
];

module.exports = internals;
