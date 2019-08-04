import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:register_shop_app/db/db_class.dart';

import 'package:register_shop_app/pages/admin_pages/admin_adding_shop_page.dart';
import 'package:register_shop_app/pages/admin_pages/admin_extra_page.dart';
import 'package:register_shop_app/pages/admin_pages/admin_shops_page.dart';

class AdminMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var db = Provider.of<Db>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Pages'),
          leading: IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await db.signOut();
            },
          ),
      ),
      body: PageView(
        children: <Widget>[
          AdminAddingShopPage(),
          AdminShopsPage(),
          AdminExtraPage(),
        ],
      ),
    );
  }
}
