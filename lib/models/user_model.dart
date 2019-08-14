import 'dart:io';

class User{

  final String id;
  final String idToken;
  final String email;
  final String name;
  final String claimType;
  final String userPhotoUrl;

  User({this.id, this.idToken, this.email, this.name, this.claimType, this.userPhotoUrl});

}