import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:register_shop_app/db/auth.dart';
import 'package:register_shop_app/models/users/shop_owner.dart';

class ProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<Auth>(context);
    return Center(
      child: StreamBuilder(
        stream: Firestore.instance
            .collection('Shops')
            .document((auth.getCurrentUser as ShopOwner).shopName)
            .collection('Products')
            .snapshots(),
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
                print('products_page 20: ${querySnapshot.data.documents[1].data}');
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
    );
  }
}
