import 'package:flutter/material.dart';
import 'package:imis/user/pages/login_page.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/navigation_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiEndpoint.setBaseUrl();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
