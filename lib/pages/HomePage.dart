import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {

      final prefs = SharedPreferences.getInstance().then((prefs) {
        final authToken = prefs.getString('X-Auth-Token');
        print('X-Auth-Token: $authToken');
      });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: const Placeholder(),
    );
  }
}