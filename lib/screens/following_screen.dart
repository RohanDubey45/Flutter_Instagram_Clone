import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/screens/profile_screen.dart';
import 'package:instagram_flutter/utils/colors.dart';

// ignore: must_be_immutable
class FollowingScreen extends StatefulWidget {
  String uid;
  FollowingScreen({super.key, required this.uid});

  @override
  State<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text("Followers"),
      ),

      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance
                .collection('users')
                .doc(widget.uid)
                .snapshots(),
        builder: (
          context,
          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot,
        ) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          List following = snapshot.data!['following'];

          if (following.isEmpty) {
            return Center(child: Text(
              "You don't have any following yet.",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500
              ),
            ));
          }

          return ListView.builder(
            itemCount: following.length,
            itemBuilder: (context, index) {
              String uid = following[index];

              return FutureBuilder(
                future:
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(uid)
                        .get(),
                builder: (
                  context,
                  AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                  userSnap,
                ) {
                  if (!userSnap.hasData) {
                    return const ListTile(title: Text('Loading...'));
                  }

                  var userData = userSnap.data!.data();
                  if (userData == null) return const SizedBox();

                  String photoUrl = userData['photoUrl'] ?? 'https://imgs.search.brave.com/jfANtCylfBObfthQ8KeWD2JVj6h_Wa4XjkQXQ3_sSEE/rs:fit:500:0:0:0/g:ce/aHR0cHM6Ly9pbWdz/LnNlYXJjaC5icmF2/ZS5jb20veFREcXpK/MUZkcXlZZGV5S1M0/dGpwc2ZxaGduc3dV/Vm53UVZQSURibHhs/cy9yczpmaXQ6NTAw/OjA6MDowL2c6Y2Uv/YUhSMGNITTZMeTkw/TkM1bS9kR05rYmk1/dVpYUXZhbkJuL0x6/QXpMek15THpVNUx6/WTEvTHpNMk1GOUdY/ek16TWpVNS9OalV6/TlY5c1FXUk1hR1ky/L1MzcGlWelpRVjFo/Q1YyVkovUmxSdmRs/UnBhVEZrY210aS9W/QzVxY0dj.jpeg';
                  String username = userData['username'] ?? 'Unknown User';

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return ProfileScreen(uid: userData['uid']);
                            }
                          )
                        );
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(photoUrl),
                          radius: 24,
                        ),
                        
                        title: Text(
                          username,
                          style: TextStyle(
                            fontSize: 17,
                            // fontWeight: FontWeight.w500
                          ),
                        ),
                    
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
