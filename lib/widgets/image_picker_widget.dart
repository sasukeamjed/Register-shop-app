import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';
import '../db/db_class.dart';

import 'dart:io';

class PickImage extends StatefulWidget {
  @override
  _PickImageState createState() => _PickImageState();
}

class _PickImageState extends State<PickImage> {

  //save the result of gallery file
  File galleryFile;

  //save the result of camera file
  File cameraFile;


  @override
  Widget build(BuildContext context) {
    var db = Provider.of<Db>(context);
    //display image selected from gallery



    return Builder(
      builder: (BuildContext build){
        return Column(
          children: <Widget>[
            RaisedButton(
              child: Text('Select Image from Gallery'),
              onPressed: db.imageSelectorGallery,
            ),
            RaisedButton(
              child: Text('Select Image from Camera'),
              onPressed: db.imageSelectorCamera,
            ),
            displaySelectedFile(db.userPhoto),
          ],
        );
      },
    );
  }

  Widget displaySelectedFile(File file) {
    return new SizedBox(
      height: 200.0,
      width: 300.0,
      //child: new Card(child: new Text(''+galleryFile.toString())),
      //child: new Image.file(galleryFile),
      child: file == null
          ? new Container()
          : new Image.file(file),
    );
  }
}
