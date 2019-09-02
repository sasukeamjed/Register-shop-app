import 'package:flutter/foundation.dart';
import 'package:register_shop_app/constants/claims_types.dart';
import 'package:register_shop_app/models/users/User.dart';

class Admin extends User{
  final ClaimsType claim;
  final String phoneNumber;


  Admin({@required String uid, @required String email, @required String token,@required this.claim, @required this.phoneNumber}) : super(uid : uid, email: email, token: token);
}

