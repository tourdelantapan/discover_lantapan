"use strict";

var internals = {};
const Place = require("../../database/models/Place");
const Favorite = require("../../database/models/Favorite");

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

    return reply
      .response({
        message: "Place fetched successfully",
        data: {
          place,
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

module.exports = internals;
