import 'dart:io';

import 'package:flutter/material.dart';

import 'package:cloud_functions/cloud_functions.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:provider/provider.dart';

import 'package:register_shop_app/db/db_class.dart';
import 'package:register_shop_app/widgets/claim_radio_buttons.dart';
import 'package:register_shop_app/widgets/image_picker_widget.dart';

import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'dart:convert';

class AdminPage extends StatelessWidget {
  final TextEditingController shopNameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  final TextEditingController locationController = TextEditingController();

  File imageFile;

  @override
  Widget build(BuildContext context) {
    var db = Provider.of<Db>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(db.userInstance.email),
        leading: IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: () async {
            await db.signOut();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'This is Home Page',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Creat new user?!'),
              TextField(
                controller: shopNameController,
                decoration: InputDecoration(labelText: 'Shop Name'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Phone Number'),
              ),
              TextField(
                controller: locationController,
                decoration: InputDecoration(labelText: 'location'),
              ),
              SizedBox(
                height: 10.0,
              ),
              SizedBox(
                width: 10.0,
              ),
              ClaimRadioButtons(),
              PickImage(
                imagePickerFunction: setImageFile,
              ),
              RaisedButton(
                child: Text('Add a new User ?!'),
                onPressed: () async {
//                fetchUserByUid('1ZXgy5DtuaToQFwEv0gDicmjMPg2');
//                await addUser(db.claim);
                  await createUser(db.claim);
                },
              ),
              RaisedButton(
                child: Text('Upload Image'),
                onPressed: () async {
                  final Map<String, dynamic> data = await uploadImage(
                      image: imageFile,
                      shopName: shopNameController.text,
                      idToken: db.userInstance.idToken);
                  print(data);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void setImageFile(File file) {
    imageFile = file;
    if (imageFile == null) {
      print('image file is null');
    } else {
      print('image file is not a null');
    }
  }

  addUser(claim) async {
    CloudFunctions.instance.getHttpsCallable(functionName: "addUser").call({
      "email": emailController.text,
      "password": emailController.text
    }).then((res) {
      print('Done creating a user');
      addAdminRole(emailController.text, claim);
    }).catchError((e) {
      print(e);
    });
    // try {
    //   await FirebaseAuth.instance.createUserWithEmailAndPassword(
    //       email: userController.text, password: passwordController.text);
    //   print('Sign up is Succesful');
    // } catch (e) {
    //   print('Sign up failed with following error $e');
    // }
  }

  Future<Map<String, dynamic>> uploadImage(
      {File image, String shopName, String idToken, String imagePath}) async {
    if(shopName == null || shopName == ''){
      return null;
    }
    try {
      final mimeTypeData = lookupMimeType(image.path).split('/');
      final imageUploadRequest = http.MultipartRequest(
          'POST',
          Uri.parse(
              'https://us-central1-fir-auth-test-a160f.cloudfunctions.net/uploadFile'));
      final file = await http.MultipartFile.fromPath('image', image.path,
          contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
      imageUploadRequest.files.add(file);

      if (imagePath != null) {
        imageUploadRequest.fields['imagePath'] = Uri.encodeComponent(imagePath);
      }

      imageUploadRequest.headers['Authorization'] = 'Bearer $idToken';
      imageUploadRequest.headers['name'] = shopName;

      //MultipartRequest return a response of streams it means in chuncks, which divide the data in many parts
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 200 && response.statusCode != 201) {
        print('Something went wrong!');
        print(json.decode(response.body));
        return null;
      }

      final responseData = json.decode(response.body);
      return responseData;
    } catch (e) {
      print('there is an error: +++++++++++++ $e +++++++++++++');
      return null;
    }
  }

  createUser(claim) async {
    CloudFunctions.instance.getHttpsCallable(functionName: "createUser").call({
      "email": emailController.text,
      "password": passwordController.text,
      "claim": claim
    }).then((res) {
      print(res.data);
    }).catchError((e) {
      print(e);
    });
//    await http.post('https://us-central1-fir-auth-test-a160f.cloudfunctions.net/uploadFile')
  }

  fetchUserByUid(uid) async {
    CloudFunctions.instance
        .getHttpsCallable(functionName: "fetchUserByUid")
        .call({"uid": uid}).then((res) {
      print(res.data['email']);
      print('Done getting a user');
    }).catchError((e) {
      print(e);
    });
  }

  fetchAllUsers() async {
    CloudFunctions.instance
        .getHttpsCallable(functionName: 'getAllUsers')
        .call()
        .then((res) {
      print('function getAllUsers is called');
      print(res);
    }).catchError((e) {
      print(e);
    });
  }

  addAdminRole(email, claim) async {
    CloudFunctions.instance
        .getHttpsCallable(functionName: 'addTheAdmin')
        .call({"email": email, "claim": claim}).then((res) {
      print('Addmin Roles is Added');
    }).catchError((e) {
      print(e);
    });
  }

  fetchUserByEmail(email) async {
    CloudFunctions.instance
        .getHttpsCallable(functionName: "fetchUserByEmail")
        .call({
      "email": email,
    }).then((res) {
      print(res.data);
      print('Done getting a user');
    }).catchError((e) {
      print(e);
    });
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
