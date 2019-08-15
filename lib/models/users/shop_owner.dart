import 'package:register_shop_app/models/users/super_admin.dart';
import 'package:flutter/foundation.dart';

class ShopOwner extends SuperAdmin{
  final String shopOwnerFullName;
  final String ownerPhotoUrl;
  final String shopName;

  ShopOwner(
      {@required String uid,
        @required String email,
        @required String claimType,
        @required String phoneNumber,
        @required this.shopOwnerFullName,
        @required this.shopName,
        this.ownerPhotoUrl,
        })
      : super(
    uid: uid,
    email: email,
    claimType: claimType,
    phoneNumber: phoneNumber,
  );
}