// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imis/announcements/models/announcement.dart';
import 'package:imis/announcements/pages/announcement_page.dart';
import 'package:imis/announcements/services/announcement_service.dart';
import 'package:imis/auditor/pages/auditor_page.dart';
import 'package:imis/auditor_offices/pages/auditor_offices_page.dart';
import 'package:imis/auditor_team/pages/auditor_team_page.dart';
import 'package:imis/dashboard/summary_offices_deliverables.dart';
import 'package:imis/dashboard/monthly_opr_report_page.dart';
import 'package:imis/dashboard/strategic_change_agenda.dart';
import 'package:imis/dashboard/strategy_roadmap_page.dart';
import 'package:imis/dashboard/summary_validated_deliverables_page.dart';
import 'package:imis/performance_governance_system/pgs_evaluator_offices/pages/evaluator_offices_page.dart';
import 'package:imis/office/pages/office_page.dart';
import 'package:imis/performance_governance_system/pgs_operation_review_protocol/pages/operation_review_protocol_page.dart';
import 'package:imis/osm_calendar_activity/pages/osm_calendar_actvity_page.dart';
import 'package:imis/performance_governance_system/deliverable_status_monitoring/pages/deliverable_status_monitoring_page.dart';
import 'package:imis/performance_governance_system/pages/performance_governance_system_page..dart';
import 'package:imis/performance_governance_system/pgs_period/pages/pgs_period_page.dart';
import 'package:imis/performance_governance_system/pgs_reports/pages/view_summary_narrative_report_page.dart';
import 'package:imis/performance_governance_system/pgs_servicehead_office/pages/service_head_office_page.dart';
import 'package:imis/performance_governance_system/pgs_signatory_template/pages/pgs_signatory_template_page.dart';
import 'package:imis/performance_governance_system/pgs_strategic_change_agenda/pages/stra_agenda.dart';
import 'package:imis/performance_governance_system/process_core_support/pages/process_core_support_page.dart';
import 'package:imis/performance_governance_system/pgs_performance_validation_tool/pages/performance_validation_page.dart';
import 'package:imis/performance_governance_system/performance_validation_tool_period/pages/performance_validation_tool_period_page.dart';
import 'package:imis/performance_governance_system/performance_validation_tool_signatory/pages/performance_validation_tool_signatory_page.dart';
import 'package:imis/performance_governance_system/pgs_roadmap/kra_period_roadmap/pages/kra_period_roadmap_page.dart';
import 'package:imis/performance_governance_system/pgs_roadmap/pages/roadmap_page.dart';
import 'package:imis/roles/pages/roles_page.dart';
import 'package:imis/performance_governance_system/pgs_scorecard/impact_strategic_goal_scorecard_period/pages/impact_strategic_goal_scorecard_period_page.dart';
import 'package:imis/performance_governance_system/pgs_scorecard/pages/impact_strategy_goal_scorecard_page.dart';
import 'package:imis/performance_governance_system/pgs_scorecard/pages/score_card_report_page.dart';
import 'package:imis/performance_governance_system/pgs_strategy_review_report/pages/strategy_review_report_page.dart';
import 'package:imis/performance_governance_system/pgs_strategy_review_report/strategy_review_period/pages/strategy_review_period_page.dart';
import 'package:imis/performance_governance_system/pgs_swot/pages/swot_analysis_page.dart';
import 'package:imis/performance_governance_system/pgs_swot/swot_analysis_strength_weakness/pages/swot_analysis_strength_weakness_page.dart';
import 'package:imis/performance_governance_system/pgs_swot/swot_opportunies_threats/pages/swot_analysis_opportunities_threats_page.dart';
import 'package:imis/team/pages/team_page.dart';
import 'package:imis/user/pages/change_password_page.dart';
import 'package:imis/user/pages/login_page.dart';
import 'package:imis/user/pages/user_office_page.dart';
import 'package:imis/user/pages/user_profile_page.dart';
import 'package:imis/user/pages/user_role_page.dart';
import 'package:imis/utils/permission_role_string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constant/constant.dart';
import '../constant/role_info.dart';
import '../roles/models/roles.dart';
import '../user/models/user_registration.dart';
import '../user/pages/home_page.dart';
import '../utils/auth_util.dart';
import '../utils/permission_service.dart';
import '../widgets/common/circle_text_widget.dart';

