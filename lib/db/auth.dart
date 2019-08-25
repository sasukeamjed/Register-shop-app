import 'package:firebase_auth/firebase_auth.dart';
import 'package:register_shop_app/db/db_class.dart';

class Auth extends Db{

  Future<IdTokenResult> signIn(String email, String password){
    setFetchingData(true);
    return FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password)
        .then((AuthResult result){
      return result.user.getIdToken();
    }).then((IdTokenResult idToken){
      setFetchingData(false);
      return idToken;
    }).catchError((e){
      print(e);
    });

  }

  static Future<IdTokenResult> signUp(String email, String password){

    return FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password)
    .then((AuthResult result){
      return result.user.getIdToken();
    }).then((IdTokenResult idToken){
      return idToken;
    }).catchError((e){
      print(e);
    });

  }

  Future<void> signOut(){
    return FirebaseAuth.instance.signOut();
  }

  static bool isTokenExpired(DateTime dateTime){
    DateTime now = DateTime.now();
    return dateTime.isBefore(now);
  }
}