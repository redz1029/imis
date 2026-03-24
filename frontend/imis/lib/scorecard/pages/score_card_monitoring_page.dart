// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/constant/permissions.dart';
import 'package:imis/performance_governance_system/process_core_support/models/key_result_area.dart';
import 'package:imis/performance_governance_system/models/pgs_deliverable_score_history.dart';
import 'package:imis/performance_governance_system/pgs_period/models/pgs_period.dart';
import 'package:imis/utils/permission_service.dart';
import 'package:imis/widgets/no_permission_widget.dart';
import 'package:imis/widgets/permission_widget.dart';
import 'package:imis/widgets/scorecard_monitoring_accomplishment_widget.dart';
import 'package:imis/scorecard/services/score_card_monitoring_services.dart';
import 'package:imis/constant/constant.dart';
import 'package:motion_toast/motion_toast.dart';
import '../../../common_services/common_service.dart';
import '../../../user/models/user_registration.dart';
import '../../../utils/auth_util.dart';
import '../../widgets/total_score_indicator.dart';

class ScoreCardMonitoringPage extends StatefulWidget {
  const ScoreCardMonitoringPage({super.key});

  @override
  State<ScoreCardMonitoringPage> createState() =>
      _ScoreCardMonitoringPageState();
}

class _ScoreCardMonitoringPageState extends State<ScoreCardMonitoringPage> {
  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();
  final ScrollController _headerHorizontalController = ScrollController();
  final ScrollController _kraScrollController = ScrollController();
  final ScrollController _kpiScrollController = ScrollController();

  final dio = Dio();
  final _commonService = CommonService(Dio());
  final _scorecardService = ScoreCardMonitoringServices(Dio());
  final permissionService = PermissionService();

  List<Map<String, dynamic>> kpiList = [];
  List<Map<String, dynamic>> roadmapList = [];
  List<Map<String, dynamic>> filteredList = [];
  String userId = "";

  bool isMenuOpenStartYear = false;
  bool isMenuOpenEndYear = false;
  bool isMenuOpenKra = false;
  List<KeyResultArea> kraListOptions = [];
  int? selectedKra;
  List<PgsPeriod> periodList = [];
  int? selectedStartYear;
  int? selectedEndYear;
  String? selectedStartYearText;
  String? selectedEndYearText;
  bool isLoading = true;
  bool isAllYearsSelected = false;

  @override
  void initState() {
    super.initState();
    _headerHorizontalController.addListener(_syncHeaderScroll);
    _horizontalController.addListener(_syncBodyScroll);

    () async {
      setState(() => isLoading = true);

      final period = await _commonService.fetchPgsPeriod();
      final kra = await _commonService.fetchKra();

      List<Map<String, dynamic>> roadmapData = [];
      List<Map<String, dynamic>> kpiData = [];
      try {
        roadmapData = await _scorecardService.fetchRoadmapFiltered(
          kraId: selectedKra,
          fromYear: selectedStartYear,
          toYear: selectedEndYear,
        );
        kpiData = await _scorecardService.fetchKpiFiltered(kraId: selectedKra);
      } catch (e) {
        debugPrint("Error preloading roadmap/KPI");
      }

      await _loadCurrentUserId();

      if (!mounted) return;

      setState(() {
        periodList = period;
        kraListOptions = kra;
        roadmapList = roadmapData;
        kpiList = kpiData;
        filteredList = List.from(roadmapData);
        isLoading = false;
      });
    }();
  }

  void _syncHeaderScroll() {
    if (_horizontalController.offset != _headerHorizontalController.offset) {
      _horizontalController.jumpTo(_headerHorizontalController.offset);
    }
  }

  void _syncBodyScroll() {
    if (_headerHorizontalController.offset != _horizontalController.offset) {
      _headerHorizontalController.jumpTo(_horizontalController.offset);
    }
  }

