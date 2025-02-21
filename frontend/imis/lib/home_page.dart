import 'package:flutter/material.dart';
import 'package:imis/PGS/Deliverables_List.dart';
import 'package:imis/Settings/Auditor/Auditor_List.dart';
import 'package:imis/Settings/KRA/Kra_List.dart';
import 'package:imis/Settings/PGS%20Period/PGS_Period.dart';
import 'package:imis/login/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Integrated Management Information System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = false; // Track loading state
  Widget _selectedScreen = const Center(
    child: Text("Welcome to IMIS! Wilbur B. Pimentel"),
  );

  void _setScreen(Widget screen) {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _selectedScreen = screen;
        _isLoading = false;
      });
    });

    Navigator.pop(context); // Close drawer
  }

  void _logout(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Integrated Management Information System"),
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF1A67A3),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          color: Colors.white,
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF1A67A3),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 15,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'lib/assets/CRMC.png',
                          width: 105,
                          height: 105,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Cotabato Regional and Medical Center',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 1,
                    top: 1,
                    child: IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.file_copy, size: 20),
              title: const Text(
                'Performance Governance System',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w100),
              ),
              onTap: () {

                _setScreen((Deliverables_List()));

              },
            ),
            ExpansionTile(
              leading: const Icon(Icons.settings, size: 20),
              title: const Text(
                'Settings',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w100),
              ),
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18),
                  leading: const Icon(Icons.medical_information, size: 18),
                  title: const Text(
                    'Key Result Area',
                    style: TextStyle(fontSize: 14),
                  ),
                  onTap: () { //=> _setScreen(KRAListScreen()
                    _setScreen(KRAListScreen());
                  }, // Load with delay                 
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18),
                  leading: const Icon(Icons.house_rounded, size: 18),
                  title: const Text(
                    'Offices',
                    style: TextStyle(fontSize: 14),
                  ),
                  onTap: () {},
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18),
                  leading: const Icon(Icons.person_2_rounded, size: 18),
                  title: const Text(
                    'Auditor',
                    style: TextStyle(fontSize: 14),
                  ),
                  onTap: () {

                     _setScreen(AuditorListScreen());

                    
                  },
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18),
                  leading: const Icon(Icons.people_alt_rounded, size: 18),
                  title: const Text(
                    'Teams',
                    style: TextStyle(fontSize: 14),
                  ),
                  onTap: () {},
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18),
                  leading: const Icon(Icons.date_range, size: 18),
                  title: const Text(
                    'PGS Period',
                    style: TextStyle(fontSize: 14),
                  ),
                  onTap: () {

                     _setScreen(PGSPeriodScreen());
                  },
                ),
              ],
            ),
            ListTile(
              leading: const Icon(Icons.folder_rounded, size: 20),
              title: const Text(
                'Reports',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w100),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app, size: 20),
              title: const Text(
                'Logout',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w100),
              ),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _selectedScreen,
    );
  }
}

void main() {
  runApp(const MyApp());
}
