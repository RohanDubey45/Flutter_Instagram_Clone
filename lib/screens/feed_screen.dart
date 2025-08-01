import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        actionsPadding: EdgeInsets.all(7),
        elevation: 0, // 👈 Prevents elevation shading
        scrolledUnderElevation: 0, // 👈
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: SvgPicture.asset(
          "assets/ic_instagram.svg",
          colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn),
          height: 32,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.messenger_sharp, size: 28),
          ),
        ],
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore
                  .instance
                  .collection('posts')
                  .orderBy('datePublished', descending: true)
                  .snapshots(), 
        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: primaryColor,),
            );
          }
          
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: PostCard(
                  snap: snapshot.data!.docs[index].data(),
                ),
              );
            }
          );
        },
      ),
    );
  }
}
