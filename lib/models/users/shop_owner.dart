import 'package:register_shop_app/models/users/super_admin.dart';
import 'package:flutter/foundation.dart';

class ShopOwner extends SuperAdmin{
  final String shopFullOwnerName;
  final String ownerPhotoUrl;

  ShopOwner(
      {@required String uid,
        @required String email,
        @required String claimType,
        @required String phoneNumber,
        @required this.shopFullOwnerName,
        this.ownerPhotoUrl,
        })
      : super(
    uid: uid,
    email: email,
    claimType: claimType,
    phoneNumber: phoneNumber,
  );
}