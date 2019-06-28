import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatelessWidget {
  Home(this.username);

  String username;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(username),
        leading: IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: () {
            signOut();
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'This is Home Page',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('Creat new user?!'),
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(
              height: 10.0,
            ),
            SizedBox(
              width: 10.0,
            ),
            RaisedButton(
              child: Text('Add a new User ?!'),
              onPressed: () {
//                fetchUserByUid('1ZXgy5DtuaToQFwEv0gDicmjMPg2');
                addAdminRole('test@test.com');
              },
            ),
          ],
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

  addUser() async {
    CloudFunctions.instance.getHttpsCallable(functionName: "addUser").call({
      "name": nameController.text,
      "email": emailController.text
    }).then((res) {
      print('Done creating a user');
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
      print(res.data);
    }).catchError((e){
      print(e);
    });
  }

  addAdminRole(email) async{
    CloudFunctions.instance.getHttpsCallable(functionName: 'addTheAdmin').call({
      "email": email
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
