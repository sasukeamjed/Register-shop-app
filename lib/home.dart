import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatelessWidget {
  Home(this.username);

  String username;

  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
              controller: userController,
              decoration: InputDecoration(labelText: 'UserName'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(
              height: 10.0,
            ),
            SizedBox(
              width: 10.0,
            ),
            RaisedButton(
              child: Text('Add a new User ?!'),
              onPressed: signUp,
            ),
          ],
        ),
      ),
    );
  }

  login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: userController.text, password: passwordController.text);
      print('LogIn is Succesful');
    } catch (e) {
      print('log in failed with following error $e');
    }
  }

  signUp() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: userController.text, password: passwordController.text);
      print('Sign up is Succesful');
    } catch (e) {
      print('Sign up failed with following error $e');
    }
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
