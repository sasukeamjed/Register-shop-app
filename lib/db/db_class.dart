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
      await createUser(user);
      print('LogIn is Succesful');
    }catch(e){
      print('log in failed with following error $e');
    }
    notifyListeners();
  }

  Future<void> signUp(email, password)async{
    try{
      FirebaseUser user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      await createUser(user);
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

  Future<User> createUser(FirebaseUser user) async{

      return _userInstance =  User(
          id: user.uid,
          idToken: await user.getIdToken(),
          email: user.email,
          name: user.displayName,
        claimType: _userClaim,
        userPhotoUrl: '',
      );

  }


}

