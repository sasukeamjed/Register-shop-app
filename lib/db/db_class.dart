import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:register_shop_app/models/user_model.dart';
import 'dart:async';
import 'dart:io';

class Db with ChangeNotifier {
  User _userInstance;
  String _userClaim = '';
  File userPhoto;

  get userInstance => _userInstance;
  get claim => _userClaim;

  setClaim(value){ _userClaim = value;}

  Future<void> login(email, password)async{
    try{
      FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      await create(user);
      print('LogIn is Succesful');
    }catch(e){
      print('log in failed with following error $e');
    }
    notifyListeners();
  }

  Future<void> signUp(email, password)async{
    try{
      FirebaseUser user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      await create(user);
      print('Sign up is Succesful');
    }catch(e){
      print('Sign up failed with following error $e');
    }
    notifyListeners();
  }

  Future<void> signOut() async{
    try{
      await FirebaseAuth.instance.signOut();
      _userInstance = null;
      notifyListeners();
    }catch(e){
      print(e);
    }
  }

  Future<User> create(FirebaseUser user) async{

      return _userInstance =  User(
          id: user.uid,
          idToken: await user.getIdToken(),
          email: user.email,
          name: user.displayName,
        claimType: _userClaim,
        userPhoto: userPhoto,
      );

  }

  imageSelectorGallery() async {
    try{
      userPhoto = await ImagePicker.pickImage(
        source: ImageSource.gallery,
        // maxHeight: 50.0,
        // maxWidth: 50.0,
      );
      print("You selected gallery image : " + userPhoto.path);
//        setState(() {});
    }catch(e){
      print('There was an error: $e');
    }
    notifyListeners();
  }

  //display image selected from camera
  imageSelectorCamera() async {
    userPhoto = await ImagePicker.pickImage(
      source: ImageSource.camera,
      //maxHeight: 50.0,
      //maxWidth: 50.0,
    );
    print("You selected camera image : " + userPhoto.path);
//      setState(() {});
    notifyListeners();
  }

}

