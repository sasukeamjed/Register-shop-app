import 'package:register_shop_app/models/product.dart';
import 'package:flutter/foundation.dart';

class ShopOwner{
  final String uid;
  final String email;
  final String idToken;
  final String phoneNumber;
  final List<Product> products;
  final String shopOwnerFullName;
  final String ownerPhotoUrl;
  final String shopName;

  ShopOwner(
      {@required this.uid,
        @required this.shopName,
        @required this.email,
        @required this.idToken,
        @required this.products,
        @required this.phoneNumber,
        @required this.shopOwnerFullName,
        this.ownerPhotoUrl,
        });
}