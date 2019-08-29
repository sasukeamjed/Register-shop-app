import 'dart:io';

import 'package:flutter/foundation.dart';

class Product{
  final String productName;
  final double price;
  final List images;

  Product({@required this.productName, @required this.price, @required this.images});

  factory Product.fromJson(Map<String, dynamic> data){
    return Product(productName: data['productName'], price: data['price'], images: data['imagesURLs']);
  }

  Future<Map<String, dynamic>> toJson(String productName, double price, Future<List<String>> generateURLs()) async{
    var imageUrls = await generateURLs();
    return {
      'productName' : productName,
      'price' : price,
      'imageUrl' : imageUrls
    };
  }
}