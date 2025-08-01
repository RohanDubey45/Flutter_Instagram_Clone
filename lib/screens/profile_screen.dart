import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/resources/firestore_methods.dart';
import 'package:instagram_flutter/screens/edit_screen.dart';
import 'package:instagram_flutter/screens/followers_screen.dart';
import 'package:instagram_flutter/screens/following_screen.dart';
import 'package:instagram_flutter/screens/login_screen.dart';
import 'package:instagram_flutter/screens/sign_up_screen.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:instagram_flutter/widgets/helper_button.dart';
import 'package:instagram_flutter/widgets/view_post.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;
  var user = {};
  int postLength = 0;
  bool isFollowing = false;

  Column buildStats(int num, String option) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          num.toString(),
          style: const TextStyle( fontSize: 17),
        ),
        Text(option, style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    try {
      var userSnap =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(widget.uid)
              .get();

      user = userSnap.data()!;

      QuerySnapshot snapPost =
          await FirebaseFirestore.instance
              .collection('posts')
              .where('uid', isEqualTo: widget.uid)
              .get();
      postLength = snapPost.docs.length;

      isFollowing = (userSnap.data()! as dynamic)['followers'].contains(
        FirebaseAuth.instance.currentUser!.uid,
      );

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      showSnackBar(e.toString(), context);
    }
  }

  followUnfollowUser() async {
    try {
      await FirestoreMethods().followUnfollowUser(
        FirebaseAuth.instance.currentUser!.uid,
        widget.uid,
      );

      if (!mounted) return;
      isFollowing
          ? showSnackBar('you unfollowed ${user['username']}', context)
          : showSnackBar('you started following ${user['username']}', context);

      setState(() {
        isFollowing = !isFollowing;
      });
    } catch (e) {
      debugPrint(e.toString());
      showSnackBar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    debugPrint("Profile UID: ${widget.uid}");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text(
          user['username'],
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        centerTitle: false,
        actions: [
          FirebaseAuth.instance.currentUser!.uid == widget.uid
              ? IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return SimpleDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        children: [
                          SimpleDialogOption(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              "New Account",
                              style: TextStyle(fontSize: 16),
                            ),
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return SignUp();
                                  },
                                ),
                              );
                            },
                          ),
                          SimpleDialogOption(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              "Sign Out",
                              style: TextStyle(fontSize: 16),
                            ),
                            onPressed: () async {
                              await FirestoreMethods().signOut(context);
                              Navigator.of(context).pop();
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return LoginScreen();
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: Icon(Icons.more_vert, color: primaryColor),
              )
              : SizedBox(),
        ],
      ),

      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18, top: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Picture and Bio
                Stack(
                  children: [
                    SizedBox(
                      width: 90, // fix width of left column
                      child: CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage(user['photoUrl']),
                        radius: 43,
                      ),
                    ),
                    Positioned(
                      bottom: -20,
                      left: 90,
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.add, color: Colors.white, size: 25),
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 22),

                // Right section: Name and Stats
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user['name'],
                        style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildStats(postLength, "posts"),
                          InkWell(
                            splashFactory: NoSplash.splashFactory,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return FollowersScreen(uid: widget.uid);
                                  },
                                ),
                              );
                            },
                            child: buildStats(
                              user['followers'].length,
                              "followers",
                            ),
                          ),
                          InkWell(
                            splashFactory: NoSplash.splashFactory,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return FollowingScreen(uid: widget.uid);
                                  },
                                ),
                              );
                            },
                            child: buildStats(
                              user['following'].length,
                              "following",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user['bio'], style: TextStyle(fontSize: 16)),

                FirebaseAuth.instance.currentUser!.uid ==
                        widget
                            .uid // viewing my own profile
                    ? HelperButton(
                      backgroundColor: mobileBackgroundColor,
                      borderColor: primaryColor,
                      text: "Edit Profile",
                      textColor: primaryColor,
                      function: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            return EditProfile();
                          })
                        );
                      },
                    )
                    : isFollowing // i am following other person show unfollow button
                    ? HelperButton(
                      backgroundColor: Colors.black,
                      borderColor: primaryColor,
                      text: "Unfollow",
                      textColor: Colors.white,
                      function: () async {
                        await await followUnfollowUser();
                        setState(() {
                          user['followers'].length--;
                        });
                      },
                    )
                    : HelperButton(
                      // i am not following other person show follow button
                      backgroundColor: Colors.blue,
                      borderColor: Colors.blue,
                      text: "Follow",
                      textColor: primaryColor,
                      function: () async {
                        await followUnfollowUser();
                        setState(() {
                          user['followers'].length++;
                        });
                      },
                    ),

                const SizedBox(height: 8),

                postLength == 0
                    ? Divider(color: Colors.transparent)
                    : Divider(color: Colors.white),

                const SizedBox(height: 2),

                FutureBuilder(
                  future:
                      FirebaseFirestore.instance
                          .collection('posts')
                          .where('uid', isEqualTo: widget.uid)
                          .get(),
                  builder: (
                    context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
                  ) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        childAspectRatio: 0.8,
                        mainAxisSpacing: 4,
                      ),
                      itemBuilder: (context, index) {
                        DocumentSnapshot snap = snapshot.data!.docs[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return ViewPost(snap: snap);
                                },
                              ),
                            );
                          },
                          child: Image(
                            image: NetworkImage(snap['postUrl']),
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
