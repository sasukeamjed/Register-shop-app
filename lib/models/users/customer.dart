import 'package:flutter/foundation.dart';
import 'package:register_shop_app/models/users/super_admin.dart';

class Customer extends SuperAdmin {
  final String userDisplayName;
  final String userRealName;
  final String userFamilyName;
  final String country;
  final String city;
  final String village;
  final String customerPhotoUrl;

  Customer({
    @required String uid,
    @required String email,
    @required String claimType,
    @required String phoneNumber,
    @required this.userDisplayName,
    @required this.userRealName,
    @required this.userFamilyName,
    @required this.country,
    @required this.city,
    @required this.village,
    this.customerPhotoUrl
  }) : super(
          uid: uid,
          email: email,
          claimType: claimType,
          phoneNumber: phoneNumber,
        );
}
