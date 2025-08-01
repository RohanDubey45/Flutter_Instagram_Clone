import 'package:flutter/material.dart';
import 'package:instagram_flutter/models/users.dart';
import 'package:instagram_flutter/resources/authentication_methods.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User? get getUser => _user;

  Future<void> refreshUserData() async{
    User user = await AuthMethods().getUserDetails();
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}