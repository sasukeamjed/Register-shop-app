import 'dart:io';

import 'package:flutter/material.dart';

import 'package:cloud_functions/cloud_functions.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:provider/provider.dart';
import 'package:register_shop_app/db/auth.dart';
import 'package:register_shop_app/db/data_managment.dart';

import 'package:register_shop_app/db/db_class.dart';
import 'package:register_shop_app/models/users/admin.dart';
import 'package:register_shop_app/models/users/shop_owner.dart';
import 'package:register_shop_app/widgets/image_picker_widget.dart';

import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'dart:convert';

class AdminAddingShopPage extends StatelessWidget {
  final TextEditingController shopNameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  final TextEditingController fullNameController = TextEditingController();

  File imageFile;

  @override
  Widget build(BuildContext context) {

    var auth = Provider.of<Auth>(context);

    return SingleChildScrollView(
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
              controller: fullNameController,
              decoration: InputDecoration(labelText: 'full name'),
            ),
            SizedBox(
              height: 10.0,
            ),
            SizedBox(
              width: 10.0,
            ),
            PickImage(
              imagePickerFunction: setImageFile,
            ),
            RaisedButton(
              child: Text('Add a new Shop ?!'),
              onPressed: () async {
                //ToDo: do something if the function returned a null
//                print(auth.getCurrentUser.token);
//                db.signUp(idToken: db.userInstance.idToken ,username: shopNameController.text, email: emailController.text, password: passwordController.text, phoneNumber: phoneController.text, firstName: null, lastName: null, address: null);
                SuperAdminManagement.addShopOwner(idToken: auth.getCurrentUser.token, shopName: shopNameController.text, email: emailController.text, password: passwordController.text, phoneNumber: phoneController.text, fullName: fullNameController.text);
              },
            ),
//            RaisedButton(
//              child: Text('Get All Shops ?!'),
//              onPressed: () async {
//                SuperAdminManagement.fetchAllShopsOwners();
//              },
//            ),
          ],
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

  Future<Map<String, dynamic>> uploadImage(
      {File image, String shopName, String idToken, String imagePath}) async {
    if (shopName == null || shopName == '') {
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
        print('Admin page line 123: Something went wrong!');
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


  updatePhotoUrl(String uid,String photoUrl){
    return CloudFunctions.instance.getHttpsCallable(functionName: "updateData").call({
      "uid": uid,
    }).then((res) {
      print('Admin page line 158: ${res.data}');
    }).catchError((e) {
      print(e);
    });
  }

  fetchUserByUid(uid) async {
    return CloudFunctions.instance
        .getHttpsCallable(functionName: "fetchUserByUid")
        .call({"uid": uid}).then((res) {
      print(res.data['email']);
      print('Done getting a user');
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
