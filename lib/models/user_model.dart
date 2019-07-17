import 'dart:io';

class User{
  //TODO: add assert to requier properties
  final String id;
  final String idToken;
  final String email;
  final String name;
  final String claimType;
  final File userPhoto;

  User({this.id, this.idToken, this.email, this.name, this.claimType, this.userPhoto});

}