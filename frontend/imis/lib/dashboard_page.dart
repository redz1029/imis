import 'dart:io';

import 'package:flutter/material.dart';
import 'package:imis/Settings/Auditor/auditor_list.dart';
import 'package:imis/Settings/pgs_period/pgs_period_page.dart';
import 'package:imis/change_password/pages/change_password_page.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/dashboard_main.dart';
import 'package:imis/login/pages/login_main.dart';
import 'package:imis/pgs/deliverable_list_page.dart';
import 'package:imis/settings/auditor/auditor_main_page.dart';
import 'package:imis/settings/key_result_area/key_result_area_list_page.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey _menuKey = GlobalKey();
  bool _isLoading = false;
  String _userName = "User";
  Widget _selectedScreen = DashboardMain();
  int _selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('UserName') ?? "User";
    });
  }

  void _setScreen(Widget screen, int index) {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _selectedScreen = screen;
        _selectedIndex = index;
        _isLoading = false;
      });
    });
  }

  void _logout(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: mainBgColor,
        title: const Text(
          'Logout',
        ),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: primaryColor),
              )),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginMain()),
              );
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  void _editProfile(BuildContext context) async {
    File? image;
    final picker = ImagePicker();

    Future<void> pickImage(Function setState) async {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          image = File(pickedFile.path);
        });
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: mainBgColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              title: Text('Edit Profile'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      // Profile Picture
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: grey,
                        backgroundImage: image != null
                            ? FileImage(image!) as ImageProvider
                            : AssetImage('lib/assets/profile1.jpg'),
                      ),

                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () async {
                            await pickImage(setState);
                          },
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.edit,
                                color: Color.fromARGB(209, 116, 116, 116),
                                size: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                  gap2,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Username'),
                    ],
                  ),
                  gap2,
                  SizedBox(
                    width: 350,
                    height: 60,
                    child: TextField(
                      decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          focusColor: primaryColor,
                          labelText: 'Username',
                          border: OutlineInputBorder()),
                    ),
                  ),
                  gap2,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Email'),
                    ],
                  ),
                  gap2,
                  SizedBox(
                    width: 350,
                    height: 60,
                    child: TextField(
                      decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          focusColor: primaryColor,
                          labelText: 'Email',
                          border: OutlineInputBorder()),
                    ),
                  ),
                  gap2,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Password'),
                    ],
                  ),
                  gap2,
                  SizedBox(
                    width: 350,
                    height: 60,
                    child: TextField(
                      decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          focusColor: primaryColor,
                          labelText: 'Password',
                          border: OutlineInputBorder()),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryBgButton,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4))),
                  child: Text('Cancel', style: TextStyle(color: primaryColor)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4))),
                  onPressed: () {},
                  child: Text(
                    'Save',
                    style: TextStyle(color: secondaryColor),
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 250,
      decoration: const BoxDecoration(color: secondaryColor),
      child: Column(
        children: [
          DrawerHeader(
            child: Column(
              children: [
                Image.asset('lib/assets/CRMC.png', width: 100),
                Text('IMIS',
                    style: TextStyle(color: primaryTextColor, fontSize: 18)),
              ],
            ),
          ),
          _buildListTile(Icons.dashboard, 'Dashboard', 0,
              () => _setScreen(DashboardMain(), 0)),
          _buildListTile(Icons.file_copy, 'Performance Governance System', 1,
              () => _setScreen(DeliverableListPage(), 1)),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: lightGrey),
            child: ExpansionTile(
              leading: const Icon(Icons.settings, color: primaryTextColor),
              title: const Text('Settings',
                  style: TextStyle(color: primaryTextColor)),
              children: [
                _buildListTile(Icons.medical_information, 'Key Result Area', 2,
                    () => _setScreen(KeyResultAreaListPage(), 2)),
                _buildListTile(Icons.person, 'Auditor', 3,
                    () => _setScreen(AuditorMainPage(), 3)),
                _buildListTile(Icons.date_range, 'PGS Period', 4,
                    () => _setScreen(PgsPeriodPage(), 4)),
              ],
            ),
          ),
          _buildListTile(Icons.folder, 'Reports', 5, () {}),
          _buildListTile(
            Icons.exit_to_app,
            'Logout',
            5,
            () => _logout(context),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(
      IconData icon, String title, int index, VoidCallback onTap) {
    return Container(
      color: _selectedIndex == index
          ? secondaryBgButton
          : Colors.transparent, // Background color
      child: ListTile(
        leading: Icon(icon,
            color: _selectedIndex == index ? primaryColor : primaryTextColor),
        title: Text(title,
            style: TextStyle(
                color:
                    _selectedIndex == index ? primaryColor : primaryTextColor)),
        onTap: onTap,
      ),
    );
  }

  void _showPopupMenu(BuildContext context) {
    final RenderBox renderBox =
        _menuKey.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx, // X position
        offset.dy + renderBox.size.height,
        offset.dx + renderBox.size.width,
        offset.dy + renderBox.size.height + 50,
      ),
      items: [
        PopupMenuItem<String>(
          value: "Profile",
          child: Row(
            children: const [
              Icon(
                Icons.person,
              ),
              SizedBox(width: 30),
              Text("Profile"),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: "change_password",
          child: Row(
            children: const [
              Icon(
                Icons.lock,
              ),
              SizedBox(width: 30),
              Text("Change Password"),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: "logout",
          child: Row(
            children: const [
              Icon(
                Icons.exit_to_app,
              ),
              SizedBox(width: 30),
              Text("Logout"),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value == "Profile") {
        _editProfile(context);
        // } else if (value == "change_password") {
        //   Navigator.of(context).pushReplacement(
        //     MaterialPageRoute(builder: (context) => const ChangePasswordPage()),
        //   );
      } else if (value == "logout") {
        _logout(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWideScreen = constraints.maxWidth > 800;

        return Scaffold(
          key: _scaffoldKey,
          body: Row(
            children: [
              if (isWideScreen) _buildSidebar(), // Sidebar stays separate
              Expanded(
                child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: secondaryColor,
                    actions: [
                      GestureDetector(
                        key: _menuKey,
                        onTap: () => _showPopupMenu(context),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              ClipOval(
                                child: Image.asset(
                                  'lib/assets/profile1.jpg',
                                  width: 24,
                                  height: 24,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Welcome, $_userName",
                              ),
                              const Icon(
                                Icons.expand_more,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  drawer: isWideScreen ? null : Drawer(child: _buildSidebar()),
                  body: _isLoading
                      ? Container(
                          color: mainBgColor,
                          child: const Center(
                              child: CircularProgressIndicator(
                            color: primaryColor,
                          )),
                        )
                      : _selectedScreen,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
