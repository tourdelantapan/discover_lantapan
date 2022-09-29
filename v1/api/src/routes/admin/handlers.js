"use strict";

var internals = {};
const Place = require("../../database/models/Place");
const { getUrlsArray } = require("../../libraries/aws-s3-storage-upload");

internals.add_place = async (req, reply) => {
  let payload = req.payload;

  let newPlace = Place({
    coordinates: {
      latitude: parseFloat(payload.latitude),
      longitude: parseFloat(payload.longitude),
    },
    ...payload,
  });

  if (Array.isArray(payload.photos) && payload.photos.length != 0) {
    let photosUrl = await getUrlsArray(payload.photos, newPlace._id, "place");
    newPlace.photos = photosUrl;
  } else {
    delete payload.photos;
  }

  try {
    await newPlace.save();
    return reply
      .response({
        message: "Place added",
      })
      .code(200);
  } catch (e) {
    return reply
      .response({
        message: "Server error",
      })
      .code(500);
  }
};

module.exports = internals;
