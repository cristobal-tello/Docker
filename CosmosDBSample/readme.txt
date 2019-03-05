This simple example is designed to read a CosmosDB

The goal is create an image of this code and deploy in azure. 
Also we need to set some env variables to connect to CosmosDB database

ENDPOINT
PRIMARYKEY
DATABASEID
CONTAINER

1) To run from node image to debug 
docker run -it -e ENDPOINT=https://ms-learn.documents.azure.com:443/ -e PRIMARYKEY=GqHGdD2IsSb9B8eVeRJRGQKPlpzo5iyrrt2mfyXCvjEqavQxyk2a9kguxLP1whoNMjLdNqWrO1yRTpuBzbtLjA== -e DATABASEID=FamilyDatabase -e CONTAINER=FamilyContainer -p:80:80 -v C:\Code\Docker\CosmosDBSample:/var/www -w "/var/www" node /bin/bash
node server.js

2) Create a docker image
docker build -t ctello/cosmosdbsample .

3) docker push ctello/cosmosdbsample

4) az container create --resource-group MS_LEARN --name cosmodbsample --image ctello/cosmosdbsample --ip-address Public --location eastus --environment-variables ENDPOINT=https://ms-learn.documents.azure.com:443/ PRIMARYKEY=GqHGdD2IsSb9B8eVeRJRGQKPlpzo5iyrrt2mfyXCvjEqavQxyk2a9kguxLP1whoNMjLdNqWrO1yRTpuBzbtLjA== DATABASEID=FamilyDatabase CONTAINER=FamilyContainer
