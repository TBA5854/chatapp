

import 'package:flutter/material.dart';

Widget chatAlert(BuildContext context) {
        String newUsername = 'johndoe';

        return AlertDialog(
          title: const Text('Enter Username'),
          content: TextField(
            onChanged: (value) {
              newUsername = value;
            },
            decoration: const InputDecoration(hintText: "Username"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                if (newUsername.isNotEmpty) {
                  Navigator.of(context).pop();
                  // print(newUsername);
                  Navigator.pushNamed(
                    context,
                    '/chat',
                    arguments: {
                      'username': newUsername,
                    },
                  );
                }
              },
            ),
          ],
        );
      }