import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:register_shop_app/db/auth.dart';
import 'package:register_shop_app/pages/shop_owner_pages/add_product_page.dart';
import 'package:register_shop_app/pages/shop_owner_pages/products_page.dart';
import 'package:register_shop_app/pages/shop_owner_pages/shop_data_page.dart';

class ShopOwnerMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<Auth>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop Owner Pages'),
        leading: IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: () async {
            await auth.signOut();
          },
        ),
      ),
      body: PageView(
        children: <Widget>[
          ShopDataPage(),
          AddProductPage(),
          ProductsPage(),
        ],
      ),
    );
  }
}