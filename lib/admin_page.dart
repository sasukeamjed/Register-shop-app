import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'db/db_class.dart';
import 'widgets/admin_page_widgets.dart';
import 'parse_jwt.dart';

class AdminPage extends StatelessWidget {

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController shopNameController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    var db = Provider.of<Db>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(db.userInstance.email),
        leading: IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: () async {
            await db.signOut();
          },
        ),
      ),
      body: Padding(
        //ToDo: Adding Form Widget And Validate Data
        //ToDo: Adding Location By Choosing From Map And Store It In Location Object
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'This is Home Page',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('Creat new user?!'),
                TextField(
                  controller: shopNameController,
                  decoration: InputDecoration(labelText: 'Shop Name'),
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                ),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(labelText: 'Phone number'),
                ),
                SizedBox(
                  height: 10.0,
                ),
                SizedBox(
                  width: 10.0,
                ),
                ClaimRadioButtons(),
                SizedBox(
                  height: 15.0,
                ),
                RaisedButton(
                  child: Text('Add a new User ?!'),
                  onPressed: () async{
//                fetchUserByUid('1ZXgy5DtuaToQFwEv0gDicmjMPg2');
//                await addUser(db.claim);
                    await createUser(db.claim);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // login() async {
  //   try {
  //     await FirebaseAuth.instance.signInWithEmailAndPassword(
  //         email: emailController.text, password: passwordController.text);
  //     print('LogIn is Succesful');
  //   } catch (e) {
  //     print('log in failed with following error $e');
  //   }
  // }

  addUser(claim) async {
    CloudFunctions.instance.getHttpsCallable(functionName: "addUser").call({
      "email": emailController.text,
      "password": emailController.text,
      "shopName": shopNameController.text,
      "phoneNumber": phoneController.text
    }).then((res) {
      print('Done creating a user');
      addAdminRole(emailController.text, claim);
    }).catchError((e) {
      print(e);
    });
    // try {
    //   await FirebaseAuth.instance.createUserWithEmailAndPassword(
    //       email: userController.text, password: passwordController.text);
    //   print('Sign up is Succesful');
    // } catch (e) {
    //   print('Sign up failed with following error $e');
    // }
  }

  createUser(claim) async{
    CloudFunctions.instance.getHttpsCallable(functionName: "createUser").call(
      {
        "email": emailController.text,
        "password": passwordController.text,
        "claim" : claim
      }
    ).then((res){
      print(res.data);
    }).catchError((e){
      print(e);
    });
  }

  fetchUserByUid(uid) async {

    CloudFunctions.instance
        .getHttpsCallable(functionName: "fetchUserByUid")
        .call({"uid": uid}).then((res) {
          print(res.data['email']);
          print('Done getting a user');
        }).catchError((e) {
          print(e);
    });
  }

  fetchAllUsers() async{
    CloudFunctions.instance.getHttpsCallable(functionName: 'getAllUsers').call().then((res){
      print('function getAllUsers is called');
      print(res);
    }).catchError((e){
      print(e);
    });
  }

  addAdminRole(email, claim) async{
    CloudFunctions.instance.getHttpsCallable(functionName: 'addTheAdmin').call({
      "email": email,
      "claim": claim
    }).then((res){
      print('Addmin Roles is Added');
    }).catchError((e){
      print(e);
    });
  }

  fetchUserByEmail(email) async{
    CloudFunctions.instance
        .getHttpsCallable(functionName: "fetchUserByEmail")
        .call({
      "email": email,
    }).then((res) {
      print(res.data);
      print('Done getting a user');
    }).catchError((e) {
      print(e);
    });
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
