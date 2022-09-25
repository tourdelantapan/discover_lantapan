const mongoose = require("mongoose");

const Schema = new mongoose.Schema(
  {
    fullName: {
      type: String,
      required: true,
    },
    email: {
      type: String,
      required: true,
    },
    password: {
      type: String,
      required: true,
    },
    scope: {
      type: Array,
      default: ["GUEST"],
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model("User", Schema);
