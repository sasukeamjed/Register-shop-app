import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main App'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: userController,
                decoration: InputDecoration(
                    labelText: 'UserName'
                ),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                    labelText: 'Password'
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: Text('LogIn'),
                    onPressed: login,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  RaisedButton(
                    child: Text('Sign Up'),
                    onPressed: signUp,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  login()async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: userController.text, password: passwordController.text);
      print('LogIn is Succesful');
    }catch(e){
      print('log in failed with following error $e');
    }
  }

  signUp()async{
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: userController.text, password: passwordController.text);
      print('Sign up is Succesful');
    }catch(e){
      print('Sign up failed with following error $e');
    }
  }


}