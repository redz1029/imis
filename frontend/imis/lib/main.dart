import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/navigation/sidebar.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiEndpoint.setBaseUrl();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "CPeMS",
      theme: ThemeData(
        brightness: Brightness.light,
        textTheme: GoogleFonts.interTextTheme(),
        scaffoldBackgroundColor: const Color(0xffEDEDED),
        primaryColor: primaryColor,
        cardColor: Colors.white,
        hintColor: Colors.grey,
      ),
      home: Sidebar(),
    );
  }
}
