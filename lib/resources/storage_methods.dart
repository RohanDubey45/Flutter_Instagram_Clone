import 'dart:typed_data';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';

class StorageMethods {
  final CloudinaryPublic cloudinary = CloudinaryPublic(
    'ddfm779fw',
    'flutter_uploads',
    cache: false,
  );

  Future<String> uploadImage(Uint8List file, String userId) async {
    try {
      CloudinaryResponse res = await cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(
          file,
          resourceType: CloudinaryResourceType.Image,
          identifier: 'profile-pics/$userId/profile',
          folder: 'profile-pics/$userId',
        ),
      );
      return res.secureUrl;
    } catch (e) {
      debugPrint("Cloudinary upload error: ${e.toString()}");
      rethrow;
    }
  }

  Future<String> uploadPost(
    Uint8List file,
    String userId,
    String postId,
  ) async {
    try {
      CloudinaryResponse res = await cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(
          file,
          resourceType: CloudinaryResourceType.Image,
          identifier: 'posts/$userId/$postId',
          folder: 'posts/$userId/$postId',
        ),
      );
      return res.secureUrl;
    } catch (e) {
      debugPrint("Cloudinary upload error (post): ${e.toString()}");
      rethrow;
    }
  }
}
