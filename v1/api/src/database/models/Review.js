const mongoose = require("mongoose");

const Schema = new mongoose.Schema(
  {
    rating: {
      type: Number,
      required: true,
    },
    content: {
      type: String,
      required: true,
    },
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model("Review", Schema);
