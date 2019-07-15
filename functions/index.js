const functions = require('firebase-functions');
const admin = require('firebase-admin');
const cors = require('cors')({ origin: true });
const Busboy = require('busboy');
const gcs = require('@google-cloud/firestore');
const path = require('path');
const os = require('os');

admin.initializeApp(functions.config().firebase);

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

// exports.addUser = functions.https.onCall((data, context) => {

//   const users = admin.firestore().collection('users');
//   return users.add({
//     name: data["name"],
//     email: data["email"]
//   });
// });

// exports.createUser = functions.https.onCall(async (data, context) => {
//   try {
//     const newUser = await admin.auth().createUser({
//       email: data['email'],
//       phoneNumber: data['phoneNumber'],
//       emailVerified: false,
//       password: data['password'],
//       displayName: data['shopName'],
//       photoURL: 'http://www.example.com/12345678/photo.png',
//       disabled: false
//     });

//     const claims = {
//       claim: data['claim']
//     };

//     await admin.auth().setCustomUserClaims(newUser.uid, claims);

//     console.log('user was created: ' + newUser);
//     return newUser;
//   } catch (error) {
//     console.log(error);
//   }

// });

exports.uploadFile = functions.https.onRequest((req, res) => {
  cors(req, res, () => {

    if (req.method !== 'POST') {
      return res.status(500).json({ message: 'Not Allowed' });
    }

    const busboy = new Busboy({ headers: req.headers });
    let uploadData = null;

    busboy.on('file', (fieldname, file, filename, encoding, mimetype) => {
      const filepath = path.join(os.tmpdir(), filename);
      uploadData = { file: filepath, type: mimetype };
      console.log('filedname :', fieldname);
      console.log('file :', file);
      console.log('filename :', filename);
      console.log('encoding :', encoding);
      console.log('mimetype :', mimetype);
    });

    busboy.on('finish', () => {
      const bucket = gcs.bucket('fir-auth-test-a160f.appspot.com');
      bucket.upload(uploadData.file, {
        uploadType: 'media',
        metadata: {
          metadata: {
            contentType: uploadData.type
          }
        },
      }).then((err, uploadedFile) => {

        if (err) {
          return res.status(500).json({ error: err });
        }

        res.status(200).json({ message: 'It Worked!' });

      });
    });



  });
});

// exports.storeImage = functions.https.onRequest((req, res) => {
//   return cors(req, res, () => {
//     if (req.method !== 'POST') {
//       return res.status(500).json({ error: 'Not Allowed' });
//     }

//     if (!req.headers.authorization || !req.headers.authorization.startsWith('Bearer ')) {
//       return res.status(401).json({ error: 'Unauthoroized.' });
//     }

//     let idToken;
//     idToken = req.headers.authorization.split('Bearer ')[1];

//     const busboy = new Busboy({ headers: req.headers });
//     busboy.on('file', (fieldname, file, filename, encoding, mimetype) => { });
//   });
// });


// exports.onCreateUser = functions.auth.user().onCreate(userRecord => {
//   const claims = {
//     claim: 'Admin'
//   };
//   admin.auth().setCustomUserClaims(userRecord.uid, claims);
//   console.log(userRecord);
// });

// exports.addTheAdmin = functions.https.onCall((data, context) => {
//   const email = data['email'];
//   // const claim = data['claim'];
//   const claims = {
//     claim: data['claim'],
//   };

//   return addAdminRole(email, claims).then(() => {
//     console.log('Admin Role Is Added');
//   });
// });

// const addAdminRole = async (email, claims) => {
//   const user = await admin.auth().getUserByEmail(email);
//   return admin.auth().setCustomUserClaims(user.uid, claims);
// };

// exports.fetchUserByUid = functions.https.onCall((data, context) => {

//   return admin.auth().getUser(data["uid"]).then((res) => {
//     console.log('Successfully fetched user data:', res.toJSON());
//     return res;
//   }).catch((e) => {
//     console.log('Error fetching user data:', e);
//   });
// });

// exports.createUser = functions.https.onCall((data, context)=>{
//     return admin.auth.createUser()
// });

// exports.getAllUsers = functions.https.onCall((data, context) => {
//   function listAllUsers(nextPageToken) {
//     // List batch of users, 1000 at a time.
//     return admin.auth().listUsers(1000, nextPageToken)
//       .then(function (listUsersResult) {
//         listUsersResult.users.forEach(function (userRecord) {
//           console.log('user', userRecord.toJSON());
//         });
//         if (listUsersResult.pageToken) {
//           // List next batch of users.
//           listAllUsers(listUsersResult.pageToken);
//         }
//         return listUsersResult.users;
//       })
//       .catch(function (error) {
//         console.log('Error listing users:', error);
//       });
//   }
//   // Start listing users from the beginning, 1000 at a time.
//   return listAllUsers();
// });



// exports.fetchUserByEmail = functions.https.onCall((data, context) => {
//   admin.auth().getUserByEmail('admin@admin.com')
//     .then(function (userRecord) {
//       // See the UserRecord reference doc for the contents of userRecord.
//       console.log('Successfully fetched user data:', userRecord.toJSON());
//     })
//     .catch(function (error) {
//       console.log('Error fetching user data:', error);
//     });
// });

// exports.updateUser = functions.https.onCall((data, context) => {

//   const users = admin.firestore().collection('users');
//   return users.doc(data["doc_id"]).set({
//     name: data["name"],
//     email: data["email"]
//   });
// });

