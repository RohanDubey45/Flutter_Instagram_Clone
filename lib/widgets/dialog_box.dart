// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:instagram_flutter/resources/firestore_methods.dart';

class DialogBox extends StatelessWidget {
  final String postId;
  const DialogBox({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Delete Post",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: const Text(
        "Are you sure you want to delete this post?",
        style: TextStyle(fontSize: 16),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false); // No
          },
          child: const Text(
            "No",
            style: TextStyle(
              color: Colors.blueAccent,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextButton(
          onPressed: () async {
            await FirestoreMethods().deletePost(postId);
            Navigator.of(context).pop(true); // Yes
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Post deleted successfully")),
            );
          },
          child: const Text(
            "Yes",
            style: TextStyle(
              color: Colors.redAccent,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
