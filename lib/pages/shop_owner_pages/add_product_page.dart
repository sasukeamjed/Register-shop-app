import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:register_shop_app/db/auth.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:register_shop_app/db/data_managment.dart';


class AddProductPage extends StatefulWidget {

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {

  List<Asset> images = List<Asset>();
  String _error;
  TextEditingController productNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
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
  Widget build(BuildContext context){
    var auth = Provider.of<Auth>(context);
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Center(
        child: Column(
          children: <Widget>[
            Text('Shop Owner Page'),
            TextField(
              controller: productNameController,
              decoration: InputDecoration(
                  hintText: 'Product Name'
              ),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(
                  hintText: 'Product Price'
              ),
            ),
            Center(child: Text('Error: $_error')),
            RaisedButton(
              child: Text("Pick images"),
              onPressed: loadAssets,
            ),
            Expanded(
              child: buildGridView(),
            ),
            RaisedButton(
              child: Text('Add The Product'),
              onPressed: () async{
                ShopsManagement shopsManagement = ShopsManagement();
                await shopsManagement.addProduct(shopName: 'fish', productName: productNameController.text, price: double.parse(priceController.text), assets: images);
              },
            ),
          ],
        ),
      ),
    );
  }
}
