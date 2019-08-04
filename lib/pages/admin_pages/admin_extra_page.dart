import 'package:flutter/material.dart';

class AdminExtraPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[Text('Extra Page', style: TextStyle(fontSize: 36, color: Colors.blue)),
      Image.network('https://firebasestorage.googleapis.com/v0/b/fir-auth-test-a160f.appspot.com/o/images%2Ftest%2Fresized-test-7cc090d3-ad65-49b0-85b3-ab923a11e49d-IMG_20190717_050829.jpg?alt=media&token=829e8328-83bb-484d-a7fc-d297357a39fc', width: 300, height: 400,)],
    );
  }
}
