import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:register_shop_app/db/auth.dart';



class ShopDataPage extends StatefulWidget {

  @override
  _ShopDataPageState createState() => _ShopDataPageState();
}

class _ShopDataPageState extends State<ShopDataPage> {

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context){
    var auth = Provider.of<Auth>(context);
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Center(
        child: Column(
          children: <Widget>[
            Text('Shop Data Page'),
          ],
        ),
      ),
    );
  }
}
