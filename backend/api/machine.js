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
  console.log("Fetch GET All Machine");
  const query = "SELECT * from [machine]";
  executeQuery(res, query);
});

router.get("/name", (req, res) => {
  console.log("Fetch GET Name");
  const query =
    "SELECT a.machine,b.model,a.machine + '_' + b.model as Combine \
        from machine a \
           inner join model b on a.machineId = b.machineId";
  executeQuery(res, query);
});

router.get("/request", (req, res) => {
  console.log("Fetch GET Request");
  const query =
    "SELECT m.machine,r.request \
                    from request r\
                      inner join machine m on r.machineId = m.machineId";
  executeQuery(res, query);
});

router.get("/zone", (req, res) => {
  console.log("Fetch GET Zone");
  const query =
    "SELECT m.machine,z.zone \
                  from zone z\
                    inner join machine m on z.machineId = m.machineId";
  executeQuery(res, query);
});

router.post("/event", (req, res) => {
  const body = req.body;
  console.log("Payload Post Event");
  const query = `INSERT event \ 
                (modelId, requestId, operatorCode, status, created) \
                VALUES ((select id from model m where m.model = '${body.model}' \ 
                and m.machineId = (select requestId from request where request LIKE N'${body.request}')), \
                (select requestId from request where request LIKE N'${body.request}'),\
                '${body.operatorCode}', \
                '${body.status}', \
                '${body.timeCreated}')`;
  executeQuery(res, query);
});

module.exports = router;
