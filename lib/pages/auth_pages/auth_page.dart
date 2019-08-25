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
              return CircularProgressIndicator();

            },
          );
        }else{
          return LoginPage();
        }
      },
    );
//    var db = Provider.of<Db>(context);
//    var authUser = Provider.of<FirebaseUser>(context);
//
//    if (authUser != null) {
//      return FutureBuilder<User>(
//        future: db.createUser(authUser),
//        builder: (context, snapshot) {
//          if(snapshot.connectionState == ConnectionState.done){
//            print('main.dart line 56: ${parseJwt(db.userInstance.idToken)}');
//            if(parseJwt(db.userInstance.idToken)['claim'] == 'Admin'){
//              print('main.dart line 57: this is the idToken: ' + db.userInstance.idToken);
//              return AdminMain();
//            }else if(parseJwt(db.userInstance.idToken)['claim'] == 'ShopOwner'){
//              return Shop();
//            }else {
//              return Customer();
//            }
//          }
//          else{
//            return CircularProgressIndicator();
//          }
//        },
//      );
//    } else {
//      return LoginPage();
//    }
  }
}
