import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:register_shop_app/pages/customer_page.dart';

class AuthPage extends StatelessWidget {
//  FirebaseUser user = FirebaseUser().getIdToken().asStream();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          return FutureBuilder(
            future: snapshot.data.getIdToken(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot){

            },
          );
        }else{
          return Customer();
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
