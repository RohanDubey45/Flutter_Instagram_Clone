import 'package:flutter/material.dart';
import 'package:instagram_flutter/models/users.dart';
import 'package:instagram_flutter/providers/user_data_provider.dart';
import 'package:instagram_flutter/resources/firestore_methods.dart';
import 'package:instagram_flutter/screens/profile_screen.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/widgets/like_animation.dart';
import 'package:provider/provider.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({super.key, required this.snap});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserProvider>(context);
    final User user = userData.getUser!;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ProfileScreen(uid: widget.snap['uid']))
              );
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(widget.snap['profImg']),
              radius: 20,
            ),
          ),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ProfileScreen(uid: widget.snap['uid']))
                    );
                    },
                    child: Text(
                      widget.snap['username'],
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                    ),
                  ),
                ),

                SizedBox(height: 2),

                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 9),
                  child: Text(
                    widget.snap['comment'],
                    style: TextStyle(fontSize: 16),
                  ),
                ),

                SizedBox(height: 2),

                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    widget.snap['datePublished'],
                    style: TextStyle(color: secondaryColor, fontSize: 15),
                  ),
                ),
              ],
            ),
          ),

          Column(
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.uid),
                smallLike: true,
                child: IconButton(
                  onPressed: () async {
                    await FirestoreMethods().likeComment(
                      widget.snap['postId'],
                      user.uid,
                      widget.snap['commentId'],
                      widget.snap['likes']
                    );
                  }, 
                  icon: widget.snap['likes'].contains(user.uid) ? 
                    Icon(Icons.favorite_rounded, color: Colors.red,) :
                    Icon(Icons.favorite_border_rounded)
                ),
              ),
              Text(widget.snap['likes'].length.toString())
            ],
          ),
        ],
      ),
    );
  }
}
