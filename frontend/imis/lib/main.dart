import 'package:flutter/material.dart';
import 'package:imis/login/pages/login_main.dart';
import 'dart:io';

void main() {
  // Allow localhost (self-signed SSL)
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IMIS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginMain(),
    );
  }
}
