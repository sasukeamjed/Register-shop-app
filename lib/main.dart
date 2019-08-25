import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:register_shop_app/pages/admin_pages/admin_main.dart';
import 'package:register_shop_app/pages/auth_pages/auth_page.dart';
import 'db/db_class.dart';
import 'package:register_shop_app/pages/admin_pages/admin_adding_shop_page.dart';
import 'package:register_shop_app/pages/auth_pages/login_page.dart';
import 'parse_jwt.dart';
import 'pages/shop_page.dart';
import 'package:register_shop_app/pages/customer_page.dart';

//import 'models/user_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Db>(
          builder: (_) => Db(),
        ),
        StreamProvider<FirebaseUser>.value(
          value: FirebaseAuth.instance.onAuthStateChanged,
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AuthPage(),
      ),
    );
  }
}


