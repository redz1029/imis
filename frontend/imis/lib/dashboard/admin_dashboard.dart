import 'dart:async';
import 'dart:math' as math;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/auditor/models/auditor.dart';
import 'package:imis/common_services/common_service.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/office/models/office.dart';
import 'package:imis/performance_governance_system/pgs_period/models/pgs_period.dart';
import 'package:imis/performance_governance_system/models/pgs_deliverables.dart';
import 'package:imis/team/models/team.dart';
import 'package:imis/user/models/user.dart';
import 'package:imis/user/models/user_registration.dart';
import 'package:imis/user/services/home_service.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/auth_util.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/widgets/home/dynamic_side_column.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  AdminDashboardState createState() => AdminDashboardState();
}

class AdminDashboardState extends State<AdminDashboard> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<PgsDeliverables> deliverablesList = [];
  List<PgsDeliverables> filteredDeliverables = [];

  List<PgsPeriod> statsPeriodList = [];
  PgsPeriod? selectedStatsPeriod;
  bool isLoadingStatistics = false;
  int statTotalDeliverables = 0;
  int statTotalOffices = 0;
  int statTotalAudited = 0;
  int statCompleted = 0;
  int statOngoing = 0;
  int statNotStarted = 0;

  List<User> userList = [];
  List<User> filteredListUser = [];
  int totalUsers = 0;
  List<String> office = [];
  String firstName = "firstName";
  final dio = Dio();
  List<Office> officeList = [];
  List<Office> filteredListOffice = [];
  int totalOffices = 0;
  final _commonService = CommonService(Dio());
  List<Team> teamList = [];
  List<Team> filteredListTeam = [];
  int totalTeam = 0;

  List<Auditor> auditorList = [];
  List<Auditor> filteredListAuditor = [];
  int totalAuditor = 0;

  final int maxDeliverables = 100;

  @override
  void initState() {
    super.initState();
    loadUserNames();
    _fetchAllData();
    _loadStatisticsPeriods();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _fetchAllData() async {
    final service = HomeService();
    try {
      final data = await service.fetchAll(
        usersEndpoint: ApiEndpoint().users,
        officeEndpoint: ApiEndpoint().office,
        teamEndpoint: ApiEndpoint().team,
        auditorEndpoint: ApiEndpoint().auditor,
        deliverablesEndpoint: ApiEndpoint().deliverables,
        kraEndpoint: ApiEndpoint().keyresult,
      );

      if (mounted) {
        setState(() {
          userList = data.users;
          filteredListUser = List.from(data.users);
          totalUsers = data.users.length;

          officeList = data.offices;
          filteredListOffice = List.from(data.offices);
          totalOffices = data.offices.length;

          teamList = data.teams;
          filteredListTeam = List.from(data.teams);
          totalTeam = data.teams.length;

          auditorList = data.auditors;
          filteredListAuditor = List.from(data.auditors);
          totalAuditor = data.auditors.length;

          deliverablesList = data.deliverables;
          filteredDeliverables = List.from(data.deliverables);
        });
      }
    } catch (e) {
      if (mounted) {}
    }
  }

  Future<void> _loadStatisticsPeriods() async {
    try {
      final periods = await _commonService.fetchPgsPeriod();
      if (!mounted) return;
      setState(() {
        statsPeriodList = periods;
        selectedStatsPeriod = periods.isNotEmpty ? periods.first : null;
      });
      if (selectedStatsPeriod != null) {
        await _fetchStatistics(selectedStatsPeriod!.id);
      }
    } catch (e) {
      // handle error
    }
  }

  Future<String> _getRoleId() async {
    final prefs = await SharedPreferences.getInstance();
    final String? selectedRoleName = prefs.getString('selectedRole');
    final roles = await AuthUtil.fetchRoles();
    if (roles != null && roles.isNotEmpty) {
      var currentRole = roles.first;
      if (selectedRoleName != null) {
        try {
          currentRole = roles.firstWhere((r) => r.name == selectedRoleName);
        } catch (_) {}
      }
      return currentRole.id;
    }
    return '';
  }

  Future<void> _fetchStatistics(int pgsPeriodId) async {
    setState(() => isLoadingStatistics = true);
    try {
      final roleIdParam = await _getRoleId();
      final results = await Future.wait([
        AuthenticatedRequest.get(
          dio,
          '${ApiEndpoint().dashboardTotalDeliverables}?roleid=$roleIdParam&pgsPeriodId=$pgsPeriodId',
        ),
        AuthenticatedRequest.get(
          dio,
          '${ApiEndpoint().dashboardTotalOffices}?roleid=$roleIdParam&pgsPeriodId=$pgsPeriodId',
        ),
        AuthenticatedRequest.get(
          dio,
          '${ApiEndpoint().dashboardTotalAudited}?roleid=$roleIdParam&pgsPeriodId=$pgsPeriodId',
        ),
        AuthenticatedRequest.get(
          dio,
          '${ApiEndpoint().dashboardAuditStatus}?roleid=$roleIdParam&pgsPeriodId=$pgsPeriodId',
        ),
      ]);

      if (!mounted) return;
      setState(() {
        statTotalDeliverables = results[0].data['totalNoDeliverable'] ?? 0;
        statTotalOffices = results[1].data['totalNoOffice'] ?? 0;
        statTotalAudited = results[2].data['totalNoAudited'] ?? 0;
        statCompleted = results[3].data['completed'] ?? 0;
        statOngoing = results[3].data['ongoing'] ?? 0;
        statNotStarted = results[3].data['notStarted'] ?? 0;
        isLoadingStatistics = false;
      });
    } catch (e) {
      if (mounted) setState(() => isLoadingStatistics = false);
    }
  }

  Future<void> loadUserNames() async {
    UserRegistration? user = await AuthUtil.fetchLoggedUser();
    List<String>? officeName = await AuthUtil.fetchOfficeNames();

    if (user != null) {
      setState(() {
        office = officeName ?? [];
        final rawName = (user.firstName ?? "firstName").trim();

        firstName = rawName.toLowerCase().replaceFirstMapped(
          RegExp(r'^[a-z]'),
          (m) => m.group(0)!.toUpperCase(),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(child: _buildMainLayout()),
      ),
    );
  }

  Widget _buildMainLayout() {
    final width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 800;

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcome(),
          const SizedBox(height: 16),
          _buildStatsRow(),
          const SizedBox(height: 16),

          _buildStatisticsSection(),
          const SizedBox(height: 16),
          _buildInfoCards(),
          const SizedBox(height: 16),
          DynamicSideColumn1(
            focusedDay: _focusedDay,
            selectedDay: _selectedDay,
            calendarFormat: _calendarFormat,
            onDaySelected: (selected, focused) {
              setState(() {
                _selectedDay = selected;
                _focusedDay = focused;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
          ),
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcome(),
              gap8px,
              _buildStatsRow(),
              gap6px,
              _buildStatisticsSection(),
              gap6px,
              _buildInfoCards(),
            ],
          ),
        ),
        const SizedBox(width: 6),
        SizedBox(
          width: 290,
          child: DynamicSideColumn1(
            focusedDay: _focusedDay,
            selectedDay: _selectedDay,
            calendarFormat: _calendarFormat,
            onDaySelected: (selected, focused) {
              setState(() {
                _selectedDay = selected;
                _focusedDay = focused;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWelcome() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 800;

        if (isMobile) {
          return Column(children: [_welcomeCard(), const SizedBox(height: 16)]);
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(flex: 2, child: _welcomeCard()),
            const SizedBox(width: 16),
          ],
        );
      },
    );
  }

  Widget _buildInfoCards() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 800;

        if (isMobile) {
          return Column(
            children: [
              _info1(),
              const SizedBox(height: 16),
              _info2(),
              const SizedBox(height: 16),
              _info3(),
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(fit: FlexFit.loose, child: _info1()),
            const SizedBox(width: 20),
            Flexible(fit: FlexFit.loose, child: _info2()),
            const SizedBox(width: 20),
            Flexible(fit: FlexFit.loose, child: _info3()),
          ],
        );
      },
    );
  }

  Widget _info1() {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 200),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF213C51),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "We build CRMC together.",
                    style: TextStyle(
                      color: Color(0xFFE37383),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Your work matters. Your role changes lives.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).cardColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Image.asset(
                'assets/shareGoals.png',
                height: 90,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _info2() {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 200),
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        child: Text(
          "Performance is everyone's responsibility.",
          style: TextStyle(
            color: Color(0xFFE37383),
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _info3() {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 200),
      child: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),

          color: Theme.of(context).cardColor,
        ),
        child: Stack(
          children: [
            Positioned(
              right: 0,
              bottom: -10,
              child: Icon(
                Icons.auto_awesome,
                size: 120,
                color: Colors.amber.withValues(alpha: 0.2),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "What's New?",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Discover the latest improvements and features added to CPeMS.",
                  style: TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 14),
                ElevatedButton.icon(
                  onPressed: _showWhatsNewDialog,
                  icon: const Icon(Icons.new_releases),
                  label: const Text("View Updates"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showWhatsNewDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 40,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 32,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          primaryColor,
                          primaryColor.withValues(alpha: 0.75),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  "RELEASE NOTES",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "What's New in CPeMS",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Version 1.0.3  •  ${_formatDate(DateTime.now())}",
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.75),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Text(
                            "🚀",
                            style: TextStyle(fontSize: 28),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionLabel("✨ UI Improvements"),
                          const SizedBox(height: 8),
                          _changeItem(
                            icon: Icons.dashboard_customize_outlined,
                            iconColor: Color(0xFF6366F1),
                            bgColor: Color(0xFFEEF2FF),
                            title: "Organized Dashboard",
                            subtitle:
                                "Data is now grouped by category for faster insights and cleaner navigation.",
                          ),
                          _changeItem(
                            icon: Icons.palette_outlined,
                            iconColor: Color(0xFF8B5CF6),
                            bgColor: Color(0xFFF5F3FF),
                            title: "Refreshed Interface",
                            subtitle:
                                "Cleaner layouts, improved spacing, and polished components throughout the app.",
                          ),

                          const SizedBox(height: 16),
                          _sectionLabel("🐛 Bug Fixes"),
                          const SizedBox(height: 8),
                          _changeItem(
                            icon: Icons.speed_outlined,
                            iconColor: Color(0xFF10B981),
                            bgColor: Color(0xFFECFDF5),
                            title: "Performance Boost",
                            subtitle:
                                "Faster report generation and reduced load times on key screens.",
                          ),

                          const SizedBox(height: 16),
                          _sectionLabel("🔄 Ongoing Development"),
                          const SizedBox(height: 8),
                          _changeItem(
                            icon: Icons.verified_outlined,
                            iconColor: Color(0xFFF59E0B),
                            bgColor: Color(0xFFFFFBEB),
                            title: "ISO Compliance Module",
                            subtitle:
                                "Coming soon: a module for developing ISO-compliant standards and documentation.",
                            isBadge: true,
                            badgeLabel: "Coming Soon",
                            badgeColor: Color(0xFFF59E0B),
                          ),

                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 16,
                                  color: Colors.grey.shade500,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "Have feedback? Reach out to your system administrator.",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey.shade100),
                      ),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          "Got it, thanks!",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
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

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return "${months[date.month - 1]} ${date.day}, ${date.year}";
  }

  Widget _sectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: Colors.black87,
        letterSpacing: 0.2,
      ),
    );
  }

  Widget _changeItem({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String subtitle,
    bool isBadge = false,
    String? badgeLabel,
    Color? badgeColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    if (isBadge && badgeLabel != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: badgeColor?.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color:
                                badgeColor?.withValues(alpha: 0.3) ??
                                Colors.transparent,
                          ),
                        ),
                        child: Text(
                          badgeLabel,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: badgeColor,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _welcomeCard() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isNarrow = constraints.maxWidth < 500;

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 150, 68, 89),
                Color.fromARGB(255, 180, 91, 112),
                Color.fromARGB(255, 190, 100, 120),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child:
              isNarrow
                  ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${getGreeting()}, ${firstName.split(' ')[0]}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Welcome to CPeMS - Centralized Performance Electronic Management System! Together, we track progress and build a culture of accountability and continuous improvement.",
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: Image.asset('assets/image1.png', height: 200),
                      ),
                    ],
                  )
                  : Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${getGreeting()}, ${firstName.split(' ')[0]}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Welcome to CPeMS - Centralized Performance Electronic Management System! Together, we track progress and build a culture of accountability and continuous improvement.",
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Image.asset('assets/image1.png', height: 150),
                    ],
                  ),
        );
      },
    );
  }

  Widget _buildStatsRow() {
    final stats = [
      _StatItem(
        label: "Total Users",
        count: totalUsers.toString(),
        icon: Icons.people_alt_outlined,
        color: primaryColor,
      ),
      _StatItem(
        label: "Total Auditors",
        count: totalAuditor.toString(),
        icon: Icons.verified_user_outlined,
        color: primaryColor,
      ),
      _StatItem(
        label: "Total Teams",
        count: totalTeam.toString(),
        icon: Icons.groups_2_outlined,
        color: primaryColor,
      ),
      _StatItem(
        label: "Total Offices",
        count: totalOffices.toString(),
        icon: Icons.apartment_outlined,
        color: primaryColor,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        if (width < 600) {
          return Column(
            children:
                stats
                    .map(
                      (s) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _buildStatCard(s),
                      ),
                    )
                    .toList(),
          );
        }
        if (width < 1000) {
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 2.8,
            ),
            itemCount: stats.length,
            itemBuilder: (context, index) {
              return _buildStatCard(stats[index]);
            },
          );
        }

        // DESKTOP (single row)
        return Row(
          children:
              stats.map((s) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: _buildStatCard(s),
                  ),
                );
              }).toList(),
        );
      },
    );
  }

  Widget _buildStatCard(_StatItem item) {
    return Container(
      height: 110,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.count,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 3,
                  width: 32,
                  decoration: BoxDecoration(
                    color: item.color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),

          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item.icon, color: item.color, size: 22),
          ),
        ],
      ),
    );
  }

  String _formatPeriodLabel(PgsPeriod period) {
    final start = _formatShortDate(period.startDate);
    final end = _formatShortDate(period.endDate);
    final baseLabel = "$start - $end";

    if (period.remarks != null && period.remarks!.trim().isNotEmpty) {
      return "${period.remarks} ($baseLabel)";
    }
    return baseLabel;
  }

  String _formatShortDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return "${months[date.month - 1]} ${date.year}";
  }

  // Widget _buildStatisticsSection() {
  //   final double auditRate =
  //       statTotalDeliverables > 0
  //           ? (statTotalAudited / statTotalDeliverables).clamp(0.0, 1.0)
  //           : 0.0;

  //   return Container(
  //     padding: const EdgeInsets.all(24),
  //     decoration: BoxDecoration(
  //       color: Theme.of(context).cardColor,
  //       borderRadius: BorderRadius.circular(16),
  //       border: Border.all(color: Colors.grey.shade200),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withValues(alpha: 0.03),
  //           blurRadius: 16,
  //           offset: const Offset(0, 4),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   "Audit Statistics",
  //                   style: GoogleFonts.plusJakartaSans(
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.w700,
  //                     color: Colors.black87,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 2),
  //                 Text(
  //                   "Overview of Audit Statistics for the Selected Period",
  //                   style: GoogleFonts.plusJakartaSans(
  //                     fontSize: 12,
  //                     color: Colors.grey.shade500,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             _buildPeriodDropdownPill(),
  //           ],
  //         ),
  //         const SizedBox(height: 24),

  //         if (isLoadingStatistics)
  //           const Padding(
  //             padding: EdgeInsets.symmetric(vertical: 40),
  //             child: Center(
  //               child: CircularProgressIndicator(color: primaryColor),
  //             ),
  //           )
  //         else
  //           LayoutBuilder(
  //             builder: (context, constraints) {
  //               final isMobile = constraints.maxWidth < 700;

  //               final cards = _buildDeliverableStatCards();
  //               final donut = _buildAuditDonut(auditRate);

  //               if (isMobile) {
  //                 return Column(
  //                   children: [cards, const SizedBox(height: 24), donut],
  //                 );
  //               }

  //               return Row(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Expanded(flex: 6, child: cards),
  //                   const SizedBox(width: 24),
  //                   Expanded(flex: 4, child: donut),
  //                 ],
  //               );
  //             },
  //           ),
  //         if (!isLoadingStatistics) ...[
  //           const SizedBox(height: 28),
  //           Divider(color: Colors.grey.shade200, height: 1),
  //           const SizedBox(height: 24),
  //           Text(
  //             "Deliverable Statistics",
  //             style: GoogleFonts.plusJakartaSans(
  //               fontSize: 18,
  //               fontWeight: FontWeight.w700,
  //               color: Colors.black87,
  //             ),
  //           ),
  //           const SizedBox(height: 4),
  //           Text(
  //             "Current deliverable status overview",
  //             style: GoogleFonts.plusJakartaSans(
  //               fontSize: 12,
  //               color: Colors.grey.shade500,
  //             ),
  //           ),
  //           const SizedBox(height: 20),
  //           _buildDeliverableStatusChart(),
  //         ],
  //       ],
  //     ),
  //   );
  // }
  Widget _buildStatisticsSection() {
    final double auditRate =
        statTotalDeliverables > 0
            ? (statTotalAudited / statTotalDeliverables).clamp(0.0, 1.0)
            : 0.0;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isLoadingStatistics)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: CircularProgressIndicator(color: primaryColor),
              ),
            )
          else ...[
            // ===== DELIVERABLE STATISTICS (now first) =====

            // ===== AUDIT STATISTICS (now second) =====
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Audit Statistics",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Overview of Audit Statistics for the Selected Period",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                _buildPeriodDropdownPill(),
              ],
            ),
            const SizedBox(height: 24),
            LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth < 700;

                final cards = _buildDeliverableStatCards();
                final donut = _buildAuditDonut(auditRate);

                if (isMobile) {
                  return Column(
                    children: [cards, const SizedBox(height: 24), donut],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 6, child: cards),
                    const SizedBox(width: 24),
                    Expanded(flex: 4, child: donut),
                  ],
                );
              },
            ),
            Text(
              "Deliverable Statistics",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Current deliverable status overview",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 20),
            _buildDeliverableStatusChart(),

            const SizedBox(height: 28),
            Divider(color: Colors.grey.shade200, height: 1),
            const SizedBox(height: 24),
          ],
        ],
      ),
    );
  }

  Widget _buildDeliverableStatCards() {
    final entries = [
      _BarEntry(
        "Total Deliverables",
        statTotalDeliverables,
        Icons.assignment_turned_in_outlined,
        primaryColor,
      ),
      _BarEntry(
        "Total Offices that Produced Deliverables",
        statTotalOffices,
        Icons.apartment_outlined,
        Colors.blue.shade400,
      ),
      _BarEntry(
        "Total Audited Deliverables",
        statTotalAudited,
        Icons.fact_check_outlined,
        Colors.purple.shade200,
      ),
    ];

    return Column(
      children: entries.map((e) => _deliverableStatCard(e)).toList(),
    );
  }

  Widget _deliverableStatCard(_BarEntry entry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: kBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: entry.color.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: entry.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(entry.icon, color: entry.color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  entry.value.toString(),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodDropdownPill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<PgsPeriod>(
          value: selectedStatsPeriod,
          icon: Icon(Icons.expand_more, size: 18, color: primaryColor),
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: primaryColor,
          ),
          hint: Text(
            "Select Period",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: primaryColor,
            ),
          ),
          items:
              statsPeriodList.map((period) {
                return DropdownMenuItem<PgsPeriod>(
                  value: period,
                  child: Text(_formatPeriodLabel(period)),
                );
              }).toList(),
          onChanged: (period) {
            if (period == null) return;
            setState(() => selectedStatsPeriod = period);
            _fetchStatistics(period.id);
          },
        ),
      ),
    );
  }

  Widget _buildAuditDonut(double rate) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kBackground,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            "Audit Completion",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: rate),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return SizedBox(
                width: 160,
                height: 160,
                child: CustomPaint(
                  painter: _DonutPainter(
                    progress: value,
                    progressColor: primaryColor,
                    backgroundColor: Colors.grey.shade200,
                    strokeWidth: 14,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${(value * 100).toStringAsFixed(0)}%",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          "Audited",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _legendDot(primaryColor, "$statTotalAudited Audited"),
              const SizedBox(width: 16),
              _legendDot(
                Colors.grey.shade300,
                "${(statTotalDeliverables - statTotalAudited).clamp(0, statTotalDeliverables == 0 ? 0 : statTotalDeliverables)} Pending",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildDeliverableStatusChart() {
    final entries = [
      _ChartBarEntry("Not Started", statNotStarted, Colors.redAccent),
      _ChartBarEntry("In Progress", statOngoing, Colors.orange.shade300),
      _ChartBarEntry("Completed", statCompleted, Colors.green.shade400),
      _ChartBarEntry("Audited", statTotalAudited, Colors.purple.shade200),
    ];

    final maxValue = entries
        .map((e) => e.value)
        .fold<int>(0, (prev, e) => e > prev ? e : prev)
        .clamp(1, 999999);

    final total = statNotStarted + statOngoing + statCompleted;

    final double notStartedPct =
        total > 0 ? (statNotStarted / total * 100) : 0.0;
    final double inProgressPct = total > 0 ? (statOngoing / total * 100) : 0.0;
    final double completedPct = total > 0 ? (statCompleted / total * 100) : 0.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 700;

        // ===== LEFT: Total Deliverables (full height) =====
        final totalCard = Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: kBackground,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: primaryColor, width: 1.5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment:
                isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
            children: [
              Text(
                total.toString(),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Total Deliverables",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        );
        final percentCards = [
          _summaryCard("Not Started (%)", notStartedPct, Colors.redAccent),
          _summaryCard(
            "In Progress (%)",
            inProgressPct,
            Colors.orange.shade300,
          ),
          _summaryCard("Completed (%)", completedPct, Colors.green.shade400),
        ];

        final percentRow =
            isMobile
                ? Column(
                  children:
                      percentCards
                          .map(
                            (c) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: c,
                            ),
                          )
                          .toList(),
                )
                : Row(
                  children:
                      percentCards
                          .map(
                            (c) => Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                child: c,
                              ),
                            ),
                          )
                          .toList(),
                );

        final chart = Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: kBackground,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Deliverable Statistics",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children:
                    entries.map((e) => _legendDot(e.color, e.label)).toList(),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 240,
                child: _GridChart(entries: entries, maxValue: maxValue),
              ),
            ],
          ),
        );

        final rightColumn = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [percentRow, const SizedBox(height: 20), chart],
        );

        if (isMobile) {
          return Column(
            children: [
              SizedBox(height: 140, child: totalCard),
              const SizedBox(height: 20),
              rightColumn,
            ],
          );
        }

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(flex: 3, child: totalCard),
              const SizedBox(width: 24),
              Expanded(flex: 7, child: rightColumn),
            ],
          ),
        );
      },
    );
  }

  Widget _summaryCard(String label, double value, Color accentColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: kBackground,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            value.toStringAsFixed(2),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem {
  final String label;
  final String count;
  final IconData icon;
  final Color color;

  const _StatItem({
    required this.label,
    required this.count,
    required this.icon,
    required this.color,
  });
}

class _BarEntry {
  final String label;
  final int value;
  final IconData icon;
  final Color color;

  _BarEntry(this.label, this.value, this.icon, this.color);
}

class _DonutPainter extends CustomPainter {
  final double progress;
  final Color progressColor;
  final Color backgroundColor;
  final double strokeWidth;

  _DonutPainter({
    required this.progress,
    required this.progressColor,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final bgPaint =
        Paint()
          ..color = backgroundColor
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    final fgPaint =
        Paint()
          ..color = progressColor
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _DonutSegment {
  final String label;
  final int value;
  final Color color;

  _DonutSegment(this.label, this.value, this.color);
}

class _MultiDonutPainter extends CustomPainter {
  final List<_DonutSegment> segments;
  final int total;
  final double strokeWidth;
  final double animationProgress;

  _MultiDonutPainter({
    required this.segments,
    required this.total,
    required this.strokeWidth,
    required this.animationProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    if (total <= 0) {
      final emptyPaint =
          Paint()
            ..color = Colors.grey.shade200
            ..strokeWidth = strokeWidth
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round;
      canvas.drawCircle(center, radius, emptyPaint);
      return;
    }

    double startAngle = -math.pi / 2;

    for (final segment in segments) {
      if (segment.value <= 0) continue;

      final sweepAngle =
          (segment.value / total) * 2 * math.pi * animationProgress;

      final paint =
          Paint()
            ..color = segment.color
            ..strokeWidth = strokeWidth
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += (segment.value / total) * 2 * math.pi;
    }
  }

  @override
  bool shouldRepaint(covariant _MultiDonutPainter oldDelegate) =>
      oldDelegate.animationProgress != animationProgress ||
      oldDelegate.segments != segments;
}

class _ChartBarEntry {
  final String label;
  final int value;
  final Color color;

  _ChartBarEntry(this.label, this.value, this.color);
}

class _GridChart extends StatelessWidget {
  final List<_ChartBarEntry> entries;
  final int maxValue;

  const _GridChart({required this.entries, required this.maxValue});

  // rounds maxValue up to a "nice" step count (e.g. 5 gridlines)
  List<int> get _gridSteps {
    final step = (maxValue / 4).ceil();
    final niceStep = step <= 0 ? 1 : step;
    return List.generate(5, (i) => niceStep * i);
  }

  @override
  Widget build(BuildContext context) {
    final steps = _gridSteps;
    final chartMax = steps.last == 0 ? 1 : steps.last;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Y-axis numbers
        SizedBox(
          width: 36,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:
                steps.reversed
                    .map(
                      (s) => Text(
                        s.toString(),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    )
                    .toList(),
          ),
        ),
        const SizedBox(width: 8),
        // Chart area with gridlines behind bars
        Expanded(
          child: Stack(
            children: [
              // background gridlines
              Positioned.fill(
                child: CustomPaint(
                  painter: _GridBackgroundPainter(
                    lineCount: steps.length,
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
              // bars on top
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:
                      entries.map((e) => _verticalBar(e, chartMax)).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _verticalBar(_ChartBarEntry entry, int maxValue) {
    final ratio = maxValue > 0 ? entry.value / maxValue : 0.0;

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            entry.value.toString(),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 190,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: ratio.clamp(0.0, 1.0)),
                duration: const Duration(milliseconds: 900),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return FractionallySizedBox(
                    heightFactor: value == 0 ? 0.01 : value,
                    child: Container(
                      width: 32,
                      decoration: BoxDecoration(
                        color: entry.color,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(6),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GridBackgroundPainter extends CustomPainter {
  final int lineCount;
  final Color color;

  _GridBackgroundPainter({required this.lineCount, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color.withValues(alpha: 0.5)
          ..strokeWidth = 1;

    // evenly spaced horizontal lines, top = max, bottom = 0
    for (int i = 0; i < lineCount; i++) {
      final y = size.height * (i / (lineCount - 1));
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridBackgroundPainter oldDelegate) => false;
}
