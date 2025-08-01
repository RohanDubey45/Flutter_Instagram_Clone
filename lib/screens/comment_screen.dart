import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/providers/user_data_provider.dart';
import 'package:instagram_flutter/resources/firestore_methods.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/widgets/comment_card.dart';
import 'package:provider/provider.dart';
import '../models/users.dart';

class CommentScreen extends StatefulWidget {
  final snap;
  const CommentScreen({super.key, required this.snap});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController commentsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserProvider>(context);
    final User user = userData.getUser!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text("Comments"),
        centerTitle: false,
      ),

      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance
                .collection('posts')
                .doc(widget.snap['postid'])
                .collection('comments')
                .orderBy('datePublished', descending: true)
                .snapshots(),
        builder: (
          context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
        ) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return CommentCard(snap: snapshot.data!.docs[index].data());
            },
          );
        },
      ),

      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight, // fixed constant height => 56
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 6,
          ),
          padding: EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.photoUrl),
                radius: 20,
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 18, right: 8),
                  child: TextField(
                    controller: commentsController,
                    style: TextStyle(
                      fontSize: 16
                    ),
                    decoration: InputDecoration(
                      hintText: 'Comment as ${user.username}',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),

              InkWell(
                onTap: () async {
                  await FirestoreMethods().commentPost(
                    widget.snap['postid'],
                    user.uid,
                    user.photoUrl,
                    commentsController.text.trim(),
                    user.username,
                  );
                  setState(() {
                    commentsController.text = "";
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8, left: 8),
                  child: Text(
                    "Post",
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
