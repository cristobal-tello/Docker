
var express = require('express');

var app = express();

app.use(express.static(__dirname + '/public')); // exposes index.html, per below

app.get('/writeRequest', function(req, res){
  res.send("Done 1"); 
});

app.get('/readRequest', function(req, res){
   res.send("Done 2");
});

app.listen(80);