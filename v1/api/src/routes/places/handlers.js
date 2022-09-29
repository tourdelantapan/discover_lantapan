"use strict";

var internals = {};
const Place = require("../../database/models/Place");
const Review = require("../../database/models/Review");
const Favorite = require("../../database/models/Favorite");
const { getUrlsArray } = require("../../libraries/aws-s3-storage-upload");
const mongoose = require("mongoose");

internals.places = async (req, reply) => {
  let userId = req.auth.credentials?._id;

  try {
    let query = [
      {
        $lookup: {
          from: "categories",
          localField: "categoryId",
          foreignField: "_id",
          as: "categoryId",
        },
      },
      {
        $unwind: "$categoryId",
      },
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
    ];
    let filters = [];

    let { searchKey } = req.query;

    if (searchKey) {
      var re = new RegExp(searchKey, "i");
      filters.push({
        $or: [
          { name: { $regex: re } },
          { address: { $regex: re } },
          { "categoryId.name": { $regex: re } },
        ],
      });
    }

    if (userId) {
      query.push({
        $lookup: {
          from: "favorites",
          localField: "_id",
          foreignField: "placeId",
          pipeline: [
            {
              $match: {
                userId: userId,
              },
            },
            { $limit: 1 },
          ],
          as: "isLiked",
        },
      });
    }

    if (filters.length > 0) {
      query.push({
        $match: {
          $and: filters,
        },
      });
    }

    let places = await Place.aggregate(query);
    return reply
      .response({
        message: "Places fetched successfully",
        data: {
          places,
        },
      })
      .code(200);
  } catch (e) {
    console.log(e);
    return reply
      .response({
        message: "Error in the server",
      })
      .code(500);
  }
};

internals.place_info = async (req, reply) => {
  let userId = req.auth.credentials?._id;

  try {
    let _place = await Place.findOne({
      _id: req.params.id,
    }).populate("categoryId");

    if (!_place) {
      return reply
        .response({
          message: "Place not found",
        })
        .code(404);
    }

    let place = JSON.parse(JSON.stringify(_place));
    if (userId) {
      let isLiked = await Favorite.countDocuments({
        userId,
        placeId: req.params.id,
      });
      place.isLiked = isLiked > 0;
    }

    let reviewsStat = await Review.aggregate([
      { $match: { placeId: mongoose.Types.ObjectId(req.params.id) } },
      {
        $group: { _id: 0, rating: { $sum: "$rating" }, count: { $sum: 1 } },
      },
      {
        $project: {
          _id: 0,
          average: { $divide: ["$rating", "$count"] },
          reviewerCount: "$count",
        },
      },
    ]);

    place.reviewsStat = reviewsStat;

    let review = await Review.find({
      placeId: req.params.id,
    })
      .limit(1)
      .sort({ createdAt: -1 })
      .populate({
        path: "placeId",
        populate: {
          path: "categoryId",
        },
      })
      .populate("userId");

    console.log(place);

    return reply
      .response({
        message: "Place fetched successfully",
        data: {
          place,
          review: review?.[0],
        },
      })
      .code(200);
  } catch (e) {
    console.log(e);
    return reply
      .response({
        message: "Error in the server",
      })
      .code(500);
  }
};

internals.like_place = async (req, reply) => {
  let userId = req.auth.credentials._id;
  let placeId = req.params.id;

  try {
    let hasAlreadyLiked = await Favorite.findOne({
      userId,
      placeId,
    });

    if (hasAlreadyLiked) {
      await Favorite.deleteOne({
        userId,
        placeId,
      });
      return reply
        .response({
          message: "Place unliked.",
          data: {
            isLiked: false,
          },
        })
        .code(200);
    } else {
      await Favorite({
        userId,
        placeId,
      }).save();
      return reply
        .response({
          message: "Placed liked.",
          data: {
            isLiked: true,
          },
        })
        .code(200);
    }
  } catch (e) {
    return reply
      .response({
        message: "Error in the server",
      })
      .code(500);
  }
};

internals.place_review_add = async (req, reply) => {
  let userId = req.auth.credentials._id;
  let payload = req.payload;

  let newReview = Review({
    userId,
    ...payload,
  });

  if (Array.isArray(payload.photos) && payload.photos.length != 0) {
    let photosUrl = await getUrlsArray(payload.photos, newReview._id, "review");
    newReview.photos = photosUrl;
  } else {
    delete payload.photos;
  }

  try {
    await newReview.save();
    return reply
      .response({
        message: "Review added",
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

internals.places_reviews_list = async (req, reply) => {
  let placeId = req.params.id;

  try {
    let reviews = await Review.find({ placeId })
      .populate({
        path: "placeId",
        populate: {
          path: "categoryId",
        },
      })
      .populate("userId");

    return reply
      .response({
        data: {
          reviews,
        },
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
