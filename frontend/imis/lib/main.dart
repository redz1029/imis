import 'package:flutter/material.dart';
import 'package:imis/user/pages/login_page.dart';

import 'package:imis/utils/api_endpoint.dart';

final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();
void main() async {
  await ApiEndpoint.setBaseUrl();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: snackbarKey,
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
