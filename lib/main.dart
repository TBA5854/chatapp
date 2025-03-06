import 'package:chat/assets/theme.dart';
import 'package:chat/pages/SignUpPage.dart';
import 'package:chat/controllers/WsController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:chat/pages/HomePage.dart';
import 'package:chat/pages/LoginPage.dart';
import 'package:chat/pages/ChatPage.dart';
import 'package:chat/pages/ProfilePage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chat/models/chat.dart';

String username = "Guest";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "lib/assets/.env");
  final backendUrl = dotenv.env['BACKEND_URL'];
  if (backendUrl == null) {
    throw Exception('.env file is missing the BACKEND_URL variable');
  }
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  print(appDocumentDir.path);
  await Hive.initFlutter(appDocumentDir.path);
  Hive.registerAdapter(ChatAdapter());
  await Hive.openBox<Chat>('chatBox');
  final prefs = await SharedPreferences.getInstance();
  // prefs.setString("username", "alexjohnson");
  final String? authToken = prefs.getString('AUTH-TOKEN');
  String? name = prefs.getString('username');
  if (name != null) {
    username = name;
  }
  String initialRoute;
  if (authToken == null || authToken.isEmpty || username.isEmpty) {
    initialRoute = '/login';
  } else {
    initialRoute = '/home';
  }
  await WsController.connectWebSocket();
  runApp(ProviderScope(child: MyApp(initialRoute: initialRoute)));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    // Define fixed color schemes
    ColorScheme lightScheme = MaterialTheme.lightScheme();
    ColorScheme darkScheme = MaterialTheme.darkScheme();

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: lightScheme,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: darkScheme,
        useMaterial3: true,
      ),
      initialRoute: initialRoute,
      routes: {
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/profile': (context) => const ProfilePage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/chat') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => ChatPage(contactName: args["username"]),
          );
        }
        return null;
      },
    );
  }
}
