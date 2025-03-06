
import 'package:chat/controllers/WsController.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chat/main.dart';

class Loginsignincontrollers {
  static login(String usrname, String password, BuildContext context) async {
    try {
      final dio = Dio();
      print('${dotenv.env['BACKEND_URL']!}login');
      final response =
          await dio.post('https://chatapp-backend-gq65.onrender.com/login',
              data: {
                'username': usrname,
                'password': password,
              },
              options: Options(validateStatus: (_) => true));
      print({"data": response.data});
      if (response.statusCode == 401) {
        throw Exception('Invalid username or password');
      }
      if (response.statusCode == 200) {
        final token = response.data as String;
        if (token.isEmpty) {
          throw Exception('Token is empty');
        }
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('AUTH-TOKEN', token);
        await prefs.setString('username', usrname);
        username = usrname;
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

  static logout(BuildContext context) {
    SharedPreferences.getInstance().then((prefs) {
      prefs.clear();
      WsController.closeWebSocket();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully logged out.')),
      );
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.of(context).pushReplacementNamed('/login');
    });
  }
}
