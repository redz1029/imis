// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imis/announcements/pages/announcement_page.dart';
import 'package:imis/auditor/pages/auditor_page.dart';
import 'package:imis/auditor_offices/pages/auditor_offices_page.dart';
import 'package:imis/performance_governance_system/deliverable_status_monitoring/pages/deliverable_status_monitoring_page.dart';
import 'package:imis/performance_governance_system/pgs_signatory_template/pages/pgs_signatory_template_page.dart';
import 'package:imis/reports/pages/view_summary_narrative_report_page.dart';
import 'package:imis/roles/models/roles.dart';
import 'package:imis/swot/pages/swot_page.dart';
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
import 'package:imis/utils/permission_string.dart';
import 'package:imis/utils/auth_util.dart';
import 'package:imis/utils/navigation_screen_factory.dart';
import 'package:imis/utils/permission_service.dart';
import 'package:imis/widgets/circle_text_widget.dart';
import 'package:imis/widgets/permission_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationPanel extends StatefulWidget {
  final int? initialScreenIndex;
  const NavigationPanel({super.key, this.initialScreenIndex});
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
  String userId = "userId";
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
  List<String> roleIds = [];
  final dio = Dio();

  @override
  void initState() {
    super.initState();
    _initializeDashboard();
    if (widget.initialScreenIndex != null) {
      _selectedIndex = widget.initialScreenIndex!;
    }
  }

  Future<void> _loadUserName() async {
    UserRegistration? user = await AuthUtil.fetchLoggedUser();
    List<Roles>? roleList = await AuthUtil.fetchRoles();

    if (user != null) {
      setState(() {
        userId = user.id ?? 'userId';
        firstName = user.firstName ?? "firstName";
        middleName = user.middleName ?? "middleName";
        lastName = user.lastName ?? "lastName";
        email = user.email ?? "No email found";
        username = user.userName ?? "No username found";

        roles = roleList?.map((r) => r.name).toList() ?? [];
        roleIds = roleList?.map((r) => r.id).toList() ?? [];
      });
    }
  }

  Future<void> _checkSelectedRole() async {
    final prefs = await SharedPreferences.getInstance();
    final savedRole = prefs.getString('selectedRole');

    if (savedRole != null) {
      final roleIndex = roles.indexOf(savedRole);
      if (roleIndex != -1 && roleIndex < roleIds.length) {
        final selectedRoleId = roleIds[roleIndex];
        await loadUserPermissionss(userId: userId, roleId: selectedRoleId);
      }

      setState(() {
        selectedRole = savedRole;
        if (widget.initialScreenIndex != null) {
          _selectedIndex = widget.initialScreenIndex!;
          _selectedScreen = NavigationScreenFactory.getScreenByIndex(
            _selectedIndex,
            selectedRole!,
          );
        }
      });
    } else {
      await prefs.remove('selectedRole');
      if (roles.length >= 2) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showSwitchRole();
        });
      } else if (roles.isNotEmpty) {
        final singleRole = roles.first;
        await prefs.setString('selectedRole', singleRole);

        final roleIndex = roles.indexOf(singleRole);
        if (roleIndex != -1 && roleIndex < roleIds.length) {
          final selectedRoleId = roleIds[roleIndex];
          await loadUserPermissionss(userId: userId, roleId: selectedRoleId);
        }

        setState(() => selectedRole = singleRole);

        if (_selectedIndex != -1 && mounted) {
          _selectedScreen = NavigationScreenFactory.getScreenByIndex(
            _selectedIndex,
            selectedRole!,
          );
        }

        if (homePageKey.currentState != null) {
          await homePageKey.currentState!.refreshUserRoles();
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
    Future.delayed(const Duration(milliseconds: 300), () {
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
                            width: 0.5,
                          ),
                          minimumSize: const Size(double.infinity, 45),
                        ),
                        onPressed: () async {
                          Navigator.of(context).pop();

                          setState(() => _isSwitchingRole = true);

                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString('selectedRole', role);

                          final roleIndex = roles.indexOf(role);
                          final selectedRoleId = roleIds[roleIndex];
                          await loadUserPermissionss(
                            userId: userId,
                            roleId: selectedRoleId,
                          );

                          await Future.delayed(
                            Duration(milliseconds: 500),
                            () async {
                              setState(() {
                                selectedRole = role;
                                _isSwitchingRole = false;
                                _selectedIndex = 0;
                                _selectedScreen = HomePage();
                              });
                              await _checkSelectedRole();
                            },
                          );

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
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Switch Role"),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    color: primaryTextColor,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
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

                          final roleIndex = roles.indexOf(role);
                          final selectedRoleId = roleIds[roleIndex];
                          await loadUserPermissionss(
                            userId: userId,
                            roleId: selectedRoleId,
                          );

                          await Future.delayed(
                            Duration(milliseconds: 500),
                            () async {
                              setState(() {
                                selectedRole = role;
                                _isSwitchingRole = false;
                                _selectedIndex = 0;
                                _selectedScreen = HomePage();
                              });
                              await _checkSelectedRole();
                            },
                          );

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
                    children: [Text(username)],
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
                    Icons.dashboard_outlined,
                    'Dashboard',
                    0,
                    () => _setScreen(HomePage(), 0),
                  ),
                  PermissionWidget(
                    child:
                        (selectedRole == PermissionString.roleAdmin ||
                                selectedRole ==
                                    PermissionString.roleStandardUser ||
                                selectedRole == PermissionString.serviceHead ||
                                selectedRole == PermissionString.osm)
                            ? _buildListTile(
                              Icons.insert_drive_file_outlined,
                              selectedRole == PermissionString.roleAdmin
                                  ? 'Create/View Deliverables'
                                  : selectedRole ==
                                      PermissionString.roleStandardUser
                                  ? 'Create Deliverables'
                                  : 'View Deliverables',
                              2,
                              () => _setScreen(
                                PerformanceGovernanceSystemPage(),
                                2,
                              ),
                            )
                            : SizedBox.shrink(),
                  ),

                  PermissionWidget(
                    child:
                        (selectedRole == PermissionString.roleAdmin ||
                                selectedRole ==
                                    PermissionString.roleStandardUser ||
                                selectedRole == PermissionString.serviceHead ||
                                selectedRole == PermissionString.osm)
                            ? _buildListTile(
                              Icons.analytics_outlined,
                              selectedRole == PermissionString.roleAdmin
                                  ? 'Create/View SWOT'
                                  : selectedRole ==
                                      PermissionString.roleStandardUser
                                  ? 'Create SWOT'
                                  : 'View SWOT',
                              23,
                              () => _setScreen(SwotPage(), 23),
                            )
                            : SizedBox.shrink(),
                  ),

                  PermissionWidget(
                    child:
                        [
                              PermissionString.roleAdmin,
                              PermissionString.serviceHead,
                              PermissionString.mcc,
                              PermissionString.osm,
                              PermissionString.pgsAuditor,
                              PermissionString.pgsHead,
                              PermissionString.coreTeam,
                            ].contains(selectedRole)
                            ? _buildListTile(
                              Icons.credit_score_outlined,
                              'Deliverable Status Monitoring',
                              20,
                              () => _setScreen(
                                DeliverableStatusMonitoringPage(),
                                20,
                              ),
                            )
                            : SizedBox.shrink(),
                  ),

                  PermissionWidget(
                    child:
                        [
                              PermissionString.headAuditor,
                              PermissionString.roleAdmin,
                            ].contains(selectedRole)
                            ? _buildListTile(
                              Icons.folder_outlined,
                              'Report',
                              hideIcon: false,
                              17,
                              () => _setScreen(
                                ViewSummaryNarrativeReportPage(),
                                17,
                              ),
                            )
                            : SizedBox.shrink(),
                  ),
                  PermissionWidget(
                    child:
                        [
                              PermissionString.serviceHead,
                              PermissionString.coreTeam,
                              PermissionString.pgsAuditor,
                            ].contains(selectedRole)
                            ? _buildListTile(
                              Icons.folder_outlined,
                              'Report',
                              hideIcon: false,
                              21,
                              () => _setScreen(
                                ViewSummaryNarrativeReportPage(),
                                21,
                              ),
                            )
                            : SizedBox.shrink(),
                  ),
                  PermissionWidget(
                    child:
                        (selectedRole == PermissionString.roleAdmin)
                            ? Theme(
                              data: Theme.of(
                                context,
                              ).copyWith(dividerColor: lightGrey),
                              child: ExpansionTile(
                                leading: const Icon(
                                  Icons.settings_outlined,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildListTile(
                                          Icons.date_range,
                                          hideIcon: true,
                                          'Announcement',
                                          22,
                                          () => _setScreen(
                                            AnnouncementPage(),
                                            22,
                                          ),
                                        ),
                                        _buildListTile(
                                          Icons.date_range,
                                          hideIcon: true,
                                          'Audit Schedules',
                                          4,
                                          () => _setScreen(
                                            AuditSchedulesPage(),
                                            4,
                                          ),
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
                                          'Auditor Offices',
                                          19,
                                          () => _setScreen(
                                            AuditorOfficesPage(),
                                            19,
                                          ),
                                        ),
                                        _buildListTile(
                                          Icons.date_range,
                                          hideIcon: true,
                                          'Auditor Team',
                                          6,
                                          () =>
                                              _setScreen(AuditorTeamPage(), 6),
                                        ),
                                        _buildListTile(
                                          Icons.date_range,
                                          hideIcon: true,
                                          'Key Result Area',
                                          7,
                                          () => _setScreen(
                                            KeyResultAreaPage(),
                                            7,
                                          ),
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
                                          () =>
                                              _setScreen(UserProfilePage(), 14),
                                        ),
                                        _buildListTile(
                                          Icons.date_range,
                                          hideIcon: true,
                                          'User Office',
                                          15,
                                          () =>
                                              _setScreen(UserOfficePage(), 15),
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
                            )
                            : SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
          _buildListTile(
            Icons.exit_to_app_outlined,
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
              Icon(Icons.person_outline),
              SizedBox(width: 30),
              Text("Profile"),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: "Switch Role",
          child: Row(
            children: const [
              Icon(Icons.switch_account_outlined),
              SizedBox(width: 30),
              Text("Switch Role"),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: "change_password",
          child: Row(
            children: const [
              Icon(Icons.lock_clock_outlined),
              SizedBox(width: 30),
              Text("Change Password"),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: "logout",
          child: Row(
            children: const [
              Icon(Icons.exit_to_app_outlined),
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
    // Get the screen index from arguments if provided
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is int && _selectedIndex != args) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _selectedIndex = args;
            _selectedScreen = NavigationScreenFactory.getScreenByIndex(
              _selectedIndex,
              selectedRole!,
            );
          });
        }
      });
    }

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
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
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
                                    SizedBox(width: 4),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              firstName
                                                  .toLowerCase()
                                                  .split(' ')
                                                  .map(
                                                    (word) =>
                                                        word.isNotEmpty
                                                            ? word[0]
                                                                    .toUpperCase() +
                                                                word.substring(
                                                                  1,
                                                                )
                                                            : '',
                                                  )
                                                  .join(' '),
                                            ),
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
                                    CircleTextWidget(
                                      text:
                                          "${firstName.isNotEmpty ? firstName[0] : "A"}${lastName.isNotEmpty ? lastName[0] : "B"}",
                                      color: primaryColor,
                                      size: 45,
                                    ),
                                  ],
                                ),
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
