const mongoose = require("mongoose");

//Set up default mongoose connection
const mongoDB = "mongodb://localhost:2277/andon";
mongoose.connect(
  mongoDB,
  { useUnifiedTopology: true, useNewUrlParser: true },
  (error) => {
    if (!error) {
      console.log("Success");
    } else {
      console.log("Error Connection to database");
    }
  }
);
