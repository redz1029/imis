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
  bool isDarkMode = false;

  void toggleTheme(bool value) {
    setState(() {
      isDarkMode = value;
    });
  }

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
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        textTheme: GoogleFonts.interTextTheme(
          ThemeData(brightness: Brightness.dark).textTheme,
        ),
        scaffoldBackgroundColor: Color(0xFF28282B),
        primaryColor: primaryColor,
        cardColor: const Color(0xff1E1E1E),
        hintColor: Colors.grey[400],
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: Sidebar(),
    );
  }
}
