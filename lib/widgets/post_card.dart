import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/models/users.dart';
import 'package:instagram_flutter/providers/user_data_provider.dart';
import 'package:instagram_flutter/resources/firestore_methods.dart';
import 'package:instagram_flutter/screens/comment_screen.dart';
import 'package:instagram_flutter/screens/profile_screen.dart';
import 'package:instagram_flutter/screens/users_liked.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/widgets/dialog_box.dart';
import 'package:instagram_flutter/widgets/like_animation.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isAnimatingLike = false;
  int totalComments = 0;

  Future<void> getComments() async {
    QuerySnapshot data =
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.snap['postid'])
            .collection('comments')
            .get();
    setState(() {
      totalComments = data.docs.length;
    });
  }

  @override
  void initState() {
    super.initState();
    getComments();
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserProvider>(context);
    final User? user = userData.getUser;

    if (user == null) {
      return const Center(child: SizedBox(),);
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return ProfileScreen(uid: widget.snap['uid']!);
                  },
                ),
              );
            },
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 13),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(widget.snap['profImg']!),
                    radius: 19,
                  ),
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Text(
                          widget.snap['username']!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Text(
                        widget.snap['name']!,
                        style: TextStyle(color: secondaryColor, fontSize: 16),
                      ),
                    ],
                  ),
                ),

                user.uid == widget.snap['uid']
                    ? Align(
                      child: IconButton(
                        alignment: Alignment.topRight,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder:
                                (context) =>
                                    DialogBox(postId: widget.snap['postid']),
                          );
                        },
                        icon: Icon(Icons.more_vert_outlined),
                      ),
                    )
                    : SizedBox(),
              ],
            ),
          ),
        ),

        GestureDetector(
          onDoubleTap: () async {
            await FirestoreMethods().likePost(
              widget.snap['postid'],
              user.uid,
              widget.snap['likes'],
            );
            setState(() {
              isAnimatingLike = true;
            });
          },

          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.50,
                width: double.infinity,
                child: Image.network(widget.snap['postUrl'], fit: BoxFit.cover),
              ),

              AnimatedOpacity(
                duration: Duration(milliseconds: 200), //opacity duration
                opacity: isAnimatingLike ? 1 : 0,
                child: LikeAnimation(
                  isAnimating: isAnimatingLike,
                  duration: const Duration(milliseconds: 400),
                  onEnd: () {
                    setState(() {
                      isAnimatingLike = false;
                    });
                  },
                  child: Icon(Icons.favorite, size: 120, color: Colors.white),
                ),
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
          child: Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.uid),
                smallLike: true,
                child: GestureDetector(
                  onTap: () async {
                    await FirestoreMethods().likePost(
                      widget.snap['postid'],
                      user.uid,
                      widget.snap['likes'],
                    );
                  },
                  child:
                      widget.snap['likes'].contains(user.uid)
                          ? Icon(
                            Icons.favorite_rounded,
                            color: Colors.red,
                            size: 28,
                          )
                          : Icon(Icons.favorite_border_rounded, size: 28),
                ),
              ),
              SizedBox(width: 4),

              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return UsersLiked(uid: widget.snap['postid']);
                    })
                  );
                },
                child: StreamBuilder(
                  stream:
                      FirebaseFirestore.instance
                          .collection('posts')
                          .doc(widget.snap['postid'])
                          .snapshots(),
                  builder: (
                    context,
                    AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                    snapshot,
                  ) {
                    if (!snapshot.hasData ||
                        snapshot.connectionState == ConnectionState.waiting) {
                      return Text(
                        '${widget.snap['likes'].length}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      );
                    }
                    final data = snapshot.data!.data();
                    final likesData = (data?['likes'] ?? []).length;
                
                    return Text(
                      likesData.toString(),
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    );
                  },
                ),
              ),

              // Text(
              //   '${widget.snap['likes'].length}',
              //   style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
              // ),
              SizedBox(width: 20),

              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return CommentScreen(snap: widget.snap);
                      },
                    ),
                  );
                },
                child: Icon(Icons.comment_outlined, size: 28),
              ),
              SizedBox(width: 4),

              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return CommentScreen(snap: widget.snap);
                      },
                    ),
                  );
                },
                child: StreamBuilder(
                  stream:
                      FirebaseFirestore.instance
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
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    );
                  },
                ),
              ),

              // Text(
              //   totalComments.toString(),
              //   style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
              // ),
              SizedBox(width: 13),

              IconButton(onPressed: () {}, icon: Icon(Icons.send, size: 28)),

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

        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.bottomLeft,
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: primaryColor),
              children: [
                TextSpan(
                  text: widget.snap['username'],
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
                TextSpan(
                  text: ' ${widget.snap['description']}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),

        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          alignment: Alignment.bottomLeft,
          child: Text(
            widget.snap['datePublished'],
            style: TextStyle(color: secondaryColor, fontSize: 15),
          ),
        ),
      ],
    );
  }
}
