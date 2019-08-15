import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../db/db_class.dart';

class ClaimRadioButtons extends StatefulWidget {
  @override
  _ClaimRadioButtonsState createState() => _ClaimRadioButtonsState();
}

class _ClaimRadioButtonsState extends State<ClaimRadioButtons> {


  String _claimType;

  get claimType => _claimType;

  registerClaim(value){
    setState(() {
      switch(value){
        case "Admin":
          _claimType = "Admin";
          break;
        case "Shop":
          _claimType = "Shop";
          break;
        case "Customer":
          _claimType = "Customer";
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var db = Provider.of<Db>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          children: <Widget>[
            Radio(
              value: "Admin",
              groupValue: _claimType,
              onChanged: (value){
                registerClaim(value);
                db.setClaim(value);
                print(db.claim);
              },
            ),
            Text('Admin'),
          ],
        ),
        Column(
          children: <Widget>[
            Radio(
              value: "Shop",
              groupValue: _claimType,
              onChanged: (value){
                registerClaim(value);
                db.setClaim(value);
                print(db.claim);
              },
            ),
            Text('Shop'),
          ],
        ),
        Column(
          children: <Widget>[
            Radio(
              value: "Customer",
              groupValue: _claimType,
              onChanged: (value){
                registerClaim(value);
                db.setClaim(value);
                print(db.claim);
              },
            ),
            Text('Customer'),
          ],
        ),
      ],
    );
  }
}