  Future<void> _loadCurrentUserId() async {
    UserRegistration? user = await AuthUtil.processTokenValidity(dio, context);
    setState(() => userId = user!.id ?? "UserId");
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _verticalController.dispose();
    _horizontalController.dispose();
    _headerHorizontalController.dispose();
    _kraScrollController.dispose();
    _kpiScrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchFiltered() async {
    try {
      final roadmapData = await _scorecardService.fetchRoadmapFiltered(
        kraId: selectedKra,
        fromYear: selectedStartYear,
        toYear: selectedEndYear,
      );
      final kpiData = await _scorecardService.fetchKpiFiltered(
        kraId: selectedKra,
        fromYear: selectedStartYear,
        toYear: selectedEndYear,
      );
      if (!mounted) return;
      setState(() {
        roadmapList = roadmapData;
        kpiList = kpiData;
        filteredList = List.from(roadmapData);
      });
    } catch (e) {
      debugPrint("Error fetching filtered data");
    }
  }

  Widget _filterChip({required String label, required bool isActive}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: isActive ? primaryColor.withValues(alpha: 0.08) : Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isActive ? primaryColor : Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isActive ? primaryColor : Colors.black87,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            Icons.keyboard_arrow_down,
            size: 16,
            color: isActive ? primaryColor : Colors.grey.shade600,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    bool hasPermission = permissionService.hasPermission(
      AppPermissions.viewKraRoadMap,
    );

    if (!hasPermission) return noPermissionScreen();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _verticalController,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── TITLE ──
                const Text(
                  'Scorecard Monitoring',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Filter by:',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 10),

                      PermissionWidget(
                        permission: AppPermissions.viewKra,
                        child: PopupMenuButton<int>(
                          color: Theme.of(context).cardColor,
                          onSelected: (value) async {
                            setState(() {
                              selectedKra = (value == -1) ? null : value;
                            });
                            await _fetchFiltered();
                          },
                          itemBuilder:
                              (_) => [
                                const PopupMenuItem(
                                  value: -1,
                                  child: Text('All KRA'),
                                ),
                                ...kraListOptions.map(
                                  (k) => PopupMenuItem(
                                    value: k.id,
                                    child: Text(k.name),
                                  ),
                                ),
                              ],
                          child: _filterChip(
                            label:
                                selectedKra == null
                                    ? 'All KRA'
                                    : kraListOptions
                                        .firstWhere((k) => k.id == selectedKra)
                                        .name,
                            isActive: isMenuOpenKra,
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      PopupMenuButton<int>(
                        color: Theme.of(context).cardColor,
                        onSelected: (value) async {
                          setState(() {
                            selectedStartYear = value == -1 ? null : value;
                          });
                          await _fetchFiltered();
                        },
                        itemBuilder:
                            (_) => [
                              const PopupMenuItem(
                                value: -1,
                                child: Text('All Years'),
                              ),
                              ...SwotYear.years.map(
                                (y) => PopupMenuItem(
                                  value: int.parse(y),
                                  child: Text(y),
                                ),
                              ),
                            ],
                        child: _filterChip(
                          label: selectedStartYear?.toString() ?? 'Start Year',
                          isActive: isMenuOpenStartYear,
                        ),
                      ),

                      const SizedBox(width: 8),

                      PopupMenuButton<int>(
                        color: Theme.of(context).cardColor,
                        onSelected: (value) async {
                          setState(() {
                            selectedEndYear = value == -1 ? null : value;
                          });
                          await _fetchFiltered();
                        },
                        itemBuilder:
                            (_) => [
                              const PopupMenuItem(
                                value: -1,
                                child: Text('All Years'),
                              ),
                              ...SwotYear.years.map(
                                (y) => PopupMenuItem(
                                  value: int.parse(y),
                                  child: Text(y),
                                ),
                              ),
                            ],
                        child: _filterChip(
                          label: selectedEndYear?.toString() ?? 'End Year',
                          isActive: isMenuOpenEndYear,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 26),

                isLoading
                    ? Center(
                      child: CircularProgressIndicator(color: primaryColor),
                    )
                    : isMobile
                    ? Column(
                      children: [
                        _buildKPITable(),
                        const SizedBox(height: 16),
                        _buildKRATable(),
                      ],
                    )
                    : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 2, child: _buildKPITable()),
                        const SizedBox(width: 16),
                        Expanded(flex: 3, child: _buildKRATable()),
                      ],
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKRATable() {
    final canView = permissionService.hasPermission(
      AppPermissions.viewKraRoadMapAccomplishment,
    );

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(blurRadius: 10, color: Colors.black.withValues(alpha: .05)),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: const Text(
              'Key Result Areas (KRA)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                _headerCell('#', flex: 1),
                _headerCell('Period', flex: 2),
                _headerCell('KRA', flex: 4),
                _headerCell('Activity', flex: 5),
                _headerCell('Action', flex: 2),
              ],
            ),
          ),

          roadmapList.isEmpty
              ? _emptyState('No KRA data available')
              : LayoutBuilder(
                builder: (context, constraints) {
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                      // max height adapts to screen size
                      maxHeight: MediaQuery.of(context).size.height * 0.6,
                    ),
                    child: Scrollbar(
                      controller: _kraScrollController,
                      thumbVisibility: true,
                      child: ListView.separated(
                        controller: _kraScrollController,
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: roadmapList.length,
                        separatorBuilder:
                            (_, __) => Divider(
                              height: 1,
                              color: Colors.grey.withValues(alpha: 0.2),
                            ),
                        itemBuilder: (context, index) {
                          final item = roadmapList[index];
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 12,
                            ),
                            color:
                                index % 2 == 0
                                    ? Colors.white
                                    : Colors.grey.shade50,
                            child: Row(
                              children: [
                                _dataCell('${index + 1}', flex: 1),
                                const SizedBox(width: 8),

                                _dataCell(item['year'] ?? '', flex: 2),
                                const SizedBox(width: 8),

                                _dataCell(
                                  item['kraDescription'] ?? '',
                                  flex: 4,
                                ),
                                const SizedBox(width: 8),

                                _dataCell(
                                  item['deliverableName'] ?? '',
                                  flex: 5,
                                ),
                                const SizedBox(width: 8),

                                Expanded(
                                  flex: 2,
                                  child: _buildActionButton(() async {
                                    await loadScorecardAccomplishments(
                                      item['id'],
                                    );
                                    showRoadmapAccomplishmentFormDialog(
                                      context,
                                      item,
                                      userId,
                                    );
                                  }, enabled: canView),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // KPI TABLE
  // ─────────────────────────────────────────────

  Widget _buildKPITable() {
    final canView = permissionService.hasPermission(
      AppPermissions.viewKraRoadMapKpiAccomplishment,
    );

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(blurRadius: 10, color: Colors.black.withValues(alpha: .05)),
        ],
      ),
      child: Column(
        children: [
          // Title bar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: const Text(
              'Key Performance Indicators (KPI)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                _headerCell('#', flex: 1),
                _headerCell('KPI', flex: 5),
                _headerCell('Action', flex: 2),
              ],
            ),
          ),

          // Rows
          kpiList.isEmpty
              ? _emptyState('No KPI data available')
              // : Flexible(
              //   child: Scrollbar(
              //     controller: _kpiScrollController,
              //     thumbVisibility: true,
              //     child: ListView.separated(
              //       controller: _kpiScrollController,
              //       shrinkWrap: true,
              //       itemCount: kpiList.length,
              //       separatorBuilder:
              //           (_, __) => Divider(
              //             height: 1,
              //             color: Colors.grey.withValues(alpha: 0.2),
              //           ),
              //       itemBuilder: (context, index) {
              //         final item = kpiList[index];
              //         return Container(
              //           padding: const EdgeInsets.symmetric(
              //             vertical: 10,
              //             horizontal: 12,
              //           ),
              //           color:
              //               index % 2 == 0 ? Colors.white : Colors.grey.shade50,
              //           child: Row(
              //             children: [
              //               _dataCell('${index + 1}', flex: 1),
              //               SizedBox(width: 8),
              //               _dataCell(item['kpiDescription'] ?? '', flex: 5),
              //               Expanded(
              //                 flex: 2,
              //                 child: _buildActionButton(() async {
              //                   await loadKPIAccomplishments(item['id']);
              //                   showKPIAccomplishmentFormDialog(
              //                     context,
              //                     item,
              //                     userId,
              //                   );
              //                 }, enabled: canView),
              //               ),
              //             ],
              //           ),
              //         );
              //       },
              //     ),
              //   ),
              // ),
              : Builder(
                builder: (context) {
                  final screenHeight = MediaQuery.of(context).size.height;

                  final tableMaxHeight = screenHeight * 0.55; // safe for mobile

                  return Container(
                    constraints: BoxConstraints(maxHeight: tableMaxHeight),
                    child: Scrollbar(
                      controller: _kpiScrollController,
                      thumbVisibility: true,
                      child: ListView.separated(
                        controller: _kpiScrollController,
                        physics: const ClampingScrollPhysics(),
                        itemCount: kpiList.length,
                        separatorBuilder:
                            (_, __) => Divider(
                              height: 1,
                              color: Colors.grey.withValues(alpha: 0.2),
                            ),
                        itemBuilder: (context, index) {
                          final item = kpiList[index];

                          return Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 12,
                            ),
                            color:
                                index % 2 == 0
                                    ? Colors.white
                                    : Colors.grey.shade50,
                            child: Row(
                              children: [
                                _dataCell('${index + 1}', flex: 1),
                                const SizedBox(width: 8),
                                _dataCell(
                                  item['kpiDescription'] ?? '',
                                  flex: 5,
                                ),
                                Expanded(
                                  flex: 2,
                                  child: _buildActionButton(() async {
                                    await loadKPIAccomplishments(item['id']);
                                    showKPIAccomplishmentFormDialog(
                                      context,
                                      item,
                                      userId,
                                    );
                                  }, enabled: canView),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // SHARED HELPERS
  // ─────────────────────────────────────────────

  Widget _headerCell(String text, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _dataCell(String text, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Text(text, style: const TextStyle(fontSize: 13), softWrap: true),
    );
  }

  Widget _emptyState(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Text(
          message,
          style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
        ),
      ),
    );
  }

  Widget _buildActionButton(VoidCallback? onPressed, {bool enabled = true}) {
    return Tooltip(
      message:
          enabled
              ? 'Open Accomplishment'
              : 'You don\'t have permission to view',
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled ? Colors.transparent : Colors.grey.shade300,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: BorderSide(
              color: enabled ? Colors.grey : Colors.grey.shade500,
              width: 1,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          textStyle: const TextStyle(fontSize: 13),
          minimumSize: const Size(80, 34),
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (!enabled) return null;
            if (states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.pressed)) {
              return const Color.fromARGB(255, 221, 221, 221);
            }
            return null;
          }),
        ),
        onPressed: enabled ? onPressed : null,
        icon: Icon(
          Icons.bar_chart_outlined,
          size: 14,
          color: enabled ? primaryTextColor : Colors.grey.shade600,
        ),
        label: Text(
          'Accomplishment',
          style: TextStyle(
            color: enabled ? primaryTextColor : Colors.grey.shade600,
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// ROADMAP ACCOMPLISHMENT DIALOG
// ─────────────────────────────────────────────

Future<bool?> showRoadmapAccomplishmentFormDialog(
  BuildContext context,
  Map<String, dynamic> deliverable,
  String userId,
) {
  int? startYear;
  int? endYear;

  final String? startDateStr = deliverable['startDate']?.toString();
  final String? endDateStr = deliverable['endDate']?.toString();
  final int? deliverableYear = () {
    final dynamic y = deliverable['year'];
    if (y is int) return y;
    if (y is String) return int.tryParse(y);
    return null;
  }();

  if (startDateStr != null && endDateStr != null) {
    final DateTime? startDt = DateTime.tryParse(startDateStr);
    final DateTime? endDt = DateTime.tryParse(endDateStr);
    if (startDt != null && endDt != null) {
      startYear = deliverableYear ?? startDt.year;
      endYear = endDt.year;
      if (endYear < startYear) endYear = startYear;
    }
  }

  if (startYear == null || endYear == null) {
    if (deliverableYear != null) {
      startYear = deliverableYear;
      endYear = deliverableYear;
    } else {
      final String? fallbackYearStr = deliverable['year']?.toString();
      if (fallbackYearStr != null && fallbackYearStr.isNotEmpty) {
        final RegExpMatch? rangeMatch = RegExp(
          r'^(\d{4})(?:\s*-\s*(\d{4}))?$',
        ).firstMatch(fallbackYearStr.trim());
        if (rangeMatch != null) {
          startYear = int.tryParse(rangeMatch.group(1)!);
          endYear = int.tryParse(rangeMatch.group(2) ?? rangeMatch.group(1)!);
        } else {
          final List<int> years =
              RegExp(r'\d{4}')
                  .allMatches(fallbackYearStr)
                  .map((m) => int.tryParse(m.group(0)!))
                  .whereType<int>()
                  .toList();
          if (years.isNotEmpty) {
            startYear = years.first;
            endYear = years.length > 1 ? years.last : years.first;
          }
        }
      }
    }
  }

  final bool useYearly =
      startYear != null && endYear != null && endYear >= startYear;
  final List<Map<String, dynamic>> periods = [];
  if (useYearly) {
    for (int y = startYear; y <= endYear; y++) {
      periods.add({'period': y.toString(), 'year': y});
    }
  }

  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      final int totalPeriods = periods.length;
      final String headerText =
          useYearly
              ? 'Accomplishment Form — ${startYear ?? ''} to ${endYear ?? ''}'
              : 'Accomplishment Form';

      return Dialog(
        backgroundColor: mainBgColor,
        insetPadding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1500),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              headerText,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Info card
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "KRA: ${deliverable['kra'] ?? 'N/A'}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Deliverable: ${deliverable['deliverableName'] ?? 'N/A'}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Tracking label
                        Row(
                          children: [
                            const Icon(Icons.bar_chart_outlined, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              "Yearly KRA & Deliverable Tracking — $totalPeriods year(s)",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            TotalScoreIndicator(
                              deliverableId: (deliverable['id'] ?? 0) as int,
                              totalPeriods: totalPeriods,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Tracking table
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  ),
                                ),
                                child: const Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          "Period",
                                          style: TextStyle(color: grey),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          "Score",
                                          style: TextStyle(color: grey),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          "Proof",
                                          style: TextStyle(color: grey),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Center(
                                        child: Text(
                                          "Remarks",
                                          style: TextStyle(color: grey),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ...periods.asMap().entries.map((entry) {
                                final index = entry.key;
                                final period = entry.value;
                                return Column(
                                  children: [
                                    const Divider(height: 1),
                                    ScorecardAccomplishmentRowWidget(
                                      period: period['period'],
                                      periodIndex: index,
                                      totalPeriods: totalPeriods,
                                      deliverableId:
                                          (deliverable['id'] ?? 0) as int,
                                    ),
                                  ],
                                );
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                PermissionWidget(
                  permission: AppPermissions.addKraRoadMapAccomplishment,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: primaryColor),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        onPressed: () async {
                          final shouldSave = await showDialog<bool>(
                            context: context,
                            builder:
                                (ctx) => AlertDialog(
                                  title: const Text("Confirm Save"),
                                  content: const Text(
                                    "Are you sure you want to save this data?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.of(ctx).pop(false),
                                      child: const Text(
                                        "No",
                                        style: TextStyle(color: primaryColor),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed:
                                          () => Navigator.of(ctx).pop(true),
                                      child: const Text(
                                        "Yes",
                                        style: TextStyle(color: primaryColor),
                                      ),
                                    ),
                                  ],
                                ),
                          );
                          if (shouldSave != true) return;
                          MotionToast.success(
                            description: const Text('Saved Successfully'),
                            toastAlignment: Alignment.topCenter,
                          ).show(context);
                          await saveScorecardAccomplishmentData(
                            deliverable['id'],
                            userId,
                          );
                          Navigator.of(context).pop(true);
                        },
                        child: const Text(
                          "Save Accomplishment",
                          style: TextStyle(color: Colors.white),
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
    },
  );
}

// ─────────────────────────────────────────────
// KPI ACCOMPLISHMENT DIALOG
// ─────────────────────────────────────────────

Future<bool?> showKPIAccomplishmentFormDialog(
  BuildContext context,
  Map<String, dynamic> deliverable,
  String userId,
) {
  int? startYear;
  int? endYear;

  final String? startDateStr = deliverable['startDate']?.toString();
  final String? endDateStr = deliverable['endDate']?.toString();
  final int? deliverableYear = () {
    final dynamic y = deliverable['year'];
    if (y is int) return y;
    if (y is String) return int.tryParse(y);
    return null;
  }();

  if (startDateStr != null && endDateStr != null) {
    final DateTime? startDt = DateTime.tryParse(startDateStr);
    final DateTime? endDt = DateTime.tryParse(endDateStr);
    if (startDt != null && endDt != null) {
      startYear = deliverableYear ?? startDt.year;
      endYear = endDt.year;
      if (endYear < startYear) endYear = startYear;
    }
  }

  if (startYear == null || endYear == null) {
    if (deliverableYear != null) {
      startYear = deliverableYear;
      endYear = deliverableYear;
    } else {
      final String? fallbackYearStr = deliverable['year']?.toString();
      if (fallbackYearStr != null && fallbackYearStr.isNotEmpty) {
        final RegExpMatch? rangeMatch = RegExp(
          r'^(\d{4})(?:\s*-\s*(\d{4}))?$',
        ).firstMatch(fallbackYearStr.trim());
        if (rangeMatch != null) {
          startYear = int.tryParse(rangeMatch.group(1)!);
          endYear = int.tryParse(rangeMatch.group(2) ?? rangeMatch.group(1)!);
        } else {
          final List<int> years =
              RegExp(r'\d{4}')
                  .allMatches(fallbackYearStr)
                  .map((m) => int.tryParse(m.group(0)!))
                  .whereType<int>()
                  .toList();
          if (years.isNotEmpty) {
            startYear = years.first;
            endYear = years.length > 1 ? years.last : years.first;
          }
        }
      }
    }
  }

  final bool useYearly =
      startYear != null && endYear != null && endYear >= startYear;
  final List<Map<String, dynamic>> periods = [];
  if (useYearly) {
    for (int y = startYear; y <= endYear; y++) {
      periods.add({'period': y.toString(), 'year': y});
    }
  }

  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      final int totalPeriods = periods.length;
      final String headerText =
          useYearly
              ? 'Accomplishment Form — ${startYear ?? ''} to ${endYear ?? ''}'
              : 'Accomplishment Form';

      return Dialog(
        backgroundColor: mainBgColor,
        insetPadding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1500),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              headerText,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "KPI: ${deliverable['kpiDescription'] ?? 'N/A'}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              softWrap: true,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Target: ${deliverable['target'] ?? 'No Target'}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              softWrap: true,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "Baseline: ${deliverable['baseLine'] ?? 'No Baseline'}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              softWrap: true,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Tracking label
                        Row(
                          children: [
                            const Icon(Icons.bar_chart_outlined, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              "Yearly KPI Tracking — $totalPeriods year(s)",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            TotalScoreIndicator(
                              deliverableId: (deliverable['id'] ?? 0) as int,
                              totalPeriods: totalPeriods,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Tracking table
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  ),
                                ),
                                child: const Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          "Period",
                                          style: TextStyle(color: grey),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          "Score",
                                          style: TextStyle(color: grey),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          "Proof",
                                          style: TextStyle(color: grey),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Center(
                                        child: Text(
                                          "Remarks",
                                          style: TextStyle(color: grey),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ...periods.asMap().entries.map((entry) {
                                final index = entry.key;
                                final period = entry.value;
                                return Column(
                                  children: [
                                    const Divider(height: 1),
                                    ScorecardAccomplishmentRowWidget(
                                      period: period['period'],
                                      periodIndex: index,
                                      totalPeriods: totalPeriods,
                                      deliverableId:
                                          (deliverable['id'] ?? 0) as int,
                                    ),
                                  ],
                                );
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                PermissionWidget(
                  permission: AppPermissions.addKraRoadMapKpiAccomplishment,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: primaryColor),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        onPressed: () async {
                          final shouldSave = await showDialog<bool>(
                            context: context,
                            builder:
                                (ctx) => AlertDialog(
                                  title: const Text("Confirm Save"),
                                  content: const Text(
                                    "Are you sure you want to save this data?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.of(ctx).pop(false),
                                      child: const Text(
                                        "No",
                                        style: TextStyle(color: primaryColor),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed:
                                          () => Navigator.of(ctx).pop(true),
                                      child: const Text(
                                        "Yes",
                                        style: TextStyle(color: primaryColor),
                                      ),
                                    ),
                                  ],
                                ),
                          );
                          if (shouldSave != true) return;
                          MotionToast.success(
                            description: const Text('Saved Successfully'),
                            toastAlignment: Alignment.topCenter,
                          ).show(context);
                          await saveKPIAccomplishmentData(
                            deliverable['id'],
                            userId,
                          );
                          Navigator.of(context).pop(true);
                        },
                        child: const Text(
                          "Save Accomplishment",
                          style: TextStyle(color: Colors.white),
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
    },
  );
}

class PgsDeliverableHistoryGrouped {
  final int pgsDeliverableId;
  final List<PgsDeliverableScoreHistory>? scoreHistory;

  PgsDeliverableHistoryGrouped(this.pgsDeliverableId, this.scoreHistory);

  factory PgsDeliverableHistoryGrouped.fromJson(Map<String, dynamic> json) {
    return PgsDeliverableHistoryGrouped(
      json['pgsDeliverableId'] as int,
      json['scoreHistory'] != null
          ? (json['scoreHistory'] as List)
              .map((e) => PgsDeliverableScoreHistory.fromJson(e))
              .toList()
          : null,
    );
  }
}
