var config = {}
/*
config.endpoint = "https://ms-learn.documents.azure.com:443/";
config.primaryKey = "GqHGdD2IsSb9B8eVeRJRGQKPlpzo5iyrrt2mfyXCvjEqavQxyk2a9kguxLP1whoNMjLdNqWrO1yRTpuBzbtLjA==";

config.database = {
    "id": "FamilyDatabase"
 };
 
 config.container = {
   "id": "FamilyContainer"
 };*/


config.endpoint = process.env.ENDPOINT;
config.primaryKey = process.env.PRIMARYKEY;

config.database = {
    "id": process.env.DATABASEID
 };
 
 config.container = {
   "id": process.env.CONTAINER
 };
 
 module.exports = config;