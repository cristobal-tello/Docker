var mongo = require('mongodb');
var mongoClient = mongo.MongoClient;
var url = "mongodb://mongo:27017";
mongoClient.connect(url, 
    function(err, db) {
    if (err)
    {
        throw err;
    }
    console.log("Database created");
    db.close();
    }
);
