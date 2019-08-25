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

  bool _fetchingData = false;

  void setFetchingData(bool state){
    _fetchingData = state;
    notifyListeners();
  }

  bool get dataState{
    return _fetchingData;
  }



}
