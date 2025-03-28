import 'package:flutter/material.dart';
import 'package:imis/user/login_page.dart';
import 'package:imis/utils/api_endpoint.dart';

void main() async {
  await ApiEndpoint.setBaseUrl();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
