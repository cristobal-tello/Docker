const express = require('express');
const CosmosClient = require('@azure/cosmos').CosmosClient;

const config = require('./config');
const url = require('url');

const endpoint = config.endpoint;
const masterKey = config.primaryKey;

const databaseId = config.database.id;
const containerId = config.container.id;



const HttpStatusCodes = { NOTFOUND: 404 };

const client = new CosmosClient({ endpoint: endpoint, auth: { masterKey: masterKey } });

var server = express();

server.use(express.static(__dirname + '/public'));

server.get('/readRequest', function(req, res) {
  //res.send("OK");
  run(res).catch(handleError);
});

console.log(endpoint);
console.log(masterKey);
console.log(databaseId);
console.log(containerId);

server.listen(80);

async function run(res) {
  const { database } = await client.databases.createIfNotExists({ id: databaseId });
  const { container } = await database.containers.createIfNotExists({ id: containerId });
  const { body: databaseDefinition } = client.database(databaseId).read();
  const querySpec = {
   query: "SELECT r.id, r.children FROM root r"
  };
  const { result: results } = await client.database(databaseId).container(containerId).items.query(querySpec).toArray();
  res.send(JSON.stringify(results));
}

async function handleError(error) {
  console.log("\nAn error with code '" + error.code + "' has occurred:");
  console.log("\t" + error.body || error);


}

