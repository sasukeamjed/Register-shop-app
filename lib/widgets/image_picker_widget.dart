import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io';

class PickImage extends StatefulWidget {

  Function imagePickerFunction;

  PickImage({this.imagePickerFunction});

  @override
  _PickImageState createState() => _PickImageState();
}

class _PickImageState extends State<PickImage> {

  //save the result of gallery file


//  //save the result of camera file
//  File cameraFile;
  File imageFile;


  @override
  Widget build(BuildContext context) {
    //display image selected from gallery

    imageSelectorGallery() async {
      try {
        imageFile = await ImagePicker.pickImage(
          source: ImageSource.gallery,
          // maxHeight: 50.0,
          // maxWidth: 50.0,
        );
        print("You selected gallery image : " + imageFile.path);
        setState(() {
          widget.imagePickerFunction(imageFile);
        });
      } catch (e) {
        print('There was an error: $e');
      }
    }

    //display image selected from camera
    imageSelectorCamera() async {
      imageFile = await ImagePicker.pickImage(
        source: ImageSource.camera,
        //maxHeight: 50.0,
        //maxWidth: 50.0,
      );
      print("You selected camera image : " + imageFile.path);
      setState(() {
        widget.imagePickerFunction(imageFile);
      });
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
            imageFile == null ? Container() : Container(
              width: 200,
              height: 300,
              child: Image.file(imageFile),
            )
          ],
        );
      },
    );
  }
}
