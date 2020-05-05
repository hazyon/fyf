// This code is adapted from https://www.youtube.com/watch?v=Qg2_VFFcAI8&t=196s
var admin = require("firebase-admin");

var serviceAccount = require("./service_key.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://studybuddyls.firebaseio.com"
});

const firestore = admin.firestore();
const path = require("path");
const fs = require("fs");
const directoryPath = path.join(__dirname, "files");

fs.readdir(directoryPath, function(err, files) {
  if (err) {
    return console.log("Unable to scan directory: " + err);
  }

  files.forEach(function(file) {
    var lastDotIndex = file.lastIndexOf(".");
    var menu = require("./files/" + file);

    var count = 1;
    menu.forEach(function(obj) {
      console.log(obj);
      firestore
        .collection(file.substring(0, lastDotIndex))
        //.doc(obj.itemID)
        .doc(count.toString())
        .set(obj)
        .then(function(docRef) {
          console.log("Document written");
        })
        .catch(function(error) {
          console.error("Error adding document: ", error);
        });
        count++;
    });
  });
});