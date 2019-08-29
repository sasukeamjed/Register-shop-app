import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:register_shop_app/db/auth.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../db/db_class.dart';

class Shop extends StatefulWidget {

  @override
  _ShopState createState() => _ShopState();
}

class _ShopState extends State<Shop> {

  List<Asset> images = List<Asset>();
  String _error;

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

  void uploadImages(List<Asset> assets){
    print('Uploading Images');
    assets.forEach((asset) async{
      try{
        ByteData byteData = await asset.requestOriginal();
        List<int> imageData = byteData.buffer.asUint8List();
        StorageReference ref = FirebaseStorage.instance.ref().child(asset.name);
        StorageUploadTask uploadTask = ref.putData(imageData);

        await uploadTask.onComplete;

        print('Done Uploading Images');
      }catch(e){
        print('--------------Error while uploading------ ($e)');
      }
    });
    setState(() {
      images = List<Asset>();
    });
  }

  @override
  Widget build(BuildContext context){
    var auth = Provider.of<Auth>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop Page'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: (){

            },
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: () async {
            await auth.signOut();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            children: <Widget>[
              Text('Shop Owner Page'),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Product Name'
                ),
              ),
              TextField(
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
                onPressed: (){},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
