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

// Select All Machine except Done
router.get("/", (req, res) => {
  console.log("Fetch Get");
  const query = `SELECT * from [AndonDB].[dbo].[Andon_Event] WHERE process != 'End'`;
  executeQuery(res, query);
});

// Select Machine
router.post("/", (req, res) => {
  const body = req.body;
  console.log("Fetch Post");
  const query = `SELECT * from [AndonDB].[dbo].[Andon_Event] WHERE zoneName = '${body.machine}' AND process != 'End'`;
  executeQuery(res, query);
});

// Update Status
router.put("/update", (req, res) => {
  const body = req.body;
  const query = `UPDATE [AndonDB].[dbo].[Andon_Event] SET process = '${
    body.process
  }' WHERE id = ${parseInt(body.id)}`;
  executeQuery(res, query);
});

// Insert Log
router.post("/insert", (req, res) => {
  const body = req.body;
  const query = `INSERT INTO [AndonDB].[dbo].[Andon_log] (timedate,machine,operation,operator,elaspedtime,created,done) VALUES('${body.timestart}','${body.machine}','${body.operation}','${body.operator}','${body.elasp}','${body.timecreated}','${body.timedone}')`;
  console.log(query);
  executeQuery(res, query);
});

module.exports = router;
