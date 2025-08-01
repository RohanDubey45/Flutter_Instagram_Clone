import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker(); 

  XFile? file = await imagePicker.pickImage(source: source);

  if(file != null) {
    return await file.readAsBytes();
  } else {
    debugPrint("No image selected");
    return null;
  }
}

showSnackBar(String res, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.grey[900],
      content: Center(
        child: Text(res, style: TextStyle(
      fontSize: 17,
      color: Colors.white,
      fontWeight: FontWeight.bold
    ),),
  )));
}