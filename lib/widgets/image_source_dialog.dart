

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class ImageSouceDialog extends StatelessWidget {

  final Function(File) onImageSlected;

  ImageSouceDialog({this.onImageSlected});

  void imageSelected(File image) async {
    if(image != null){
      onImageSlected(image);
    }
  }

  /* void imageSelected(File image) async {
    if (image != null) {
      File croppedImage = await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatio: CropAspectRatio(
              ratioX: 1.0,
              ratioY: 1.0)
      );
      onImageSlected(croppedImage);
    }
  }*/


  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(35)
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 22, bottom: 22),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GestureDetector(
                  child: Column(
                    children: <Widget>[
                      Image.asset("images/icons/galeria1.png",
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,),
                      Text("Galeria",
                          style: GoogleFonts.acme(
                            textStyle: TextStyle(color: Colors.black54, fontSize: 20),
                          )),
                    ],
                  ) ,
                  onTap: () async {
                    File image =
                    // ignore: deprecated_member_use
                    await ImagePicker.pickImage(source: ImageSource.gallery);
                    imageSelected(image);
                  },
                ),
                GestureDetector(
                  child: Column(
                    children: <Widget>[
                      Image.asset("images/icons/camera.png",
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,),
                      Text("Camera",
                          style: GoogleFonts.acme(
                            textStyle: TextStyle(color: Colors.black54, fontSize: 20),
                          )),
                    ],
                  ) ,
                  onTap: () async {
                    File image =
                    await ImagePicker.pickImage(source: ImageSource.camera);
                    imageSelected(image);
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
