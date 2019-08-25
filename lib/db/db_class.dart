import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:register_shop_app/constants/claims_types.dart';
import 'package:register_shop_app/db/data_managment.dart';
//import 'package:register_shop_app/models/user_model.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;

class Db with ChangeNotifier {
//  User _userInstance;
  String _userClaim = '';
  File userPhoto;

//  get userInstance => _userInstance;

  get claim => _userClaim;

  setClaim(value) {
    _userClaim = value;
  }

  Future<void> login(email, password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
//      await createUser(user);
      print('LogIn is Succesful');
    } catch (e) {
      print('log in failed with following error $e');
    }
    notifyListeners();
  }

  Future<void> signUp({
    String idToken,
    @required String username,
    @required String email,
    @required String password,
    @required String phoneNumber,
    @required String firstName,
    @required String lastName,
    @required String address,
    String shopLocation,
  }) async {
    if (idToken != null) {
      //ToDo: get claim from idToken by parsing it

      SuperAdminManagement.addShopOwner(
          idToken: idToken,
          shopName: username,
          email: email,
          password: password,
          phoneNumber: phoneNumber,
          fullName: firstName);
      //ToDo: store the results of fetchAllShopsOwners method into general variable
      SuperAdminManagement.fetchAllShopsOwners();

    } else {
      SuperAdminManagement.addCustomer();
    }
  }

//  Future<Map<String, dynamic>> uploadImage(
//      {File image, String shopName, String idToken, String imagePath}) async {
//    if (shopName == null || shopName == '') {
//      return null;
//    }
//    try {
//      final mimeTypeData = lookupMimeType(image.path).split('/');
//      final imageUploadRequest = http.MultipartRequest(
//          'POST',
//          Uri.parse(
//              'https://us-central1-fir-auth-test-a160f.cloudfunctions.net/uploadFile'));
//      final file = await http.MultipartFile.fromPath('image', image.path,
//          contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
//      imageUploadRequest.files.add(file);
//
//      if (imagePath != null) {
//        imageUploadRequest.fields['imagePath'] = Uri.encodeComponent(imagePath);
//      }
//
//      imageUploadRequest.headers['Authorization'] = 'Bearer $idToken';
//      imageUploadRequest.headers['name'] = shopName;
//
//      //MultipartRequest return a response of streams it means in chuncks, which divide the data in many parts
//      final streamedResponse = await imageUploadRequest.send();
//      final response = await http.Response.fromStream(streamedResponse);
//      if (response.statusCode != 200 && response.statusCode != 201) {
//        print('Admin page line 123: Something went wrong!');
//        print(json.decode(response.body));
//        return null;
//      }
//
//      final responseData = json.decode(response.body);
//      return responseData;
//    } catch (e) {
//      print('there is an error: +++++++++++++ $e +++++++++++++');
//      return null;
//    }
//  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
//      _userInstance = null;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

//  Future<User> createUser(FirebaseUser user) async {
//    return _userInstance = User(
//      id: user.uid,
//      idToken: await user.getIdToken(),
//      email: user.email,
//      name: user.displayName,
//      claimType: _userClaim,
//      userPhotoUrl: '',
//    );
//  }
}
