import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:imis/auditor/models/auditor.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/office/models/office.dart';
import 'package:imis/performance_governance_system/process_core_support/models/key_result_area.dart';
import 'package:imis/performance_governance_system/models/pgs_deliverables.dart';
import 'package:imis/team/models/team.dart';
import 'package:imis/user/models/user.dart';
import 'package:imis/user/models/user_registration.dart';
import 'package:imis/user/services/home_service.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/auth_util.dart';
import 'package:imis/widgets/dynamic_side_column.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../performance_governance_system/enum/pgs_status.dart';

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

  List<KeyResultArea> kraList = [];
  List<KeyResultArea> filteredKra = [];
  List<String> roles = [];

  List<User> userList = [];
  List<User> filteredListUser = [];
  int totalUsers = 0;
  List<String> office = [];
  String firstName = "firstName";

  List<Office> officeList = [];
  List<Office> filteredListOffice = [];
  int totalOffices = 0;

  List<Team> teamList = [];
  List<Team> filteredListTeam = [];
  int totalTeam = 0;

  List<Auditor> auditorList = [];
  List<Auditor> filteredListAuditor = [];
  int totalAuditor = 0;

  final int maxDeliverables = 100;
  int _currentImageIndex = 0;
  late Timer imageTimer;
  final List<String> rotatingImages = ['assets/pic1.jpg', 'assets/pic2.jpg'];

  @override
  void initState() {
    super.initState();
    loadUserNames();
    _fetchAllData();
    imageTimer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (mounted) {
        setState(() {
          _currentImageIndex = (_currentImageIndex + 1) % rotatingImages.length;
        });
      }
    });
  }

  @override
  void dispose() {
    imageTimer.cancel();
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

          kraList = data.kras;
          filteredKra = List.from(data.kras);
        });
      }
    } catch (e) {
      if (mounted) {}
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
              const SizedBox(height: 24),
              _buildStatsRow(),
              const SizedBox(height: 24),
              _buildInfoCards(),
            ],
          ),
        ),

        const SizedBox(width: 24),

        SizedBox(
          width: 250,
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
                  // ── Header banner ───────────────────────────────────
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
                                "Version 4.0  •  ${_formatDate(DateTime.now())}",
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
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 150, 68, 89),
            Color.fromARGB(255, 167, 80, 101),
            Color.fromARGB(255, 190, 100, 120),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
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
          const SizedBox(width: 100),
          Image.asset('assets/image1.png', height: 150),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isNarrow = constraints.maxWidth < 400;

        if (isNarrow) {
          return Column(
            children: [
              buildDashboardBox(
                "Total Users",
                Colors.blue,
                totalUsers.toString(),
                'assets/users.png',
              ),
              SizedBox(height: 10),
              buildDashboardBox(
                "Total Auditors",
                Colors.green,
                totalAuditor.toString(),
                'assets/auditor.png',
              ),
              SizedBox(height: 10),
              buildDashboardBox(
                "Total Teams",
                Colors.purple,
                totalTeam.toString(),
                'assets/team.png',
              ),
              SizedBox(height: 10),
              buildDashboardBox(
                "Total Offices",
                const Color.fromARGB(255, 194, 106, 47),
                totalOffices.toString(),
                'assets/office.png',
              ),
            ],
          );
        } else {
          return Row(
            children: [
              Expanded(
                child: buildDashboardBox(
                  "Total Users",
                  Colors.blue,
                  totalUsers.toString(),
                  'assets/users.png',
                ),
              ),
              Expanded(
                child: buildDashboardBox(
                  "Total Auditors",
                  Colors.green,
                  totalAuditor.toString(),
                  'assets/auditor.png',
                ),
              ),
              Expanded(
                child: buildDashboardBox(
                  "Total Teams",
                  Colors.purple,
                  totalTeam.toString(),
                  'assets/team.png',
                ),
              ),
              Expanded(
                child: buildDashboardBox(
                  "Total Offices",
                  const Color.fromARGB(255, 194, 106, 47),
                  totalOffices.toString(),
                  'assets/office.png',
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildPerformanceChart(
    List<KeyResultArea> kraList,
    List<PgsDeliverables> deliverablesList,
  ) {
    final Map<int, double> kraPercentTotals = {};
    for (var deliverable in deliverablesList) {
      kraPercentTotals[deliverable.kra!.id] =
          (kraPercentTotals[deliverable.kra!.id] ?? 0) +
          (deliverable.percentDeliverables / 100);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        final chartHeight = isMobile ? 350.0 : 250.0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Center(
                child: Text(
                  'Performance Chart',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              height: chartHeight,
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 24 : 8,
                vertical: 8,
              ),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.blueGrey.withAlpha(200),
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${rod.toY.toStringAsFixed(1)}%',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 20,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: 4,
                            child: Text(
                              value.toInt().toString(),
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        reservedSize: 100,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          int index = value.toInt();
                          if (index >= 0 && index < kraList.length) {
                            final kra = kraList[index];
                            return Transform.translate(
                              offset: const Offset(0, 80),
                              child: Transform.rotate(
                                angle: -0.872, // ~50° rotation
                                alignment: Alignment.center,
                                child: Text(
                                  kra.name,
                                  style: TextStyle(
                                    fontSize: isMobile ? 8 : 10,
                                    color: Colors.black87,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                  barGroups: List.generate(kraList.length, (index) {
                    final kra = kraList[index];
                    double percent = kraPercentTotals[kra.id] ?? 0;
                    percent = percent.clamp(0.0, 100.0);

                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: percent,
                          color: primaryLightColor,
                          width: 20,
                          borderRadius: BorderRadius.circular(4),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: 100,
                            color: Colors.grey.shade200,
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatusWidget(List<PgsDeliverables> deliverablesList) {
    final statusCounts = countStatuses(deliverablesList);

    int getCount(PgsStatus status) => statusCounts[status] ?? 0;

    final List<PgsStatus> statusesToDisplay = [
      PgsStatus.notStarted,
      PgsStatus.onGoing,
      PgsStatus.completed,
    ];

    final Map<PgsStatus, Color> statusColors = {
      PgsStatus.notStarted: Colors.grey.shade700,

      PgsStatus.completed: Colors.green,
      PgsStatus.onGoing: Colors.deepOrange,
    };

    List<Widget> buildStatusRows() {
      List<Widget> rows = [];
      for (int i = 0; i < statusesToDisplay.length; i += 3) {
        final status1 = statusesToDisplay[i];
        final status2 =
            (i + 1 < statusesToDisplay.length)
                ? statusesToDisplay[i + 1]
                : null;
        final status3 =
            (i + 2 < statusesToDisplay.length)
                ? statusesToDisplay[i + 2]
                : null;
        final int totalCount = statusesToDisplay.fold(
          0,
          (sum, status) => sum + getCount(status),
        );

        rows.add(
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getStatusLabel(status1),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: statusColors[status1] ?? Colors.black,
                      ),
                    ),

                    Text(
                      totalCount > 0
                          ? "${((getCount(status1) / totalCount) * 100).toStringAsFixed(0)}% (${getCount(status1)})"
                          : "0% (0)",
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
              // Status 2
              Expanded(
                child:
                    status2 != null
                        ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getStatusLabel(status2),
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: statusColors[status2] ?? Colors.black,
                              ),
                            ),
                            Text(
                              totalCount > 0
                                  ? "${((getCount(status2) / totalCount) * 100).toStringAsFixed(0)}% (${getCount(status2)})"
                                  : "0% (0)",
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ],
                        )
                        : Container(),
              ),

              Expanded(
                child:
                    status3 != null
                        ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getStatusLabel(status3),
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: statusColors[status3] ?? Colors.black,
                              ),
                            ),
                            Text(
                              totalCount > 0
                                  ? "${((getCount(status3) / totalCount) * 100).toStringAsFixed(0)}% (${getCount(status3)})"
                                  : "0% (0)",
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ],
                        )
                        : Container(),
              ),
            ],
          ),
        );
        rows.add(const SizedBox(height: 16));
      }
      return rows;
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: mainBgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "PGS Status",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ...buildStatusRows(),
                ],
              ),
            ),
            const SizedBox(width: 16),

            _buildPieChart(deliverablesList),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart(List<PgsDeliverables> deliverablesList) {
    final statusCounts = countStatuses(deliverablesList);

    final Map<PgsStatus, Color> statusColors = {
      PgsStatus.notStarted: Colors.grey.shade300,

      PgsStatus.onGoing: Colors.deepOrange,

      PgsStatus.completed: Colors.green,
    };

    final List<PgsStatus> statusesToDisplay = [
      PgsStatus.notStarted,
      PgsStatus.onGoing,
      PgsStatus.completed,
    ];

    final int totalCount = statusesToDisplay.fold(
      0,
      (sum, status) => sum + (statusCounts[status] ?? 0),
    );

    final sections =
        statusesToDisplay
            .map((status) {
              final count = statusCounts[status] ?? 0;
              final percentage =
                  totalCount > 0 ? (count / totalCount) * 100 : 0.0;
              if (count == 0) return null;

              return PieChartSectionData(
                color: statusColors[status],
                value: percentage,
                title: '${percentage.toStringAsFixed(0)}%',
                radius: 40,
                titleStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              );
            })
            .where((section) => section != null)
            .toList();

    return SizedBox(
      width: 200,
      height: 200,
      child: PieChart(
        PieChartData(
          centerSpaceRadius: 45,
          sectionsSpace: 3,
          sections: sections.cast<PieChartSectionData>(),
        ),
      ),
    );
  }
}

Widget buildDashboardBox(
  String title,
  Color color,
  String count,
  String iconAsset,
) {
  return Card(
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    child: Container(
      height: 130,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  count,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Image.asset(iconAsset),
            ),
          ),
        ],
      ),
    ),
  );
}

Map<PgsStatus, int> countStatuses(List<PgsDeliverables> deliverablesList) {
  final Map<PgsStatus, int> statusCounts = {};

  for (var deliverable in deliverablesList) {
    final status = deliverable.status;
    statusCounts[status] = (statusCounts[status] ?? 0) + 1;
  }

  return statusCounts;
}

String getStatusLabel(PgsStatus status) {
  switch (status) {
    case PgsStatus.notStarted:
      return "Not Started";
    case PgsStatus.completed:
      return "Completed";
    case PgsStatus.onGoing:
      return "On Going";
  }
}
