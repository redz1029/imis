import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imis/auditor/pages/auditor_page.dart';
import 'package:imis/performance_governance_system/pages/performance_governance_system_page.dart';
import 'package:imis/auth/pages/home_page.dart';
import 'package:imis/performance_governance_system/key_result_area/pages/key_result_area_page.dart';
import 'package:imis/performance_governance_system/office/pages/office_page.dart';
import 'package:imis/performance_governance_system/pgs_period/pages/pgs_period_page.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/auth/pages/login_page.dart';
import 'package:imis/performance_governance_system/team/pages/team_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardNavigationPanel extends StatefulWidget {
  const DashboardNavigationPanel({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DashboardNavigationPanelState createState() =>
      _DashboardNavigationPanelState();
}

class _DashboardNavigationPanelState extends State<DashboardNavigationPanel> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey _menuKey = GlobalKey();
  bool _isLoading = false;
  String firstName = "User";
  List<String> roles = [];
  Widget _selectedScreen = HomePage();
  int _selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      firstName = prefs.getString('firstName') ?? "User";
      roles = prefs.getStringList('roles') ?? [];
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
      builder:
          (context) => AlertDialog(
            backgroundColor: mainBgColor,
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: primaryColor),
                ),
              ),
              TextButton(
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.clear();

                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false,
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
                borderRadius: BorderRadius.circular(12.0),
              ),
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
                        backgroundImage:
                            image != null
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
                            child: Icon(
                              Icons.edit,
                              color: Color.fromARGB(209, 116, 116, 116),
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  gap2,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [Text('Username')],
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
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  gap2,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [Text('Email')],
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
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  gap2,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [Text('Password')],
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
                        border: OutlineInputBorder(),
                      ),
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
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Text('Cancel', style: TextStyle(color: primaryColor)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: () {},
                  child: Text('Save', style: TextStyle(color: secondaryColor)),
                ),
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
                Image.asset('assets/CRMC.png', width: 100),
                Text(
                  'IMIS',
                  style: TextStyle(color: primaryTextColor, fontSize: 18),
                ),
              ],
            ),
          ),
          _buildListTile(
            Icons.dashboard,
            'Dashboard',
            0,
            () => _setScreen(HomePage(), 0),
          ),
          _buildListTile(
            Icons.file_copy,
            'Performance Governance System',
            1,
            () => _setScreen(PerformanceGovernanceSystemPage(), 1),
          ),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: lightGrey),
            child: ExpansionTile(
              leading: const Icon(Icons.settings, color: primaryTextColor),
              title: const Text(
                'Settings',
                style: TextStyle(color: primaryTextColor),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 40,
                  ), // Adjust margin here
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildListTile(
                        Icons.medical_information,
                        hideIcon: true,
                        'Key Result Area',
                        2,
                        () => _setScreen(KeyResultAreaPage(), 2),
                      ),
                      _buildListTile(
                        Icons.person,
                        hideIcon: true,
                        'Auditor',
                        3,
                        () => _setScreen(AuditorPage(), 3),
                      ),
                      _buildListTile(
                        Icons.date_range,
                        hideIcon: true,
                        'PGS Period',
                        4,
                        () => _setScreen(PgsPeriodPage(), 4),
                      ),
                      _buildListTile(
                        Icons.date_range,
                        hideIcon: true,
                        'Team',
                        5,
                        () => _setScreen(TeamPage(), 5),
                      ),
                      _buildListTile(
                        Icons.date_range,
                        hideIcon: true,
                        'Office',
                        6,
                        () => _setScreen(OfficePage(), 6),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          _buildListTile(Icons.folder, 'Reports', 7, () {}),
          _buildListTile(
            Icons.exit_to_app,
            'Logout',
            7,
            () => _logout(context),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(
    IconData icon,
    String title,
    int index,
    VoidCallback onTap, {
    bool hideIcon = false, // New optional parameter
  }) {
    return Container(
      color: _selectedIndex == index ? secondaryBgButton : Colors.transparent,
      child: ListTile(
        leading:
            hideIcon
                ? null
                : Icon(
                  // Conditionally hide icon
                  icon,
                  color:
                      _selectedIndex == index ? primaryColor : primaryTextColor,
                ),
        title: Text(
          title,
          style: TextStyle(
            // fontWeight: FontWeight.w600,
            color: _selectedIndex == index ? primaryColor : primaryTextColor,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  void _showProfileSetting(BuildContext context) {
    final RenderBox renderBox =
        _menuKey.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    showMenu(
      color: secondaryColor,
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
              Icon(Icons.person),
              SizedBox(width: 30),
              Text("Profile"),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: "change_password",
          child: Row(
            children: const [
              Icon(Icons.lock),
              SizedBox(width: 30),
              Text("Change Password"),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: "logout",
          child: Row(
            children: const [
              Icon(Icons.exit_to_app),
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
                        onTap: () => _showProfileSetting(context),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipOval(
                                child: Image.asset(
                                  'assets/profile1.jpg',
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [Text("Welcome, $firstName")],
                                  ),

                                  Text(
                                    roles.join(', '),
                                    style: TextStyle(fontSize: 12, color: grey),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 8),
                              Icon(Icons.expand_more, size: 32),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  drawer: isWideScreen ? null : Drawer(child: _buildSidebar()),
                  body:
                      _isLoading
                          ? Container(
                            color: mainBgColor,
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: primaryColor,
                              ),
                            ),
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
