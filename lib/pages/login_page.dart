import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:register_shop_app/db/db_class.dart';



class LoginPage extends StatelessWidget {

  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    var db = Provider.of<Db>(context);
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
                    onPressed: () async{
                      await db.login(userController.text, passwordController.text);
                    },
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  RaisedButton(
                    child: Text('Sign Up'),
                    onPressed: () async {
                      await db.signUp(userController.text, passwordController.text);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }




}