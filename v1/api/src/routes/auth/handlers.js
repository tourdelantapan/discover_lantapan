"use strict";

var internals = {};
const User = require("../../database/models/User");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const mongoose = require("mongoose");
const Config = require("../../config");

const ObjectId = mongoose.Types.ObjectId;

// SEPARATE THIS handlers because naga sagol2 nani diri hahahah

internals.profile = async (req, reply) => {
  try {
    if (!req?.auth?.credentials?.email) {
      return reply
        .response({
          message: "Data not found",
          data: {},
        })
        .code(201);
    }

    let _profile = await User.findOne({
      email: req.auth.credentials.email,
    });

    let profile = JSON.parse(JSON.stringify(_profile));
    delete profile.password;
    delete profile.__v;
    delete profile.createdAt;
    delete profile.updatedAt;

    return reply
      .response({
        message: "Success.",
        data: {
          profile,
        },
      })
      .code(200);
  } catch (e) {
    return reply
      .response({
        errorMessage: e,
      })
      .code(500);
  }
};

internals.login = async (req, reply) => {
  const { email, password } = req.payload;

  try {
    let _profile = await User.findOne({ email });

    if (!_profile) {
      return reply
        .response({
          message: "Email not found.",
        })
        .code(404);
    }
    let validPass = await bcrypt.compare(password, _profile.password);
    if (!validPass) {
      return reply
        .response({
          message: "Incorrect password.",
        })
        .code(405);
    }

    let profile = JSON.parse(JSON.stringify(_profile));
    delete profile.password;
    delete profile?.__v;
    delete profile?.createdAt;
    delete profile?.updatedAt;

    return reply
      .response({
        message: "Success",
        data: {
          accessToken: jwt.sign({ id: profile._id }, Config.crypto.privateKey),
          ...profile,
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

internals.signup = async (req, res) => {
  let newUser = User(req.payload);
  newUser.password = await bcrypt.hash(req.payload.password, 10);

  if (!req.payload.email.match(/.+@.+\.[A-Za-z]+$/))
    return res
      .response({
        message: "Invalid email format",
      })
      .code(422);
  if (req.payload.password?.length < 4)
    return res
      .response({
        message: "Password too short.",
      })
      .code(422);

  return await User.findOne({ email: req.payload.email }).then(
    (data, error) => {
      if (error)
        return res
          .response({
            message: "Error in the server",
          })
          .code(500);

      if (data)
        return res
          .response({
            message: "Email already taken.",
          })
          .code(409);
      else {
        return newUser
          .save()
          .then(async () => {
            return res
              .response({
                message: "Successfully signed up. You can log in now.",
              })
              .code(200);
          })
          .catch((err) => {
            console.log(err);
            return res
              .response({
                message: "There is an error in the server.",
              })
              .code(500);
          });
      }
    }
  );
};

module.exports = internals;
