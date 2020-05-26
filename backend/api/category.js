const express = require("express");
const router = express.Router();
const sql = require("mssql");

//Initiallising connection string
const dbConfig = {
  authentication: {
    type: "default",
    options: { userName: "sa", password: "qwerty@1" },
  },
  server: "172.16.73.146",
  database: "AndonDB",
  options: { encrypt: false, enableArithAbort: false },
};

// Functon Connect SQL SERVER

const executeQuery = (res, query) => {
  sql.connect(dbConfig, (err) => {
    if (err) {
      console.log("Error while connecting database :- " + err);
      res.send(err);
    } else {
      // create Request object
      const request = new sql.Request();
      // query to the database
      request.query(query, (err, recordset) => {
        if (err) {
          console.log("Error while querying database :- " + err);
          res.send(err);
        } else {
          res.send(recordset.recordset);
        }
      });
    }
  });
};

router.get("/", (req, res) => {
  console.log("Fetch GET");
  const query = "SELECT * from [AndonDB].[dbo].[Andon_Category]";
  executeQuery(res, query);
});

module.exports = router;
