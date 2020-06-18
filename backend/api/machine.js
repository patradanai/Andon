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
  database: "AndonAnnounce",
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
  const query = "SELECT * from [machine]";
  executeQuery(res, query);
});

router.get("/name", (req, res) => {
  const query =
    "SELECT a.machine,b.model,a.machine + '_' + b.model as Combine \
        from machine a \
           inner join model b on a.machineId = b.machineId";
  executeQuery(res, query);
});

router.get("/request", (req, res) => {
  console.log("Fetch GET");
  const query =
    "SELECT m.machine,r.request \
                    from request r\
                      inner join machine m on r.machineId = m.machineId";
  executeQuery(res, query);
});

router.get("/zone", (req, res) => {
  console.log("Fetch GET");
  const query =
    "SELECT m.machine,z.zone \
                  from zone z\
                    inner join machine m on z.machineId = m.machineId";
  executeQuery(res, query);
});

module.exports = router;
