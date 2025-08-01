import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/resources/firestore_methods.dart';
import 'package:instagram_flutter/screens/comment_screen.dart';
import 'package:instagram_flutter/screens/profile_screen.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/widgets/like_animation.dart';

class ViewPost extends StatefulWidget {
  final snap;
  const ViewPost({super.key, required this.snap});

  @override
  State<ViewPost> createState() => _ViewPostState();
}

class _ViewPostState extends State<ViewPost> {
  bool isAnimatingLike = false;
  List likes = [];
  String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    likes = List.from(widget.snap['likes']);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Post"),
        backgroundColor: mobileBackgroundColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return ProfileScreen(uid: widget.snap['uid']);
                  },
                ));
              },
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 13),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(widget.snap['profImg']),
                      radius: 20,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Text(
                            widget.snap['username'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Text(
                          widget.snap['name'],
                          style: TextStyle(
                            color: secondaryColor,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// POST IMAGE + DOUBLE TAP LIKE
          GestureDetector(
            onDoubleTap: () async {
              await FirestoreMethods().likePost(
                widget.snap['postid'],
                userId,
                likes,
              );
              setState(() {
                isAnimatingLike = true;
                if (likes.contains(userId)) {
                  likes.remove(userId);
                } else {
                  likes.add(userId);
                }
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.50,
                  width: double.infinity,
                  child: Image.network(
                    widget.snap['postUrl'],
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: Duration(milliseconds: 200),
                  opacity: isAnimatingLike ? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: isAnimatingLike,
                    duration: const Duration(milliseconds: 400),
                    onEnd: () {
                      setState(() {
                        isAnimatingLike = false;
                      });
                    },
                    child: Icon(
                      Icons.favorite,
                      size: 120,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// LIKE / COMMENT BAR
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
            child: Row(
              children: [
                LikeAnimation(
                  isAnimating: likes.contains(userId),
                  smallLike: true,
                  child: GestureDetector(
                    onTap: () async {
                      await FirestoreMethods().likePost(
                        widget.snap['postid'],
                        userId,
                        likes,
                      );
                      setState(() {
                        if (likes.contains(userId)) {
                          likes.remove(userId);
                        } else {
                          likes.add(userId);
                        }
                      });
                    },
                    child: likes.contains(userId)
                        ? Icon(Icons.favorite_rounded, color: Colors.red, size: 28)
                        : Icon(Icons.favorite_border_rounded, size: 28),
                  ),
                ),
                SizedBox(width: 2),

                /// Likes count
                Text(
                  likes.length.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                SizedBox(width: 20),

                /// Comment button
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return CommentScreen(snap: widget.snap);
                      },
                    ));
                  },
                  child: Icon(Icons.comment_outlined, size: 28),
                ),
                SizedBox(width: 3),

                /// Comment count
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .doc(widget.snap['postid'])
                      .collection('comments')
                      .snapshots(),
                  builder: (
                    context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
                  ) {
                    if (!snapshot.hasData) {
                      return Text(
                        '0',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      );
                    }
                    return Text(
                      snapshot.data!.docs.length.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    );
                  },
                ),
                SizedBox(width: 10),

                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.send, size: 28),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.bookmark_outline, size: 28),
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// Description
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.bottomLeft,
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: primaryColor),
                children: [
                  TextSpan(
                    text: widget.snap['username'],
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  TextSpan(
                    text: ' ${widget.snap['description']}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),

          /// Timestamp
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            alignment: Alignment.bottomLeft,
            child: Text(
              widget.snap['datePublished'],
              style: TextStyle(color: secondaryColor, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
