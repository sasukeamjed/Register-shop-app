import 'package:flutter/foundation.dart';
import 'package:register_shop_app/models/users/shop_owner.dart';

class SuperAdmin{
  final String uid;
  final String idToken;
  final String email;
  final String phoneNumber;
  final List<ShopOwner> shops;

  SuperAdmin({@required this.uid, @required this.idToken, @required this.email, @required this.phoneNumber,  @required this.shops,});
}