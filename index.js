const functions = require('firebase-functions');
const admin = require('firebase-admin');

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

admin.initializeApp(functions.config().firebase);
exports.movieTrigger = functions.firestore.document('user2/{movieId}').onCreate((snapshot, context) => {
    msgData = snapshot.data();
    console.log("This was a message:" + msgData.Title);
    admin.firestore().collection('devices').get().then((snapshots) => {
        var tokens = [];

        if (snapshots.empty) {
            console.log('No Devices');
            return 0;
        }
        else {
            for (var tokenn of snapshots.docs) {
                tokens.push(tokenn.data().token);
                console.log("Token: " + tokenn.data().token);
            }
            var payload = {
                "notification": {
                    "title": "New movie",
                    "body": msgData.Title + " was added",
                    "sound": "default"
                },
                "data": {
                    "sendername": "Adar",
                    "message": "message from me"
                }
            }


            return admin.messaging().sendToDevice(tokens, payload).then((response) => {
                console.log('Pushed them all');
            }).catch((err) => {
                console.log(err);
            });



        }
    })
});