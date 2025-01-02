import 'package:flutter/material.dart';
import 'package:resep_masak/views/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resep Makanan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.white,textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.white))),
      home: HomePage(),
    );
  }
}
