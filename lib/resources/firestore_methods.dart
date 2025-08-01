import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagram_flutter/providers/user_data_provider.dart';
import 'package:instagram_flutter/resources/storage_methods.dart';
import 'package:instagram_flutter/utils/global_variables.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/posts.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost({
    required String uid,
    required String username,
    required String profImg,
    required String name,
    required String description,
    required Uint8List file,
  }) async {
    String res = "some error occurred";

    try {
      // 1. Generate a unique postId
      String postId = const Uuid().v4();

      // 2. Upload image to Cloudinary
      String postUrl = await StorageMethods().uploadPost(file, uid, postId);

      // 3. Create Post object
      Post post = Post(
        uid: uid,
        postid: postId,
        username: username,
        postUrl: postUrl,
        name: name,
        description: description,
        likes: [],
        datePublished: getFormattedIndianTime(),
        profImg: profImg,
      );

      // 4. Upload to Firestore
      await _firestore
          .collection('posts')
          // .doc(uid)
          // .collection('userPosts') // subcollection folder under each user
          .doc(postId)
          .set(post.toJson());

      res = "success";
      return res;
    } catch (e) {
      res = e.toString();
      debugPrint(e.toString());
      return res;
    }
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        // 1. User already liked the post → remove the like(the userId)
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        // 2. User has not liked the post → add the like(the userId)
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> commentPost(
    String postId,
    String uid,
    String profImg,
    String comment,
    String username,
  ) async {
    try {
      if (comment.isNotEmpty) {
        String commentId = const Uuid().v4();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
              'postId': postId,
              'username': username,
              'uid': uid,
              'comment': comment,
              'likes': [],
              'commentId': commentId,
              'profImg': profImg,
              'datePublished': getFormattedIndianTime(),
            });
      } else {
        debugPrint("comment cannot be empty");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> likeComment(
    String postId,
    String uid,
    String commentId,
    List likes,
  ) async {
    try {
      if (likes.contains(uid)) {
        // 1. User has already liked the post → remove the userId from the likes list
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
              'likes': FieldValue.arrayRemove([uid]),
            });
      } else {
        // 2. User has not liked the post → add the userId in the likes list
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
              'likes': FieldValue.arrayUnion([uid]),
            });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> followUnfollowUser(String uid, String followPersonsUid) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data() as dynamic)['following'];

      if (following.contains(followPersonsUid)) {
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followPersonsUid]),
        });
        await _firestore.collection('users').doc(followPersonsUid).update({
          'followers': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followPersonsUid]),
        });
        await _firestore.collection('users').doc(followPersonsUid).update({
          'followers': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> signOut(BuildContext context) async{
    await FirebaseAuth.instance.signOut();
    Provider.of<UserProvider>(context, listen: false).clearUser(); // 👈 clear old user
  }

  Future<void> deletePost(String postid) async {
    await _firestore.collection('posts').doc(postid).delete();
  }
}
