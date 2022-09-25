"use strict";
var Handlers = require("./handlers"),
  internals = {};

internals.endpoints = [
  {
    method: ["GET"],
    path: "/places",
    options: {
      handler: Handlers.places,
      auth: {
        mode: "try",
      },
    },
  },
  {
    method: ["GET"],
    path: "/places/{id}",
    options: {
      handler: Handlers.place_info,
      auth: {
        mode: "try",
      },
    },
  },
  {
    method: ["GET"],
    path: "/places/like/{id}",
    handler: Handlers.like_place,
    config: {
      auth: "token",
    },
  },
];

module.exports = internals;
