import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  static login(String username, String password, BuildContext context) async {
    try {
      final dio = Dio();
      print('${dotenv.env['BACKEND_URL']!}login');
      final response = await dio.post(
        'https://chatapp-backend-gq65.onrender.com/login',
        data: {
          'username': username,
          'password': password,
        },
        options: Options(validateStatus: (_) => true)
      );
      print({"data":response.data});
      if (response.statusCode==401) {
        throw Exception('Invalid username or password');
      }
      if (response.statusCode == 200) {
        final token = response.data as String;
        if (token.isEmpty) {
          throw Exception('Token is empty');
        }
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('X-Auth-Token', token);
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed. Please try again.')),
        );
      }
    } catch (e) {
      print(e);
      // Handle exceptions
      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

}