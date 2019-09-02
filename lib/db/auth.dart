import 'package:firebase_auth/firebase_auth.dart';
import 'package:register_shop_app/constants/claims_types.dart';
import 'package:register_shop_app/db/db_class.dart';
import 'package:register_shop_app/models/users/User.dart';
import 'package:register_shop_app/models/users/admin.dart';
import 'package:register_shop_app/models/users/customer.dart';
import 'package:register_shop_app/models/users/shop_owner.dart';

class Auth extends Db {
  Future<IdTokenResult> signIn(String email, String password) {
    setFetchingData(true);
    return FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((AuthResult result) {
      return result.user.getIdToken();
    }).then((IdTokenResult idToken) {
//      createUser(idToken);
      setFetchingData(false);
      return idToken;
    }).catchError((e) {
      print(e);
    });
  }

  Future<IdTokenResult> signUp(String email, String password) {
    setFetchingData(true);
    return FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((AuthResult result) {
      return result.user.getIdToken();
    }).then((IdTokenResult idToken) {
//      print('auth_page 33: createUser method is called');
//      createUser(idToken);
      setFetchingData(false);
      return idToken;
    }).catchError((e) {
      print(e);
    });
  }

  Future<void> signOut() {
    setUser = null;
    return FirebaseAuth.instance.signOut();
  }

  static bool isTokenExpired(DateTime dateTime) {
    //ToDo: check token expire time
    DateTime now = DateTime.now();
    return dateTime.isBefore(now);
  }

  void createUser(IdTokenResult idToken) {
    User user;

    switch (idToken.claims['claim']) {
      case 'Admin':
        user = Admin(
            uid: idToken.claims['user_id'],
            email: idToken.claims['email'],
            token: idToken.claims['token'],
            claim: ClaimsType.Admin,
            phoneNumber: idToken.claims['phone_number']);
        break;
      case 'ShopOwner':
        user = ShopOwner(
            uid: idToken.claims['user_id'],
            email: idToken.claims['email'],
            token: idToken.claims['token'],
            claim: ClaimsType.ShopOwner,
            shopName: idToken.claims['displayName'],
            phoneNumber: idToken.claims['phone_number'],
            //ToDo: get first name and last
            firstName: 'amjed',
            lastName: 'al anqoodi',
            ownerPhotoUrl: idToken.claims['photoUrl']);
        break;
      default:
        user = Customer(
            uid: idToken.claims['user_id'],
            email: idToken.claims['email'],
            token: idToken.claims['token'],
            phoneNumber: idToken.claims['phone_number'],
            userDisplayName: 'test',
            userRealName: 'amjed san',
            userFamilyName: 'al anqoodi',
            country: 'oman',
            city: 'nizwa',
            village: 'marfa daris');
        break;
    }

    setUser = user;
//    print('auth.dart 75: ${user.email}');
  }
}
