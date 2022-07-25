import 'package:flutter/widgets.dart';
import 'package:instagramclone/models/user.dart';
import 'package:instagramclone/resources/auth_methods.dart';

import '../models/user.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final Authmethods _authMethods = Authmethods();

  User? get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
