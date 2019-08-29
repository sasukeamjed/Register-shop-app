import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:register_shop_app/pages/admin_pages/admin_main.dart';
import 'package:register_shop_app/pages/customer_page.dart';
import 'package:register_shop_app/pages/auth_pages/login_page.dart';
import 'package:register_shop_app/pages/shop_page.dart';

class AuthPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot){
        if(snapshot.hasData){
          return FutureBuilder(
            future: snapshot.data.getIdToken(),
            builder: (BuildContext context, AsyncSnapshot<IdTokenResult> idToken){
              print('auth_page 21: $idToken');
              if(idToken.hasData){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return CircularProgressIndicator();
                }
                if(idToken.data.claims['claim'] == 'Admin'){
                  return AdminMain();
                }else if(idToken.data.claims['claim'] == 'ShopOwner'){
                  return Shop();
                }
                return Customer();
              }
              //ToDo: return a splash screen
              return CircularProgressIndicator();
            },
          );
        }else{
          return LoginPage();
        }
      },
    );
  }
}
