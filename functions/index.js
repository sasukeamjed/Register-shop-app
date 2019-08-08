const functions = require('firebase-functions');
const admin = require('firebase-admin');
const cors = require('cors')({ origin: true });
const Busboy = require('busboy');
const path = require('path');
const os = require('os');
const fs = require('fs');
const spawn = require('child-process-promise').spawn;
const uuid = require('uuid/v4');

admin.initializeApp({ credential: admin.credential.cert(require('./fir-auth-test-a160f-firebase-adminsdk-ff597-38849e6620.json')) });
// admin.initializeApp(functions.config().firebase);

const gcconfig = {
  projectId: "fir-auth-test-a160f",
  keyFilename: "fir-auth-test-a160f-firebase-adminsdk-ff597-38849e6620.json",
};

const gcs = admin.storage();




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

exports.createShop = functions.https.onCall(async (data, context) => {
  return admin.auth().verifyIdToken(data['idToken']).then((decodedToken) => {
    console.log(decodedToken);
    if (decodedToken.claim !== 'Admin') {
      throw Error('UnAuthorized');
    }

    return admin.auth().createUser({
      email: data['email'],
      phoneNumber: '+96895868408',
      emailVerified: false,
      password: data['password'],
      displayName: data['shopName'],
      photoURL: 'https://images.immediate.co.uk/production/volatile/sites/4/2009/07/GettyImages-931270318-43ab672.jpg?quality=45&resize=960,413',
      disabled: false
    });

  }).then((newUser) => {
    console.log('user was created with the following uid:' + newUser.uid);
    return newUser;
  }).catch(e => e);

});

// On sign up.
exports.processSignUp = functions.auth.user().onCreate(event => {
  const user = event.data; // The Firebase user.
  // Check if user meets role criteria.
  if (user.email) {
    const customClaims = {
      claim: 'admin',
    };
    // Set custom user claims on this newly created user.
    return admin.auth().setCustomUserClaims(user.uid, customClaims)
      .then(() => {
        // Update real-time database to notify client to force refresh.
        const metadataRef = admin.database().ref("metadata/" + user.uid);
        // Set the refresh time to the current UTC timestamp.
        // This will be captured on the client to force a token refresh.
        console.log('this is the user claims: ' + event.data);
        return metadataRef.set({ refreshTime: new Date().getTime() });
      })
      .catch(error => {
        console.log(error);
      });
  }
});

exports.updateData = functions.https.onCall(async (data, context) => {
  try {
    await admin.auth().updateUser(data['uid'], {
      photoURL: 'http://www.example.com/12345678/photo.png',
    });
  }
  catch (e) {
    return e;
  }
});

exports.uploadFile = functions.https.onRequest((req, res) => {
  cors(req, res, () => {
    // console.log(req);

    if (req.method !== 'POST') {
      return res.status(500).json({ message: 'Not Allowed' });
    }

    if (!req.headers.authorization || !req.headers.authorization.startsWith('Bearer ')) {
      return res.status(401).json({ error: 'UnAutherized' });
    }

    const shopName = req.headers.name;

    let idToken;
    idToken = req.headers.authorization.split('Bearer ')[1];

    const busboy = new Busboy({ headers: req.headers });
    let uploadData = null;
    let oldImagePath;

    busboy.on('file', (fieldname, file, filename, encoding, mimetype) => {

      const filepath = path.join(os.tmpdir(), filename);

      uploadData = { filepath: filepath, type: mimetype, name: filename };
      file.pipe(fs.createWriteStream(filepath));

    });

    busboy.on('field', (fieldname, value) => {
      oldImagePath = decodeURIComponent(value);
    });

    busboy.on('finish', () => {
      const bucket = gcs.bucket('fir-auth-test-a160f.appspot.com');
      const id = uuid();
      console.log('this is the uid:' + id);
      let imagePath = 'images/' + shopName + '/' + shopName + '-' + id + '-' + uploadData.name;
      if (oldImagePath) {
        imagePath = oldImagePath;
      }
      return admin.auth().verifyIdToken(idToken).then(decodedToken => {
        console.log('verifying is done!!');
        return bucket.upload(uploadData.filepath, {
          uploadType: 'media',
          destination: imagePath,
          metadata: {
            metadata: uploadData.type,
            firebaseStorageDownloadToken: id
          }
        });
      }).then(() => {
        return res.status(201).json({
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/' + bucket.name + '/o/' + encodeURIComponent(imagePath) + '?alt=media&token=' + id,
          imagePath: imagePath
        });
      }).catch(error => {
        res.status(401).json({
          error: error,
          idToken,
          errorMessage: 'Unauthorized!'
        });
      });
    });

    return busboy.end(req.rawBody);
  });
});



// exports.onFileChange = functions.storage.object().onFinalize(async (event) => {
//   const bucket = event.bucket;
//   const contentType = event.contentType;
//   const filePath = event.name;

//   const shopName = path.basename(filePath).split('-')[0];
//   // console.log(shopName);

//   if (path.basename(filePath).startsWith('resized-')) {
//     console.log('We already renamed that file!');
//     return;
//   }

//   const destBucket = gcs.bucket(bucket);
//   const tempFilePath = path.join(os.tmpdir(), path.basename(filePath));

//   const metadata = {
//     contentType: contentType
//   };

//   return destBucket.file(filePath).download({
//     destination: tempFilePath
//   })
//     .then(() => {
//       return destBucket.file(filePath).delete();
//     })
//     .then(() => {
//       return spawn('convert', [tempFilePath, '-resize', '500x500', tempFilePath]);
//     }).then(() => {
//       return destBucket.upload(tempFilePath, {
//         destination: 'images/' + shopName + '/' + 'resized-' + path.basename(filePath),
//         metadata: metadata
//       });
//     }).catch(e => {
//       console.log('there is an error: ' + e);
//     });
// });

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

