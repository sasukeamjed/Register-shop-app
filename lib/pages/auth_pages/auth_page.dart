import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:register_shop_app/db/auth.dart';
import 'package:register_shop_app/pages/admin_pages/admin_main.dart';
import 'package:register_shop_app/pages/customer_page.dart';
import 'package:register_shop_app/pages/auth_pages/login_page.dart';
import 'package:register_shop_app/pages/shop_owner_pages/main_shop_owner_page.dart';

class AuthPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Auth auth = Auth();

    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot){
        if(snapshot.hasData){
          return FutureBuilder(
            future: snapshot.data.getIdToken(),
            builder: (BuildContext context, AsyncSnapshot<IdTokenResult> idToken){
              print('auth_page 20: $idToken');
              if(idToken.hasData){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return CircularProgressIndicator();
                }
                if(idToken.data.claims['claim'] == 'Admin'){
                  auth.createUser(idToken.data);
                  return AdminMain();
                }else if(idToken.data.claims['claim'] == 'ShopOwner'){
                  auth.createUser(idToken.data);
                  return ShopOwnerMain();
                }
                auth.createUser(idToken.data);
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
