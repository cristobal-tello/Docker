var express = require('express');
var mongo = require('mongodb');

var mongoClient = mongo.MongoClient;

var url = "mongodb://mongo:27017/mydb"; // On Windows, set on hosts file an entry to map 127.0.0.1 to mongo

var app = express();

app.use(express.static(__dirname + '/public')); // exposes index.html, per below

app.get('/writeRequest', function(req, res){
  InsertDocument();
  res.send("Done"); 
});

app.get('/readRequest', function(req, res){
    //var x = ReadDocument();
    //console.log(x);
    //res.send(ReadDocument());
    ReadDocument(res)
});

app.listen(80);

function InsertDocument()
{
    mongoClient.connect(url, 
        function(err, db) {
            if (err) throw err;
            var dbo = db.db("mydb");
            var myobj = { name: "Company Inc", address: "Highway 37", date: new Date().toISOString().replace(/T/, ' ').replace(/\..+/, '') };
            dbo.collection("customers").insertOne(myobj, 
                function(err, res) {
                if (err) throw err;
                console.log("1 document inserted");
                db.close();
            });
      });
}


function ReadDocument(res)
{
    mongoClient.connect(url, function(err, db) {
    if (err) throw err;
    var dbo = db.db("mydb");
    dbo.collection("customers").find({}).toArray(function(err, result) {
      if (err) throw err;
      db.close();
    //  console.log(JSON.stringify(result));
      res.send(JSON.stringify(result));
    });
  });
}