class _NavChild {
  final String title;
  final int? index;
  final List<String>? allowedRoles;
  final List<_NavChild> children;
  final String Function(String? role)? titleFor;
  const _NavChild(
    this.title,
    this.index, {
    this.allowedRoles,
    this.children = const [],
    this.titleFor,
  });

  String resolveTitle(String? role) => titleFor?.call(role) ?? title;
}

class _NavGroup {
  final IconData icon;
  final String label;
  final int pageIndex;
  final List<_NavChild> children;
  final List<String>? allowedRoles;
  const _NavGroup({
    required this.icon,
    required this.label,
    required this.pageIndex,
    this.children = const [],
    this.allowedRoles,
  });
}

class Sidebar extends StatefulWidget {
  final int? initialScreenIndex;

  const Sidebar({super.key, this.initialScreenIndex});

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
  final AnnouncementService _announcementService = AnnouncementService(Dio());
  final GlobalKey _notificationKey = GlobalKey();
  List<Announcement> _unreadAnnouncements = [];
  int selectedPage = 0;
  int selectedSubPage = 0;

  bool _isCollapsed = false;

  final Set<String> _expandedKeys = {'g0'};
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  static const double _kExpandedWidth = 268;
  static const double _kCollapsedWidth = 76;

  static const double _kActiveHighlightAlpha = 0.35;

  @override
  void initState() {
    super.initState();
    _initializeDashboard();
    _checkLoginStatus();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.trim());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
    if (page == 2) return 0; // ISO
    if (page == 4) return 0; // Settings always starts at 0

