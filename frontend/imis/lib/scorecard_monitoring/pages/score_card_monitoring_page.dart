// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/constant/permissions.dart';
import 'package:imis/performance_governance_system/deliverable_status_monitoring/models/pgs_deliverable_accomplishment.dart';
import 'package:imis/performance_governance_system/deliverable_status_monitoring/models/pgs_filter.dart';
import 'package:imis/performance_governance_system/deliverable_status_monitoring/services/deliverable_status_monitoring_service.dart';
import 'package:imis/performance_governance_system/key_result_area/models/key_result_area.dart';
import 'package:imis/performance_governance_system/models/pgs_deliverable_score_history.dart';
import 'package:imis/performance_governance_system/pgs_period/models/pgs_period.dart';
import 'package:imis/scorecard_monitoring/models/kpi_filter.dart';
import 'package:imis/scorecard_monitoring/models/score_card_monitoring_filter.dart';
import 'package:imis/utils/permission_service.dart';
import 'package:imis/widgets/accomplishment_auditor_widget.dart';
import 'package:imis/widgets/breakthrough_widget.dart';
import 'package:imis/widgets/filter_button_widget.dart';
import 'package:imis/widgets/no_permission_widget.dart';
import 'package:imis/widgets/permission_widget.dart';
import 'package:intl/intl.dart';
import 'package:imis/constant/constant.dart';
import 'package:motion_toast/motion_toast.dart';
import '../../../common_services/common_service.dart';
import '../../../user/models/user_registration.dart';
import '../../../utils/api_endpoint.dart';
import '../../../utils/auth_util.dart';
import '../../../utils/http_util.dart';
import '../../../utils/permission_string.dart';

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
  final double numberColumnWidth = 70;
  final double dataColumnWidth = 280;
  final double actionColumnWidth = 120;
  final dio = Dio();
  final _commonService = CommonService(Dio());
  final _deliverableStatusMonitoring = DeliverableStatusMonitoringService(
    Dio(),
  );
  final permissionService = PermissionService();
  List<Map<String, dynamic>> kpiList = [];
  List<Map<String, dynamic>> roadmapList = [];
  List<Map<String, dynamic>> filteredList = [];
  List<PgsDeliverableHistoryGrouped> deliverableHistoryGrouped = [];
  String userId = "";

  final List<String> kraHeaders = ["PERIOD", "KRA", "ACTIVITY", "ACTION"];

  final List<String> kpiHeaders = ["KPI", "ACTIONS"];

  bool isMenuOpenPeriod = false;
  bool isMenuOpenKra = false;
  List<KeyResultArea> kraListOptions = [];
  int? selectedKra;

  List<PgsPeriod> periodList = [];
  int? selectedPeriod;
  int? selectedPeriodCreateReport;
  String? selectedPeriodText;
  String? selectedPeriodTextCreateReport;
  String? _selectedPeriod;

  int? officeId;
  int? periodId;
  bool _hasAvailableDeliverables = false;

  @override
  void initState() {
    super.initState();
    _headerHorizontalController.addListener(_syncHeaderScroll);
    _horizontalController.addListener(_syncBodyScroll);
    () async {
      ;
      final period = await _commonService.fetchPgsPeriod();
      final kra = await _commonService.fetchKra();
      if (!mounted) return;

      setState(() {
        periodList = period;
        kraListOptions = kra;
      });
    }();
    fetchRoadmap();
    _loadCurrentUserId();
    fetchKpi();
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

  Future<void> _checkDeliverablesAvailability(Function setDialogState) async {
    if (_selectedPeriod == null) {
      setState(() {
        _hasAvailableDeliverables = false;
      });
      return;
    }

    try {
      periodId = int.tryParse(_selectedPeriod!) ?? 0;

      final filter = PgsFilter(
        periodId,
        officeId,
        null,
        null,
        null,
        null,
        null,
        null,
      );

      final queryParams =
          filter.toJson()..removeWhere((key, value) => value == null);

      final response = await AuthenticatedRequest.get(
        dio,
        ApiEndpoint().filterBy,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final items = data["items"] as List<dynamic>? ?? [];

        setDialogState(() {
          _hasAvailableDeliverables = items.isNotEmpty;
        });
      } else {
        setDialogState(() {
          _hasAvailableDeliverables = false;
        });
      }
    } catch (e) {
      debugPrint("Error checking deliverables availability: $e");
      setDialogState(() {
        _hasAvailableDeliverables = false;
      });
    }
    setDialogState(() {});
  }

  Future<bool> _hasCompleteAccomplishmentData(
    int deliverableId,
    int expectedPeriods,
  ) async {
    try {
      final List<PgsDeliverableAccomplishment> accomplishments =
          await _deliverableStatusMonitoring.fetchAccomplishments(
            deliverableId,
          );

      if (accomplishments.isEmpty || accomplishments.length < expectedPeriods) {
        return false;
      }

      int completedPeriods = 0;

      for (var i = 0; i < accomplishments.length; i++) {
        var accomplishment = accomplishments[i];

        final status = accomplishment.remarks;

        final attachmentPath = accomplishment.attachmentPath;

        bool hasValidStatus = status != null && status.toString().isNotEmpty;

        bool hasValidAttachment =
            attachmentPath != null && attachmentPath.isNotEmpty;

        bool isComplete = hasValidStatus && hasValidAttachment;

        if (isComplete) {
          completedPeriods++;
        } else {
          if (!hasValidStatus) debugPrint("    - Missing status: $status");
        }
      }

      bool allComplete = completedPeriods >= expectedPeriods;

      return allComplete;
    } catch (e) {
      return false;
    }
  }

  @override
  void dispose() {
    _verticalController.dispose();
    _horizontalController.dispose();
    _headerHorizontalController.dispose();
    super.dispose();
  }

  Future<void> fetchRoadmap() async {
    try {
      String endpoint;
      Map<String, dynamic>? queryParams;
      if (selectedKra == null &&
          (_selectedPeriod == null || _selectedPeriod!.isEmpty)) {
        endpoint = '${ApiEndpoint().scorecardMonitoringFilter}/kra-year';
        queryParams = null;
      } else {
        endpoint = ApiEndpoint().scorecardMonitoringFilter;
        final filter = ScoreCardMonitoringFilter(
          selectedKra,
          int.tryParse(_selectedPeriod ?? ''),
        );
        queryParams =
            filter.toJson()..removeWhere((key, value) => value == null);
      }

      final response = await AuthenticatedRequest.get(
        dio,
        endpoint,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final items = data["deliverables"] as List<dynamic>? ?? [];
        List<Map<String, dynamic>> formattedData =
            items.map((item) {
              return {
                'kraDescription': item['kraDescription'] ?? '',
                'deliverableName': item['deliverableDescription'] ?? '',
                'year': item['year']?.toString() ?? '',
              };
            }).toList();
        if (mounted) {
          setState(() {
            roadmapList = formattedData;
            filteredList = List.from(formattedData);
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching filtered data: $e");
    }
  }

  Future<void> fetchKpi() async {
    try {
      String endpoint = '${ApiEndpoint().scorecardMonitoringFilter}/kra';
      Map<String, dynamic>? queryParams;

      if (selectedKra != null) {
        queryParams = {'kraid': selectedKra};
      }

      final response = await AuthenticatedRequest.get(
        dio,
        endpoint,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final items = data["deliverables"] as List<dynamic>? ?? [];

        List<Map<String, dynamic>> formattedData =
            items.map((item) {
              return {
                'kpiDescription': item['kpiDescription'] ?? '',
                // add more fields if needed
              };
            }).toList();

        if (mounted) {
          setState(() {
            kpiList = formattedData;
            filteredList = List.from(formattedData);
          });
        }
      } else {
        debugPrint("Error: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching KPI data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    bool hasPermission = permissionService.hasPermission(
      AppPermissions.viewPgsDeliverableMonitor,
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
                  permission: AppPermissions.viewOffice,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        gap8px,
                        PopupMenuButton<int>(
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

                          onSelected: (int value) {
                            setState(() {
                              selectedKra = (value == -1) ? null : value;
                              isMenuOpenKra = false;

                              fetchRoadmap();
                            });
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

                            return updatedKraList.map<PopupMenuItem<int>>((
                              kra,
                            ) {
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
                      ],
                    ),
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
                  _buildKRATable(),
                  const SizedBox(height: 32),
                  _buildKPITable(),
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
                              _buildActionButton('', () {
                                debugPrint(
                                  'Edit KRA: ${item['pgsDeliverableId']}',
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
                            _tableCell('${item['id'] ?? index + 1}'),
                            _tableCell(item['kpiDescription'] ?? ''),
                            _buildKPIActionButtons(item['id'] ?? index + 1),
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
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
      ),
    );
  }

  Widget _buildActionButton(String label, VoidCallback onPressed) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: Colors.blue.shade600,
          backgroundColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildKPIActionButtons(int id) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: () {
              debugPrint('View KPI: $id');
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue.shade600,
              backgroundColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              minimumSize: const Size(40, 30),
            ),
            child: const Text(
              '',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(width: 4),
          TextButton(
            onPressed: () {
              debugPrint('Edit KPI: $id');
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue.shade600,
              backgroundColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              minimumSize: const Size(40, 30),
            ),
            child: const Text(
              '',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateAccomplishmentAndBreakthroughCell(
    int index,
    VoidCallback onPressed,
  ) {
    final deliverable = roadmapList[index];
    final deliverableId = deliverable['pgsDeliverableId'];

    final startDateStr = deliverable['Start Date'];
    final endDateStr = deliverable['End Date'];
    final startDate = DateFormat('MMM dd, yyyy').parse(startDateStr);
    final endDate = DateFormat('MMM dd, yyyy').parse(endDateStr);

    List<Map<String, dynamic>> monthlyPeriods = [];
    DateTime current = DateTime(startDate.year, startDate.month);
    DateTime end = DateTime(endDate.year, endDate.month);

    while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
      monthlyPeriods.add({
        'period': DateFormat('MMMM yyyy').format(current),
        'month': current.month,
        'year': current.year,
      });
      current = DateTime(current.year, current.month + 1);
    }
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Tooltip(
            message: 'Click to open Accomplishment Form',
            child: SizedBox(
              height: 30,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: const BorderSide(color: Colors.black, width: 1),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  textStyle: const TextStyle(fontSize: 13),
                  minimumSize: Size.zero,
                ).copyWith(
                  overlayColor: WidgetStateProperty.resolveWith<Color?>((
                    states,
                  ) {
                    if (states.contains(WidgetState.hovered) ||
                        states.contains(WidgetState.pressed)) {
                      return const Color.fromARGB(255, 221, 221, 221);
                    }
                    return null;
                  }),
                ),
                onPressed: () async {
                  await loadAccomplishments(deliverable['pgsDeliverableId']);
                  showAccomplishmentFormDialog(context, deliverable, userId);
                },
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
            ),
          ),

          const SizedBox(width: 8),

          FutureBuilder<bool>(
            future: _hasCompleteAccomplishmentData(
              deliverableId,
              monthlyPeriods.length,
            ),
            builder: (context, snapshot) {
              final hasCompleteData = snapshot.data ?? false;

              return Tooltip(
                message:
                    hasCompleteData
                        ? 'Click to open Breakthrough Scoring'
                        : "The accomplishment data hasn't been completed yet.",
                child: SizedBox(
                  height: 30,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          hasCompleteData
                              ? Colors.transparent
                              : Colors.grey.shade300,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: BorderSide(
                          color: hasCompleteData ? Colors.black : Colors.grey,
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      textStyle: const TextStyle(fontSize: 13),
                      minimumSize: Size.zero,
                    ).copyWith(
                      overlayColor: WidgetStateProperty.resolveWith<Color?>((
                        states,
                      ) {
                        if (hasCompleteData &&
                            (states.contains(WidgetState.hovered) ||
                                states.contains(WidgetState.pressed))) {
                          return const Color.fromARGB(255, 221, 221, 221);
                        }
                        return null;
                      }),
                    ),
                    onPressed:
                        hasCompleteData
                            ? () async {
                              await loadBreakThrough(deliverableId);
                              showBreakthroughFormDialog(
                                context,
                                deliverable,
                                userId,
                              );
                            }
                            : null,
                    icon: Icon(
                      Icons.star_outline,
                      size: 14,
                      color: hasCompleteData ? primaryTextColor : Colors.grey,
                    ),
                    label: Text(
                      'Breakthrough Scoring',
                      style: TextStyle(
                        color: hasCompleteData ? primaryTextColor : Colors.grey,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

Future<bool?> showAccomplishmentFormDialog(
  BuildContext context,
  Map<String, dynamic> deliverable,
  String userId,
) {
  final startDateStr = deliverable['Start Date'];
  final endDateStr = deliverable['End Date'];

  final startDate = DateFormat('MMM dd, yyyy').parse(startDateStr);
  final endDate = DateFormat('MMM dd, yyyy').parse(endDateStr);

  List<Map<String, dynamic>> monthlyPeriods = [];

  DateTime current = DateTime(startDate.year, startDate.month);
  DateTime end = DateTime(endDate.year, endDate.month);

  while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
    monthlyPeriods.add({
      'period': DateFormat('MMMM yyyy').format(current),
      'month': current.month,
      'year': current.year,
    });

    current = DateTime(current.year, current.month + 1);
  }

  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
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
                              "Accomplishment Form - ${DateFormat('MMMM dd, yyyy').format(startDate)} to ${DateFormat('MMMM dd, yyyy').format(endDate)}",
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
                                    "Office: ${deliverable['officeName'] ?? 'N/A'}",
                                  ),
                                  Text(
                                    "Monthly Tracking Periods: ${monthlyPeriods.length} month(s)",
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
                                  Text("KRA: ${deliverable['kra'] ?? 'N/A'}"),
                                  Text(
                                    "Due: ${deliverable['byWhen'] ?? 'N/A'}",
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Type: ${deliverable['isDirect'] == true ? 'Direct' : 'Indirect'}",
                              ),
                              Text(
                                "Deliverable: ${deliverable['deliverableName'] ?? 'N/A'}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Section title
                        const Row(
                          children: [
                            Icon(Icons.bar_chart_outlined, size: 18),
                            SizedBox(width: 8),
                            Text(
                              "Monthly Accomplishment Tracking",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Dynamic table
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
                                      flex: 3,
                                      child: Center(
                                        child: Text(
                                          "Remarks (Department Head)",
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
                                          "Remarks (Auditor)",
                                          style: TextStyle(color: grey),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ...monthlyPeriods.asMap().entries.map((entry) {
                                final index = entry.key;
                                final period = entry.value;
                                return Column(
                                  children: [
                                    const Divider(height: 1),
                                    TrackingRowWidget(
                                      period: period['period'],
                                      periodIndex: index,
                                      totalPeriods: monthlyPeriods.length,
                                      deliverableId:
                                          deliverable['pgsDeliverableId'],
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
                  allowedRoles: [
                    PermissionString.pgsAuditor,
                    PermissionString.roleAdmin,
                  ],
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
                          await saveAccomplishmentData(
                            deliverable['pgsDeliverableId'],
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

Future<bool?> showBreakthroughFormDialog(
  BuildContext context,
  Map<String, dynamic> deliverable,
  String userId,
) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        backgroundColor: mainBgColor,
        insetPadding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
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
                              "Breakthrough Form",
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

                        // Info section
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
                                    "Office: ${deliverable['officeName'] ?? 'N/A'}",
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("KRA: ${deliverable['kra'] ?? 'N/A'}"),
                                ],
                              ),
                              const SizedBox(height: 4),

                              Text(
                                "Type: ${deliverable['isDirect'] == true ? 'Direct' : 'Indirect'}",
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
                        ),
                        const SizedBox(height: 20),

                        const Row(
                          children: [
                            Icon(Icons.star_outline, size: 18),
                            SizedBox(width: 8),
                            Text(
                              "Breakthrough Scoring",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Dynamic table
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
                                          "Percent Accomplishment",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          "Target Achievement",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          "Strategic Contribution ",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          "Breakthrough Impact",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),

                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          "Final Score",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          "Final Grade",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Column(
                                children: [
                                  const Divider(height: 1),
                                  BreakthroughWidget(
                                    deliverableId:
                                        deliverable['pgsDeliverableId'],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20),
                PermissionWidget(
                  allowedRoles: [
                    PermissionString.pgsAuditor,
                    PermissionString.roleAdmin,
                  ],
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
                          await saveBreakthroughData(
                            deliverable['pgsDeliverableId'],
                          );
                          Navigator.of(context).pop(true);
                        },
                        child: Text(
                          "Save",
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
