import 'package:flutter/material.dart';
import 'package:instagram_flutter/utils/colors.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
      ),
      body: Center(
        child: Text(
          "Edit profile feature coming soon",
          style: TextStyle(
            fontSize: 17,
          ),
        ),
      ),
    );
  }
}