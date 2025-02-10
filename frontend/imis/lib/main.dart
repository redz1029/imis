import 'package:flutter/material.dart';
import 'package:imis/home_page.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IMIS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),     
      home: HomePage(),
    );
  }
}


