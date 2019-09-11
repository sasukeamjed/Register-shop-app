import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:register_shop_app/db/auth.dart';

class Loader extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<Auth>(context);
    return auth.isFetching ? CircularProgressIndicator() : Container();
  }
}
