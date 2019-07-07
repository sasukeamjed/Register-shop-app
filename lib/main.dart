import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'db/db_class.dart';
import 'admin_page.dart';
import 'login_page.dart';
import 'parse_jwt.dart';
import 'shop_page.dart';
import 'customer_page.dart';

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


  @override
  Widget build(BuildContext context) {
    var db = Provider.of<Db>(context);
    var authUser = Provider.of<FirebaseUser>(context);

    if (authUser != null) {
      return FutureBuilder<User>(
        future: db.create(authUser),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done){
            print(parseJwt(db.userInstance.idToken));
            if(parseJwt(db.userInstance.idToken)['claim'] == 'Admin'){
              return AdminPage();
            }else if(parseJwt(db.userInstance.idToken)['claim'] == 'Shop'){
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
