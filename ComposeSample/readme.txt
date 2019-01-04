Simple example to use with docker compose (sample based in MongoDBSample)

1) Check node.dockerfile file to make sure how node image works
2) Check docker-compose.yml file to check how compose will use this file to build the image 
2.1) Tab indentation is important
2.2) Container name is also important in order to match mongodb host
3) Run: docker-compose build
4) Run: docker images  (In order to check if image is available)
5) Run: docker-compose up
6) Check if app is running browsing to localhost
7) Abort node (Ctrl+C) and down the container running: docker-compose down
8) Run: docker-compose up -d