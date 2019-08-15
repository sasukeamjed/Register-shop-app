import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:register_shop_app/constants/claims_types.dart';

class SuperAdminManagement {
  void addUser(
      {@required ClaimsType claim,
      @required String email,
      @required String password,
      @required String phoneNumber}) {
    if (claim == ClaimsType.Admin) {
      addAdmin();
    } else if (claim == ClaimsType.ShopOwner) {
      addShopOwner();
    } else if (claim == ClaimsType.Customer) {
      addCustomer();
    }
  }

  static Future<void> addAdmin({
    @required ClaimsType claim,
    @required String email,
    @required String password,
    @required String phoneNumber,
    String fullName,
    String displayName,
  }) {

  }

  void addShopOwner({
    @required ClaimsType claim,
    @required String shopName,
    @required String email,
    @required String password,
    @required String phoneNumber,
    @required String fullName,
    String displayName,
  }) {}

  void addCustomer({
    @required String email,
    @required String claimType,
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

  void fetchAllShopsOwners() {}
}

class ShopsManagement {
  void addProduct() {}

  void deleteProduct() {}

  void deleteProducts() {}

  void fetchAllProducts() {}
}

//class ProductsManagement{
//  void addProduct(){
//
//  }
//
//  void deleteProduct(){
//
//  }
//
//  void fetchAllProducts(){
//
//  }
//}
//
//class UsersManagement{
//  void addUser(){
//
//  }
//
//  void deleteUser(){
//
//  }
//}
