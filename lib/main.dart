// main.dart
import 'package:flutter/material.dart';
import 'landing_page.dart';
import 'home_page.dart';
import 'history_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sibisi App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Set landing page as the initial route
      initialRoute: '/',
      routes: {
        '/': (context) => LandingPage(),
        '/home': (context) => HomePage(),
        '/history': (context) => HistoryPage(),
      },
    );
  }
}