    if (page == 1) {
      final role = selectedRole;

      final canSeeRoadmaps = [
        PermissionRoleString.roleAdmin,
        PermissionRoleString.roleStandardUser,
        PermissionRoleString.mcc,
        PermissionRoleString.osm,
        PermissionRoleString.coreTeam,
        PermissionRoleString.serviceHead,
        PermissionRoleString.trainingOfficer,
        PermissionRoleString.hrOfficer,
        PermissionRoleString.serviceOfficer,
        PermissionRoleString.financeOfficer,
        PermissionRoleString.safetyOfficer,
        PermissionRoleString.facilityOfficer,
        PermissionRoleString.linkagesOfficer,
        PermissionRoleString.informationOfficer,
        PermissionRoleString.researchOfficer,
        PermissionRoleString.pgsAuditor,
        PermissionRoleString.headAuditor,
        PermissionRoleString.twg,
        PermissionRoleString.evaluator,
      ].contains(role);
      if (canSeeRoadmaps) return 0;

      final canSeeDeliverables = [
        PermissionRoleString.roleAdmin,
        PermissionRoleString.roleStandardUser,
        PermissionRoleString.serviceHead,
        PermissionRoleString.mcc,
        PermissionRoleString.coreTeam,
        PermissionRoleString.osm,
        PermissionRoleString.twg,
      ].contains(role);
      if (canSeeDeliverables) return 1;

      final canseeSwot = [
        PermissionRoleString.roleAdmin,
        PermissionRoleString.roleStandardUser,
        PermissionRoleString.serviceHead,
        PermissionRoleString.mcc,
        PermissionRoleString.coreTeam,
        PermissionRoleString.osm,
        PermissionRoleString.twg,
      ].contains(role);
      if (canseeSwot) return 2;

      final canSeeMonitoring = [
        PermissionRoleString.roleAdmin,
        PermissionRoleString.serviceHead,
        PermissionRoleString.mcc,
        PermissionRoleString.osm,
        PermissionRoleString.pgsAuditor,
        PermissionRoleString.pgsHead,
        PermissionRoleString.coreTeam,
        PermissionRoleString.twg,
        PermissionRoleString.headAuditor,
        PermissionRoleString.evaluator,
      ].contains(role);
      if (canSeeMonitoring) return 3;

      final canSeeScorecard = [
        PermissionRoleString.roleAdmin,
        PermissionRoleString.trainingOfficer,
        PermissionRoleString.hrOfficer,
        PermissionRoleString.serviceOfficer,
        PermissionRoleString.financeOfficer,
        PermissionRoleString.safetyOfficer,
        PermissionRoleString.facilityOfficer,
        PermissionRoleString.linkagesOfficer,
        PermissionRoleString.informationOfficer,
        PermissionRoleString.researchOfficer,
        PermissionRoleString.coreTeam,
        PermissionRoleString.mcc,
        PermissionRoleString.osm,
        PermissionRoleString.pgsAuditor,
        PermissionRoleString.headAuditor,
        PermissionRoleString.serviceHead,
        PermissionRoleString.twg,
        PermissionRoleString.evaluator,
      ].contains(role);
      if (canSeeScorecard) return 4;

      final canSeeAuditorReport = [
        PermissionRoleString.headAuditor,
        PermissionRoleString.roleAdmin,
        PermissionRoleString.twg,
      ].contains(role);
      if (canSeeAuditorReport) return 5;

      final canSeeOperationReviewProtocol = [
        PermissionRoleString.pgsAuditor,
        PermissionRoleString.roleAdmin,
        PermissionRoleString.twg,
        PermissionRoleString.evaluator,
      ].contains(role);
      if (canSeeOperationReviewProtocol) return 8;
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
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Center(
            child: StatefulBuilder(
              builder: (context, setDialogState) {
                return Dialog(
                  backgroundColor: Colors.white,
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
                        Text(
                          "Welcome Back!",
                          style: GoogleFonts.plusJakartaSans(
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

  Future<void> _loadUnreadAnnouncements() async {
    try {
      final unread = await _announcementService.getUnreadAnnouncements();
      if (!mounted) return;

      final notifiable = unread.where((a) => a.isRead == true).toList();

      setState(() => _unreadAnnouncements = notifiable);
    } catch (_) {}
  }

  void _showNotificationMenu(BuildContext context) {
    final RenderBox renderBox =
        _notificationKey.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    showMenu(
      color: Colors.white,
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx - 300,
        offset.dy + renderBox.size.height,
        offset.dx + renderBox.size.width,
        offset.dy + renderBox.size.height + 50,
      ),
      constraints: const BoxConstraints(maxWidth: 360),
      items: [
        PopupMenuItem<String>(
          enabled: false,
          padding: EdgeInsets.zero,
          child: StatefulBuilder(
            builder: (context, setMenuState) {
              return Container(
                width: 340,
                constraints: const BoxConstraints(maxHeight: 420),
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _unreadAnnouncements.isEmpty
                          ? 'Notifications'
                          : '${_unreadAnnouncements.length} New Notifications',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: kText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Divider(color: kBorder, height: 1),
                    const SizedBox(height: 4),
                    Flexible(
                      child:
                          _unreadAnnouncements.isEmpty
                              ? Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 24,
                                ),
                                child: Text(
                                  'No new notifications.',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    color: kMuted,
                                  ),
                                ),
                              )
                              : ListView.separated(
                                shrinkWrap: true,
                                itemCount: _unreadAnnouncements.length,
                                separatorBuilder:
                                    (_, __) =>
                                        Divider(color: kBorder, height: 1),
                                itemBuilder: (context, index) {
                                  final a = _unreadAnnouncements[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(top: 5),
                                          width: 8,
                                          height: 8,
                                          decoration: const BoxDecoration(
                                            color: primaryColor,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                a.title,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: kText,
                                                    ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                a.description,
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                      fontSize: 12,
                                                      color: kMuted,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    ).then((_) => _loadUnreadAnnouncements());
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
        showChangePasswordDialog(context);
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
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
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
                            Text(
                              "Switch Role",
                              style: GoogleFonts.plusJakartaSans(
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
      if (selectedSubPage == 1) return OsmCalendarActvityPage();
      if (selectedSubPage == 2) return StrategyRoadmapPage();
      if (selectedSubPage == 3) return const StrategicChangeAgenda();
    }
    if (selectedPage == 1) {
      if (selectedSubPage == 0) return const RoadmapPage();
      if (selectedSubPage == 1) return const PerformanceGovernanceSystemPage();
      if (selectedSubPage == 2) return const SwotAnalysisPage();
      if (selectedSubPage == 3) return const DeliverableStatusMonitoringPage();
      if (selectedSubPage == 4) return const StrategyReviewReportPage();
      if (selectedSubPage == 5) {
        return const ImpactStrategyGoalScorecardPage();
      }
      if (selectedSubPage == 6) return const ScoreCardReportPage();
      if (selectedSubPage == 7) return const OperationReviewProtocolPage();
      if (selectedSubPage == 8) return const PerformanceValidationPage();
      if (selectedSubPage == 9) return const ViewSummaryNarrativeReportPage();
      if (selectedSubPage == 10) {
        return const SummaryValidatedDeliverablesPage();
      }
      if (selectedSubPage == 11) return SummaryOfficesDeliverables();
      if (selectedSubPage == 12) return MonthlyOprReportPage();
      if (selectedSubPage == 13) return StrategicPositionPage();
    }

    // if (selectedPage == 2) {
    //   if (selectedSubPage == 0) return const AuditorPage();
    //   if (selectedSubPage == 1) return const AuditorOfficesPage();
    //   if (selectedSubPage == 2) return const AuditorTeamPage();
    //   if (selectedSubPage == 3) return const AnnouncementPage();
    // }

    if (selectedPage == 3) {
      if (selectedSubPage == 0) return const AnnouncementPage();
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
      if (selectedSubPage == 15) return const StrategyReviewPeriodPage();
      if (selectedSubPage == 16) {
        return const PerformanceValidationToolPeriodPage();
      }
      if (selectedSubPage == 17) {
        return const PerformanceValidationToolSignatoryPage();
      }
      if (selectedSubPage == 18) {
        return const ImpactStrategicGoalScorecardPeriodPage();
      }
      if (selectedSubPage == 19) {
        return const SwotAnalysisStrengthWeaknessPage();
      }
      if (selectedSubPage == 20) {
        return const SwotAnalysisOpportunitiesThreatsPage();
      }
      if (selectedSubPage == 21) {
        return const EvaluatorOfficesPage();
      }
      if (selectedSubPage == 22) {
        return const ServiceHeadOfficePage();
      }
    }
    return HomePage();
  }

  List<_NavGroup> _buildNavGroups() {
    const pgsRoles = [
      PermissionRoleString.roleAdmin,
      PermissionRoleString.roleStandardUser,
      PermissionRoleString.mcc,
      PermissionRoleString.osm,
      PermissionRoleString.coreTeam,
      PermissionRoleString.serviceHead,
      PermissionRoleString.trainingOfficer,
      PermissionRoleString.hrOfficer,
      PermissionRoleString.serviceOfficer,
      PermissionRoleString.financeOfficer,
      PermissionRoleString.safetyOfficer,
      PermissionRoleString.facilityOfficer,
      PermissionRoleString.linkagesOfficer,
      PermissionRoleString.informationOfficer,
      PermissionRoleString.researchOfficer,
      PermissionRoleString.pgsAuditor,
      PermissionRoleString.headAuditor,
      PermissionRoleString.twg,
      PermissionRoleString.msgc,
      PermissionRoleString.evaluator,
    ];

    const officerRoles = [
      PermissionRoleString.trainingOfficer,
      PermissionRoleString.hrOfficer,
      PermissionRoleString.serviceOfficer,
      PermissionRoleString.financeOfficer,
      PermissionRoleString.safetyOfficer,
      PermissionRoleString.facilityOfficer,
      PermissionRoleString.linkagesOfficer,
      PermissionRoleString.informationOfficer,
      PermissionRoleString.researchOfficer,
    ];

    return [
      _NavGroup(
        icon: Icons.dashboard_outlined,
        label: 'Dashboard',
        pageIndex: 0,
        children: const [
          _NavChild('Overview', 0),
          _NavChild('Calendar of Activities', 1),
          _NavChild('Strategy Map', 2),
          _NavChild('Strategic Change Agenda', 3),
        ],
      ),
      _NavGroup(
        icon: Icons.timeline_outlined,
        label: 'PGS',
        pageIndex: 1,
        children: [
          _NavChild(
            'Roadmaps',
            0,
            allowedRoles: pgsRoles,
            titleFor: (role) {
              if (role == PermissionRoleString.roleAdmin) {
                return 'Create/View Roadmaps';
              }
              if (officerRoles.contains(role)) return 'Create Roadmaps';
              return 'View Roadmaps';
            },
          ),
          _NavChild(
            'Deliverables',
            1,
            allowedRoles: [
              PermissionRoleString.roleAdmin,
              PermissionRoleString.roleStandardUser,
              PermissionRoleString.serviceHead,
              PermissionRoleString.mcc,
              PermissionRoleString.coreTeam,
              PermissionRoleString.osm,
              PermissionRoleString.twg,
            ],
            titleFor: (role) {
              if (role == PermissionRoleString.roleAdmin) {
                return 'Create/View Deliverables';
              }
              if (role == PermissionRoleString.roleStandardUser) {
                return 'Create Deliverables';
              }
              return 'View Deliverables';
            },
          ),
          _NavChild(
            'SWOT',
            2,
            allowedRoles: [
              PermissionRoleString.roleAdmin,
              PermissionRoleString.roleStandardUser,
              PermissionRoleString.serviceHead,
              PermissionRoleString.mcc,
              PermissionRoleString.coreTeam,
              PermissionRoleString.osm,
              PermissionRoleString.twg,
            ],
            titleFor: (role) {
              if (role == PermissionRoleString.roleAdmin ||
                  role == PermissionRoleString.serviceHead) {
                return 'Create/View SWOT';
              }
              if (role == PermissionRoleString.roleStandardUser) {
                return 'Create SWOT';
              }
              return 'View SWOT';
            },
          ),
          _NavChild(
            'Deliverable Status Monitoring',
            3,
            allowedRoles: [
              PermissionRoleString.roleAdmin,
              PermissionRoleString.serviceHead,
              PermissionRoleString.mcc,
              PermissionRoleString.osm,
              PermissionRoleString.pgsAuditor,
              PermissionRoleString.pgsHead,
              PermissionRoleString.coreTeam,
              PermissionRoleString.twg,
              PermissionRoleString.headAuditor,
              PermissionRoleString.msgc,
              PermissionRoleString.evaluator,
            ],
          ),
          _NavChild(
            'Strategy Review Report',
            4,
            allowedRoles: pgsRoles,
            titleFor: (role) {
              if (role == PermissionRoleString.roleAdmin) {
                return 'Create/View Strategy Review Report';
              }
              if (officerRoles.contains(role)) {
                return 'Create Strategy Review Report';
              }
              return 'View Strategy Review Report';
            },
          ),
          // ---- nested sub-group: Scorecard ----
          const _NavChild(
            'Scorecard',
            null,
            children: [
              _NavChild('Impact and Strategic Goal', 5),
              _NavChild('Core & Support Processes', 6),
            ],
          ),
          _NavChild(
            'Operation Review Protocol',
            7,
            allowedRoles: [
              PermissionRoleString.roleAdmin,
              PermissionRoleString.mcc,
              PermissionRoleString.osm,
              PermissionRoleString.coreTeam,
              PermissionRoleString.serviceHead,
              PermissionRoleString.pgsAuditor,
              PermissionRoleString.headAuditor,
              PermissionRoleString.twg,
              PermissionRoleString.evaluator,
            ],
            titleFor: (role) {
              if (role == PermissionRoleString.roleAdmin) {
                return 'Create/View Operation Review Protocol';
              }
              return 'View Operation Review Protocol';
            },
          ),
          _NavChild(
            'Performance Validation Tool',
            8,
            allowedRoles: [
              PermissionRoleString.pgsAuditor,
              PermissionRoleString.roleAdmin,
              PermissionRoleString.twg,
              PermissionRoleString.osm,
              PermissionRoleString.headAuditor,
              PermissionRoleString.roleStandardUser,
              PermissionRoleString.serviceHead,
              PermissionRoleString.coreTeam,
              PermissionRoleString.evaluator,
            ],
          ),
          _NavChild(
            'PGS Auditor Report',
            9,
            allowedRoles: [
              PermissionRoleString.headAuditor,
              PermissionRoleString.roleAdmin,
              PermissionRoleString.twg,
            ],
          ),
          const _NavChild(
            'PGS Reports',
            null,
            children: [
              _NavChild('Summary Validated Deliverables', 10),
              _NavChild('Summary of Offices with Deliverables', 11),
              _NavChild('Summary of Offices — Monthly ORP', 12),
            ],
          ),
          const _NavChild('Strategic Change Agenda', 13),
        ],
      ),

      _NavGroup(
        icon: Icons.fact_check_outlined,
        label: 'ISO',
        pageIndex: 2,
        children: const [
          // _NavChild('Auditor', 0),
          // _NavChild('Auditor Offices', 1),
          // _NavChild('Auditor Team', 2),
          // _NavChild('ISO Announcements', 3),
        ],
      ),
      _NavGroup(
        icon: Icons.settings_outlined,
        label: 'Settings',
        pageIndex: 3,
        allowedRoles: [PermissionRoleString.roleAdmin],
        children: const [
          _NavChild('Announcement', 0),
          _NavChild('Auditor', 2),
          _NavChild('Auditor Offices', 3),
          _NavChild('Auditor Team', 4),
          _NavChild('Process Core & Support', 5),
          _NavChild('KRA Roadmap Period', 6),
          _NavChild('Office', 7),
          _NavChild('PGS Signatory', 8),
          _NavChild('PGS Period', 9),
          _NavChild('Role', 10),
          _NavChild('Team', 11),
          _NavChild('User', 12),
          _NavChild('User Office', 13),
          _NavChild('User Role', 14),
          _NavChild('Strategy Review Period', 15),
          _NavChild('Performance Validation Tool Period', 16),
          _NavChild('Performance Validation Tool Signatory', 17),
          _NavChild('Impact & Strategic Goal Period', 18),
          _NavChild('SWOT — Strength & Weakness', 19),
          _NavChild('SWOT — Opportunities & Threats', 20),
          _NavChild('Evaluator Offices', 21),
          _NavChild('Service Head Office', 22),
        ],
      ),
    ];
  }

  bool _roleAllowed(List<String>? allowedRoles) {
    if (allowedRoles == null) return true;
    return allowedRoles.contains(selectedRole);
  }

  List<_NavChild> _filterChildren(List<_NavChild> children) {
    final out = <_NavChild>[];
    for (final c in children) {
      if (!_roleAllowed(c.allowedRoles)) continue;
      if (c.children.isNotEmpty) {
        final filtered = _filterChildren(c.children);
        if (filtered.isEmpty) continue;
        out.add(
          _NavChild(
            c.title,
            c.index,
            allowedRoles: c.allowedRoles,
            children: filtered,
            titleFor: c.titleFor,
          ),
        );
      } else {
        out.add(c);
      }
    }
    return out;
  }

  bool _containsActive(List<_NavChild> children, int pageIndex) {
    for (final c in children) {
      if (c.children.isNotEmpty) {
        if (_containsActive(c.children, pageIndex)) return true;
      } else if (selectedPage == pageIndex && selectedSubPage == c.index) {
        return true;
      }
    }
    return false;
  }

  void _collectLeaves(List<_NavChild> children, List<_NavChild> out) {
    for (final c in children) {
      if (c.children.isNotEmpty) {
        _collectLeaves(c.children, out);
      } else {
        out.add(c);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool isMobile = width < 900;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer:
          isMobile
              ? Drawer(child: _buildSidebarPanel(forceExpanded: true))
              : null,
      body: Row(
        children: [
          if (!isMobile)
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeInOut,
              width: _isCollapsed ? _kCollapsedWidth : _kExpandedWidth,
              child: _buildSidebarPanel(),
            ),
          VerticalDivider(
            width: 1,
            thickness: 0.8,
            color: Colors.grey.shade200,
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          IconButton(
                            key: _notificationKey,
                            tooltip: 'Notification',
                            icon: Icon(
                              Icons.notifications_outlined,
                              color: Colors.grey[700],
                              size: 32,
                            ),
                            onPressed: () => _showNotificationMenu(context),
                          ),
                          if (_unreadAnnouncements.isNotEmpty)
                            Positioned(
                              right: 6,
                              top: 6,
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: const BoxDecoration(
                                  color: Colors.redAccent,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Text(
                                  '${_unreadAnnouncements.length}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 24),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          double maxWidth = constraints.maxWidth * 0.4;
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
                                      size: 45,
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

  void _logout(BuildContext context) async {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            backgroundColor: Colors.white,
            child: Container(
              width: 380,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: kSurface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 32,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: kDangerLight,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.logout_outlined,
                      color: primaryColor,
                      size: 28,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Logout',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                      color: kText,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Are you sure you want to logout?',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: kMuted,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: kBorder),
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.plusJakartaSans(
                              color: kMuted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () async {
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.remove('selectedRole');
                            await AuthUtil.logout(context);
                            if (!context.mounted) return;
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                              (route) => false,
                            );
                          },
                          child: Text(
                            'Logout',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildSidebarPanel({bool forceExpanded = false}) {
    final collapsed = forceExpanded ? false : _isCollapsed;
    final groups = _buildNavGroups().where((g) => _roleAllowed(g.allowedRoles));

    List<MapEntry<_NavGroup, _NavChild>> searchResults = [];
    if (_searchQuery.isNotEmpty) {
      for (final g in groups) {
        final leaves = <_NavChild>[];
        _collectLeaves(_filterChildren(g.children), leaves);
        for (final c in leaves) {
          final resolvedTitle = c.resolveTitle(selectedRole);
          if (resolvedTitle.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          )) {
            searchResults.add(MapEntry(g, c));
          }
        }
      }
    }

    return Container(
      color: primaryColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 12, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!collapsed)
                  Image.asset('assets/CRMC.png', width: 72, fit: BoxFit.contain)
                else
                  const SizedBox.shrink(),
                if (!forceExpanded)
                  IconButton(
                    tooltip: collapsed ? 'Expand' : 'Collapse',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      collapsed
                          ? Icons.keyboard_double_arrow_right
                          : Icons.keyboard_double_arrow_left,
                      size: 20,
                      color: Colors.white70,
                    ),
                    onPressed:
                        () => setState(() => _isCollapsed = !_isCollapsed),
                  ),
              ],
            ),
          ),
          if (!collapsed)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(fontSize: 13, color: Colors.white),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.12),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                    borderSide: BorderSide(
                      color: Colors.white.withValues(alpha: 0.6),
                      width: 1.2,
                    ),
                  ),
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 13,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    size: 18,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                  suffixIcon:
                      _searchQuery.isEmpty
                          ? null
                          : IconButton(
                            icon: Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                            onPressed: () => _searchController.clear(),
                          ),
                ),
              ),
            )
          else
            IconButton(
              tooltip: 'Search',
              icon: const Icon(Icons.search, size: 20, color: Colors.white70),
              onPressed: () => setState(() => _isCollapsed = false),
            ),

          const SizedBox(height: 4),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 20),
              child:
                  searchResults.isNotEmpty ||
                          (_searchQuery.isNotEmpty && !collapsed)
                      ? _buildSearchResults(searchResults)
                      : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final g in groups)
                            _navGroupTile(g, collapsed: collapsed),
                          const SizedBox(height: 12),
                          const Divider(
                            indent: 16,
                            endIndent: 16,
                            height: 1,
                            color: Colors.white24,
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
            ),
          ),
          _logoutTile(collapsed: collapsed),
        ],
      ),
    );
  }

  Widget _buildSearchResults(List<MapEntry<_NavGroup, _NavChild>> results) {
    if (results.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(
          'No matches for "$_searchQuery"',
          style: TextStyle(
            fontSize: 12.5,
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          results.map((entry) {
            final g = entry.key;
            final c = entry.value;
            final resolvedTitle = c.resolveTitle(selectedRole);
            final active =
                selectedPage == g.pageIndex && selectedSubPage == c.index;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color:
                    active
                        ? Colors.white.withValues(alpha: _kActiveHighlightAlpha)
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  setState(() {
                    selectedPage = g.pageIndex;
                    selectedSubPage = c.index!;
                    _expandedKeys.add('g${g.pageIndex}');
                    _searchController.clear();
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 9,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Icon(g.icon, size: 14, color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              resolvedTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              g.label,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _navGroupTile(_NavGroup g, {required bool collapsed}) {
    final isActive = selectedPage == g.pageIndex;
    final key = 'g${g.pageIndex}';
    final expanded = _expandedKeys.contains(key);
    final visibleChildren = _filterChildren(g.children);
    final hasActiveChild = _containsActive(visibleChildren, g.pageIndex);
    final leafActive = isActive && visibleChildren.isEmpty;

    if (collapsed) {
      return Tooltip(
        message: g.label,
        waitDuration: const Duration(milliseconds: 300),
        child: InkWell(
          onTap:
              () => setState(() {
                selectedPage = g.pageIndex;
                selectedSubPage = _firstPermittedSubPage(g.pageIndex);
              }),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 14),
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color:
                  isActive
                      ? Colors.white.withValues(alpha: _kActiveHighlightAlpha)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(g.icon, size: 21, color: Colors.white),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          decoration: BoxDecoration(
            color:
                leafActive
                    ? Colors.white.withValues(alpha: _kActiveHighlightAlpha)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              setState(() {
                selectedPage = g.pageIndex;
                selectedSubPage = _firstPermittedSubPage(g.pageIndex);
                if (visibleChildren.isNotEmpty) {
                  expanded ? _expandedKeys.remove(key) : _expandedKeys.add(key);
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
              child: Row(
                children: [
                  Icon(
                    g.icon,
                    size: 19,
                    color: Colors.white.withValues(
                      alpha: (leafActive || hasActiveChild) ? 1 : 0.75,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      g.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight:
                            (leafActive || hasActiveChild)
                                ? FontWeight.w700
                                : FontWeight.w500,
                        color: Colors.white.withValues(
                          alpha: (leafActive || hasActiveChild) ? 1 : 0.85,
                        ),
                      ),
                    ),
                  ),
                  if (visibleChildren.isNotEmpty)
                    Icon(
                      expanded ? Icons.remove : Icons.add,
                      size: 18,
                      color: Colors.white.withValues(
                        alpha: hasActiveChild ? 1 : 0.6,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox(width: double.infinity, height: 0),
          secondChild: _childrenBlock(visibleChildren, g.pageIndex, key),
          crossFadeState:
              expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 180),
          sizeCurve: Curves.easeInOut,
        ),
      ],
    );
  }

  Widget _childrenBlock(
    List<_NavChild> children,
    int pageIndex,
    String parentKey, {
    double leftMargin = 26,
  }) {
    if (children.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(left: leftMargin, right: 10, bottom: 6, top: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(children.length, (i) {
          final c = children[i];
          final resolvedTitle = c.resolveTitle(selectedRole);
          final isFirst = i == 0;
          final isLast = i == children.length - 1;
          final hasSubChildren = c.children.isNotEmpty;
          final key = '$parentKey/${c.title}';

          Widget header;
          Widget? subBlock;

          if (hasSubChildren) {
            final expanded = _expandedKeys.contains(key);
            final hasActiveDescendant = _containsActive(c.children, pageIndex);

            header = InkWell(
              onTap:
                  () => setState(() {
                    expanded
                        ? _expandedKeys.remove(key)
                        : _expandedKeys.add(key);
                  }),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.5,
                  horizontal: 4,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        resolvedTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 12.5,
                          height: 1.3,
                          fontWeight:
                              hasActiveDescendant
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                          color: Colors.white.withValues(
                            alpha: hasActiveDescendant ? 1 : 0.75,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Padding(
                      padding: const EdgeInsets.only(top: 1),
                      child: Icon(
                        expanded ? Icons.remove : Icons.add,
                        size: 16,
                        color: Colors.white.withValues(
                          alpha: hasActiveDescendant ? 1 : 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );

            subBlock = AnimatedCrossFade(
              firstChild: const SizedBox(width: double.infinity, height: 0),
              secondChild: _childrenBlock(
                c.children,
                pageIndex,
                key,
                leftMargin: 18,
              ),
              crossFadeState:
                  expanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 160),
              sizeCurve: Curves.easeInOut,
            );
          } else {
            final active =
                selectedPage == pageIndex && selectedSubPage == c.index;
            header = InkWell(
              onTap:
                  () => setState(() {
                    selectedPage = pageIndex;
                    selectedSubPage = c.index!;
                  }),
              borderRadius: BorderRadius.circular(8),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8.5,
                ),
                decoration: BoxDecoration(
                  color:
                      active
                          ? Colors.white.withValues(
                            alpha: _kActiveHighlightAlpha,
                          )
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  resolvedTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 12.5,
                    height: 1.3,
                    color: Colors.white.withValues(alpha: active ? 1 : 0.7),
                    fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: 16,
                      child: CustomPaint(
                        painter: _RootConnectorPainter(
                          isFirst: isFirst,
                          isLast: isLast,
                          color: Colors.white38, // connector line color
                        ),
                      ),
                    ),
                    Expanded(child: header),
                  ],
                ),
              ),
              if (subBlock != null) subBlock,
            ],
          );
        }),
      ),
    );
  }

  Widget _logoutTile({required bool collapsed}) {
    if (collapsed) {
      return Tooltip(
        message: 'Logout',
        child: InkWell(
          onTap: () => _logout(context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 14),
            padding: const EdgeInsets.all(11),
            child: const Icon(
              Icons.logout_outlined,
              size: 21,
              color: Colors.white70,
            ),
          ),
        ),
      );
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: InkWell(
        onTap: () => _logout(context),
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          child: Row(
            children: [
              Icon(
                Icons.logout_outlined,
                size: 19,
                color: Colors.white.withValues(alpha: 0.75),
              ),
              const SizedBox(width: 12),
              Text(
                'Logout',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RootConnectorPainter extends CustomPainter {
  final bool isFirst;
  final bool isLast;
  final Color color;

  _RootConnectorPainter({
    required this.isFirst,
    required this.isLast,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = 1.4
          ..style = PaintingStyle.stroke;

    final double midY = size.height / 2;
    const double curve = 8.0;

    if (!isFirst) {
      canvas.drawLine(const Offset(0, 0), Offset(0, midY - curve), paint);
    }
    if (!isLast) {
      canvas.drawLine(Offset(0, midY), Offset(0, size.height), paint);
    }

    final path =
        Path()
          ..moveTo(0, midY - curve)
          ..quadraticBezierTo(0, midY, curve, midY)
          ..lineTo(size.width, midY);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _RootConnectorPainter oldDelegate) {
    return oldDelegate.isFirst != isFirst ||
        oldDelegate.isLast != isLast ||
        oldDelegate.color != color;
  }
}
