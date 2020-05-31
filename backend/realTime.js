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

const executeQuery = (query) => {
  sql.connect(dbConfig, (err) => {
    if (err) {
      console.log("Error while connecting database :- " + err);
    } else {
      // create Request object
      const request = new sql.Request();
      // query to the database
      request.query(query, (err, recordset) => {
        if (err) {
          console.log("Error while querying database :- " + err);
        } else {
          return recordset.recordset
        }
      });
    }
  });
};


const realTime(){
    const query = "SELECT * FROM [AndonDB].[dbo].[Andon_Event] WHERE id = (select MAX(id) from [AndonDB].[dbo].[Andon_Event])";
    const recordset = executeQuery(query);
}

module.exports = realTime;