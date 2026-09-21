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
import 'package:imis/widgets/home/dashboard_widget.dart';
import 'package:imis/widgets/home/dynamic_side_column.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class _StatsSummary {
  final int totalDeliverables;
  final int totalOffices;
  final int totalAudited;
  final int notStarted;
  final int ongoing;
  final int completed;
  final double percentCompleted;
  final double percentInProgress;
  final double percentNotStarted;
  final bool isLoading;

  const _StatsSummary({
    this.totalDeliverables = 0,
    this.totalOffices = 0,
    this.totalAudited = 0,
    this.notStarted = 0,
    this.ongoing = 0,
    this.completed = 0,
    this.percentCompleted = 0,
    this.percentInProgress = 0,
    this.percentNotStarted = 0,
    this.isLoading = false,
  });
}

class StandardUserDashboard extends StatefulWidget {
  const StandardUserDashboard({super.key});

  @override
  StandardUserDashboardState createState() => StandardUserDashboardState();
}

class StandardUserDashboardState extends State<StandardUserDashboard> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<PgsDeliverables> deliverablesList = [];
  List<PgsDeliverables> filteredDeliverables = [];

  List<PgsPeriod> statsPeriodList = [];
  PgsPeriod? selectedStatsPeriod;

  // --- Service filter (new) ---
  List<Office> serviceList = [];
  Office? selectedService;
  bool isLoadingServices = false;

  bool isLoadingStatistics = false;
  int statTotalOffices = 0;
  int statTotalAudited = 0;
  int statOngoing = 0;
  int statNotStarted = 0;

  int countAudited = 0;
  int countCompleted = 0;
  int countInProgress = 0;
  int countNotStarted = 0;
  double percentCompleted = 0;
  double percentInProgress = 0;
  double percentNotStarted = 0;
  int totalDeliverables = 0;

  bool isLoadingMyStatistics = false;
  int myTotalOffices = 0;
  int myTotalAudited = 0;
  int myOngoing = 0;
  int myNotStarted = 0;
  int myCompleted = 0;
  int myTotalDeliverables = 0;
  double myPercentCompleted = 0;
  double myPercentInProgress = 0;
  double myPercentNotStarted = 0;

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
    _loadServices();
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

  Future<void> _loadServices() async {
    setState(() => isLoadingServices = true);
    try {
      final services = await _commonService.fetchService();
      if (!mounted) return;
      setState(() {
        serviceList = services;
        isLoadingServices = false;
      });
    } catch (e) {
      debugPrint('fetchService error: $e');
      if (mounted) setState(() => isLoadingServices = false);
    }
  }

  Future<void> _loadStatisticsPeriods() async {
    try {
      final periods = await _commonService.fetchPgsPeriod();

      PgsPeriod? activePeriod;

      for (final p in periods) {
        if (p.isActive == true) {
          activePeriod = p;
          break;
        }
      }

      if (!mounted) return;

      setState(() {
        statsPeriodList = periods;
        selectedStatsPeriod =
            activePeriod ?? (periods.isNotEmpty ? periods.first : null);
      });

      if (selectedStatsPeriod != null) {
        await Future.wait([
          _fetchStatistics(
            selectedStatsPeriod!.id,
            parentOfficeId: selectedService?.id,
          ),
          _fetchMyStatistics(
            selectedStatsPeriod!.id,
            parentOfficeId: selectedService?.id,
          ),
        ]);
      }
    } catch (e) {
      debugPrint(e.toString());
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

  Future<void> _fetchStatistics(int pgsPeriodId, {int? parentOfficeId}) async {
    // NOTE: This endpoint (dashboardTotalOffices + dashboardAuditStatus,
    // scoped by roleId) turns out to return the CURRENT USER's own
    // (personal) numbers — not org-wide — so its results now feed the
    // "My Statistics" panel (my* fields), not the "Overall" panel.
    setState(() => isLoadingMyStatistics = true);
    try {
      final roleIdParam = await _getRoleId();
      final officeParam =
          parentOfficeId != null ? '&parentOfficeId=$parentOfficeId' : '';
      final results = await Future.wait([
        AuthenticatedRequest.get(
          dio,
          '${ApiEndpoint().dashboardTotalOffices}?roleid=$roleIdParam&pgsPeriodId=$pgsPeriodId$officeParam',
        ),
        AuthenticatedRequest.get(
          dio,
          '${ApiEndpoint().dashboardAuditStatus}?roleid=$roleIdParam&pgsPeriodId=$pgsPeriodId$officeParam',
        ),
      ]);

      if (!mounted) return;

      final auditData = results[1].data;

      setState(() {
        myTotalOffices = results[0].data['totalNoOffice'] ?? 0;
        isLoadingMyStatistics = false;

        myTotalAudited = auditData['countAudited'] ?? 0;
        myNotStarted = auditData['countNotStarted'] ?? 0;
        myTotalDeliverables = auditData['totalDeliverables'] ?? 0;
        myCompleted = auditData['countCompleted'] ?? 0;
        myOngoing = auditData['countInProgress'] ?? 0;

        myPercentCompleted =
            (auditData['percentCompleted'] as num?)?.toDouble() ?? 0;
        myPercentInProgress =
            (auditData['percentInProgress'] as num?)?.toDouble() ?? 0;
        myPercentNotStarted =
            (auditData['percentNotStarted'] as num?)?.toDouble() ?? 0;
      });
    } catch (e) {
      debugPrint('fetchStatistics error: $e');
      if (mounted) setState(() => isLoadingMyStatistics = false);
    }
  }

  Future<void> _fetchMyStatistics(
    int pgsPeriodId, {
    int? parentOfficeId,
  }) async {
    setState(() => isLoadingStatistics = true);
    try {
      final roleIdParam = await _getRoleId();
      final officeParam =
          parentOfficeId != null ? '&parentOfficeId=$parentOfficeId' : '';

      final results = await Future.wait([
        AuthenticatedRequest.get(
          dio,
          '${ApiEndpoint.baseUrl}/dashboard/audit-status-count-deliverables-standarduser?roleId=$roleIdParam&pgsPeriodId=$pgsPeriodId$officeParam',
        ),
        AuthenticatedRequest.get(
          dio,
          '${ApiEndpoint.baseUrl}/dashboard/total-offices-count-deliverables-standarduser?roleId=$roleIdParam&pgsPeriodId=$pgsPeriodId$officeParam',
        ),
      ]);

      if (!mounted) return;

      final auditData = results[0].data;
      final officesData = results[1].data;

      setState(() {
        isLoadingStatistics = false;

        countAudited = auditData['countAudited'] ?? 0;
        countNotStarted = auditData['countNotStarted'] ?? 0;
        totalDeliverables = auditData['totalDeliverables'] ?? 0;
        countCompleted = auditData['countCompleted'] ?? 0;
        countInProgress = auditData['countInProgress'] ?? 0;

        percentCompleted =
            (auditData['percentCompleted'] as num?)?.toDouble() ?? 0;
        percentInProgress =
            (auditData['percentInProgress'] as num?)?.toDouble() ?? 0;
        percentNotStarted =
            (auditData['percentNotStarted'] as num?)?.toDouble() ?? 0;

        statTotalAudited = countAudited;
        statNotStarted = countNotStarted;
        statOngoing = countInProgress;

        // Adjust the key below to match the actual field name your
        // total-offices-count-deliverables-standarduser response uses.
        statTotalOffices =
            officesData['totalNoOffice'] ?? officesData['totalOffices'] ?? 0;
      });
    } catch (e) {
      debugPrint('fetchMyStatistics error: $e');
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 100 || constraints.maxHeight < 100) {
                return const SizedBox.shrink();
              }
              return SingleChildScrollView(child: _buildMainLayout());
            },
          ),
        ),
      ),
    );
  }

  Widget _percentStatBox({
    required String label,
    required double percent,
    required int count,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, color: color, size: 12),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                "${percent.toStringAsFixed(0)}%",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                "($count)",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainLayout() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final bool isMobile = width < 900;

        if (isMobile) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcome(),
              const SizedBox(height: 16),
              _buildStatisticsSection(),
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
                children: [_buildWelcome(), gap6px, _buildStatisticsSection()],
              ),
            ),
            const SizedBox(width: 6),
            SizedBox(
              width: math.min(290.0, width * 0.32).clamp(180.0, 290.0),
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
      },
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
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: constraints.maxWidth * 0.7,
                            maxHeight: 200,
                          ),
                          child: Image.asset(
                            'assets/image1.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  )
                  : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                      Flexible(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 220,
                            maxHeight: 150,
                          ),
                          child: Image.asset(
                            'assets/image1.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
        );
      },
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

  _StatsSummary get _myStats => _StatsSummary(
    totalDeliverables: myTotalDeliverables,
    totalOffices: myTotalOffices,
    totalAudited: myTotalAudited,
    notStarted: myNotStarted,
    ongoing: myOngoing,
    completed: myCompleted,
    percentCompleted: myPercentCompleted,
    percentInProgress: myPercentInProgress,
    percentNotStarted: myPercentNotStarted,
    isLoading: isLoadingMyStatistics,
  );

  _StatsSummary get _overallStats => _StatsSummary(
    totalDeliverables: totalDeliverables,
    totalOffices: statTotalOffices,
    totalAudited: statTotalAudited,
    notStarted: statNotStarted,
    ongoing: statOngoing,
    completed: countCompleted,
    percentCompleted: percentCompleted,
    percentInProgress: percentInProgress,
    percentNotStarted: percentNotStarted,
    isLoading: isLoadingStatistics,
  );

  Widget _buildStatisticsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 560;

              final titleBlock = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Statistics Overview",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    "Personal and organization-wide numbers, side by side",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              );

              final controls = Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _buildServiceDropdownPill(),
                  _buildPeriodDropdownPill(),
                ],
              );

              if (isNarrow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [titleBlock, const SizedBox(height: 10), controls],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: titleBlock),
                  const SizedBox(width: 12),
                  controls,
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.grey.shade100, height: 1),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 900;

              final myPanel = _buildStatsPanel(
                title: "My Statistics",
                badgeLabel: "PERSONAL",
                description: "Your deliverables for the selected period",
                data: _myStats,
                isMine: true,
                accentColor: kPersonalAccentColor,
                icon: Icons.person_outline,
              );
              final overallPanel = _buildStatsPanel(
                title: "Overall Statistics",
                badgeLabel: "ORG-WIDE",
                description: "Statistics for the selected period",
                data: _overallStats,
                isMine: false,
                accentColor: primaryColor,
                icon: Icons.corporate_fare_outlined,
              );

              if (isWide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: myPanel),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 20),
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(color: Colors.grey.shade200),
                          ),
                        ),
                        child: overallPanel,
                      ),
                    ),
                  ],
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  myPanel,
                  const SizedBox(height: 20),
                  Divider(color: Colors.grey.shade200, height: 1),
                  const SizedBox(height: 20),
                  overallPanel,
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatsPanel({
    required String title,
    required String badgeLabel,
    required String description,
    required _StatsSummary data,
    required bool isMine,
    required Color accentColor,
    required IconData icon,
  }) {
    final double auditRate =
        data.totalDeliverables > 0
            ? (data.totalAudited / data.totalDeliverables).clamp(0.0, 1.0)
            : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: accentColor, size: 14),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6,
                    runSpacing: 2,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          badgeLabel,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                            color: accentColor,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 1),
                  Text(
                    description,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        if (data.isLoading)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: accentColor,
                ),
              ),
            ),
          )
        else ...[
          _buildCompactMetricCards(data, isMine, accentColor),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 520;
              final chart = _buildCompactStatusChart(data, accentColor);
              final donut = _buildCompactDonut(auditRate, data, accentColor);

              if (isNarrow) {
                return Column(
                  children: [chart, const SizedBox(height: 12), donut],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 7, child: chart),
                  const SizedBox(width: 12),
                  Expanded(flex: 3, child: donut),
                ],
              );
            },
          ),
        ],
      ],
    );
  }

  Widget _buildCompactMetricCards(
    _StatsSummary data,
    bool isMine,
    Color accentColor,
  ) {
    final entries = [
      BarEntry(
        isMine ? "My Deliverables" : "Total Deliverables",
        data.totalDeliverables,
        Icons.assignment_turned_in_outlined,
        accentColor,
      ),
      BarEntry(
        isMine ? "My Offices with Deliverables" : "Offices with Deliverables",
        data.totalOffices,
        Icons.apartment_outlined,
        blue,
      ),
      BarEntry(
        "Audited",
        data.totalAudited,
        Icons.fact_check_outlined,
        Colors.purple.shade300,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool tooNarrow = constraints.maxWidth < 340;

        if (tooNarrow) {
          return Column(
            children:
                entries
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _compactMetricCard(e),
                      ),
                    )
                    .toList(),
          );
        }

        return Row(
          children:
              entries.asMap().entries.map((e) {
                final isLast = e.key == entries.length - 1;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: isLast ? 0 : 8),
                    child: _compactMetricCard(e.value),
                  ),
                );
              }).toList(),
        );
      },
    );
  }

  Widget _compactMetricCard(BarEntry entry) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: kBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: entry.color.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: entry.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(entry.icon, color: entry.color, size: 14),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  entry.value.toString(),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  entry.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
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
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 200),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: primaryColor.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<PgsPeriod>(
            value: selectedStatsPeriod,
            isExpanded: true,
            isDense: true,
            icon: Icon(Icons.expand_more, size: 16, color: primaryColor),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: primaryColor,
            ),
            hint: Text(
              "Select Period",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: primaryColor,
              ),
            ),
            items:
                statsPeriodList.map((period) {
                  return DropdownMenuItem<PgsPeriod>(
                    value: period,
                    child: Text(
                      _formatPeriodLabel(period),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  );
                }).toList(),
            onChanged: (period) {
              if (period == null) return;
              setState(() => selectedStatsPeriod = period);
              _fetchStatistics(period.id, parentOfficeId: selectedService?.id);
              _fetchMyStatistics(
                period.id,
                parentOfficeId: selectedService?.id,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildServiceDropdownPill() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 200),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: primaryColor.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<Office?>(
            value: selectedService,
            isExpanded: true,
            isDense: true,
            icon: Icon(Icons.expand_more, size: 16, color: primaryColor),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: primaryColor,
            ),
            hint: Text(
              isLoadingServices ? "Loading services..." : "Select Service",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: primaryColor,
              ),
            ),
            items: [
              DropdownMenuItem<Office?>(
                value: null,
                child: Text(
                  "All Services",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              ...serviceList.map((service) {
                return DropdownMenuItem<Office?>(
                  value: service,
                  child: Text(
                    service.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                );
              }),
            ],
            onChanged: (service) {
              setState(() => selectedService = service);
              if (selectedStatsPeriod == null) return;

              _fetchStatistics(
                selectedStatsPeriod!.id,
                parentOfficeId: service?.id,
              );
              _fetchMyStatistics(
                selectedStatsPeriod!.id,
                parentOfficeId: service?.id,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCompactDonut(
    double rate,
    _StatsSummary data,
    Color accentColor,
  ) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 260),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: kBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: accentColor.withValues(alpha: 0.12)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Audit Completion",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 14),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: rate),
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return SizedBox(
                  width: 110,
                  height: 110,
                  child: CustomPaint(
                    painter: DonutPainter(
                      progress: value,
                      progressColor: accentColor,
                      backgroundColor: Colors.grey.shade200,
                      strokeWidth: 10,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${(value * 100).toStringAsFixed(0)}%",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            "Audited",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 8,
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
            const SizedBox(height: 14),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              runSpacing: 6,
              children: [
                _legendDot(accentColor, "${data.totalAudited} Audited"),
                _legendDot(
                  Colors.grey.shade300,
                  "${(data.totalDeliverables - data.totalAudited).clamp(0, data.totalDeliverables == 0 ? 0 : data.totalDeliverables)} Pending",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 9,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildCompactStatusChart(_StatsSummary data, Color accentColor) {
    final entries = [
      ChartBarEntry("Not Started", data.notStarted, Colors.redAccent),
      ChartBarEntry("On Going", data.ongoing, Colors.orange.shade300),
      ChartBarEntry("Completed", data.completed, kSuccess),
      ChartBarEntry("Audited", data.totalAudited, Colors.purple.shade300),
    ];

    final maxValue = entries
        .map((e) => e.value)
        .fold<int>(0, (prev, e) => e > prev ? e : prev)
        .clamp(1, 999999);

    final double audiedPercent =
        data.totalDeliverables > 0
            ? (data.totalAudited / data.totalDeliverables) * 100
            : 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Deliverable Statistics",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),

          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 420;
              final boxes = [
                _percentStatBox(
                  label: "Not Started",
                  percent: data.percentNotStarted,
                  count: data.notStarted,
                  color: Colors.redAccent,
                  icon: Icons.pause_circle_outline,
                ),
                _percentStatBox(
                  label: "On Going",
                  percent: data.percentInProgress,
                  count: data.ongoing,
                  color: Colors.orange.shade400,
                  icon: Icons.autorenew,
                ),
                _percentStatBox(
                  label: "Completed",
                  percent: data.percentCompleted,
                  count: data.completed,
                  color: kSuccess,
                  icon: Icons.check_circle_outline,
                ),
                _percentStatBox(
                  label: "Audited",
                  percent: audiedPercent,
                  count: data.totalAudited,
                  color: Colors.purple.shade300,
                  icon: Icons.fact_check_outlined,
                ),
              ];

              if (isNarrow) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: boxes[0]),
                        const SizedBox(width: 8),
                        Expanded(child: boxes[1]),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: boxes[2]),
                        const SizedBox(width: 8),
                        Expanded(child: boxes[3]),
                      ],
                    ),
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(child: boxes[0]),
                  const SizedBox(width: 8),
                  Expanded(child: boxes[1]),
                  const SizedBox(width: 8),
                  Expanded(child: boxes[2]),
                  const SizedBox(width: 8),
                  Expanded(child: boxes[3]),
                ],
              );
            },
          ),

          const SizedBox(height: 16),
          SizedBox(
            height: 150,
            child: GridChart(
              entries: entries,
              maxValue: maxValue,
              barAreaHeight: 84,
              barWidth: 18,
            ),
          ),
        ],
      ),
    );
  }
}
