import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io';

class PickImage extends StatefulWidget {

  File imageFile;

  @override
  _PickImageState createState() => _PickImageState();
}

class _PickImageState extends State<PickImage> {

  //save the result of gallery file


//  //save the result of camera file
//  File cameraFile;


  @override
  Widget build(BuildContext context) {
    //display image selected from gallery

    imageSelectorGallery() async {
      try {
        widget.imageFile = await ImagePicker.pickImage(
          source: ImageSource.gallery,
          // maxHeight: 50.0,
          // maxWidth: 50.0,
        );
        print("You selected gallery image : " + widget.imageFile.path);
        setState(() {});
      } catch (e) {
        print('There was an error: $e');
      }
    }

    //display image selected from camera
    imageSelectorCamera() async {
      widget.imageFile = await ImagePicker.pickImage(
        source: ImageSource.camera,
        //maxHeight: 50.0,
        //maxWidth: 50.0,
      );
      print("You selected camera image : " + widget.imageFile.path);
      setState(() {});
    }


    return Builder(
      builder: (BuildContext build) {
        return Column(
          children: <Widget>[
            RaisedButton(
              child: Text('Select Image from Gallery'),
              onPressed: imageSelectorGallery,
            ),
            RaisedButton(
              child: Text('Select Image from Camera'),
              onPressed: imageSelectorCamera,
            ),
            widget.imageFile == null ? Container() : Container(
              width: 200,
              height: 300,
              child: Image.file(widget.imageFile),
            )
          ],
        );
      },
    );
  }
}
