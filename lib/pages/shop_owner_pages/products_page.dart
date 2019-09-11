import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:register_shop_app/db/auth.dart';
import 'package:register_shop_app/db/data_managment.dart';
import 'package:register_shop_app/models/product.dart';
import 'package:register_shop_app/models/users/shop_owner.dart';

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

    return Center(
      child: Column(
        children: <Widget>[
          Expanded(
            child: FutureBuilder(
              future: ,
              builder:
                  (BuildContext context, AsyncSnapshot<QuerySnapshot> querySnapshot) {
                if(querySnapshot.connectionState == ConnectionState.waiting){
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }else {
                  return GridView.builder(
                    itemCount: querySnapshot.data.documents.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (BuildContext context, int index) {
//                      print('products_page 20: ${querySnapshot.data.documents[1].data}');
                      return Card(
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Center(
                                child: Text(querySnapshot.data.documents[index].data['productName']),
                              ),
                            ),
                            Expanded(
                              child: FadeInImage(image: NetworkImage(querySnapshot.data.documents[index].data['imagesUrls'][0]), placeholder: AssetImage('lib/assets/place_holder_product_image.jpg'), height: 100, fit: BoxFit.cover,),
                            ),
                            Text(querySnapshot.data.documents[index].data['price'].toString()),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),

        ],
      ),
    );
  }
}
