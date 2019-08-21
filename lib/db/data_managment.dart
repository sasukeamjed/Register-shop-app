import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:register_shop_app/constants/claims_types.dart';
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

  static List<Shop> fetchAllShopsOwners() {
    return [];
  }
}

class ShopsManagement {
  static void addProduct(@required String idToken,) {

  }

  void deleteProduct() {}

  void deleteProducts() {}

  void fetchAllProducts() {}
}

