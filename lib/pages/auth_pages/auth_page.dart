import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:register_shop_app/db/auth.dart';
import 'package:register_shop_app/pages/admin_pages/admin_main.dart';
import 'package:register_shop_app/pages/customer_page.dart';
import 'package:register_shop_app/pages/auth_pages/login_page.dart';
import 'package:register_shop_app/pages/shop_owner_pages/main_shop_owner_page.dart';

class AuthPage extends StatelessWidget {
  //ToDo: Check if user exist or not
  //ToDo: if exist call splash screen until data fetching is completed
  //ToDo: if not direct to the login screen

  @override
  Widget build(BuildContext context) {
    Auth auth = Auth();

    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
        if (snapshot.hasData) {
          print('auth_page 23: $snapshot');
          return FutureBuilder(
            future: snapshot.data.getIdToken(),
            builder: (BuildContext context, AsyncSnapshot<IdTokenResult> idToken) {
//              print('auth_page 26: $idToken');
//              print('auth_page 27: ${idToken.connectionState}');
              if (idToken.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
                if (idToken.data.claims['claim'] == 'Admin') {
                  auth.createUser(idToken.data);
                  return AdminMain();
                } else if (idToken.data.claims['claim'] == 'ShopOwner') {
                  auth.createUser(idToken.data);
                  return ShopOwnerMain();
                }
                auth.createUser(idToken.data);
//                print('auth_page 36: createUser method is called');
                return Customer();

            },
          );
        } else {
          return LoginPage();
        }
      },
    );
  }
}
