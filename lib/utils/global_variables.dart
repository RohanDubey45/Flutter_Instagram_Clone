import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/screens/feed_screen.dart';
import 'package:instagram_flutter/screens/post_screen.dart';
import 'package:instagram_flutter/screens/profile_screen.dart';
import 'package:instagram_flutter/screens/search_screen.dart';
import 'package:intl/intl.dart';

final webScreen = 600;

List<Widget> get homeScreen {
  return [
    FeedScreen(),
    SearchScreen(),
    PostScreen(),
    Center(child: Text("Favourite screen"),),
    ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid,),
  ];
}

String getFormattedIndianTime() {
  DateTime istTime = DateTime.now().toUtc().add(const Duration(hours: 5, minutes: 30));
  return DateFormat('d MMM y').format(istTime); 
}
