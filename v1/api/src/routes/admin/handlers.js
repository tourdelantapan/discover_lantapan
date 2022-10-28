"use strict";

var internals = {};
const Place = require("../../database/models/Place");
const User = require("../../database/models/User");
const Visitor = require("../../database/models/Visitor");
const Review = require("../../database/models/Review");
const { getUrlsArray } = require("../../libraries/aws-s3-storage-upload");

internals.add_place = async (req, reply) => {
  let payload = req.payload;

  let newPlace = Place({
    coordinates: {
      latitude: parseFloat(payload.latitude),
      longitude: parseFloat(payload.longitude),
    },
    ...payload,
    timeTable: JSON.parse(payload.timeTable),
  });

  if (!Array.isArray(payload.photos) && payload.photos)
    payload.photos = [payload.photos];

  if (Array.isArray(payload.photos) && payload.photos.length != 0) {
    let photosUrl = await getUrlsArray(payload.photos, newPlace._id, "place");
    newPlace.photos = photosUrl;
  }

  if (!payload?.photos) {
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
        message: "",
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
    payload.address = JSON.parse(payload?.address);
  } catch (e) {
    return reply
      .response({
        message: "Error parsing address.",
      })
      .code(500);
  }

  console.log(payload);

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

internals.visitor_list = async (req, reply) => {
  try {
    let visitorList = await Visitor.find({})
      .populate({
        path: "placeId",
        populate: {
          path: "categoryId",
        },
      })
      .sort({ createdAt: -1 });

    let visitorCount = await Visitor.aggregate([
      { $group: { _id: 0, count: { $sum: "$numberOfVisitors" } } },
    ]);

    let visitorCountInBukidnon = await Visitor.aggregate([
      { $match: { "address.provinceId": "614c2580dd90f126474a5e26" } },
      { $group: { _id: 0, count: { $sum: "$numberOfVisitors" } } },
    ]);

    let visitorCountOutsideBukidnon = await Visitor.aggregate([
      { $match: { "address.provinceId": { $ne: "614c2580dd90f126474a5e26" } } },
      { $group: { _id: 0, count: { $sum: "$numberOfVisitors" } } },
    ]);

    return reply
      .response({
        message: "",
        data: {
          visitorList,
          visitorCount: visitorCount?.[0]?.count || 0,
          visitorCountInBukidnon: visitorCountInBukidnon?.[0]?.count || 0,
          visitorCountOutsideBukidnon:
            visitorCountOutsideBukidnon?.[0]?.count || 0,
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

internals.review_delete = async (req, reply) => {
  let reviewId = req.params.reviewId;

  try {
    await Review.deleteOne({ _id: reviewId });
    return reply
      .response({
        message: "Review/Comment successfully deleted.",
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
