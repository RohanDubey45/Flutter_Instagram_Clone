import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String email;
  final String bio;
  final String name;
  final String username;
  final String photoUrl;
  final List followers;
  final List following;

  User({
    required this.uid,
    required this.email,
    required this.photoUrl,
    required this.name,
    required this.followers,
    required this.following,
    required this.bio,
    required this.username,
  });

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'username': username.trim(),
    'email': email.trim(),
    'bio': bio,
    'name': name.trim(),
    'followers': followers,
    'following': following,
    'photoUrl': photoUrl,
  };

  static User fromSnap(DocumentSnapshot snap) {
    final snapshot = snap.data() as Map<String, dynamic>;

    return User(
      uid: snapshot['uid'],
      email: snapshot['email'],
      photoUrl: snapshot['photoUrl'] ?? '',
      name: snapshot['name'],
      username: snapshot['username'],
      bio: snapshot['bio'],
      followers: snapshot['followers'],
      following: snapshot['following'],
    );
  }
}
