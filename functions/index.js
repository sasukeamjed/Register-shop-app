const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

exports.addUser = functions.https.onCall((data, context) => {

   const users = admin.firestore().collection('users');
   return users.add({
       name: data["name"],
       email: data["email"]
   });
});

exports.fetchUserByUid = functions.https.onCall((data, context) => {

    return admin.auth().getUser(data["uid"]).then((res) => {
        console.log('Successfully fetched user data:', res.toJSON());
        return res;
    }).catch((e) => {
        console.log('Error fetching user data:', e);
    });
});

// exports.createUser = functions.https.onCall((data, context)=>{
//     return admin.auth.createUser()
// });

exports.getAllUsers = functions.https.onCall((data, context)=>{
    function listAllUsers(nextPageToken) {
        // List batch of users, 1000 at a time.
        return admin.auth().listUsers(1000, nextPageToken)
          .then(function(listUsersResult) {
            listUsersResult.users.forEach(function(userRecord) {
              console.log('user', userRecord.toJSON());
            });
            if (listUsersResult.pageToken) {
              // List next batch of users.
              listAllUsers(listUsersResult.pageToken);
            }
            return listUsersResult.users;
          })
          .catch(function(error) {
            console.log('Error listing users:', error);
          });
      }
    // Start listing users from the beginning, 1000 at a time.
    return listAllUsers();
});

exports.fetchUserByEmail = functions.https.onCall((data, context)=>{
    admin.auth().getUserByEmail('admin@admin.com')
       .then(function(userRecord) {
         // See the UserRecord reference doc for the contents of userRecord.
         console.log('Successfully fetched user data:', userRecord.toJSON());
       })
       .catch(function(error) {
        console.log('Error fetching user data:', error);
    });
});

exports.updateUser = functions.https.onCall((data, context) => {

    const users = admin.firestore().collection('users');
    return users.doc(data["doc_id"]).set({
        name: data["name"],
        email: data["email"]
    });
});

