import 'package:chat/pages/SignUpPage.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:chat/pages/HomePage.dart';
import 'package:chat/pages/LoginPage.dart';
import 'package:chat/pages/ChatPage.dart';
import 'package:chat/pages/ProfilePage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load .env file
  await dotenv.load(fileName: "lib/assets/.env");
  final backendUrl = dotenv.env['BACKEND_URL'];
  if (backendUrl == null) {
    throw Exception('.env file is missing the BACKEND_URL variable');
  }
  // Initialize Hive
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  print(appDocumentDir.path);
  await Hive.initFlutter(appDocumentDir.path);
  
  // Register Hive adapters here if needed
  // Hive.registerAdapter(YourModelAdapter());
  
  // Open your Hive boxes
  // await Hive.openBox('yourBoxName');
  
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightScheme;
        ColorScheme darkScheme;

        if (lightDynamic != null && darkDynamic != null) {
          lightScheme = lightDynamic;
          darkScheme = darkDynamic;
        } else {
            lightScheme = ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
            );
            darkScheme = ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
            );
        }

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
          initialRoute: '/login',
            routes: {
            '/home': (context) => const HomePage(),
            '/login': (context) => const LoginPage(),
            '/signup': (context) => const SignUpPage(),
            '/chat': (context) => const ChatPage(),
            '/profile': (context) => const ProfilePage(),
          },
        );
      },
    );
  }
}
