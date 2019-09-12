import 'package:flutter/material.dart';
import 'package:register_shop_app/models/product.dart';

class ProductCard extends StatelessWidget {

  final Product product;

  ProductCard({this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Container(
            child: Center(
              child: Text(product.productName),
            ),
          ),
          Expanded(
            child: FadeInImage(image: NetworkImage(product.images[0]), placeholder: AssetImage('lib/assets/place_holder_product_image.jpg'), height: 100, fit: BoxFit.cover,),
          ),
          Text(product.price.toString()),
        ],
      ),
    );
  }
}
