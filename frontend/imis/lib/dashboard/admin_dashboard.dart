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
import 'package:imis/widgets/help_assistant/help_chat_widget.dart.dart';
import 'package:imis/widgets/home/dashboard_widget.dart';
import 'package:imis/widgets/home/dynamic_side_column.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

const double _kRadiusLg = 16;
const double _kRadiusMd = 14;
const double _kRadiusSm = 12;

const EdgeInsets _kCardPad = EdgeInsets.symmetric(horizontal: 18, vertical: 16);
const EdgeInsets _kSectionPad = EdgeInsets.all(22);

BoxDecoration _surfaceCard({Color? borderColor}) {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(_kRadiusMd),
    border: Border.all(color: borderColor ?? Colors.grey.shade100, width: 1),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.03),
        blurRadius: 12,
        offset: const Offset(0, 2),
      ),
    ],
  );
}

BoxDecoration _tintedCard(Color accent) {
  return BoxDecoration(
    color: kBackground,
    borderRadius: BorderRadius.circular(_kRadiusMd),
    border: Border.all(color: accent.withValues(alpha: 0.15)),
  );
}

TextStyle _sectionTitleStyle() => GoogleFonts.plusJakartaSans(
  fontSize: 18,
  fontWeight: FontWeight.w700,
  color: Colors.black87,
);

TextStyle _sectionSubtitleStyle() =>
    GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey.shade500);

TextStyle _cardLabelStyle() => GoogleFonts.plusJakartaSans(
  fontSize: 12,
  fontWeight: FontWeight.w500,
  color: Colors.grey.shade600,
);

TextStyle _cardValueStyle({Color color = Colors.black87, double size = 22}) =>
    GoogleFonts.plusJakartaSans(
      fontSize: size,
      fontWeight: FontWeight.w800,
      color: color,
    );

