import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../db/db_class.dart';

class Shop extends StatelessWidget {

  @override
  Widget build(BuildContext context){
    var db = Provider.of<Db>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop Page'),
        leading: IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: () async {
            await db.signOut();
          },
        ),
      ),
      body: Center(
        child: Text('This is Shop page'),
      ),
    );
  }
}
