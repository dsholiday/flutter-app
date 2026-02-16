import 'package:flutter/material.dart';
import 'package:travel_suite/screens/login/login_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Travel Suite App",
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
          centerTitle: true,
          backgroundColor: Color.fromRGBO(29, 78, 216, 1),
          iconTheme: IconThemeData(
            color: Colors.white,                // Back arrow / icons globally
          ),
        ),
        primarySwatch: Colors.blue,
        fontFamily: 'Arial',
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(29, 78, 216, 1),
          foregroundColor: Colors.white,          
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),          
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
      ),
    ),
      ),
      home: const LoginPage(),
    );
  }
}