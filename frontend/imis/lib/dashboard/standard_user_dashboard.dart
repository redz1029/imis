import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/performance_governance_system/models/pgs_deliverables.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/widgets/dynamic_side_column.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import '../performance_governance_system/enum/pgs_status.dart';
import '../user/models/user_registration.dart';
import '../utils/auth_util.dart';

class StandardUserDashboard extends StatefulWidget {
  const StandardUserDashboard({super.key});

  @override
  StandardUserDashboardState createState() => StandardUserDashboardState();
}

class StandardUserDashboardState extends State<StandardUserDashboard> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<String> office = [];
  String firstName = "firstName";
  bool loading = true;
  List<PgsDeliverables> deliverablesList = [];
  final dio = Dio();

  @override
  void initState() {
    super.initState();
    _loadUserName();
    loadDeliverables();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadUserName() async {
    UserRegistration? user = await AuthUtil.fetchLoggedUser();

    if (user != null) {
      setState(() {
        final rawName = (user.firstName ?? "firstName").trim();

        firstName = rawName.toLowerCase().replaceFirstMapped(
          RegExp(r'^[a-z]'),
          (m) => m.group(0)!.toUpperCase(),
        );
      });
    }
  }

  Future<void> loadDeliverables() async {
    setState(() => deliverablesList = []);

    try {
      UserRegistration? user = await AuthUtil.fetchLoggedUser();
      if (user == null) return;

      final prefs = await SharedPreferences.getInstance();
      final String? selectedRoleName = prefs.getString('selectedRole');
      final roles = await AuthUtil.fetchRoles();

      if (roles == null || roles.isEmpty) return;

      var currentRole = roles.first;

      if (selectedRoleName != null) {
        try {
          currentRole = roles.firstWhere((r) => r.name == selectedRoleName);
        } catch (_) {
          // keep first
        }
      }

      final response = await AuthenticatedRequest.get(
        dio,
        "${ApiEndpoint().performancegovernancesystem}/user/${user.id}",
        queryParameters: {
          "roleId": currentRole.id,
          "page": 1,
          "pageSize": 10000,
        },
      );

      if (response.statusCode == 200) {
        final List data = response.data;

        final List<PgsDeliverables> allDeliverables =
            data
                .expand((item) => (item['pgsDeliverables'] as List))
                .map((d) => PgsDeliverables.fromJson(d))
                .toList();

        setState(() {
          deliverablesList = allDeliverables;
        });
      }
    } catch (e) {
      debugPrint("Error loading deliverables");
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
          const SizedBox(height: 16),
          _buildStatsRow(),
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
              _buildInfoCards(),
              const SizedBox(height: 24),
              _buildStatsRow(),
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
                                "Version 1.0.3 •  ${_formatDate(DateTime.now())}",
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
                Color.fromARGB(255, 167, 80, 101),
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
    int total = deliverablesList.length;
    int direct = deliverablesList.where((d) => d.isDirect).length;
    int indirect = deliverablesList.where((d) => !d.isDirect).length;
    int completed =
        deliverablesList.where((d) => d.status == PgsStatus.completed).length;
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isNarrow = constraints.maxWidth < 400;

        if (isNarrow) {
          return Column(
            children: [
              buildDashboardBox(
                title: "Total Deliverables",
                subtitle: office.join(', '),
                count: "$total",
                color: Colors.black,
                icon: Icons.show_chart,
              ),

              buildDashboardBox(
                title: "Direct Deliverables",
                count: "$direct",
                color: primaryColor,
                icon: Icons.directions_outlined,
                progress: total > 0 ? direct / total : 0,
              ),
              buildDashboardBox(
                title: "Indirect Deliverables",
                count: "$indirect",
                color: Colors.orange,
                icon: Icons.alt_route,
                progress: total > 0 ? indirect / total : 0,
              ),
              buildDashboardBox(
                title: "Total Deliverables",
                subtitle: "$completed of $total completed",
                count:
                    total > 0
                        ? "${((completed / total) * 100).toStringAsFixed(0)}%"
                        : "0%",
                color: Colors.green,
                icon: Icons.check_circle_outline,
              ),
            ],
          );
        } else {
          return Row(
            children: [
              Expanded(
                child: buildDashboardBox(
                  title: "Total Deliverables",
                  subtitle: office.join(', '),
                  count: "$total",
                  color: Colors.black,
                  icon: Icons.inventory_outlined,
                ),
              ),

              Expanded(
                child: buildDashboardBox(
                  title: "Direct Deliverables",
                  count: "$direct",
                  color: primaryColor,
                  icon: Icons.directions_outlined,
                  progress: total > 0 ? direct / total : 0,
                ),
              ),

              Expanded(
                child: buildDashboardBox(
                  title: "Indirect Deliverables",
                  count: "$indirect",
                  color: Colors.orange,
                  icon: Icons.alt_route,
                  progress: total > 0 ? indirect / total : 0,
                ),
              ),

              Expanded(
                child: buildDashboardBox(
                  title: "Completion Rate",
                  subtitle: "$completed of $total completed",
                  count:
                      total > 0
                          ? "${((completed / total) * 100).toStringAsFixed(0)}%"
                          : "0%",
                  color: Colors.green,
                  icon: Icons.check_circle_outline,
                ),
              ),
            ],
          );
        }
      },
    );
  }
}

Widget buildDashboardBox({
  required String title,
  required String count,
  String? subtitle,
  required Color color,
  required IconData icon,
  double? progress,
}) {
  return Card(
    color: mainBgColor,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: Colors.grey.shade300, width: 1),
    ),
    child: Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 160),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color.fromARGB(129, 0, 0, 0),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: 12),

          Text(
            count,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),

          if (progress != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey.shade300,
                    color: color,
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "${(progress * 100).toStringAsFixed(1)}%",
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ],

          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ],
      ),
    ),
  );
}
