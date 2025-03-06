import 'package:flutter/material.dart';

class LoginSignup {
  static bool _isLogin = true;
  // bool get isLogin => _isLogin;
  static void togglePage(BuildContext context) {
    _isLogin = !_isLogin;
    if (_isLogin) {
      Navigator.of(context).popAndPushNamed('/login');
    } else {
      Navigator.of(context).popAndPushNamed('/signup');
    }
  }
}
