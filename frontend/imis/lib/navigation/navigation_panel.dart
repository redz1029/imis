// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imis/auditor/pages/auditor_page.dart';
import 'package:imis/performance_governance_system/pgs_scrore_monitoring/pages/pgs_score_monitoring_page.dart';
import 'package:imis/performance_governance_system/pgs_signatory_template/pages/pgs_signatory_template_page.dart';
import 'package:imis/reports/pages/pgs_report_page.dart';
import 'package:imis/dashboard/standard_user_dashboard.dart';
import 'package:imis/user/models/user_registration.dart';
import 'package:imis/user/pages/change_password_page.dart';
import 'package:imis/user/pages/user_office_page.dart';
import 'package:imis/user/pages/user_profile_page.dart';
import 'package:imis/audit_schedules/pages/audit_schedules_page.dart';
import 'package:imis/auditor_team/pages/auditor_team_page.dart';
import 'package:imis/performance_governance_system/pages/performance_governance_system_page.dart';
import 'package:imis/user/pages/home_page.dart';
import 'package:imis/performance_governance_system/key_result_area/pages/key_result_area_page.dart';
import 'package:imis/office/pages/office_page.dart';
import 'package:imis/performance_governance_system/pgs_period/pages/pgs_period_page.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/user/pages/login_page.dart';
import 'package:imis/roles/pages/roles_page.dart';
import 'package:imis/team/pages/team_page.dart';
import 'package:imis/user/pages/user_role_page.dart';
import 'package:imis/utils/app_permission.dart';
import 'package:imis/utils/auth_util.dart';
import 'package:imis/utils/permission_service.dart';
import 'package:imis/widgets/permission_widget.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationPanel extends StatefulWidget {
  const NavigationPanel({super.key});

  @override
  NavigationPanelState createState() => NavigationPanelState();
}

class NavigationPanelState extends State<NavigationPanel> {
  final GlobalKey _menuKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldMessengerState> snackbarKey =
      GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  bool _isLoading = false;
  String firstName = "firstName";
  String middleName = "middleName";
  String lastName = "lastName";
  String email = "email";
  String username = "userName";
  List<String> roles = [];
  Widget _selectedScreen = HomePage();
  int _selectedIndex = -1;
  String? selectedRole;
  bool _isSwitchingRole = false;

  final dio = Dio();

  @override
  void initState() {
    super.initState();
    _initializeDashboard();
  }

  Future<void> _loadUserName() async {
    UserRegistration? user = await AuthUtil.fetchLoggedUser();
    List<String>? roleList = await AuthUtil.fetchRoles();
    if (user != null) {
      setState(() {
        firstName = user.firstName ?? "firstName";
        middleName = user.middleName ?? "middleName";
        lastName = user.lastName ?? "lastName";
        email = user.email ?? "No email found";
        username = user.userName ?? "No username found";
        roles = roleList ?? [];
      });
      if (roleList == null || roleList.isEmpty) {
        MotionToast.error(
          title: const Text("No Role Assigned"),
          description: const Text(
            "This user has no role assigned. Please contact the Administrator.",
          ),
          toastDuration: Duration(seconds: 10),
          toastAlignment: Alignment.topCenter,
        ).show(context);
      }
    }
  }

