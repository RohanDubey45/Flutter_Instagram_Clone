import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:instagram_flutter/models/users.dart' as models;
import 'package:instagram_flutter/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<models.User> getUserDetails() async {

    String currUser = _auth.currentUser!.uid;
    DocumentSnapshot snap = await _firestore.collection('users').doc(currUser).get();

    return models.User.fromSnap(snap);
  }

  Future<String> signUpUser({
    required String name,
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "some error occured";
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          bio.isNotEmpty) {

        final usernameSnap = await _firestore.collection('users')
        .where('username', isEqualTo: username)
        .get();

        if(usernameSnap.docs.isNotEmpty) {
          res = "username already taken";
          return res;
        }

        // register user with email & password
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        debugPrint(cred.user!.uid);

        String photoUrl = await StorageMethods().uploadImage(
          file,
          cred.user!.uid,
        );

        models.User user = models.User(
          uid: cred.user!.uid, 
          email: email, 
          photoUrl: photoUrl, 
          name: name,
          followers: [], 
          following: [], 
          bio: bio, 
          username: username
        );

        // add the user to database
        await _firestore.collection('users').doc(cred.user!.uid).set(user.toJson());

        res = "success";
      } else {
        res = "All fields are required";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        res = 'This email is already in use.';
      } else if (e.code == 'weak-password') {
        res = 'The password is too weak.';
      } else if (e.code == 'invalid-email') {
        res = 'The email address is invalid.';
      } else {
        res = e.message ?? "An unknown error occurred.";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occured";
    try{
      if(email.trim().isNotEmpty && password.trim().isNotEmpty) {
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = "success";
      } else {
        res = "All fields are required";
      }
    } catch(err) {
      res = err.toString();
      debugPrint(res);
    }
    return res;
  }
}
