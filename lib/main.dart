import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'admin_page.dart';
import 'login_page.dart';
import 'parse_jwt.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder<FirebaseUser> (
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, user) {
          print('AuthState is changed');
          String userToken;
          user.data.getIdToken().then((token){
            userToken = token;
            print(userToken);
            if(user.hasData){
              return Home(user.data.email);
            }else{
              return LoginPage();
            }
          }).catchError((e){
            print(e);
          });


        },
      ),
    );
  }
}


