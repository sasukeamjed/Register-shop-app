import 'package:firebase_auth/firebase_auth.dart';

class Auth{

  static Future<IdTokenResult> signIn(String email, String password){

    return FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password)
        .then((AuthResult result){
      return result.user.getIdToken();
    }).then((IdTokenResult idToken){
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

  static Future<void> signOut(){
    return FirebaseAuth.instance.signOut();
  }

  static bool isTokenExpired(DateTime dateTime){
    DateTime now = DateTime.now();
    return dateTime.isBefore(now);
  }
}