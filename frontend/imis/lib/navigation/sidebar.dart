// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imis/announcements/pages/announcement_page.dart';
import 'package:imis/audit_schedules/pages/audit_schedules_page.dart';
import 'package:imis/auditor/pages/auditor_page.dart';
import 'package:imis/auditor_offices/pages/auditor_offices_page.dart';
import 'package:imis/auditor_team/pages/auditor_team_page.dart';
import 'package:imis/dashboard/standard_user_dashboard.dart';
import 'package:imis/dashboard/strategy_roadmap_page.dart';
import 'package:imis/office/pages/office_page.dart';
import 'package:imis/performance_governance_system/deliverable_status_monitoring/pages/deliverable_status_monitoring_page.dart';
import 'package:imis/performance_governance_system/pages/performance_governance_system_page.dart';
import 'package:imis/performance_governance_system/pgs_period/pages/pgs_period_page.dart';
import 'package:imis/performance_governance_system/pgs_signatory_template/pages/pgs_signatory_template_page.dart';
import 'package:imis/performance_governance_system/process_core_support/pages/process_core_support_page.dart';
import 'package:imis/reports/pages/view_summary_narrative_report_page.dart';
import 'package:imis/roadmap/kra_period_roadmap/pages/kra_period_roadmap_page.dart';
import 'package:imis/roadmap/pages/roadmap_page.dart';
import 'package:imis/roles/pages/roles_page.dart';
import 'package:imis/scorecard/pages/score_card_monitoring_page.dart';
import 'package:imis/scorecard/pages/score_card_report_page.dart';
import 'package:imis/swot/pages/swot_page.dart';
import 'package:imis/team/pages/team_page.dart';
import 'package:imis/user/pages/change_password_page.dart';
import 'package:imis/user/pages/login_page.dart';
import 'package:imis/user/pages/user_office_page.dart';
import 'package:imis/user/pages/user_profile_page.dart';
import 'package:imis/user/pages/user_role_page.dart';
import 'package:imis/user_guide/user_guide_page.dart';
import 'package:imis/utils/permission_string.dart';
import 'package:imis/widgets/permission_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constant/constant.dart';
import '../constant/role_info.dart';
import '../roles/models/roles.dart';
import '../user/models/user_registration.dart';
import '../user/pages/home_page.dart';
import '../utils/auth_util.dart';
import '../utils/permission_service.dart';
import '../widgets/circle_text_widget.dart';

class Sidebar extends StatefulWidget {
  // final bool isDarkMode;
  // final Function(bool) onThemeToggle;
  final int? initialScreenIndex;

  const Sidebar({
    super.key,
    // required this.isDarkMode,
    // required this.onThemeToggle,
    this.initialScreenIndex,
  });

  @override
  State<Sidebar> createState() => SidebarState();
}

class SidebarState extends State<Sidebar> {
  final GlobalKey _menuKey = GlobalKey();
  final GlobalKey<ScaffoldMessengerState> snackbarKey =
      GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  String userId = "userId";
  String firstName = "firstName";
  String middleName = "middleName";
  String lastName = "lastName";
  String email = "email";
  String username = "userName";
  List<String> roles = [];
  Widget selectedScreen = HomePage();
  String? selectedRole;
  bool isSwitchingRole = false;
  List<String> roleIds = [];
  final dio = Dio();
  int? _hoveredIndex;

  int selectedPage = 0;
  int selectedSubPage = 0;

