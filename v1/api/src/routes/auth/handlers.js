"use strict";

var internals = {};
const User = require("../../database/models/User");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const mongoose = require("mongoose");
const Config = require("../../config");
const moment = require("moment");
const { sendOTP } = require("../../libraries/email-helper");
const ObjectId = mongoose.Types.ObjectId;

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

internals.generate_otp = async (req, reply) => {
  let { email, recipient_name } = req.query;
  const OTP = Math.floor(100000 + Math.random() * 900000);

  try {
    await User.updateOne(
      { email },
      {
        $push: {
          emailVerification: {
            isConfirmed: false,
            email,
            pin: OTP,
          },
        },
      },
      { new: true }
    );
    sendOTP(email, {
      recipient_name,
      OTP,
    });
    return reply
      .response({
        message: "OTP has been sent.",
      })
      .code(200);
  } catch (err) {
    console.log(err);
    return reply
      .response({
        message: "Server error.",
      })
      .code(500);
  }
};

internals.confirm_pin = async (req, reply) => {
  let pin = req.params.pin;
  let { email } = req.query;

  try {
    let user = await User.findOne({ email });

    if (!user) {
      return reply
        .response({
          message: "User not found.",
        })
        .code(404);
    }

    if (user?.emailVerification?.length === 0) {
      return reply
        .response({
          message: "No confirm pin yet.",
        })
        .code(404);
    }

    var currentPin;
    let pins = user.emailVerification;
    for (let i = 0; i < pins.length; i++) {
      if (i < pins.length - 1) {
        if (pins?.[i]?.pin === pin) {
          return reply
            .response({
              message: "Pin expired.",
            })
            .code(404);
        }
      } else {
        currentPin = pins[i];
      }
    }

    if (moment().diff(currentPin?.createdAt, "minutes") > 30) {
      return reply
        .response({
          message: "Pin expires after 30 minutes. Request a new one.",
        })
        .code(404);
    }

    if (currentPin?.pin === pin) {
      user.emailVerification[
        user.emailVerification.length - 1
      ].isConfirmed = true;

      await user.save();

      let profile = JSON.parse(JSON.stringify(user));
      delete profile.password;
      delete profile?.__v;
      delete profile?.createdAt;
      delete profile?.updatedAt;

      return reply
        .response({
          message: "Pin is correct. Your email is now verified.",
          data: {
            profile,
          },
        })
        .code(200);
    } else {
      return reply
        .response({
          message: "Pin incorrect.",
        })
        .code(404);
    }
  } catch (error) {
    console.log("err", error);
    return reply
      .response({
        message: "An error occurred.",
      })
      .code(500);
  }
};

module.exports = internals;
