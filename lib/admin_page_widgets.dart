import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckBoxes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text('Admin'),
            Checkbox(),
          ],
        ),
        Row(
          children: <Widget>[
            Text('Shop'),
            Checkbox(),
          ],
        ),Row(
          children: <Widget>[
            Text('Customer'),
            Checkbox(),
          ],
        ),
      ],
    );
  }
}
