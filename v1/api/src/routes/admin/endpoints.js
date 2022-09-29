"use strict";
var Handlers = require("./handlers"),
  internals = {};

internals.endpoints = [
  {
    method: "POST",
    path: "/place/add",
    options: {
      payload: {
        output: "file",
        parse: true,
        multipart: true,
        maxBytes: 100000000000,
      },
      handler: Handlers.add_place,
      auth: {
        strategy: "token",
      },
    },
  },
  {
    method: "GET",
    path: "/admin/dashboard/count",
    handler: Handlers.admin_dashboard_count,
    config: {
      auth: "token",
    },
  },
  {
    method: "GET",
    path: "/admin/dashboard/likes",
    handler: Handlers.admin_dashboard_likes,
    config: {
      auth: "token",
    },
  },
  {
    method: "GET",
    path: "/admin/dashboard/ratings",
    handler: Handlers.admin_dashboard_ratings,
    config: {
      auth: "token",
    },
  },
];

module.exports = internals;
