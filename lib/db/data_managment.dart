import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import 'package:register_shop_app/constants/claims_types.dart';
import 'package:register_shop_app/db/db_class.dart';
import 'package:register_shop_app/models/product.dart';
import 'package:register_shop_app/models/shop.dart';
import 'package:register_shop_app/models/users/shop_owner.dart';

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
  }) {

    print('data_managment 37: $idToken');

    assert(idToken != null && shopName != null && email != null && password != null, 'data_mangement 38: can not pass a null value');

    CloudFunctions.instance.getHttpsCallable(functionName: "createUser").call({
      "idToken": idToken,
      "shopName": shopName,
      "email": email,
      "password": password,
      "phoneNumber": phoneNumber,
      "shopOwnerName": fullName,
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

class ShopsManagement extends Db {

  Future<void> addProduct({@required ClaimsType claim, @required String shopName, @required String productName, @required double price, @required List<Asset> assets}) async{
    assert(claim != null && shopName != null && productName != null && price != null, 'can not accept a null value');
    if(claim != ClaimsType.ShopOwner) return null;

    print('data_manegment.dart 87: $productName');

    setFetchingData(true);

    try{
      List<String> imagesUrls = await _uploadImages(assets);

      DocumentSnapshot shopDocument = await Firestore.instance.collection('Shops').document(shopName).get();
      if(shopDocument.exists){
        return shopDocument.reference.collection('Products').document().setData({
          'productName' : productName,
          'price' : price,
          'imagesUrls' : imagesUrls
        });
      }
      setFetchingData(false);
    }catch(e){
      print('data_managment.dart 95: $e');
    }
    setFetchingData(false);
  }

  Future<void> updateProduct(){

  }

  Future<List<String>> _uploadImages(List<Asset> assets) async{
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

  Future<List<Product>> fetchAllProducts(ShopOwner shopOwner) async{
    setFetchingData(true);
    List<Product> products = [];

    var data = await Firestore.instance
        .collection('Shops')
        .document(shopOwner.shopName)
        .collection('Products').getDocuments();

    List<DocumentSnapshot> docs = data.documents;
    print(docs[0].data);
    for( var i = 0 ; i < docs.length; i++ ) {
      String productId = docs[i].documentID;
      products.add(Product.fromJson(productId: productId, data: docs[i].data));
    }
    setFetchingData(false);
    return products;
  }
}
