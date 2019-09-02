import 'package:register_shop_app/constants/claims_types.dart';
import 'package:flutter/foundation.dart';
import 'package:register_shop_app/models/users/User.dart';

class ShopOwner extends User{
  final String shopName;
  final String phoneNumber;
  final String shopOwnerFullName;
  final String ownerPhotoUrl;
  final ClaimsType claim;


  ShopOwner({
    @required String uid,
    @required String email,
    @required String token,
    @required this.claim,
    @required this.shopName,
    @required this.phoneNumber,
    @required this.shopOwnerFullName,
    @required this.ownerPhotoUrl,
  }): super(uid: uid, email: email, token: token);

  factory ShopOwner.fromJson(Map<String, dynamic> data) {
    return ShopOwner(
        uid: data['uid'],
        email: data['email'],
        phoneNumber: data['phone_number'],
        shopOwnerFullName: '',
        ownerPhotoUrl: data['picture'],
        shopName: data['name']);
  }
}
