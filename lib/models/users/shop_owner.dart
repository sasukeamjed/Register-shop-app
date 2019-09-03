import 'package:register_shop_app/constants/claims_types.dart';
import 'package:flutter/foundation.dart';
import 'package:register_shop_app/models/users/User.dart';

class ShopOwner extends User{
  final String shopName;
  final String phoneNumber;
  final String firstName;
  final String lastName;
  final String ownerPhotoUrl;
  final ClaimsType claim;


  ShopOwner({
    @required String uid,
    @required String email,
    @required String token,
    @required this.claim,
    @required this.shopName,
    @required this.phoneNumber,
    @required this.firstName,
    @required this.lastName,
    @required this.ownerPhotoUrl,
  }):assert(uid != null && email != null && shopName != null, 'one of theses properties are null: shopName => $shopName, email => $email, uid => $uid') ,super(uid: uid, email: email, token: token);

  factory ShopOwner.fromJson(Map<String, dynamic> data) {
    return ShopOwner(
        uid: data['uid'],
        email: data['email'],
        phoneNumber: data['phone_number'],
        firstName: '',
        lastName: '',
        ownerPhotoUrl: data['picture'],
        shopName: data['name']);
  }
}
