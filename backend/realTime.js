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
  return new Promise((resolve, reject) => {
    try {
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
              resolve(recordset.recordset);
            }
          });
        }
      });
    } catch (err) {
      reject(err);
    }
  });
};

let previusSet;

const realTime = async () => {
  const query =
    "SELECT * FROM [AndonDB].[dbo].[Andon_Event] WHERE id = (select MAX(id) from [AndonDB].[dbo].[Andon_Event])";
  let recordset = await executeQuery(query);
  // console.log(recordset[0].id);
  // console.log(parseInt(recordset[0].id), previusSet);
  if (parseInt(recordset[0].id) !== previusSet) {
    console.log("Last ID Not Seem");
    const query =
      "SELECT * FROM [AndonDB].[dbo].[Andon_Event] WHERE process != 'Done' ";
    const recordsetAll = await executeQuery(query);
    previusSet = parseInt(recordset[0].id);
    return recordsetAll;
  } else {
    console.log("SEEM ID");
    return [];
  }
};

module.exports = {
  realTime,
};
