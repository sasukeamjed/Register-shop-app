import 'dart:io';

import 'package:flutter/foundation.dart';

class Product{
  final String productName;
  final double price;
  final List<String> imagesURLs;

  Product({@required this.productName, @required this.price, @required this.imagesURLs});
}