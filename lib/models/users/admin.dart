import 'package:register_shop_app/models/users/super_admin.dart';
import 'package:flutter/foundation.dart';

class Admin extends SuperAdmin {
  final String adminFullName;
  final String displayName;
  final String location;
  final String adminPhotoUrl;

  Admin(
      {@required String uid,
      @required String email,
      @required String claimType,
      @required String phoneNumber,
      @required this.adminFullName,
      @required this.displayName,
      @required this.location,
      this.adminPhotoUrl,})
      : super(
          uid: uid,
          email: email,
          claimType: claimType,
          phoneNumber: phoneNumber,
        );
}
