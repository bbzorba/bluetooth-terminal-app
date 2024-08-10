import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:yapilacaklar_listesi/home_page.dart'; // Replace with your home page file
import 'firebase_options.dart'; // Import Firebase options if needed

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(), // Replace with your home page widget
    );
  }
}