  Future<void> _checkSelectedRole() async {
    final prefs = await SharedPreferences.getInstance();
    final savedRole = prefs.getString('selectedRole');

    if (savedRole != null) {
      final permissions = RolePermissions.getPermissionsForRoles([savedRole]);
      PermissionService().loadPermissions(permissions);
      setState(() {
        selectedRole = savedRole;
      });
    } else {
      if (roles.length >= 2) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showSwitchRole();
        });
      } else {
        if (roles.isNotEmpty) {
          setState(() {
            selectedRole = roles.first;
          });
          final permissions = RolePermissions.getPermissionsForRoles([
            roles.first,
          ]);
          PermissionService().loadPermissions(permissions);
        }
      }
    }
  }

  Future<void> _initializeDashboard() async {
    await _loadUserName();
    await _checkSelectedRole();
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
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove('selectedRole');
                  await AuthUtil.logout(context);
                  if (!context.mounted) return;
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

  void _showSwitchRole() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.1),
      pageBuilder: (context, anim1, anim2) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Center(
            child: AlertDialog(
              backgroundColor: mainBgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text(
                "Welcome!",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Your account has multiple roles. Select one to continue.",
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  ...roles.map(
                    (role) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainBgColor,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0.1),
                          ),
                          side: const BorderSide(
                            color: primaryTextColor,
                            width: 0.5, // border thickness
                          ),
                          minimumSize: const Size(double.infinity, 45),
                        ),
                        onPressed: () async {
                          setState(() {
                            selectedRole = role;
                          });

                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString('selectedRole', role);
                          final permissions =
                              RolePermissions.getPermissionsForRoles([role]);
                          PermissionService().loadPermissions(permissions);

                          Navigator.of(context).pop();
                        },
                        child: Text(
                          role,
                          style: TextStyle(color: primaryTextColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showRoleSwitchDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.1),
      pageBuilder: (context, animation, secondaryAnimation) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Center(
            child: AlertDialog(
              backgroundColor: mainBgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text("Switch Role"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...roles.map(
                    (role) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainBgColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0.1),
                          ),
                          side: const BorderSide(
                            color: primaryTextColor,
                            width: 0.5,
                          ),
                          minimumSize: const Size(double.infinity, 45),
                        ),
                        onPressed: () async {
                          Navigator.of(context).pop();

                          setState(() => _isSwitchingRole = true);

                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString('selectedRole', role);
                          final permissions =
                              RolePermissions.getPermissionsForRoles([role]);
                          PermissionService().loadPermissions(permissions);

                          await Future.delayed(Duration(milliseconds: 500));

                          setState(() {
                            selectedRole = role;
                            _isSwitchingRole = false;
                          });
                          if (homePageKey.currentState != null) {
                            await homePageKey.currentState!.refreshUserRoles();
                          }
                        },
                        child: Text(
                          role,
                          style: TextStyle(color: primaryTextColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _viewProfile(BuildContext context) async {
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
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: mainBgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),

              title: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                  ),
                  SizedBox(height: 4, width: 400),
                  Text(
                    'My Profile',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),

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
                                : AssetImage('assets/iconprofile.png'),
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
                  gap16px,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$firstName $middleName $lastName',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  gap4px,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        // username != "username" ? username : "No username found",
                        username,
                      ),
                    ],
                  ),
                  gap4px,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text(email)],
                  ),
                  gap16px,
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    onPressed: () {
                      _editProfile(context);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.edit, color: Colors.white),
                        SizedBox(width: 5),
                        Text(
                          'Edit Profile',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
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

    TextEditingController fullnameController = TextEditingController(
      text: '$firstName $middleName $lastName',
    );
    TextEditingController usernameController = TextEditingController(
      text: username,
    );
    TextEditingController emailController = TextEditingController(text: email);
    showDialog(
      context: context,
      barrierDismissible: false,
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
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: grey,
                        backgroundImage:
                            image != null
                                ? FileImage(image!) as ImageProvider
                                : AssetImage('assets/iconprofile.jpg'),
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
                  gap4px,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [Text('Full name')],
                  ),
                  gap4px,
                  SizedBox(
                    width: 350,
                    height: 60,
                    child: TextField(
                      controller: fullnameController,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        focusColor: primaryColor,
                        labelText: 'Full name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  gap4px,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [Text('Username')],
                  ),
                  gap4px,
                  SizedBox(
                    width: 350,
                    height: 60,
                    child: TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        focusColor: primaryColor,
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  gap4px,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [Text('Email')],
                  ),
                  gap4px,
                  SizedBox(
                    width: 350,
                    height: 60,
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        focusColor: primaryColor,
                        labelText: "Email",
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
      key: const ValueKey('sidebar_container'),
      width: 250,
      color: secondaryColor,
      child: Column(
        children: [
          DrawerHeader(
            child: Column(
              children: [
                Image.asset('assets/CRMC.png', width: 100),
                Text(
                  'CPeMS',
                  style: TextStyle(color: primaryTextColor, fontSize: 18),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildListTile(
                    Icons.dashboard,
                    'Dashboard',
                    0,
                    () => _setScreen(StandardUserDashboard(), 0),
                  ),

                  PermissionWidget(
                    permission: AppPermission.viewPerformanceGovernanceSystem,
                    child: _buildListTile(
                      Icons.insert_drive_file,
                      'Create PGS Deliverables',
                      2,
                      () => _setScreen(PerformanceGovernanceSystemPage(), 2),
                    ),
                  ),

                  PermissionWidget(
                    permission: AppPermission.viewPgsDeliverableMonitor,
                    child: _buildListTile(
                      Icons.credit_score,
                      'Deliverable Status Monitoring',
                      3,
                      () => _setScreen(PgsScoreMonitoringPage(), 3),
                    ),
                  ),
                  PermissionWidget(
                    permission: AppPermission.editTeam,
                    child: Theme(
                      data: Theme.of(context).copyWith(dividerColor: lightGrey),
                      child: ExpansionTile(
                        leading: const Icon(
                          Icons.settings,
                          color: primaryTextColor,
                        ),
                        title: const Text(
                          'Settings',
                          style: TextStyle(color: primaryTextColor),
                        ),

                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 40),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildListTile(
                                  Icons.date_range,
                                  hideIcon: true,
                                  'Audit Schedules',
                                  4,
                                  () => _setScreen(AuditSchedulesPage(), 4),
                                ),
                                _buildListTile(
                                  Icons.date_range,
                                  hideIcon: true,
                                  'Auditor',
                                  5,
                                  () => _setScreen(AuditorPage(), 5),
                                ),
                                _buildListTile(
                                  Icons.date_range,
                                  hideIcon: true,
                                  'Auditor Team',
                                  6,
                                  () => _setScreen(AuditorTeamPage(), 6),
                                ),
                                _buildListTile(
                                  Icons.date_range,
                                  hideIcon: true,
                                  'Key Result Area',
                                  7,
                                  () => _setScreen(KeyResultAreaPage(), 7),
                                ),
                                _buildListTile(
                                  Icons.date_range,
                                  hideIcon: true,
                                  'Office',
                                  8,
                                  () => _setScreen(OfficePage(), 8),
                                ),

                                _buildListTile(
                                  Icons.date_range,
                                  hideIcon: true,
                                  'PGS Signatory',
                                  9,
                                  () => _setScreen(
                                    (PgsSignatoryTemplatePage()),
                                    9,
                                  ),
                                ),
                                _buildListTile(
                                  Icons.date_range,
                                  hideIcon: true,
                                  'Pgs Period',
                                  10,
                                  () => _setScreen(PgsPeriodPage(), 10),
                                ),
                                _buildListTile(
                                  Icons.date_range,
                                  hideIcon: true,
                                  'Role',
                                  12,
                                  () => _setScreen(RolesPage(), 12),
                                ),

                                _buildListTile(
                                  Icons.date_range,
                                  hideIcon: true,
                                  'Team',
                                  13,
                                  () => _setScreen(TeamPage(), 13),
                                ),

                                _buildListTile(
                                  Icons.medical_information,
                                  hideIcon: true,
                                  'User',
                                  14,
                                  () => _setScreen(UserProfilePage(), 14),
                                ),
                                _buildListTile(
                                  Icons.date_range,
                                  hideIcon: true,
                                  'User Office',
                                  15,
                                  () => _setScreen(UserOfficePage(), 15),
                                ),
                                _buildListTile(
                                  Icons.person,
                                  hideIcon: true,
                                  'User Role',
                                  16,
                                  () => _setScreen(UserRolePage(), 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  _buildListTile(
                    Icons.folder,
                    'Reports',
                    17,
                    () => _setScreen(PgsReportPage(), 17),
                  ),
                ],
              ),
            ),
          ),
          _buildListTile(
            Icons.exit_to_app,
            'Logout',
            18,
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
    bool hideIcon = false,
  }) {
    return Container(
      color: _selectedIndex == index ? secondaryBgButton : Colors.transparent,
      child: ListTile(
        leading:
            hideIcon
                ? null
                : Icon(
                  icon,
                  color:
                      _selectedIndex == index ? primaryColor : primaryTextColor,
                ),
        title: Text(
          title,
          style: TextStyle(
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
        offset.dx,
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
          value: "Switch Role",
          child: Row(
            children: const [
              Icon(Icons.switch_account),
              SizedBox(width: 30),
              Text("Switch Role"),
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
        if (!context.mounted) return;
        _viewProfile(context);
      } else if (value == "Switch Role") {
        _showRoleSwitchDialog(context);
      } else if (value == "change_password") {
        if (!context.mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ChangePasswordPage()),
        );
      } else if (value == "logout") {
        if (!context.mounted) return;
        _logout(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWideScreen = constraints.maxWidth > 800;
        return Stack(
          children: [
            Scaffold(
              key: _scaffoldKey,
              body: Row(
                children: [
                  if (isWideScreen) _buildSidebar(),
                  Expanded(
                    child: Scaffold(
                      appBar: AppBar(
                        backgroundColor: secondaryColor,
                        actions: [
                          GestureDetector(
                            key: _menuKey,
                            onTap: () => _showProfileSetting(context),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipOval(
                                    child: Image.asset(
                                      'assets/iconprofile.png',
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(firstName.split(' ')[0]),
                                        ],
                                      ),
                                      Text(
                                        selectedRole ?? 'No role selected',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: grey,
                                        ),
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
                      drawer:
                          isWideScreen ? null : Drawer(child: _buildSidebar()),
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
            ),
            if (_isSwitchingRole)
              Container(
                color: Colors.black.withValues(alpha: 0.5),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
