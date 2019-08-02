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
      let imagePath = 'images/' + shopName + '/' + shopName + id + '-' + uploadData.name;
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

exports.onFileChange = functions.storage.object().onFinalize(event => {
  // console.log(event);
  const bucket = event.bucket;
  console.log(event);
  const contentType = event.contentType;
  const filePath = event.name;

  if (path.basename(filePath).startsWith('resized-')) {
    console.log('We already renamed that file!');
    return;
  }

  const destBucket = gcs.bucket(bucket + filePath);
  const tempFilePath = path.join(os.tmpdir(), path.basename(filePath));

  const metadata = {
    contentType: contentType
  };

  return destBucket.file(filePath).download({
    destination: tempFilePath
  }).then(() => {
    return spawn('convert', [tempFilePath, '-resize', '500x500', tempFilePath]);
  }).then(() => {
    return destBucket.upload(tempFilePath, {
      destination: 'resized-' + path.basename(filePath),
      metadata: metadata
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

