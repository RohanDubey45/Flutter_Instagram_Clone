import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String uid;
  final String postid;
  final String username;
  final String postUrl;
  final String name;
  final String description;
  final String profImg;
  final String datePublished;
  final List likes;

  Post({
    required this.uid,
    required this.postid,
    required this.username,
    required this.name,
    required this.postUrl,
    required this.description,
    required this.likes,
    required this.datePublished,
    required this.profImg,
  });

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'postid': postid,
    'username': username,
    'postUrl': postUrl,
    'name': name,
    'description': description,
    'likes': likes,
    'datePublished': datePublished,
    'profImg': profImg
  };

  static Post fromSnap(DocumentSnapshot snap) {
    final snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      uid: snapshot['uid'], 
      postid: snapshot['postid'],
      name: snapshot['name'],
      username: snapshot['username'],
      postUrl: snapshot['postUrl'],
      description: snapshot['description'],
      likes: snapshot['likes'],
      datePublished: snapshot['datePublished'],
      profImg: snapshot['profImg']
    );
  }
}
