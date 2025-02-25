import 'package:flutter/material.dart';
import 'package:imis/PGS/Deliverables_List.dart';
import 'package:imis/Settings/Auditor/Auditor_List.dart';
import 'package:imis/Settings/KRA/Kra_List.dart';
import 'package:imis/Settings/PGS%20Period/PGS_Period.dart';
import 'package:imis/login/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

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

  bool _isLoading = false;
  String _userName = "User"; // Default username
  Widget _selectedScreen = const Center(
    child: Text("Welcome to IMIS!"),
  );

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  /// Load user's name from SharedPreferences
  Future<void> _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('UserName') ?? "User"; // Default if not found
    });
  }

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

    Navigator.pop(context);
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

  void _changePassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Change Password Clicked')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
  backgroundColor: const Color(0xFF1A67A3),
  foregroundColor: Colors.white,
  title: Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ensures spacing
  children: [
    Expanded(
      child: Center( // Centering the title
        child: Text(
          "Integrated Management Information System",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
        ),
      ),
    ),

    // Username & Dropdown stays on the right
    PopupMenuButton<String>(
      onSelected: (value) {
        if (value == "change_password") {
          _changePassword();
        } else if (value == "logout") {
          _logout(context);
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem<String>(
          value: "change_password",
          child: Row(
            children: [
              Icon(Icons.lock, color: Colors.black54),
              SizedBox(width: 10),
              Text("Change Password"),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: "logout",
          child: Row(
            children: [
              Icon(Icons.exit_to_app, color: Colors.black54),
              SizedBox(width: 10),
              Text("Logout"),
            ],
          ),
        ),
      ],
      child: Row(
        children: [
          Text(
            "Welcome, $_userName",
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
          const Icon(Icons.arrow_drop_down, color: Colors.white),
        ],
      ),
    ),
  ],
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
                _setScreen(Deliverables_List());
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
                  onTap: () {
                    _setScreen(KRAListScreen());
                  },
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
