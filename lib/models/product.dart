import 'dart:io';

import 'package:flutter/foundation.dart';

class Product{
  final String productId;
  final String productName;
  final double price;
  final List images;

  Product({@required this.productId, @required this.productName, @required this.price, @required this.images});

  factory Product.fromJson({String productId, Map<String, dynamic> data}){
    return Product(productId: productId,productName: data['productName'], price: data['price'], images: data['imagesUrls']);
  }

  Map<String, dynamic> toJson(String productName, double price, List<String> generatedUrls) {
    return {
      'productName' : productName,
      'price' : price,
      'imageUrl' : generatedUrls,
    };
  }
}