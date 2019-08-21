import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:register_shop_app/pages/admin_pages/admin_main.dart';
import 'db/db_class.dart';
import 'package:register_shop_app/pages/admin_pages/admin_adding_shop_page.dart';
import 'package:register_shop_app/pages/login_page.dart';
import 'parse_jwt.dart';
import 'shop_page.dart';
import 'package:register_shop_app/pages/customer_page.dart';

import 'models/user_model.dart';

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


class AuthPage extends StatelessWidget {
//  FirebaseUser user = FirebaseUser().getIdToken().asStream();

  @override
  Widget build(BuildContext context) {
    var db = Provider.of<Db>(context);
    var authUser = Provider.of<FirebaseUser>(context);

    if (authUser != null) {
      return FutureBuilder<User>(
        future: db.createUser(authUser),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done){
            print('main.dart line 56: ${parseJwt(db.userInstance.idToken)}');
            if(parseJwt(db.userInstance.idToken)['claim'] == 'Admin'){
              print('main.dart line 57: this is the idToken: ' + db.userInstance.idToken);
              return AdminMain();
            }else if(parseJwt(db.userInstance.idToken)['claim'] == 'ShopOwner'){
              return Shop();
            }else {
              return Customer();
            }
          }
          else{
            return CircularProgressIndicator();
          }
        },
      );
    } else {
      return LoginPage();
    }
  }
}
