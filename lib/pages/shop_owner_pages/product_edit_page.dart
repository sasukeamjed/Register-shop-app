import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:register_shop_app/constants/dimensions.dart';
import 'package:register_shop_app/db/auth.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:register_shop_app/db/data_managment.dart';

import 'package:register_shop_app/models/product.dart';
import 'package:register_shop_app/models/users/shop_owner.dart';

class ProductEditPage extends StatefulWidget {
  final Product product;

  ProductEditPage({@required this.product});

  @override
  _ProductEditPageState createState() => _ProductEditPageState();
}

class _ProductEditPageState extends State<ProductEditPage> {
  List<Asset> images = List<Asset>();
  String _error;
  TextEditingController productNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  double screenHeight;
  double screenWidth;

  @override
  void initState() {
    productNameController.text = widget.product.productName;
    priceController.text = widget.product.price.toString();

    super.initState();
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 2,
      children: List.generate(widget.product.images.length, (index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: <Widget>[
              CachedNetworkImage(
                imageUrl: widget.product.images[index],
                placeholder: (context, url)=> Center(child: CircularProgressIndicator(),),
                errorWidget: (context,url,error) => Center(child: new Icon(Icons.error)),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    GestureDetector(
                      child: Icon(Icons.camera),
                      onTap: () {
                        print('choose photo from library');
                      },
                    ),
                    GestureDetector(
                      child: Icon(Icons.camera_alt),
                      onTap: () {
                        print('Choose photo from camera');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    setState(() {
      images = List<Asset>();
    });

    List<Asset> resultList;
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 5,
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      if (error == null) _error = 'No Error Dectected';
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    var auth = Provider.of<Auth>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Edit Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            children: <Widget>[
              Text('Shop Owner Page'),
              TextField(
                controller: productNameController,
                decoration: InputDecoration(hintText: 'Product Name'),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(hintText: 'Product Price'),
              ),
              Center(child: Text('Error: $_error')),
              RaisedButton(
                child: Text("Pick images"),
                onPressed: loadAssets,
              ),
              Expanded(
                child: buildGridView(),
              ),
              auth.isFetching ? CircularProgressIndicator() : Container(),
              RaisedButton(
                child: Text('Update Product'),
                onPressed: () async {
                  ShopsManagement shopsManagement = ShopsManagement();
                  auth.setFetchingData(true);
                  await shopsManagement.addProduct(
                      claim: (auth.getCurrentUser as ShopOwner).claim,
                      shopName: (auth.getCurrentUser as ShopOwner).shopName,
                      productName: productNameController.text,
                      price: double.parse(priceController.text),
                      assets: images);
                  auth.setFetchingData(false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
