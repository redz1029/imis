import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/common_services/common_service.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/office/models/office.dart';
import 'package:imis/performance_governance_system/pgs_period/models/pgs_period.dart';
import 'package:imis/performance_governance_system/models/pgs_deliverables.dart';
import 'package:imis/user/models/user_registration.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/auth_util.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/widgets/home/dashboard_widget.dart';
import 'package:imis/widgets/home/dynamic_side_column.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class OfficerDashboard extends StatefulWidget {
  const OfficerDashboard({super.key});

  @override
  OfficerDashboardState createState() => OfficerDashboardState();
}

class OfficerDashboardState extends State<OfficerDashboard> {
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
  // int statTotalDeliverables = 0;
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

  List<String> office = [];
  String firstName = "firstName";
  final dio = Dio();

  final _commonService = CommonService(Dio());

  @override
  void initState() {
    super.initState();
    loadUserNames();
    _loadStatisticsPeriods();
    _loadServices();
  }

  @override
  void dispose() {
    super.dispose();
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

      final auditData = results[1].data;

      setState(() {
        statTotalOffices = results[0].data['totalNoOffice'] ?? 0;
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

        // these were never assigned before — root cause ng blangkong chart
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
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
    final double auditRate =
        totalDeliverables > 0
            ? (statTotalAudited / totalDeliverables).clamp(0.0, 1.0)
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
            LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 480;

                final titleBlock = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
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
                    children: [
                      titleBlock,
                      const SizedBox(height: 10),
                      Align(alignment: Alignment.centerLeft, child: controls),
                    ],
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
      BarEntry(
        "Total Deliverables",
        totalDeliverables,
        Icons.assignment_turned_in_outlined,
        primaryColor,
      ),
      BarEntry(
        "Total Offices that Produced Deliverables",
        statTotalOffices,
        Icons.apartment_outlined,
        Colors.blue.shade400,
      ),
      BarEntry(
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

  Widget _deliverableStatCard(BarEntry entry) {
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
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 220),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
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

  /// "Select Service" filter pill — same pattern as StandardUserDashboard.
  /// Filters the audit statistics by parentOfficeId; null means "All Services".
  Widget _buildServiceDropdownPill() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 220),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
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

  Widget _buildDeliverableStatusChart() {
    final entries = [
      ChartBarEntry("Not Started", statNotStarted, Colors.redAccent),
      ChartBarEntry("On Going", statOngoing, Colors.orange.shade300),
      ChartBarEntry("Completed", countCompleted, Colors.green.shade400),
      ChartBarEntry("Audited", statTotalAudited, Colors.purple.shade200),
    ];

    final maxValue = entries
        .map((e) => e.value)
        .fold<int>(0, (prev, e) => e > prev ? e : prev)
        .clamp(1, 999999);

    final total = statNotStarted + statOngoing + countCompleted;
    final double notStartedPct = percentNotStarted;
    final double inProgressPct = percentInProgress;
    final double completedPct = percentCompleted;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 700;
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
          summaryCard("Not Started (%)", notStartedPct, Colors.redAccent),
          summaryCard("On Going (%)", inProgressPct, Colors.orange.shade300),
          summaryCard("Completed (%)", completedPct, Colors.green.shade400),
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
                child: GridChart(entries: entries, maxValue: maxValue),
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
}
