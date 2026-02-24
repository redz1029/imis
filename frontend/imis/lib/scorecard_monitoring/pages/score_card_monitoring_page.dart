// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/constant/permissions.dart';
import 'package:imis/performance_governance_system/key_result_area/models/key_result_area.dart';
import 'package:imis/performance_governance_system/models/pgs_deliverable_score_history.dart';
import 'package:imis/performance_governance_system/pgs_period/models/pgs_period.dart';
import 'package:imis/utils/permission_service.dart';
import 'package:imis/widgets/filter_button_widget.dart';
import 'package:imis/widgets/no_permission_widget.dart';
import 'package:imis/widgets/permission_widget.dart';
import 'package:imis/widgets/scorecard_monitoring_accomplishment_widget.dart';
import 'package:imis/scorecard_monitoring/services/score_card_monitoring_services.dart';
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
  final int kraColumns = 4;
  final int kpiColumns = 2;

  final dio = Dio();
  final _commonService = CommonService(Dio());
  final _scorecardService = ScoreCardMonitoringServices(Dio());
  final permissionService = PermissionService();
  List<Map<String, dynamic>> kpiList = [];
  List<Map<String, dynamic>> roadmapList = [];
  List<Map<String, dynamic>> filteredList = [];
  String userId = "";

  final List<String> kraHeaders = ["PERIOD", "KRA", "ACTIVITY", "ACTION"];

  final List<String> kpiHeaders = ["KPI", "ACTIONS"];

  bool isMenuOpenStartYear = false;
  bool isMenuOpenEndYear = false;
  bool isMenuOpenKra = false;
  bool isMenuOpenKraKpi = false;
  List<KeyResultArea> kraListOptions = [];
  int? selectedKra;
  List<PgsPeriod> periodList = [];
  int? selectedStartYear;
  int? selectedEndYear;
  int? selectedPeriodCreateReport;
  String? selectedPeriodText;
  String? selectedPeriodTextCreateReport;
  String? selectedStartYearText;
  String? selectedEndYearText;
  bool isLoading = true;
  int? officeId;
  int? periodId;
  bool hasAvailableDeliverables = false;
  bool isAllYearsSelected = false;

  @override
  void initState() {
    super.initState();
    _headerHorizontalController.addListener(_syncHeaderScroll);
    _horizontalController.addListener(_syncBodyScroll);

    () async {
      setState(() {
        isLoading = true;
      });

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

    setState(() {
      userId = user!.id ?? "UserId";
    });

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _verticalController.dispose();
    _horizontalController.dispose();
    _headerHorizontalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool hasPermission = permissionService.hasPermission(
      AppPermissions.viewKraRoadMapAccomplishment,
    );

    if (!hasPermission) {
      return noPermissionScreen();
    }
    return Scaffold(
      backgroundColor: mainBgColor,
      appBar: AppBar(
        backgroundColor: mainBgColor,
        title: const Text(
          'Scorecard Monitoring',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Filter by', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
                PermissionWidget(
                  permission: AppPermissions.viewKra,
                  child: PopupMenuButton<int>(
                    color: mainBgColor,
                    offset: const Offset(0, 30),
                    onCanceled: () {
                      setState(() {
                        isMenuOpenKra = false;
                      });
                    },
                    onOpened: () {
                      setState(() {
                        isMenuOpenKra = true;
                      });
                    },

                    onSelected: (int value) async {
                      setState(() {
                        selectedKra = (value == -1) ? null : value;
                        isMenuOpenKra = false;
                      });

                      try {
                        final roadmapData = await _scorecardService
                            .fetchRoadmapFiltered(
                              kraId: selectedKra,
                              fromYear: selectedStartYear,
                              toYear: selectedEndYear,
                            );
                        final kpiData = await _scorecardService
                            .fetchKpiFiltered(
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
                    },
                    itemBuilder: (BuildContext context) {
                      final updatedKraList = [
                        {'id': -1, 'name': 'All KRA'},
                        ...kraListOptions.map(
                          (k) => {
                            'id': k.id,
                            'name': k.name,
                            'remarks': k.remarks,
                          },
                        ),
                      ];

                      return updatedKraList.map<PopupMenuItem<int>>((kra) {
                        return PopupMenuItem<int>(
                          value: kra['id'] as int,
                          child: Text(kra['name'].toString()),
                        );
                      }).toList();
                    },
                    child: FilterButton(
                      label:
                          selectedKra == null
                              ? 'All KRA'
                              : kraListOptions
                                  .firstWhere(
                                    (kra) => kra.id == selectedKra,
                                    orElse:
                                        () => KeyResultArea(
                                          0,
                                          'name',
                                          'remarks',
                                          'strategic',
                                          false,
                                        ),
                                  )
                                  .name,
                      isActive: isMenuOpenKra,
                    ),
                  ),
                ),
                SizedBox(width: 6),
                PopupMenuButton<int>(
                  color: mainBgColor,
                  offset: const Offset(0, 30),

                  onCanceled: () {
                    setState(() {
                      isMenuOpenStartYear = false;
                    });
                  },

                  onOpened: () {
                    setState(() {
                      isMenuOpenStartYear = true;
                    });
                  },

                  onSelected: (int value) async {
                    setState(() {
                      selectedStartYear = (value == -1) ? null : value;
                      selectedStartYearText =
                          (value == -1) ? null : value.toString();
                      isMenuOpenStartYear = false;
                      isAllYearsSelected = (value == -1);
                    });
                    try {
                      final roadmapData = await _scorecardService
                          .fetchRoadmapFiltered(
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
                  },

                  itemBuilder: (BuildContext context) {
                    final updatedYearList = [
                      -1,
                      ...SwotYear.years.map((y) => int.parse(y)),
                    ];

                    return updatedYearList.map((year) {
                      return PopupMenuItem<int>(
                        value: year,
                        child: Text(year == -1 ? 'All Years' : year.toString()),
                      );
                    }).toList();
                  },

                  child: FilterButton(
                    label:
                        selectedStartYear == null
                            ? (isAllYearsSelected ? 'All Years' : 'Start Year')
                            : selectedStartYear.toString(),
                    isActive: isMenuOpenStartYear,
                  ),
                ),
                SizedBox(width: 6),
                PopupMenuButton<int>(
                  color: mainBgColor,
                  offset: const Offset(0, 30),

                  onCanceled: () {
                    setState(() {
                      isMenuOpenEndYear = false;
                    });
                  },

                  onOpened: () {
                    setState(() {
                      isMenuOpenEndYear = true;
                    });
                  },

                  onSelected: (int value) async {
                    setState(() {
                      selectedEndYear = (value == -1) ? null : value;
                      selectedEndYearText =
                          (value == -1) ? null : value.toString();
                      isMenuOpenEndYear = false;
                      isAllYearsSelected = (value == -1);
                    });
                    try {
                      final roadmapData = await _scorecardService
                          .fetchRoadmapFiltered(
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
                  },

                  itemBuilder: (BuildContext context) {
                    final updatedYearList = [
                      -1,
                      ...SwotYear.years.map((y) => int.parse(y)),
                    ];

                    return updatedYearList.map((year) {
                      return PopupMenuItem<int>(
                        value: year,
                        child: Text(year == -1 ? 'All Years' : year.toString()),
                      );
                    }).toList();
                  },

                  child: FilterButton(
                    label:
                        selectedEndYear == null
                            ? (isAllYearsSelected ? 'All Years' : 'End Year')
                            : selectedEndYear.toString(),
                    isActive: isMenuOpenEndYear,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _verticalController,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildKPITable(),
                  const SizedBox(height: 32),
                  _buildKRATable(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKRATable() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Title Row
          Container(
            decoration: BoxDecoration(
              color: primaryLightColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Table(
              columnWidths: const {0: FlexColumnWidth(1)},
              children: [
                TableRow(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 20,
                      ),
                      child: const Text(
                        'Key Result Areas (KRA)',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Header (fixed)
          Container(
            decoration: BoxDecoration(color: Colors.grey.shade100),
            child: Table(
              columnWidths: const {
                0: FixedColumnWidth(60),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(6),
                3: FlexColumnWidth(8),
                4: FixedColumnWidth(200),
              },
              children: [
                TableRow(
                  children: [
                    _tableCell('#', isHeader: true),
                    _tableCell('PERIOD', isHeader: true),
                    _tableCell('KRA', isHeader: true),
                    _tableCell('ACTIVITY', isHeader: true),
                    _tableCell('ACTION', isHeader: true),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(
            height: 7 * 56.0,
            child: Scrollbar(
              controller: _kraScrollController,
              thumbVisibility: true,
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  _kraScrollController.jumpTo(
                    _kraScrollController.offset - details.delta.dy,
                  );
                },
                child: ListView.builder(
                  controller: _kraScrollController,
                  physics: const ClampingScrollPhysics(),
                  itemCount: roadmapList.length,
                  itemBuilder: (context, index) {
                    final item = roadmapList[index];
                    final isEven = index % 2 == 0;

                    return Container(
                      color: isEven ? Colors.white : Colors.grey.shade50,
                      child: Table(
                        columnWidths: const {
                          0: FixedColumnWidth(60),
                          1: FlexColumnWidth(2),
                          2: FlexColumnWidth(6),
                          3: FlexColumnWidth(8),
                          4: FixedColumnWidth(200),
                        },
                        children: [
                          TableRow(
                            children: [
                              _tableCell('${index + 1}'),
                              _tableCell(item['year'] ?? ''),
                              _tableCell(item['kraDescription'] ?? ''),
                              _tableCell(item['deliverableName'] ?? ''),
                              _buildActionButton('', () async {
                                await loadScorecardAccomplishments(item['id']);
                                showRoadmapAccomplishmentFormDialog(
                                  context,
                                  item,
                                  userId,
                                );
                              }),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKPITable() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Title Row
          Container(
            decoration: BoxDecoration(
              color: primaryLightColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Table(
              columnWidths: const {0: FlexColumnWidth(1)},
              children: [
                TableRow(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 20,
                      ),
                      child: const Text(
                        'Key Performance Indicators (KPI)',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Header (fixed)
          Container(
            decoration: BoxDecoration(color: Colors.grey.shade100),
            child: Table(
              columnWidths: const {
                0: FixedColumnWidth(60),
                1: FlexColumnWidth(5),
                2: FixedColumnWidth(200),
              },
              children: [
                TableRow(
                  children: [
                    _tableCell('#', isHeader: true),
                    _tableCell('KPI', isHeader: true),
                    _tableCell('ACTIONS', isHeader: true),
                  ],
                ),
              ],
            ),
          ),
          // Scrollable data rows
          SizedBox(
            height: 7 * 56.0,
            child: Scrollbar(
              controller: _kpiScrollController,
              thumbVisibility: true,
              child: ListView.builder(
                controller: _kpiScrollController,
                itemCount: kpiList.length,
                itemBuilder: (context, index) {
                  final item = kpiList[index];
                  final isEven = index % 2 == 0;
                  return Container(
                    decoration: BoxDecoration(
                      color: isEven ? Colors.white : Colors.grey.shade50,
                    ),
                    child: Table(
                      columnWidths: const {
                        0: FixedColumnWidth(60),
                        1: FlexColumnWidth(5),
                        2: FixedColumnWidth(200),
                      },
                      children: [
                        TableRow(
                          children: [
                            _tableCell('${index + 1}'),
                            _tableCell(item['kpiDescription'] ?? ''),
                            _buildActionButton('', () {
                              showKPIAccomplishmentFormDialog(
                                context,
                                item,
                                userId,
                              );
                            }),
                          ],
                        ),
                      ],
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

  Widget _tableCell(String text, {bool isHeader = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.grey.shade300, width: 0.5),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.w600 : FontWeight.normal,
          fontSize: isHeader ? 14 : 14,
          color: isHeader ? Colors.grey.shade700 : Colors.black87,
        ),

        softWrap: true,
      ),
    );
  }

  Widget _buildActionButton(String label, VoidCallback onPressed) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: const BorderSide(color: Colors.grey, width: 1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          textStyle: const TextStyle(fontSize: 13),
          minimumSize: const Size(100, 36),
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.pressed)) {
              return const Color.fromARGB(255, 221, 221, 221);
            }
            return null;
          }),
        ),
        onPressed: onPressed,
        icon: const Icon(
          Icons.bar_chart_outlined,
          size: 14,
          color: primaryTextColor,
        ),
        label: const Text(
          'Accomplishment',
          style: TextStyle(color: primaryTextColor, fontSize: 10),
        ),
      ),
    );
  }
}

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
      if (endYear < startYear) {
        endYear = startYear;
      }
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

  final List<Map<String, dynamic>> periods = <Map<String, dynamic>>[];
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
              ? 'Accomplishment Form - Years ${startYear ?? ''} to ${endYear ?? ''}'
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
                // Scrollable Content
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
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("KRA: ${deliverable['kra'] ?? 'N/A'}"),
                                  Text(
                                    useYearly
                                        ? "Yearly Tracking: ${startYear ?? ''}-${endYear ?? ''} ($totalPeriods year(s))"
                                        : "Tracking Periods: $totalPeriods period(s)",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Deliverable: ${deliverable['deliverableName'] ?? 'N/A'}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        Row(
                          children: [
                            const Icon(Icons.bar_chart_outlined, size: 18),
                            const SizedBox(width: 8),
                            const Text(
                              "Yearly Accomplishment Tracking",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            TotalScoreIndicator(
                              deliverableId: (deliverable['id'] ?? 0) as int,
                              totalPeriods: totalPeriods,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              // Headers
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
                                child: Row(
                                  children: const [
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
                                          "Status",
                                          style: TextStyle(color: grey),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          "Percent Accomplishment",
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
                SizedBox(height: 20),
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
                                  title: Text("Confirm Save"),
                                  content: Text(
                                    "Are you sure you want to save this data?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.of(ctx).pop(false),
                                      child: Text(
                                        "No",
                                        style: TextStyle(color: primaryColor),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed:
                                          () => Navigator.of(ctx).pop(true),
                                      child: Text(
                                        "Yes",
                                        style: TextStyle(color: primaryColor),
                                      ),
                                    ),
                                  ],
                                ),
                          );

                          if (shouldSave != true) return;
                          MotionToast.success(
                            description: Text('Saved Successfully'),
                            toastAlignment: Alignment.topCenter,
                          ).show(context);
                          await saveScorecardAccomplishmentData(
                            deliverable['id'],
                            userId,
                          );

                          Navigator.of(context).pop(true);
                        },
                        child: Text(
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
      if (endYear < startYear) {
        endYear = startYear;
      }
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

  final List<Map<String, dynamic>> periods = <Map<String, dynamic>>[];
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
              ? 'Accomplishment Form - Years ${startYear ?? ''} to ${endYear ?? ''}'
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
                // Scrollable Content
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
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "KPI: ${deliverable['kpiDescription'] ?? deliverable['kpiDescription'] ?? 'N/A'}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    useYearly
                                        ? "Yearly Tracking: ${startYear ?? ''}-${endYear ?? ''} ($totalPeriods year(s))"
                                        : "Tracking Periods: $totalPeriods period(s)",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Target: ${deliverable['target'] ?? 'No Target'}",
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Baseline: ${deliverable['baseLine'] ?? 'No Baseline'}",
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const Icon(Icons.bar_chart_outlined, size: 18),
                            const SizedBox(width: 8),
                            const Text(
                              "Yearly Accomplishment Tracking",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            TotalScoreIndicator(
                              deliverableId: (deliverable['id'] ?? 0) as int,
                              totalPeriods: totalPeriods,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              // Headers
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
                                child: Row(
                                  children: const [
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
                                          "Status",
                                          style: TextStyle(color: grey),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          "Percent Accomplishment",
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
                SizedBox(height: 20),
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
                                  title: Text("Confirm Save"),
                                  content: Text(
                                    "Are you sure you want to save this data?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.of(ctx).pop(false),
                                      child: Text(
                                        "No",
                                        style: TextStyle(color: primaryColor),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed:
                                          () => Navigator.of(ctx).pop(true),
                                      child: Text(
                                        "Yes",
                                        style: TextStyle(color: primaryColor),
                                      ),
                                    ),
                                  ],
                                ),
                          );

                          if (shouldSave != true) return;
                          MotionToast.success(
                            description: Text('Saved Successfully'),
                            toastAlignment: Alignment.topCenter,
                          ).show(context);
                          await saveKPIAccomplishmentData(
                            deliverable['id'],
                            userId,
                          );

                          Navigator.of(context).pop(true);
                        },
                        child: Text(
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