int _niceCeiling(int value) {
  if (value <= 10) return value + 1;
  final digits = value.toString().length;
  final magnitude = math.pow(10, digits - 1).toInt();
  final step = (magnitude / 2).clamp(1, magnitude).toInt();
  return ((value / step).ceil()) * step;
}

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

  final GlobalKey _leftColumnKey = GlobalKey();
  double? _leftColumnHeight;
  final GlobalKey _statsHeaderKey = GlobalKey();

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

  void _syncLeftColumnHeight() {
    final renderObject = _leftColumnKey.currentContext?.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) return;
    final newHeight = renderObject.size.height;
    if (_leftColumnHeight == null ||
        (newHeight - _leftColumnHeight!).abs() > 1) {
      if (mounted) setState(() => _leftColumnHeight = newHeight);
    }
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
        await _fetchStatistics(
          selectedStatsPeriod!.id,
          parentOfficeId: selectedService?.id,
        );
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
    setState(() => isLoadingStatistics = true);
    try {
      final roleIdParam = await _getRoleId();
      final officeParam =
          parentOfficeId != null ? '&parentOfficeId=$parentOfficeId' : '';
      final results = await Future.wait([
        AuthenticatedRequest.get(
          dio,
          '${ApiEndpoint.baseUrl}/dashboard/total-offices-count-deliverables-standarduser?roleId=$roleIdParam&pgsPeriodId=$pgsPeriodId$officeParam',
        ),
        AuthenticatedRequest.get(
          dio,
          '${ApiEndpoint.baseUrl}/dashboard/audit-status-count-deliverables-standarduser?roleId=$roleIdParam&pgsPeriodId=$pgsPeriodId$officeParam',
        ),
      ]);

      if (!mounted) return;

      final officesData = results[0].data;
      final auditData = results[1].data;

      setState(() {
        statTotalOffices =
            officesData['totalNoOffice'] ?? officesData['totalOffices'] ?? 0;
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
      });
    } catch (e) {
      debugPrint('fetchStatistics error: $e');
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
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _syncLeftColumnHeight(),
    );
    return Scaffold(
      backgroundColor: kBackground,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(child: _buildMainLayout()),
          ),
          const HelpChatWidget(),
        ],
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
          _welcomeCard(),
          const SizedBox(height: 16),
          _buildStatsRow(),
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
          child: Container(
            key: _leftColumnKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _welcomeCard(),
                const SizedBox(height: 16),
                _buildStatsRow(),
                const SizedBox(height: 16),
                _buildStatisticsSection(),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 290,
          height: _leftColumnHeight,
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

  Widget _welcomeCard() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isNarrow = constraints.maxWidth < 500;
        final greetingBlock = Column(
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
              "Welcome to CPeMS - Centralized Performance Electronic Management System! "
              "Together, we track progress and build a culture of accountability and continuous improvement.",
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ],
        );

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 150, 68, 89),
                Color.fromARGB(255, 180, 91, 112),
                Color.fromARGB(255, 190, 100, 120),
              ],
            ),
            borderRadius: BorderRadius.circular(_kRadiusLg),
          ),
          child:
              isNarrow
                  ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      greetingBlock,
                      const SizedBox(height: 14),
                      Center(
                        child: Image.asset('assets/image1.png', height: 180),
                      ),
                    ],
                  )
                  : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: greetingBlock),
                      const SizedBox(width: 16),
                      Image.asset('assets/image1.png', height: 140),
                    ],
                  ),
        );
      },
    );
  }

  Widget _buildStatsRow() {
    final stats = [
      StatItem(
        label: "Total Users",
        count: totalUsers.toString(),
        icon: Icons.people_alt_outlined,
        color: primaryColor,
      ),
      StatItem(
        label: "Total Auditors",
        count: totalAuditor.toString(),
        icon: Icons.verified_user_outlined,
        color: primaryColor,
      ),
      StatItem(
        label: "Total Teams",
        count: totalTeam.toString(),
        icon: Icons.groups_2_outlined,
        color: primaryColor,
      ),
      StatItem(
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
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.8,
            ),
            itemCount: stats.length,
            itemBuilder: (context, index) => _buildStatCard(stats[index]),
          );
        }
        return Row(
          children:
              stats
                  .map(
                    (s) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: _buildStatCard(s),
                      ),
                    ),
                  )
                  .toList(),
        );
      },
    );
  }

  Widget _buildStatCard(StatItem item) {
    return Container(
      height: 110,
      clipBehavior: Clip.antiAlias,
      decoration: _surfaceCard(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left accent strip — quick color cue per metric, matches the
          // stat's icon color so the card reads faster at a glance.
          Container(width: 4, color: item.color),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(item.count, style: _cardValueStyle(size: 26)),
                        const SizedBox(height: 6),
                        Text(item.label, style: _cardLabelStyle()),
                      ],
                    ),
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: item.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(_kRadiusSm),
                    ),
                    child: Icon(item.icon, color: item.color, size: 22),
                  ),
                ],
              ),
            ),
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

  Widget _buildStatisticsSection() {
    return Container(
      padding: _kSectionPad,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(_kRadiusLg),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child:
          isLoadingStatistics
              ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: CircularProgressIndicator(color: primaryColor),
                ),
              )
              : _buildAuditStatisticsColumn(),
    );
  }

  Widget _buildAuditStatisticsColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          key: _statsHeaderKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Performance Overview", style: _sectionTitleStyle()),
              const SizedBox(height: 2),
              Text(
                "Overview of performance statistics for the selected period",
                style: _sectionSubtitleStyle(),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _buildServiceDropdownPill(),
                  _buildPeriodDropdownPill(),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 850;

            if (isNarrow) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDeliverableStatCards(),
                  const SizedBox(height: 16),
                  _buildDeliverableStatusChart(),
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 5, child: _buildDeliverableStatCards()),
                const SizedBox(width: 18),
                Expanded(
                  flex: 5,
                  child: _buildDeliverableStatusChart(chartHeight: 460),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildDeliverableStatCards() {
    final double auditRate =
        totalDeliverables > 0
            ? (statTotalAudited / totalDeliverables).clamp(0.0, 1.0)
            : 0.0;

    return Column(
      children: [
        _deliverableStatCard(
          BarEntry(
            "Total Offices that Produced Deliverables",
            statTotalOffices,
            Icons.apartment_outlined,
            Colors.purple,
          ),
        ),
        const SizedBox(height: 12),
        _buildTotalDeliverablesCard(),
        const SizedBox(height: 16),
        _buildAuditDonut(auditRate),
      ],
    );
  }

  Widget _buildAuditDonut(double rate) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kBackground,
        borderRadius: BorderRadius.circular(_kRadiusMd),
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
                  painter: DonutPainter(
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
                        Text("Audited", style: _sectionSubtitleStyle()),
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
                "${(totalDeliverables - statTotalAudited).clamp(0, totalDeliverables == 0 ? 0 : totalDeliverables)} Pending",
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

  Widget _buildTotalDeliverablesCard() {
    final breakdown = <(String, double, Color)>[
      ("Not Started", percentNotStarted, Colors.redAccent),
      ("On Going", percentInProgress, Colors.orange.shade300),
      ("Completed", percentCompleted, kSuccess),
    ];

    return Container(
      padding: _kCardPad,
      decoration: _tintedCard(kAccent),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: kAccent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(_kRadiusSm),
                ),
                child: const Icon(
                  Icons.assignment_turned_in_outlined,
                  color: kAccent,
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Total Deliverables", style: _cardLabelStyle()),
                    const SizedBox(height: 4),
                    Text(
                      totalDeliverables.toString(),
                      style: _cardValueStyle(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: kAccent.withValues(alpha: 0.1), height: 1),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 380;
              final blocks =
                  breakdown
                      .map((b) => _breakdownBlock(b.$1, b.$2, b.$3))
                      .toList();

              if (isNarrow) {
                return Wrap(spacing: 20, runSpacing: 14, children: blocks);
              }
              return Row(
                children: blocks.map((b) => Expanded(child: b)).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _breakdownBlock(String label, double percent, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "${percent.toStringAsFixed(0)}%",
          style: _cardValueStyle(color: color),
        ),
        const SizedBox(height: 4),
        Text(label, style: _cardLabelStyle()),
      ],
    );
  }

  Widget _deliverableStatCard(BarEntry entry) {
    return Container(
      padding: _kCardPad,
      decoration: _tintedCard(entry.color),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: entry.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(_kRadiusSm),
            ),
            child: Icon(entry.icon, color: entry.color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.label, style: _cardLabelStyle()),
                const SizedBox(height: 4),
                Text(entry.value.toString(), style: _cardValueStyle()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodDropdownPill() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 220),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: primaryColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(_kRadiusSm),
          border: Border.all(color: primaryColor.withValues(alpha: 0.35)),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<PgsPeriod>(
            value: selectedStatsPeriod,
            isExpanded: true,
            isDense: true,
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
            },
          ),
        ),
      ),
    );
  }

  Widget _buildServiceDropdownPill() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 220),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: primaryColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(_kRadiusSm),
          border: Border.all(color: primaryColor.withValues(alpha: 0.35)),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<Office?>(
            value: selectedService,
            isExpanded: true,
            isDense: true,
            icon: Icon(Icons.expand_more, size: 18, color: primaryColor),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: primaryColor,
            ),
            hint: Text(
              isLoadingServices ? "Loading services..." : "Select Service",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
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
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDeliverableStatusChart({double chartHeight = 240}) {
    final entries = [
      ChartBarEntry("Not Started", statNotStarted, Colors.redAccent),
      ChartBarEntry("On Going", statOngoing, Colors.orange.shade300),
      ChartBarEntry("Completed", countCompleted, kSuccess),
      ChartBarEntry("Audited", statTotalAudited, blue),
    ];

    final rawMax = entries
        .map((e) => e.value)
        .fold<int>(0, (prev, e) => e > prev ? e : prev);
    final maxValue = _niceCeiling(rawMax).clamp(1, 999999);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kBackground,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
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
            children: entries.map((e) => _legendDot(e.color, e.label)).toList(),
          ),
          const SizedBox(height: 20),

          SizedBox(
            height: chartHeight,
            child: GridChart(entries: entries, maxValue: maxValue),
          ),
        ],
      ),
    );
  }
}
