const express = require("express");
const app = express();
const sockerIO = require("socket.io");
const cors = require("cors");
const bodyParser = require("body-parser");
const mongoose = require("mongoose");
const Port = process.env.PORT || 4900;

app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Homepage
app.get("/", (req, res) => {
  res.status(200).send("Welcome My World");
});

// Category
const category = require("./api/category");

app.use("/api/category", category);

// Process
const eventProcess = require("./api/eventProcess");

app.use("/api/process", eventProcess);

app.listen(Port, () => {
  console.log(`BACKEND ON PORT ${Port}`);
});
