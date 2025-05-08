import 'package:flutter/material.dart';
import 'package:imis/auth/pages/login_page.dart';
import 'package:imis/performance_governance_system/pages/pgs_print_page.dart';

import 'package:imis/utils/api_endpoint.dart';

void main() async {
  await ApiEndpoint.setBaseUrl();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: LoginPage());
  }
}
