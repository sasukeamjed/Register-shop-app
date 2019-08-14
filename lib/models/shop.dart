import 'package:flutter/foundation.dart';
import 'package:register_shop_app/models/product.dart';
import 'package:register_shop_app/models/users/shop_owner.dart';

class Shop{
  final ShopOwner owner;
  final List<Product> products;
  final String shopLocation;

  Shop({@required this.owner, @required this.products, @required this.shopLocation});
}