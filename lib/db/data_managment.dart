import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import 'package:register_shop_app/constants/claims_types.dart';
import 'package:register_shop_app/models/product.dart';
import 'package:register_shop_app/models/shop.dart';

class SuperAdminManagement {
  static Future<void> addAdmin({
    @required ClaimsType claim,
    @required String email,
    @required String password,
    @required String phoneNumber,
    String fullName,
    String displayName,
  }) {
    return null;
  }

  static void addShopOwner({
    @required String idToken,
    @required String shopName,
    @required String email,
    @required String password,
    @required String phoneNumber,
    @required String fullName,
    String displayName,
  }) {
    CloudFunctions.instance.getHttpsCallable(functionName: "createUser").call({
      "idToken": idToken,
      "shopName": shopName,
      "email": email,
      "password": password,
      "phoneNumber": phoneNumber,
      "shopOwnerName": fullName,
      "displayName": displayName,
    }).then((res) async {
      print('data_management.dart line 39: ${res.data}');
      print('data_management.dart line 40: ${res.data['uid']}');
    }).catchError((e) {
      print('data_management.dart line 42: $e');
    });
  }

  static void addCustomer({
    @required String email,
    @required String phoneNumber,
    @required String userDisplayName,
    @required String userRealName,
    @required String userFamilyName,
    @required String country,
    @required String city,
    @required String village,
  }) {}

  void deleteAdmin() {}

  void deleteShopOwner() {}

  static fetchAllShopsOwners() {
    return CloudFunctions.instance
        .getHttpsCallable(functionName: 'getAllUsers')
        .call()
        .then((res) {
      print('function getAllUsers is called');
      print(res.data.toList());
    }).catchError((e) {
      print(e);
    });
  }
}

class ShopsManagement {
  Future<void> addProduct({@required String shopName, @required String productName, @required double price, @required List<Asset> assets}) async{

    List<String> imagesUrls = await uploadImages(assets);

    DocumentReference shopDocument = Firestore.instance.collection('Shops').document(shopName);
    return shopDocument.setData({
      'productName' : productName,
      'price' : price,
      'imagesUrls' : imagesUrls
    });
  }

  Future<List<String>> uploadImages(List<Asset> assets) async{
    print('Uploading Images');
    List<String> urls = [];
    await Future.forEach(assets, (asset) async {
      try{
        ByteData byteData = await asset.requestOriginal();
        List<int> imageData = byteData.buffer.asUint8List();
        StorageReference ref = FirebaseStorage.instance.ref().child(asset.name);
        StorageUploadTask uploadTask = ref.putData(imageData);

        String url = await (await uploadTask.onComplete).ref.getDownloadURL();
        urls.add(url.toString());
        print('Done Uploading Images');
      }catch(e){
        print('--------------Error while uploading------ ($e)');
      }
    });
    print(urls);
    return urls;
  }

  void deleteProduct() {}

  void deleteProducts() {}

  void fetchAllProducts() {}
}
