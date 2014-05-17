var express = require("express"),
    path = require('path'),
    fs = require('fs');

var app = express();


//app.use(express.bodyParser({uploadDir:'/path/to/temporary/directory/to/store/uploaded/files'}));
uploadPath = __dirname + "/tmp";

app.use(express.bodyParser({uploadDir: uploadPath}));
app.set('uploadDir', uploadPath);

fs.exists(uploadPath, function (exist) {
    if (!exist) {
        fs.mkdir(uploadPath);
    }
});

/// Include the express body parser
app.configure(function () {
    app.use(express.bodyParser());
});

var form = "<!DOCTYPE HTML><html><body>" +
    "<form method='post' action='/upload' enctype='multipart/form-data'>" +
    "<input type='file' name='image'/>" +
    "<input type='submit' /></form>" +
    "</body></html>";

app.get('/', function (req, res){
    res.writeHead(200, {'Content-Type': 'text/html' });
    res.end(form);

});

/// Include the node file module


app.post('/upload', function (req, res) {
    var tempPath = req.files.file.path,
        targetPath = path.resolve('./image.jpg');
    if (path.extname(req.files.file.name).toLowerCase() === '.jpg') {
        fs.rename(tempPath, targetPath, function(err) {
            if (err) throw err;
            console.log("Upload completed!");
        });
    } else {
        fs.unlink(tempPath, function () {
            if (err) throw err;
            console.error("Only .png files are allowed!");
        });
    }
    res.end("woo");
    // ...
});




//
///// Post files
//app.post('/upload', function(req, res) {
//
//    fs.readFile(req.files.image.path, function (err, data) {
//
//        var imageName = req.files.image.name;
////        var imageName = "wave.jpg";
//
//        /// If there's an error
//        if(!imageName){
//
//            console.log("There was an error");
//            res.redirect("/");
//            res.end();
//
//        } else {
//
////            var path = __dirname + "/uploads/fullsize/" + imageName;
//            var path = imageName;
//
//
//
//            /// write file to uploads/fullsize folder
//            fs.writeFile(path, data, function (err) {
//
//
////            fs.writeFile('helloworld.txt', 'Hello World!', function (err) {
////                if (err) return console.log(err);
////                console.log('Hello World > helloworld.txt');
////            });
//
////            fs.writeFile(path, req.body, function (err) {
//                if (err) {
//                    return console.log(err);
//                }
////                res.redirect("/uploads/fullsize/" + imageName);
//                res.end("woo:");
//
//            });
//        }
//    });
//});

/// Show files
app.get('/uploads/fullsize/:file', function (req, res){
    file = req.params.file;
    var img = fs.readFileSync(__dirname + "/uploads/fullsize/" + file);
    res.writeHead(200, {'Content-Type': 'image/jpg' });
    res.end(img, 'binary');

});

app.get('/uploads/thumbs/:file', function (req, res){
    file = req.params.file;
    var img = fs.readFileSync(__dirname + "/uploads/thumbs/" + file);
    res.writeHead(200, {'Content-Type': 'image/jpg' });
    res.end(img, 'binary');

});

app.listen(1234)


