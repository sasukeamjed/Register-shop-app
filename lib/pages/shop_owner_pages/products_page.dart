import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:register_shop_app/db/auth.dart';
import 'package:register_shop_app/db/data_managment.dart';
import 'package:register_shop_app/models/product.dart';
import 'package:register_shop_app/models/users/shop_owner.dart';
import 'package:register_shop_app/widgets/product_card.dart';

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  ShopsManagement shopsManagement;

  @override
  void initState() {
    shopsManagement = ShopsManagement();

    super.initState();
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  print('fetching a product');
    return Center(
      child: Column(
        children: <Widget>[
          Expanded(
            child: FutureBuilder(
              future: shopsManagement.fetchAllProducts(Provider.of<Auth>(context).getCurrentUser),
              builder: (context, productsList){
                if(productsList.connectionState == ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator());
                }
                List<Product> products = productsList.data;
                return GridView.count(crossAxisCount: 2, children: products.map((product) => ProductCard(product: product),).toList(),);
              },

            ),
          ),

        ],
      ),
    );
  }
}
