import 'package:register_shop_app/constants/claims_types.dart';
import 'package:flutter/foundation.dart';
import 'package:register_shop_app/models/product.dart';
import 'package:register_shop_app/models/users/User.dart';

class ShopOwner extends User{
  final String shopName;
  final String phoneNumber;
  final String firstName;
  final String lastName;
  final String ownerPhotoUrl;
  final ClaimsType claim;
  final List<Product> products;


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
    @required this.products,
  }):assert(uid != null && email != null && shopName != null, 'one of theses properties are null: shopName => $shopName, email => $email, uid => $uid') ,super(uid: uid, email: email, token: token);

}
