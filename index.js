

const functions = require('firebase-functions');
const admin = require('firebase-admin');

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

admin.initializeApp(functions.config().firebase);

const firestore = admin.firestore();
firestore.settings({ timestampsInSnapshots: true });

var movieId = "";
exports.movieTrigger = functions.firestore.document('user2/{movieId}').onCreate((snapshot, context) => {
    const msgData = snapshot.data();
    console.log("This was a message:" + msgData.Title);
    console.log(movieId);
    admin.firestore().collection('devices').get().then((snapshots) => {
        var tokens = [];

        if (snapshots.empty) {
            console.log('No Devices');

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
                    "click_action": "FLUTTER_NOTIFICATION_CLICK",
                    "sendername": "Adar",
                    "message": "message from me"
                }
            }


            return admin.messaging().sendToDevice(tokens, payload).then((response) => {
                console.log('Pushed them all' + response);
            }).catch((err) => {
                console.log(err);
            });



        }
    })
    return 0;
});