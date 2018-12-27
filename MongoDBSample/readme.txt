Simple example to use with docker witn Node and Mongo DB (linking)

1) Make sure you have node and mongo db images (node and mongo)
2) Build a docker file using node 
docker build -t ctello/nodeandmongo .
3) Run an instance of MongoDB
docker run -d --name my-mongodb mongo
4) Start Node and Link to MongoDB containter
docker run -d -p 80:80 --link my-mongodb:mongo ctello/nodeandmongo


Simple example to use with docker witn Node and Mongo DB (network)

1) Make sure you have node and mongo db images
2) Build a docker file using node 
docker build -t ctello/nodeandmongo .
3) Create network: docker network create --driver bridge my_network
4) Run an instance of MongoDB
docker run -d --net my_network --name mongo mongo
5) Start Node and use same network name to use Mongo DB
docker run -d -p 80:80 --net my_network --name nodeapp ctello/nodeandmongo
