import 'package:chat/controllers/LoginSigninControllers.dart';
import 'package:chat/main.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
        backgroundColor: theme.primaryContainer,
        foregroundColor: theme.onPrimaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: theme.onPrimary,
                child:  Text(
                  username[0].toUpperCase(),
                  style: TextStyle(fontSize: 40, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Name:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
             Text(
              username,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Loginsignincontrollers.logout(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryContainer,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
