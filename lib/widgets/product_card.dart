import 'package:flutter/material.dart';
import 'package:register_shop_app/models/product.dart';
import 'package:register_shop_app/pages/shop_owner_pages/product_edit_page.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  ProductCard({this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(product.productName),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_)=> ProductEditPage(product: product,)));
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: FadeInImage(
              image: NetworkImage(product.images[0]),
              placeholder:
                  AssetImage('lib/assets/place_holder_product_image.jpg'),
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          Text(product.price.toString()),
        ],
      ),
    );
  }
}