  @override
  void initState() {
    super.initState();
    _initializeDashboard();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    final dio = Dio();
    final loggedUser = await AuthUtil.processTokenValidity(dio, context);

    if (!mounted) return;

    if (loggedUser == null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => LoginPage()),
        (route) => false,
      );
    }
  }

  int _firstPermittedSubPage(int page) {
    if (page == 0) return 0;
    if (page == 2) {
      // SWOT: only certain roles see index 0
      final allowedSwot = [
        PermissionString.roleAdmin,
        PermissionString.roleStandardUser,
        PermissionString.serviceHead,
        PermissionString.mcc,
        PermissionString.coreTeam,
        PermissionString.osm,
      ];
      return allowedSwot.contains(selectedRole) ? 0 : 0;
    }
    if (page == 4) return 0; // Settings always starts at 0

    if (page == 1) {
      // PGS — check each subpage in order and return the first one visible
      final role = selectedRole;

      // SubPage 0: Roadmaps
      final canSeeRoadmaps = [
        PermissionString.roleAdmin,
        PermissionString.roleStandardUser,
        PermissionString.mcc,
        PermissionString.osm,
        PermissionString.coreTeam,
        PermissionString.serviceHead,
        PermissionString.trainingOfficer,
        PermissionString.hrOfficer,
        PermissionString.serviceOfficer,
        PermissionString.financeOfficer,
        PermissionString.safetyOfficer,
        PermissionString.facilityOfficer,
        PermissionString.linkagesOfficer,
        PermissionString.informationOfficer,
        PermissionString.researchOfficer,
        PermissionString.pgsAuditor,
      ].contains(role);
      if (canSeeRoadmaps) return 0;

      // SubPage 1: Deliverables
      final canSeeDeliverables = [
        PermissionString.roleAdmin,
        PermissionString.roleStandardUser,
        PermissionString.serviceHead,
        PermissionString.mcc,
        PermissionString.coreTeam,
        PermissionString.osm,
      ].contains(role);
      if (canSeeDeliverables) return 1;

      final canseeSwot = [
        PermissionString.roleAdmin,
        PermissionString.roleStandardUser,
        PermissionString.serviceHead,
        PermissionString.mcc,
        PermissionString.coreTeam,
        PermissionString.osm,
      ].contains(role);
      if (canseeSwot) return 2;

      // SubPage 2: Deliverable Status Monitoring
      final canSeeMonitoring = [
        PermissionString.roleAdmin,
        PermissionString.serviceHead,
        PermissionString.mcc,
        PermissionString.osm,
        PermissionString.pgsAuditor,
        PermissionString.pgsHead,
        PermissionString.coreTeam,
      ].contains(role);
      if (canSeeMonitoring) return 3;

      // SubPage 3/4: Scorecard
      final canSeeScorecard = [
        PermissionString.roleAdmin,
        PermissionString.trainingOfficer,
        PermissionString.hrOfficer,
        PermissionString.serviceOfficer,
        PermissionString.financeOfficer,
        PermissionString.safetyOfficer,
        PermissionString.facilityOfficer,
        PermissionString.linkagesOfficer,
        PermissionString.informationOfficer,
        PermissionString.researchOfficer,
        PermissionString.coreTeam,
        PermissionString.mcc,
        PermissionString.osm,
        PermissionString.pgsAuditor,
      ].contains(role);
      if (canSeeScorecard) return 4;

      // SubPage 5: PGS Auditor Report
      final canSeeAuditorReport = [
        PermissionString.headAuditor,
        PermissionString.roleAdmin,
      ].contains(role);
      if (canSeeAuditorReport) return 5;
    }

    return 0;
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

  Future<void> _initializeDashboard() async {
    await _loadUserName();
    await _checkSelectedRole();
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
        // if (widget.initialScreenIndex != null) {
        //   _selectedIndex = widget.initialScreenIndex!;
        //   // selectedScreen = NavigationScreenFactory.getScreenByIndex(
        //   //   _selectedIndex,
        //   //   selectedRole!,
        //   // );
        // }
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

        // if (_selectedIndex != -1 && mounted) {
        //   selectedScreen = NavigationScreenFactory.getScreenByIndex(
        //     _selectedIndex,
        //     selectedRole!,
        //   );
        // }

        if (homePageKey.currentState != null) {
          await homePageKey.currentState!.refreshUserRoles();
        }
      }
    }
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
            child: StatefulBuilder(
              builder: (context, setDialogState) {
                return Dialog(
                  backgroundColor: Theme.of(context).cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    width: 500,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/CRMC.png',
                          width: 100,
                          height: 60,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: 14),
                        const Text(
                          "Welcome Back!",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 6),
                        const Text(
                          "You have access to multiple roles. Choose one to continue to your dashboard.",
                          style: TextStyle(fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24),
                        Flexible(
                          child: SingleChildScrollView(
                            child: Column(
                              children:
                                  roles.asMap().entries.map((entry) {
                                    final index = entry.key;
                                    final role = entry.value;
                                    final roleInfo = getRoleInfo(role);

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 6,
                                      ),
                                      child: MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        onEnter: (_) {
                                          setDialogState(
                                            () => _hoveredIndex = index,
                                          );
                                        },
                                        onExit: (_) {
                                          setDialogState(
                                            () => _hoveredIndex = null,
                                          );
                                        },
                                        child: GestureDetector(
                                          onTap: () async {
                                            Navigator.of(context).pop();
                                            setDialogState(
                                              () => isSwitchingRole = true,
                                            );

                                            final prefs =
                                                await SharedPreferences.getInstance();
                                            await prefs.setString(
                                              'selectedRole',
                                              role,
                                            );

                                            final roleIndex = roles.indexOf(
                                              role,
                                            );
                                            final selectedRoleId =
                                                roleIds[roleIndex];

                                            await loadUserPermissionss(
                                              userId: userId,
                                              roleId: selectedRoleId,
                                            );

                                            await Future.delayed(
                                              const Duration(milliseconds: 500),
                                              () {
                                                setState(() {
                                                  selectedRole = role;
                                                  isSwitchingRole = false;
                                                  selectedSubPage =
                                                      _firstPermittedSubPage(0);
                                                  selectedPage = 0;
                                                  selectedScreen = HomePage();
                                                });
                                              },
                                            );

                                            if (homePageKey.currentState !=
                                                null) {
                                              await homePageKey.currentState!
                                                  .refreshUserRoles();
                                            }
                                          },
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                              milliseconds: 200,
                                            ),
                                            decoration: BoxDecoration(
                                              color: roleInfo.backgroundColor,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color:
                                                    _hoveredIndex == index
                                                        ? roleInfo.iconColor
                                                        : roleInfo.borderColor,
                                                width:
                                                    _hoveredIndex == index
                                                        ? 2
                                                        : 1,
                                              ),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                              horizontal: 16,
                                            ),
                                            child: Row(
                                              children: [
                                                RoleIconBox(
                                                  roleInfo: roleInfo,
                                                  size: 48,
                                                  opacity: 0.08,
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        role,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                          color:
                                                              roleInfo
                                                                  .textColor,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 2),
                                                      Text(
                                                        roleInfo.description,
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.black87,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.arrow_forward_ios,
                                                  size: 16,
                                                  color:
                                                      _hoveredIndex == index
                                                          ? roleInfo.iconColor
                                                          : roleInfo.textColor,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        const Text(
                          "Need help? Contact your system administrator.",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
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

  void _showRoleSwitchDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.1),
      pageBuilder: (context, anim1, anim2) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Center(
            child: StatefulBuilder(
              builder: (context, setDialogState) {
                return Dialog(
                  backgroundColor: mainBgColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        width: 500,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/CRMC.png',
                              width: 100,
                              height: 60,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(height: 14),
                            const Text(
                              "Switch Role",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 6),
                            const Text(
                              "You have access to multiple roles. Choose one to continue to your dashboard.",
                              style: TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 24),
                            Flexible(
                              child: SingleChildScrollView(
                                child: Column(
                                  children:
                                      roles.asMap().entries.map((entry) {
                                        final index = entry.key;
                                        final role = entry.value;
                                        final roleInfo = getRoleInfo(role);

                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 6,
                                          ),
                                          child: MouseRegion(
                                            cursor: SystemMouseCursors.click,
                                            onEnter: (_) {
                                              setDialogState(
                                                () => _hoveredIndex = index,
                                              );
                                            },
                                            onExit: (_) {
                                              setDialogState(
                                                () => _hoveredIndex = null,
                                              );
                                            },
                                            child: GestureDetector(
                                              onTap: () async {
                                                Navigator.of(context).pop();
                                                setDialogState(
                                                  () => isSwitchingRole = true,
                                                );

                                                final prefs =
                                                    await SharedPreferences.getInstance();
                                                await prefs.setString(
                                                  'selectedRole',
                                                  role,
                                                );

                                                final roleIndex = roles.indexOf(
                                                  role,
                                                );
                                                final selectedRoleId =
                                                    roleIds[roleIndex];

                                                await loadUserPermissionss(
                                                  userId: userId,
                                                  roleId: selectedRoleId,
                                                );

                                                await Future.delayed(
                                                  const Duration(
                                                    milliseconds: 500,
                                                  ),
                                                  () {
                                                    setState(() {
                                                      selectedRole = role;
                                                      isSwitchingRole = false;
                                                      selectedScreen =
                                                          HomePage();
                                                      selectedSubPage =
                                                          _firstPermittedSubPage(
                                                            0,
                                                          );
                                                      selectedPage = 0;
                                                    });
                                                  },
                                                );

                                                if (homePageKey.currentState !=
                                                    null) {
                                                  await homePageKey
                                                      .currentState!
                                                      .refreshUserRoles();
                                                }
                                              },
                                              child: AnimatedContainer(
                                                duration: const Duration(
                                                  milliseconds: 200,
                                                ),
                                                decoration: BoxDecoration(
                                                  color:
                                                      roleInfo.backgroundColor,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color:
                                                        _hoveredIndex == index
                                                            ? roleInfo.iconColor
                                                            : roleInfo
                                                                .borderColor,
                                                    width:
                                                        _hoveredIndex == index
                                                            ? 2
                                                            : 1,
                                                  ),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 16,
                                                    ),
                                                child: Row(
                                                  children: [
                                                    RoleIconBox(
                                                      roleInfo: roleInfo,
                                                      size: 48,
                                                      opacity: 0.08,
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            role,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                              color:
                                                                  roleInfo
                                                                      .textColor,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 2,
                                                          ),
                                                          Text(
                                                            roleInfo
                                                                .description,
                                                            style: const TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors
                                                                      .black87,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Icon(
                                                      Icons.arrow_forward_ios,
                                                      size: 16,
                                                      color:
                                                          _hoveredIndex == index
                                                              ? roleInfo
                                                                  .iconColor
                                                              : roleInfo
                                                                  .textColor,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            const Text(
                              "Need help? Contact your system administrator.",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 6,
                        right: 6,
                        child: IconButton(
                          icon: const Icon(Icons.close),
                          splashRadius: 20,
                          tooltip: "Close",
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
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

  Widget getCurrentPage() {
    if (selectedPage == 0) {
      if (selectedSubPage == 0) return HomePage();
      if (selectedSubPage == 1) return const StrategyRoadmapPage();
      // if (selectedSubPage == 2) return const UserGuidePage();
    }
    if (selectedPage == 1) {
      if (selectedSubPage == 0) return const RoadmapPage();
      if (selectedSubPage == 1) return const PerformanceGovernanceSystemPage();
      if (selectedSubPage == 2) return const SwotPage();
      if (selectedSubPage == 3) return const DeliverableStatusMonitoringPage();
      if (selectedSubPage == 4) return const ScoreCardMonitoringPage();
      if (selectedSubPage == 5) return const ScoreCardReportPage();
      if (selectedSubPage == 6) return const ViewSummaryNarrativeReportPage();
    }

    if (selectedPage == 3) {
      if (selectedSubPage == 0) return const AnnouncementPage();
      if (selectedSubPage == 1) return const AuditSchedulesPage();
      if (selectedSubPage == 2) return const AuditorPage();
      if (selectedSubPage == 3) return const AuditorOfficesPage();
      if (selectedSubPage == 4) return const AuditorTeamPage();
      if (selectedSubPage == 5) return const ProcessCoreSupportPage();
      if (selectedSubPage == 6) return const KraPeriodRoadmapPage();
      if (selectedSubPage == 7) return const OfficePage();
      if (selectedSubPage == 8) return const PgsSignatoryTemplatePage();
      if (selectedSubPage == 9) return const PgsPeriodPage();
      if (selectedSubPage == 10) return const RolesPage();
      if (selectedSubPage == 11) return const TeamPage();
      if (selectedSubPage == 12) return const UserProfilePage();
      if (selectedSubPage == 13) return const UserOfficePage();
      if (selectedSubPage == 14) return const UserRolePage();
    }
    return StandardUserDashboard();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool isMobile = width < 900;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: isMobile ? Drawer(child: mainSidebar()) : null,
      body: Row(
        children: [
          if (!isMobile)
            Container(
              width: 70,
              color: Theme.of(context).cardColor,
              child: Column(
                children: [
                  const SizedBox(height: 30),

                  // IconButton(
                  //   icon: Icon(
                  //     widget.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  //     color: Colors.grey[700],
                  //   ),
                  //   onPressed: () {
                  //     widget.onThemeToggle(!widget.isDarkMode);
                  //   },
                  // ),
                  const SizedBox(height: 40),
                  sidebarIcon(Icons.dashboard_outlined, 0, label: 'Dashboard'),
                  const SizedBox(height: 18),
                  Tooltip(
                    message: 'Performance Governance System (PGS)',
                    child: sidebarIcon(
                      Icons.timeline_outlined,
                      1,
                      label: 'PGS',
                    ),
                  ),
                  const SizedBox(height: 18),

                  sidebarIcon(Icons.fact_check_outlined, 2, label: 'ISO'),
                  const Spacer(),
                  PermissionWidget(
                    child:
                        (selectedRole == PermissionString.roleAdmin)
                            ? sidebarIcon(
                              Icons.settings_outlined,
                              3,
                              label: 'Settings',
                            )
                            : SizedBox.shrink(),
                  ),
                  const SizedBox(height: 18),

                  sidebarIcon(Icons.logout_outlined, 4, label: 'Logout'),
                  const SizedBox(height: 18),
                ],
              ),
            ),

          VerticalDivider(
            width: 1,
            thickness: 0.8,
            color: Colors.grey.shade200,
          ),
          if (!isMobile) SizedBox(width: 200, child: mainSidebar()),

          Expanded(
            child: Column(
              children: [
                Container(
                  color: Theme.of(context).cardColor,
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      if (isMobile)
                        Builder(
                          builder:
                              (context) => IconButton(
                                icon: const Icon(Icons.menu),
                                onPressed: () {
                                  Scaffold.of(context).openDrawer();
                                },
                              ),
                        ),

                      Text(
                        "CPeMS",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: primaryColor,
                        ),
                      ),

                      const Spacer(),

                      LayoutBuilder(
                        builder: (context, constraints) {
                          double maxWidth =
                              constraints.maxWidth *
                              0.4; // max width for text+avatar
                          return MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              key: _menuKey,
                              onTap: () => _showProfileSetting(context),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: maxWidth),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisSize: MainAxisSize.min,
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
                                                              word.substring(1)
                                                          : '',
                                                )
                                                .join(' '),
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
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
                                    ),
                                    const SizedBox(width: 8),
                                    CircleTextWidget(
                                      text:
                                          "${firstName.isNotEmpty ? firstName[0] : "A"}${lastName.isNotEmpty ? lastName[0] : "B"}",
                                      color: primaryColor,
                                      size: 45, // avatar stays readable
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                Expanded(child: getCurrentPage()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget sidebarHeader(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  void _logout(BuildContext context) async {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Theme.of(context).cardColor,

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
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
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

                child: Text(
                  'Logout',
                  style: TextStyle(color: Theme.of(context).cardColor),
                ),
              ),
            ],
          ),
    );
  }

  Widget sidebarIcon(IconData icon, int index, {double? size, String? label}) {
    bool isActive = selectedPage == index;

    return InkWell(
      onTap: () {
        if (index == 4) {
          _logout(context);
          return;
        }

        setState(() {
          selectedPage = index;
          // selectedSubPage = 0;
          selectedSubPage = _firstPermittedSubPage(index);
        });
      },
      borderRadius: BorderRadius.circular(30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  isActive
                      ? Theme.of(context).primaryColor
                      : Colors.transparent,
            ),
            child: Icon(
              icon,
              size: size ?? 24,
              color: isActive ? Colors.white : Colors.grey[700],
            ),
          ),

          if (label != null) ...[
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color:
                    isActive
                        ? primaryColor
                        : Theme.of(
                          context,
                        ).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget mainSidebar() {
    bool isMobile = MediaQuery.of(context).size.width < 900;

    return Container(
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.asset(
              'assets/CRMC.png',
              width: 80,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 16),
          if (isMobile) ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.start,
              children: [
                // IconButton(
                //   icon: Icon(
                //     widget.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                //     color: Colors.grey[700],
                //   ),
                //   onPressed: () {
                //     widget.onThemeToggle(!widget.isDarkMode);
                //   },
                // ),
                sidebarIcon(Icons.dashboard_outlined, 0, label: 'Dashboard'),
                Tooltip(
                  message: 'Performance Governance System',
                  child: sidebarIcon(Icons.timeline_outlined, 1, label: 'PGS'),
                ),

                sidebarIcon(Icons.fact_check_outlined, 2, label: 'ISO'),
                PermissionWidget(
                  child:
                      (selectedRole == PermissionString.roleAdmin)
                          ? sidebarIcon(
                            Icons.settings_outlined,
                            3,
                            label: 'Settings',
                          )
                          : SizedBox.shrink(),
                ),
                sidebarIcon(Icons.logout_outlined, 4, label: 'Logout'),
              ],
            ),
            const SizedBox(height: 16),
          ],
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (selectedPage == 0) ...[
                    sidebarSubText("Overview", 0),
                    sidebarSubText("Strategy Roadmap", 1),
                    // sidebarSubText("User Guide", 2),
                  ],
                  //PGS
                  if (selectedPage == 1) ...[
                    PermissionWidget(
                      child:
                          (selectedRole == PermissionString.roleAdmin ||
                                  selectedRole ==
                                      PermissionString.roleStandardUser ||
                                  selectedRole == PermissionString.mcc ||
                                  selectedRole == PermissionString.osm ||
                                  selectedRole == PermissionString.coreTeam ||
                                  selectedRole ==
                                      PermissionString.serviceHead ||
                                  selectedRole == PermissionString.pgsAuditor)
                              ? sidebarSubText(
                                selectedRole == PermissionString.roleAdmin
                                    ? 'Create/View Roadmaps'
                                    : 'View Roadmaps',
                                0,
                              )
                              : (selectedRole ==
                                      PermissionString.trainingOfficer ||
                                  selectedRole == PermissionString.hrOfficer ||
                                  selectedRole ==
                                      PermissionString.serviceOfficer ||
                                  selectedRole ==
                                      PermissionString.financeOfficer ||
                                  selectedRole ==
                                      PermissionString.safetyOfficer ||
                                  selectedRole ==
                                      PermissionString.facilityOfficer ||
                                  selectedRole ==
                                      PermissionString.linkagesOfficer ||
                                  selectedRole ==
                                      PermissionString.informationOfficer ||
                                  selectedRole ==
                                      PermissionString.researchOfficer)
                              ? sidebarSubText('Create Roadmaps', 0)
                              : const SizedBox.shrink(),
                    ),
                    PermissionWidget(
                      child:
                          (selectedRole == PermissionString.roleAdmin ||
                                  selectedRole ==
                                      PermissionString.roleStandardUser ||
                                  selectedRole ==
                                      PermissionString.serviceHead ||
                                  selectedRole == PermissionString.mcc ||
                                  selectedRole == PermissionString.coreTeam ||
                                  selectedRole == PermissionString.osm)
                              ? sidebarSubText(
                                selectedRole == PermissionString.roleAdmin
                                    ? 'Create/View Deliverables'
                                    : selectedRole ==
                                        PermissionString.roleStandardUser
                                    ? 'Create Deliverables'
                                    : 'View Deliverables',
                                1,
                              )
                              : SizedBox.shrink(),
                    ),
                    PermissionWidget(
                      child:
                          (selectedRole == PermissionString.roleAdmin ||
                                  selectedRole ==
                                      PermissionString.roleStandardUser ||
                                  selectedRole ==
                                      PermissionString.serviceHead ||
                                  selectedRole == PermissionString.mcc ||
                                  selectedRole == PermissionString.coreTeam ||
                                  selectedRole == PermissionString.osm)
                              ? sidebarSubText(
                                selectedRole == PermissionString.roleAdmin
                                    ? 'Create/View SWOT'
                                    : selectedRole ==
                                        PermissionString.roleStandardUser
                                    ? 'Create SWOT'
                                    : 'View SWOT',
                                2,
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
                              ? sidebarSubText(
                                'Deliverable Status Monitoring',
                                3,
                              )
                              : SizedBox.shrink(),
                    ),

                    PermissionWidget(
                      child:
                          [
                                PermissionString.roleAdmin,
                                PermissionString.trainingOfficer,
                                PermissionString.hrOfficer,
                                PermissionString.serviceOfficer,
                                PermissionString.financeOfficer,
                                PermissionString.safetyOfficer,
                                PermissionString.facilityOfficer,
                                PermissionString.linkagesOfficer,
                                PermissionString.informationOfficer,
                                PermissionString.researchOfficer,
                                PermissionString.coreTeam,
                                PermissionString.mcc,
                                PermissionString.osm,
                                PermissionString.pgsAuditor,
                              ].contains(selectedRole)
                              ? ExpandableSidebarItem(
                                title: "Scorecard",
                                items: [
                                  {"title": "Monitoring", "index": 4},
                                  {"title": "Reports", "index": 5},
                                ],
                                selectedSubPage: selectedSubPage,
                                onTap: (index) {
                                  setState(() {
                                    selectedSubPage = index;
                                  });
                                },
                              )
                              : SizedBox.shrink(),
                    ),
                    PermissionWidget(
                      child:
                          [
                                PermissionString.headAuditor,
                                PermissionString.roleAdmin,
                              ].contains(selectedRole)
                              ? sidebarSubText("PGS Auditor Report", 6)
                              : SizedBox.shrink(),
                    ),
                  ],

                  if (selectedPage == 3) ...[
                    sidebarSubText("Announcement", 0),
                    sidebarSubText("Audit Schedules", 1),
                    sidebarSubText("Auditor", 2),
                    sidebarSubText("Auditor Offices", 3),
                    sidebarSubText("Auditor Team", 4),
                    sidebarSubText("Process Core & Support", 5),
                    sidebarSubText("KRA Roadmap Period", 6),
                    sidebarSubText("Office", 7),
                    sidebarSubText("PGS Signatory", 8),
                    sidebarSubText("Pgs Period", 9),
                    sidebarSubText("Role", 10),
                    sidebarSubText("Team", 11),
                    sidebarSubText("User", 12),
                    sidebarSubText("User Office", 13),
                    sidebarSubText("User Role", 14),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget sidebarSubText(String text, int index) {
    bool isActive = selectedSubPage == index;

    return InkWell(
      onTap: () {
        setState(() {
          selectedSubPage = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),

        child: Text(
          text,
          style: TextStyle(
            fontSize: 15,
            color:
                isActive
                    ? primaryColor
                    : Theme.of(
                      context,
                    ).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
            fontWeight: isActive ? FontWeight.bold : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class SalesPage extends StatelessWidget {
  const SalesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Audit Plan Page", style: TextStyle(fontSize: 30)),
    );
  }
}

class GoalsPage extends StatelessWidget {
  const GoalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Audit Programme Page", style: TextStyle(fontSize: 30)),
    );
  }
}

class MonthlyTargetPage extends StatelessWidget {
  const MonthlyTargetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Checklist Page", style: TextStyle(fontSize: 30)),
    );
  }
}

class ExpandableSidebarItem extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> items;
  final int selectedSubPage;
  final Function(int) onTap;

  const ExpandableSidebarItem({
    super.key,
    required this.title,
    required this.items,
    required this.selectedSubPage,
    required this.onTap,
  });

  @override
  State<ExpandableSidebarItem> createState() => _ExpandableSidebarItemState();
}

class _ExpandableSidebarItemState extends State<ExpandableSidebarItem> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final TextStyle normalStyle = TextStyle(
      fontSize: 15,
      color: Theme.of(
        context,
      ).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
      fontWeight: FontWeight.w400,
    );
    final TextStyle activeStyle = TextStyle(
      fontSize: 15,
      color: primaryColor,
      fontWeight: FontWeight.bold,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Main item
        InkWell(
          onTap: () {
            setState(() {
              expanded = !expanded;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Icon(
                  expanded
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_right,
                  size: 18,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
                const SizedBox(width: 4),
                Text(widget.title, style: normalStyle),
              ],
            ),
          ),
        ),

        /// Sub-items
        if (expanded)
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              children:
                  widget.items.map((item) {
                    bool isActive = widget.selectedSubPage == item["index"];
                    // last item

                    return InkWell(
                      onTap: () => widget.onTap(item["index"]),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Tree line
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Text(
                                item["title"],
                                style: isActive ? activeStyle : normalStyle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
            ),
          ),
      ],
    );
  }
}
