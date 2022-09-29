"use strict";

var internals = {};
const Place = require("../../database/models/Place");
const User = require("../../database/models/User");
const Visitor = require("../../database/models/Visitor");
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

internals.admin_dashboard_count = async (req, reply) => {
  try {
    var totalUsers = await User.countDocuments({
      scope: "GUEST",
    });
    var totalPlaces = await Place.countDocuments({});
    var totalPlacesByCategory = await Place.aggregate([
      {
        $group: {
          _id: "$categoryId",
          count: { $sum: 1 },
        },
      },
    ]);
    return reply
      .response({
        data: {
          totalUsers,
          totalPlaces,
          totalPlacesByCategory,
        },
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

internals.admin_dashboard_likes = async (req, reply) => {
  try {
    var likesCount = await Place.aggregate([
      {
        $lookup: {
          from: "favorites",
          localField: "_id",
          foreignField: "placeId",
          pipeline: [
            {
              $group: {
                _id: 1,
                count: { $sum: 1 },
              },
            },
          ],
          as: "favorites",
        },
      },
      {
        $unwind: "$favorites",
      },
      {
        $project: {
          _id: "$_id",
          name: "$name",
          photos: "$photos",
          favorites: "$favorites",
        },
      },
    ]);
    return reply
      .response({
        data: {
          likesCount,
        },
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

internals.admin_dashboard_ratings = async (req, reply) => {
  try {
    var ratingsCount = await Place.aggregate([
      {
        $lookup: {
          from: "reviews",
          localField: "_id",
          foreignField: "placeId",
          pipeline: [
            {
              $group: {
                _id: "$placeId",
                rating: { $sum: "$rating" },
                count: { $sum: 1 },
              },
            },
            {
              $project: {
                _id: 0,
                average: { $divide: ["$rating", "$count"] },
                reviewerCount: "$count",
              },
            },
          ],
          as: "reviewsStat",
        },
      },
      {
        $unwind: "$reviewsStat",
      },
      {
        $project: {
          _id: "$_id",
          name: "$name",
          photos: "$photos",
          reviewsStat: "$reviewsStat",
        },
      },
    ]);

    return reply
      .response({
        data: {
          ratingsCount,
        },
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

internals.visitor_form = async (req, reply) => {
  let payload = req.payload;

  try {
    await Visitor(payload).save();
    return reply
      .response({
        message: "Information saved.",
      })
      .code(200);
  } catch (e) {
    console.log(e);
    return reply
      .response({
        message: "Server error",
      })
      .code(500);
  }
};

module.exports = internals;
