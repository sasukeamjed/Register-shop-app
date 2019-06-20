const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);

const auth = admin.auth();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

//exports.addUser = functions.https.onCall((data, context) => {
//
//    const users = admin.firestore().collection('users');
//    return users.add({
//        name: data["name"],
//        email: data["email"]
//    });
//});

exports.fetchUserByUid = functions.https.onCall((data, context) => {

    admin.auth().getUser(data["uid"]).then((res) => {
        console.log('Successfully fetched user data:', res.toJSON());
    }).catch((e) => {
        console.log('Error fetching user data:', e);
    });
});

exports.fetchUserByEmail = functions.https.onCall((data, context)=>{
    admin.auth().getUserByEmail(data['email'])
      .then(function(userRecord) {
        // See the UserRecord reference doc for the contents of userRecord.
        console.log('Successfully fetched user data:', userRecord.toJSON());
      })
      .catch(function(error) {
       console.log('Error fetching user data:', error);
      });
});

//exports.updateUser = functions.https.onCall((data, context) => {
//
//    const users = admin.firestore().collection('users');
//    return users.doc(data["doc_id"]).set({
//        name: data["name"],
//        email: data["email"]
//    });
//});

