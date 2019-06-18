import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'home.dart';
import 'login_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder<FirebaseUser>(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, snapshot){
          print('AuthState is changed');
          if(snapshot.hasData){
            return Home(snapshot.data.email);
          }else{
            return LoginPage();
          }
        },
      ),
    );
  }
}


