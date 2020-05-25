const mongoose = require("mongoose");

const Schema = mongoose.Schema;

const modelSchema = new Schema({
  machine: {
    type: String,
  },
  operation: {
    type: String,
  },
  created: {
    type: Date,
  },
});

module.exports = mongoose.model("Event", modelSchema);
