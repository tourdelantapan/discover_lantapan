"use strict";

var internals = {};
const Place = require("../../database/models/Place");
const User = require("../../database/models/User");
const Visitor = require("../../database/models/Visitor");
const Review = require("../../database/models/Review");
const GasStation = require("../../database/models/GasStation");
const { getUrlsArray } = require("../../libraries/aws-s3-storage-upload");
require("../../database/models/GasStation")();

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

internals.nearby_gas_stations = async (req, reply) => {
  let { userLocation } = req.query;
  let query = {};

  try {
    userLocation = userLocation && JSON.parse(userLocation);
    console.log(userLocation);
    const distance = 25;
    const unitValue = 1000;
    if (userLocation?.longitude && userLocation?.latitude) {
      query = {
        ...query,
        coordinates: {
          $near: {
            $maxDistance: distance * unitValue,
            $geometry: {
              type: "Point",
              coordinates: [userLocation?.longitude, userLocation?.latitude],
            },
          },
        },
      };
    }

    var gasStations = await GasStation.find(query);

    return reply
      .response({
        data: {
          gasStations,
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

const stations = [
  /* 1 */
  {
    name: "AGT Petroleum",
    photos: [],
    coordinates: {
      type: "Point",
      coordinates: [8.05521525710373, 125.134475232513],
    },
  } /* 2 */,

  {
    name: "Caltex",
    photos: [],
    coordinates: {
      type: "Point",
      coordinates: [8.05563752034916, 125.13424456254],
    },
  } /* 3 */,

  {
    name: "JACC Fuel",
    photos: [],
    coordinates: {
      type: "Point",
      coordinates: [8.05183142953978, 125.131066879656],
    },
  } /* 4 */,

  {
    name: "Petron",
    photos: [],
    coordinates: {
      type: "Point",
      coordinates: [8.05567735647946, 125.134673715972],
    },
  } /* 5 */,

  {
    name: "RM C Petrol",
    photos: [],
    coordinates: {
      type: "Point",
      coordinates: [8.04965369465056, 125.126550039743],
    },
  } /* 6 */,

  {
    name: "JC Petron",
    photos: [],
    coordinates: {
      type: "Point",
      coordinates: [8.05388234092127, 125.138769679707],
    },
  } /* 7 */,

  {
    name: "Phoenix Aglayan",
    photos: [],
    coordinates: {
      type: "Point",
      coordinates: [8.0535666328871, 125.136385951785],
    },
  } /* 8 */,

  {
    name: "AIIJI Gasoline Station",
    photos: [],
    coordinates: {
      type: "Point",
      coordinates: [7.99984310401245, 125.02408862699],
    },
  } /* 9 */,

  {
    name: "PLC Fuel",
    photos: [],
    coordinates: {
      type: "Point",
      coordinates: [7.99878655610082, 125.021624828727],
    },
  } /* 10 */,

  {
    name: "M & Y Gasoline Station",
    photos: [],
    coordinates: {
      type: "Point",
      coordinates: [7.99888973362361, 125.027093281981],
    },
  } /* 11 */,

  {
    name: "Gas Station",
    photos: [],
    coordinates: {
      type: "Point",
      coordinates: [7.99748854905563, 125.029272723886],
    },
  } /* 12 */,

  {
    name: "Phoenix Gasoline Station",
    photos: [],
    coordinates: {
      type: "Point",
      coordinates: [8.00289358643431, 125.010119681997],
    },
  } /* 13 */,

  {
    name: "NIPA GASOLINE STATION",
    photos: [],
    coordinates: {
      type: "Point",
      coordinates: [8.02581809234537, 124.989592194115],
    },
  } /* 14 */,

  {
    name: "Aiji Fuel",
    photos: [],
    coordinates: {
      type: "Point",
      coordinates: [8.04965552878343, 124.896842687902],
    },
  } /* 15 */,

  {
    name: "RC Fuel",
    photos: [],
    coordinates: {
      type: "Point",
      coordinates: [8.047666711539, 124.893371212762],
    },
  } /* 16 */,

  {
    name: "UELZONE",
    photos: [],
    coordinates: {
      type: "Point",
      coordinates: [8.04957239698852, 124.891225645977],
    },
  },
];

module.exports = internals;
