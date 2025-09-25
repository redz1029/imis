// ignore_for_file: use_build_context_synchronously, deprecated_member_use
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imis/common_services/common_service.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/office/models/office.dart';
import 'package:imis/performance_governance_system/deliverable_status_monitoring/services/deliverable_status_monitoring_service.dart';
import 'package:imis/performance_governance_system/enum/pgs_status.dart';
import 'package:imis/performance_governance_system/key_result_area/models/key_result_area.dart';
import 'package:imis/performance_governance_system/models/pgs_deliverable_score_history.dart';
import 'package:imis/performance_governance_system/pgs_period/models/pgs_period.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/date_time_converter.dart';
import 'package:imis/utils/permission_string.dart';
import 'package:imis/utils/range_input_formatter.dart';
import 'package:imis/widgets/filter_button_widget.dart';
import 'package:imis/widgets/permission_widget.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import '../../../user/models/user_registration.dart';
import '../../../utils/auth_util.dart';
import '../../../utils/http_util.dart';
import '../../../utils/permission_service.dart';
import '../../../widgets/accomplishment_widget.dart';
import '../models/pgs_filter.dart';

class DeliverableStatusMonitoringPage extends StatefulWidget {
  const DeliverableStatusMonitoringPage({super.key});

  @override
  DeliverableStatusMonitoringPageState createState() =>
      DeliverableStatusMonitoringPageState();
}

class DeliverableStatusMonitoringPageState
    extends State<DeliverableStatusMonitoringPage> {
  final _commonService = CommonService(Dio());
  final _deliverableStatusMonitoring = DeliverableStatusMonitoringService(
    Dio(),
  );
  final _dateConverter = const LongDateOnlyConverter();

  final GlobalKey _menuScoreRangeKey = GlobalKey();
  final GlobalKey _menuPageKey = GlobalKey();
  Map<int, TextEditingController> remarkControllers = {};

  List<Map<String, dynamic>> deliverableList = [];
  List<Map<String, dynamic>> filteredList = [];
  Map<int, String> selectedByWhen = {};

  Map<int, TextEditingController> percentageControllers = {};
  Map<int, int> percentageValues = {};

  int accomplishmentCount = 3;
  List<KeyResultArea> kraListOptions = [];
  int? selectedKra;

  List<Office> officeList = [];
  String? _selectedOfficeId;

  List<PgsPeriod> periodList = [];
  int? selectedPeriod;
  String? selectedPeriodText;
  final PermissionService _permissionService = PermissionService();
  bool _hasEditPermission = false;
  List<PgsDeliverableHistoryGrouped> deliverableHistoryGrouped = [];
  List<PgsDeliverableHistoryGrouped> deliverableHistoryGroupedfilteredList = [];
  bool hasSeenOnGoingTip = false;
  Map<int, PgsStatus> selectedStatus = {};

  TextEditingController scoreRangeToController = TextEditingController();
  TextEditingController scoreRangeFromController = TextEditingController();
  TextEditingController pageController = TextEditingController();
  TextEditingController pageSizeController = TextEditingController();
  String userId = "";
  bool? isDirect;

  bool isMenuOpenOffice = false;
  bool isMenuOpenPeriod = false;
  bool isMenuOpenKra = false;
  bool isMenuOpenType = false;
  bool isMenuScoreRange = false;
  bool isMenuOpenPage = false;

  final dio = Dio();

  @override
  void initState() {
    super.initState();
    fetchFilteredPgsList();
    fetchScoreHistory();
    _checkPermissions();
    () async {
      final offices = await _deliverableStatusMonitoring.fetchOffices();
      final period = await _commonService.fetchPgsPeriod();
      final kra = await _commonService.fetchKra();
      if (!mounted) return;

      setState(() {
        officeList = offices;
        periodList = period;
        kraListOptions = kra;
      });
    }();
    _loadCurrentUserId();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _checkPermissions() {
    setState(() {
      _hasEditPermission = _permissionService.hasPermission(
        PermissionString.scorePgsDeliverableMonitor,
        allowedRoles: [PermissionString.pgsAuditor, PermissionString.roleAdmin],
      );
    });
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

  Future<void> fetchFilteredPgsList() async {
    try {
      int? scoreFrom =
          scoreRangeFromController.text.isNotEmpty
              ? int.tryParse(scoreRangeFromController.text)
              : null;
      int? scoreTo =
          scoreRangeToController.text.isNotEmpty
              ? int.tryParse(scoreRangeToController.text)
              : null;

      int? page =
          pageController.text.isNotEmpty
              ? int.tryParse(pageController.text)
              : null;
      int? pageSize =
          pageSizeController.text.isNotEmpty
              ? int.tryParse(pageSizeController.text)
              : null;

      final filter = PgsFilter(
        selectedPeriod,
        int.tryParse(_selectedOfficeId ?? ''),
        selectedKra,
        isDirect,
        scoreFrom,
        scoreTo,
        page,
        pageSize,
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

        remarkControllers.clear();
        percentageControllers.clear();
        percentageValues.clear();
        selectedStatus.clear();

        List<Map<String, dynamic>> formattedData =
            items.map((item) {
              String formattedByWhen = '';
              if (item['byWhen'] != null &&
                  item['byWhen'].toString().isNotEmpty) {
                try {
                  DateTime date = DateTime.parse(item['byWhen'].toString());
                  formattedByWhen = DateFormat('MMMM, yyyy').format(date);
                } catch (e) {
                  formattedByWhen = item['byWhen'].toString();
                }
              }

              deliverableHistoryGrouped.firstWhere(
                (h) => h.pgsDeliverableId == item['pgsDeliverableId'],
                orElse: () => PgsDeliverableHistoryGrouped(0, null),
              );

              return {
                'pgsDeliverableId': item['pgsDeliverableId'],
                'kra': item['keyResultArea'],
                'kraDescription': item['kraDescription'],
                'Start Date': item['pgsPeriod']?.split(" - ")?.first ?? '',
                'End Date': item['pgsPeriod']?.split(" - ")?.last ?? '',
                'officeName': item['office'],
                'isDirect': item['isDirect'],
                'deliverableName': item['deliverable'],
                'byWhen': formattedByWhen,
                'status':
                    item['status'] is PgsStatus
                        ? (item['status'] as PgsStatus).name
                        : item['status'].toString(),
                'remarks': item['remarks'],
                'score': item['score'],
              };
            }).toList();

        if (mounted) {
          setState(() {
            deliverableList = formattedData;
            filteredList = List.from(formattedData);
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching filtered data: $e");
    }
  }

  Future<void> fetchScoreHistory() async {
    var url = ApiEndpoint().pgsDeliverableScoreHistoryGrouped;

    try {
      var response = await AuthenticatedRequest.get(dio, url);

      if (response.statusCode == 200 && response.data is List) {
        List<PgsDeliverableHistoryGrouped> data =
            (response.data as List)
                .map((e) => PgsDeliverableHistoryGrouped.fromJson(e))
                .toList();

        setState(() {
          deliverableHistoryGrouped = data;
        });

        debugPrint("deliverable list loaded");
      }
    } catch (e) {
      debugPrint("fetchdeliverableList Error: $e");
    }
  }

  PgsStatus dynamicToPgsStatus(dynamic value) {
    if (value == null) return PgsStatus.notStarted;

    if (value is int) {
      if (value >= 0 && value < PgsStatus.values.length) {
        return PgsStatus.values[value];
      }
    }

    if (value is String) {
      try {
        return PgsStatus.values.firstWhere(
          (status) => status.name == value,
          orElse: () => PgsStatus.notStarted,
        );
      } catch (e) {
        debugPrint("Failed to parse status string");
      }
    }

    return PgsStatus.notStarted;
  }

  Widget _buildStatusCell(int index, VoidCallback setDialogState) {
    if (!selectedStatus.containsKey(index)) {
      final rawStatus = deliverableList[index]['status'];
      final parsedStatus = dynamicToPgsStatus(rawStatus);
      selectedStatus[index] = parsedStatus;
    }

    final statusDescriptions = {
      PgsStatus.notStarted:
          "Deliverable has been defined but work has not yet begun",
      PgsStatus.completed:
          "Deliverable has been finished and meets PGS requirements",
      PgsStatus.onGoing:
          "Deliverable is in progress and may be on hold pending decisions or resources",
    };

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child:
          _hasEditPermission
              ? DropdownButtonFormField<PgsStatus>(
                value: selectedStatus[index],
                onChanged: (PgsStatus? newValue) async {
                  if (newValue != null) {
                    setDialogState();
                    setState(() {
                      selectedStatus[index] = newValue;
                    });

                    if (newValue == PgsStatus.completed) {
                      percentageValues[index] = 100;
                      percentageControllers[index]?.text = '100';
                      setState(() {});
                    }

                    if (newValue == PgsStatus.notStarted) {
                      percentageValues[index] = 0;
                      percentageControllers[index]?.text = '0';
                      setState(() {});
                    }

                    if (newValue == PgsStatus.onGoing) {
                      percentageValues[index] = 0;
                      percentageControllers[index]?.text = '';
                    }
                  }
                },
                isExpanded: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(8.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),
                ),
                items:
                    PgsStatus.values.map((PgsStatus value) {
                      return DropdownMenuItem<PgsStatus>(
                        value: value,
                        child: Tooltip(
                          message: statusDescriptions[value] ?? value.name,
                          child: Text(
                            value.name,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      );
                    }).toList(),
              )
              : Center(
                child: Text(
                  selectedStatus[index]?.name ?? 'Unknown',
                  style: const TextStyle(fontSize: 13),
                ),
              ),
    );
  }

  void showFormDialog(int pgsDeliverableId) async {
    final groupedItem = deliverableHistoryGrouped.firstWhere(
      (item) => item.pgsDeliverableId == pgsDeliverableId,
      orElse: () => PgsDeliverableHistoryGrouped(pgsDeliverableId, null),
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: mainBgColor,

          contentPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.all(16),
          title: Stack(
            children: [
              const Text("Deliverable's History"),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                  color: primaryTextColor,
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: 1600,
            height: 700,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (groupedItem.scoreHistory != null &&
                      groupedItem.scoreHistory!.isNotEmpty)
                    _buildHistoryTable(groupedItem.scoreHistory!)
                  else
                    const Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Text('No history available for this deliverable'),
                    ),
                ],
              ),
            ),
          ),
          actions: [],
        );
      },
    );
  }

  Widget _buildHistoryTable(List<PgsDeliverableScoreHistory> items) {
    items.sort((a, b) => b.date.compareTo(a.date));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          color: Colors.grey.shade200,
          child: Row(
            children: const [
              Expanded(
                flex: 2,
                child: Text('Date', style: TextStyle(color: grey)),
              ),

              Expanded(
                flex: 2,
                child: Text('Status', style: TextStyle(color: grey)),
              ),
              Expanded(
                flex: 3,
                child: Text('Remarks', style: TextStyle(color: grey)),
              ),
              Expanded(
                flex: 1,
                child: Text('Score', style: TextStyle(color: grey)),
              ),
            ],
          ),
        ),

        const SizedBox(height: 4),

        ...items.map((item) {
          final date = item.date;
          final datePart = DateFormat('MMM. dd, yyyy').format(date);
          final timePart = DateFormat('hh:mm a').format(date);

          return Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                      children: [
                        TextSpan(text: datePart),
                        const WidgetSpan(child: SizedBox(width: 10)),
                        TextSpan(
                          text: timePart,
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    item.status.name,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    (item.remarks == null || item.remarks!.trim().isEmpty)
                        ? 'No Remarks'
                        : item.remarks!,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    '${item.score}%',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCreateAccomplishmentCell(int index, VoidCallback onPressed) {
    final deliverable = deliverableList[index];
    return Padding(
      padding: const EdgeInsets.all(4.0),
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
            overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
              if (states.contains(MaterialState.hovered)) {
                return const Color.fromARGB(255, 221, 221, 221);
              }
              if (states.contains(MaterialState.pressed)) {
                return const Color.fromARGB(255, 221, 221, 221);
              }
              return null; // default
            }),
          ),

          onPressed: () {
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
    );
  }

  Widget _buildRemarkCell(int index) {
    if (!remarkControllers.containsKey(index)) {
      final remarks = deliverableList[index]['remarks'];

      remarkControllers[index] = TextEditingController(text: remarks);
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child:
          _hasEditPermission
              ? ConstrainedBox(
                constraints: BoxConstraints(minHeight: 50.0),
                child: TextField(
                  controller: remarkControllers[index],
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  style: TextStyle(fontSize: 14.0),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: grey),
                    ),
                    contentPadding: EdgeInsets.all(8.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              )
              : Center(
                child: Text(
                  (remarkControllers[index]?.text.isEmpty ?? true)
                      ? 'No remarks'
                      : remarkControllers[index]!.text,
                ),
              ),
    );
  }

  Widget _buildScoringCell(int index) {
    if (!percentageControllers.containsKey(index)) {
      final score = deliverableList[index]['score'];
      final initialScore = (score is int && score <= 100) ? score : 0;

      percentageControllers[index] = TextEditingController(
        text: initialScore.toString(),
      );
      percentageValues[index] = initialScore;

      percentageControllers[index]!.addListener(() {
        final text = percentageControllers[index]!.text;
        final value = int.tryParse(text);
        setState(() {
          percentageValues[index] = (value != null && value <= 100) ? value : 0;
        });
      });
    }

    final status = selectedStatus[index];
    final int progress = percentageValues[index] ?? 0;

    double progressFraction;
    Color progressColor;

    if (status == PgsStatus.onGoing &&
        (percentageControllers[index]?.text.isEmpty ?? true)) {
      progressFraction = 0.0;
      progressColor = Colors.transparent;
    } else if (progress == 100) {
      progressFraction = 1.0;
      progressColor = Colors.green;
    } else if (progress == 0) {
      progressFraction = 1.0;
      progressColor = Colors.red;
    } else {
      progressFraction = progress / 100.0;
      progressColor = Colors.orange;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child:
          _hasEditPermission
              ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(
                          value: progressFraction,
                          strokeWidth: 6,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            progressColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            TextField(
                              onTap: () {
                                if (selectedStatus[index] ==
                                    PgsStatus.onGoing) {
                                  MotionToast.info(
                                    title: const Text("Ongoing Status"),
                                    description: const Text(
                                      "Enter a score between 1 to 99 only.",
                                    ),
                                    toastDuration: const Duration(seconds: 2),
                                    toastAlignment: Alignment.center,
                                    borderRadius: 10.0,
                                  ).show(context);
                                }
                              },
                              controller: percentageControllers[index],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              keyboardType: TextInputType.number,
                              readOnly:
                                  progress == 100 ||
                                  (progress == 0 &&
                                      selectedStatus[index] !=
                                          PgsStatus.onGoing),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 12,
                                ),
                                isDense: true,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(3),
                                if (selectedStatus[index] == PgsStatus.onGoing)
                                  RangeInputFormatter(1, 99)
                                else
                                  RangeInputFormatter(0, 100),
                              ],
                            ),
                            Positioned(
                              right: 0.5,
                              child: Text(
                                '%',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  gap16px,
                  Center(
                    child: TextButton(
                      onPressed: () {
                        final pgsDeliverableId =
                            deliverableList[index]['pgsDeliverableId'];
                        if (pgsDeliverableId != null) {
                          showFormDialog(pgsDeliverableId);
                          setState(() {
                            fetchScoreHistory();
                            fetchFilteredPgsList();
                          });
                        }
                      },
                      child: Text(
                        textAlign: TextAlign.center,
                        'View Score History',
                        style: TextStyle(
                          fontSize: 10,
                          color: primaryLightColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              )
              : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(
                          value:
                              (progress == 0 || progress == 100)
                                  ? 1.0
                                  : progress / 100.0,
                          strokeWidth: 6,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            progress == 100 ? Colors.green : Colors.red,
                          ),
                        ),
                      ),

                      SizedBox(
                        width: 40,
                        height: 40,
                        child: Center(
                          child: Text(
                            '$progress%',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  gap16px,
                  Center(
                    child: TextButton(
                      onPressed: () {
                        final pgsDeliverableId =
                            deliverableList[index]['pgsDeliverableId'];
                        if (pgsDeliverableId != null) {
                          showFormDialog(pgsDeliverableId);
                        }
                      },
                      child: Text(
                        textAlign: TextAlign.center,
                        'View Score History',
                        style: TextStyle(
                          fontSize: 10,
                          color: primaryLightColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainBgColor,
        title: const Text('Deliverables Status Monitoring'),
      ),
      backgroundColor: mainBgColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
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
                          Text(
                            'Filter by',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PopupMenuButton<String>(
                            color: mainBgColor,
                            offset: const Offset(0, 30),
                            onCanceled: () {
                              setState(() {
                                isMenuOpenPeriod = false;
                              });
                            },
                            onOpened: () {
                              setState(() {
                                isMenuOpenPeriod = true;
                              });
                            },
                            onSelected: (String value) {
                              setState(() {
                                selectedPeriod =
                                    value.isEmpty ? null : int.tryParse(value);
                                if (selectedPeriod == null) {
                                  selectedPeriodText = 'All Period';
                                } else {
                                  final selected = periodList.firstWhere(
                                    (period) => period.id == selectedPeriod,
                                    orElse:
                                        () => PgsPeriod(
                                          0,
                                          false,
                                          DateTime.now(),
                                          DateTime.now(),
                                          'remarks',
                                        ),
                                  );
                                  selectedPeriodText =
                                      "${_dateConverter.toJson(selected.startDate)} - ${_dateConverter.toJson(selected.endDate)}";
                                  isMenuOpenPeriod = true;
                                }
                                fetchFilteredPgsList();
                              });
                            },
                            itemBuilder: (BuildContext context) {
                              final updatedPeriodList = [
                                {'id': '', 'name': 'All Period'},
                                ...periodList.map(
                                  (period) => {
                                    'id': period.id,
                                    'name':
                                        "${_dateConverter.toJson(period.startDate)} - ${_dateConverter.toJson(period.endDate)}",
                                  },
                                ),
                              ];

                              return updatedPeriodList
                                  .map<PopupMenuItem<String>>((period) {
                                    return PopupMenuItem<String>(
                                      value: period['id'].toString(),
                                      child: Text(period['name']!.toString()),
                                    );
                                  })
                                  .toList();
                            },
                            child: FilterButton(
                              label:
                                  selectedPeriod == null
                                      ? 'All Period'
                                      : selectedPeriodText ?? 'Period',
                              isActive: isMenuOpenPeriod,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PopupMenuButton<String>(
                            color: mainBgColor,
                            offset: const Offset(0, 30),
                            onCanceled: () {
                              setState(() {
                                isMenuOpenOffice = false;
                              });
                            },
                            onOpened: () {
                              setState(() {
                                isMenuOpenOffice = true;
                              });
                            },
                            onSelected: (String value) {
                              setState(() {
                                _selectedOfficeId =
                                    value.isEmpty ? null : value;
                                isMenuOpenOffice = false;
                                fetchFilteredPgsList();
                              });
                            },
                            itemBuilder: (BuildContext context) {
                              final updatedOfficeList = [
                                {'id': '', 'name': 'All Offices'},
                                ...officeList.map(
                                  (o) => {'id': o.id, 'name': o.name},
                                ),
                              ];

                              final searchController = TextEditingController();
                              ValueNotifier<String> searchQuery = ValueNotifier(
                                '',
                              );

                              return [
                                PopupMenuItem<String>(
                                  enabled: false,
                                  height: kMinInteractiveDimension,
                                  child: Column(
                                    children: [
                                      TextField(
                                        controller: searchController,
                                        decoration: InputDecoration(
                                          hintText: 'Search offices...',
                                          hintStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                          prefixIcon: Icon(
                                            Icons.search,
                                            size: 18,
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 8,
                                          ),
                                          border: OutlineInputBorder(),
                                          isDense: true,
                                        ),
                                        onChanged: (value) {
                                          searchQuery.value =
                                              value.toLowerCase();
                                        },
                                      ),
                                      const Divider(height: 16, thickness: 1),
                                    ],
                                  ),
                                ),

                                PopupMenuItem<String>(
                                  enabled: false,
                                  child: ValueListenableBuilder<String>(
                                    valueListenable: searchQuery,
                                    builder: (context, query, _) {
                                      final filteredOffices =
                                          updatedOfficeList
                                              .where(
                                                (office) => office['name']
                                                    .toString()
                                                    .toLowerCase()
                                                    .contains(query),
                                              )
                                              .toList();

                                      return ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxHeight:
                                              MediaQuery.of(
                                                context,
                                              ).size.height *
                                              0.4,
                                        ),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children:
                                                filteredOffices
                                                    .map<Widget>(
                                                      (office) => ListTile(
                                                        dense: true,
                                                        title: Text(
                                                          office['name']
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                color:
                                                                    Colors
                                                                        .black,
                                                              ),
                                                        ),
                                                        onTap: () {
                                                          Navigator.pop(
                                                            context,
                                                          );
                                                          setState(() {
                                                            _selectedOfficeId =
                                                                office['id']
                                                                    .toString();
                                                            fetchFilteredPgsList();
                                                          });
                                                        },
                                                      ),
                                                    )
                                                    .toList(),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ];
                            },

                            child: FilterButton(
                              label:
                                  _selectedOfficeId == null
                                      ? 'All Offices'
                                      : officeList
                                          .firstWhere(
                                            (office) =>
                                                office.id.toString() ==
                                                _selectedOfficeId,
                                            orElse:
                                                () => Office(
                                                  id: 0,
                                                  name: 'Office',
                                                ),
                                          )
                                          .name,
                              isActive: isMenuOpenOffice,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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

                                fetchFilteredPgsList();
                              });
                            },
                            itemBuilder: (BuildContext context) {
                              final updatedKraList = [
                                {'id': -1, 'name': 'All KRA'},
                                ...kraListOptions.map(
                                  (k) => {
                                    'id': k.id,
                                    'name': k.name,
                                    'remakrs': k.remarks,
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

                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PopupMenuButton<String>(
                            color: mainBgColor,
                            offset: const Offset(0, 30),
                            onCanceled: () {
                              setState(() {
                                isMenuOpenType = false;
                              });
                            },
                            onOpened: () {
                              setState(() {
                                isMenuOpenType = true;
                              });
                            },
                            onSelected: (String value) {
                              setState(() {
                                if (value.isEmpty) {
                                  isDirect = null;
                                } else if (value == 'true') {
                                  isDirect = true;
                                } else {
                                  isDirect = false;
                                }
                                isMenuOpenType = false;

                                fetchFilteredPgsList();
                              });
                            },
                            itemBuilder: (BuildContext context) {
                              return [
                                PopupMenuItem<String>(
                                  value: '',
                                  child: Text('All Types'),
                                ),
                                PopupMenuItem<String>(
                                  value: 'true',
                                  child: Text('Direct'),
                                ),
                                PopupMenuItem<String>(
                                  value: 'false',
                                  child: Text('Indirect'),
                                ),
                              ];
                            },
                            child: FilterButton(
                              label:
                                  isDirect == null
                                      ? 'All Types'
                                      : isDirect!
                                      ? 'Direct'
                                      : 'Indirect',
                              isActive: isMenuOpenType,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            key: _menuScoreRangeKey,
                            onTap: () => _showScoreRangeMenu(context),
                            child: FilterButton(
                              label:
                                  (scoreRangeFromController.text.isEmpty ||
                                          scoreRangeToController.text.isEmpty)
                                      ? 'Score Range'
                                      : 'From ${scoreRangeFromController.text} to ${scoreRangeToController.text}',
                              isActive: isMenuScoreRange,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            key: _menuPageKey,
                            onTap: () => _showPageSizeMenu(context),
                            child: FilterButton(
                              label:
                                  (pageController.text.isEmpty ||
                                          pageSizeController.text.isEmpty)
                                      ? 'Page'
                                      : 'From ${pageController.text} to ${pageSizeController.text}',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Column(
                  children: [
                    // HEADER (Fixed)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        color: primaryLightColor,
                        child: Table(
                          border: TableBorder.all(
                            color: Colors.black,
                            width: 1.0,
                          ),
                          columnWidths: const {
                            0: FlexColumnWidth(0.5),
                            1: FlexColumnWidth(2),
                            2: FlexColumnWidth(2),
                            3: FlexColumnWidth(3),
                            4: FlexColumnWidth(1.5),
                            5: FlexColumnWidth(4),
                            6: FlexColumnWidth(2),
                            // 7: FlexColumnWidth(7),
                            7: FlexColumnWidth(2),
                            8: FlexColumnWidth(2),
                            9: FlexColumnWidth(2),
                            10: FlexColumnWidth(2.5),
                          },
                          children: [
                            TableRow(
                              children: [
                                _buildTableHeaderCell('#'),
                                _buildTableHeaderCell('PERIOD'),
                                _buildTableHeaderCell('OFFICE'),
                                _buildTableHeaderCell('KRA'),
                                _buildTableHeaderCell('DIRECT'),
                                _buildTableHeaderCell('DELIVERABLES'),
                                _buildTableHeaderCell('BY WHEN'),
                                _buildTableHeaderCell('STATUS'),
                                _buildTableHeaderCell('REMARKS'),
                                _buildTableHeaderCell('SCORE'),
                                _buildTableHeaderCell('ACTIONS'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: constraints.maxWidth,
                          ),
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              child: Table(
                                border: TableBorder.all(
                                  color: Colors.black,
                                  width: 1.0,
                                ),
                                defaultVerticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                columnWidths: const {
                                  0: FlexColumnWidth(0.5),
                                  1: FlexColumnWidth(2),
                                  2: FlexColumnWidth(2),
                                  3: FlexColumnWidth(3),
                                  4: FlexColumnWidth(1.5),
                                  5: FlexColumnWidth(4),
                                  6: FlexColumnWidth(2),
                                  // 7: FlexColumnWidth(2),
                                  // 7: FlexColumnWidth(2),
                                  // 9: FlexColumnWidth(2),
                                  7: FlexColumnWidth(2),
                                  8: FlexColumnWidth(2),
                                  9: FlexColumnWidth(2),
                                  10: FlexColumnWidth(2.5),
                                },

                                children: [
                                  ...deliverableList.asMap().entries.map((
                                    entry,
                                  ) {
                                    final int index = entry.key;
                                    final deliverable = entry.value;

                                    return TableRow(
                                      children: [
                                        _buildTableCell('${index + 1}'),
                                        _buildTableCell(
                                          '${deliverable['Start Date']} - ${deliverable['End Date']}',
                                        ),
                                        _buildTableCell(
                                          deliverable['officeName'] ?? '',
                                        ),
                                        _buildKRA(
                                          deliverable['kra'] ?? ' ',
                                          deliverable['kraDescription'],
                                        ),
                                        _buildTableCell(
                                          '',
                                          isDirect: deliverable['isDirect'],
                                        ),
                                        _buildTableCell(
                                          deliverable['deliverableName'] ?? '',
                                        ),
                                        _buildTableCell(
                                          deliverable['byWhen'] ?? '',
                                        ),
                                        _buildStatusCell(index, () => (index)),
                                        _buildRemarkCell(index),
                                        _buildScoringCell(index),
                                        _buildCreateAccomplishmentCell(
                                          index,
                                          () {},
                                        ),
                                      ],
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // PermissionWidget(
              //   allowedRoles: [
              //     PermissionString.pgsAuditor,
              //     PermissionString.roleAdmin,
              //   ],
              //   child: Padding(
              //     padding: const EdgeInsets.all(32.0),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.end,
              //       children: [
              //         ElevatedButton(
              //           onPressed: () async {
              //             bool? confirmAction = await showDialog<bool>(
              //               context: context,
              //               builder: (context) {
              //                 return AlertDialog(
              //                   title: Text("Confirm Save"),
              //                   content: Text(
              //                     "Are you sure you want to save this record?",
              //                   ),
              //                   actions: [
              //                     TextButton(
              //                       onPressed:
              //                           () => Navigator.pop(context, false),
              //                       child: Text(
              //                         "No",
              //                         style: TextStyle(color: primaryColor),
              //                       ),
              //                     ),
              //                     TextButton(
              //                       onPressed: () {
              //                         {
              //                           Navigator.pop(context, true);
              //                         }
              //                       },
              //                       child: Text(
              //                         "Yes",
              //                         style: TextStyle(color: primaryColor),
              //                       ),
              //                     ),
              //                   ],
              //                 );
              //               },
              //             );
              //             if (confirmAction == true) {
              //               final dataToSave = _prepareSaveData();

              //               try {
              //                 await _deliverableStatusMonitoring.saveData(
              //                   dataToSave,
              //                 );

              //                 if (mounted) {
              //                   MotionToast.success(
              //                     title: const Text("Success"),
              //                     description: const Text(
              //                       "Data saved successfully!",
              //                     ),
              //                     toastAlignment: Alignment.topCenter,
              //                   ).show(context);
              //                 }
              //               } catch (e) {
              //                 debugPrint("Error saving data: $e");
              //                 if (mounted) {
              //                   MotionToast.error(
              //                     title: const Text("Failed"),
              //                     description: Text("Error: $e"),
              //                     toastAlignment: Alignment.topCenter,
              //                   ).show(context);
              //                 }
              //               }
              //             }
              //           },
              //           style: ElevatedButton.styleFrom(
              //             backgroundColor: primaryColor,
              //             shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(4),
              //             ),
              //           ),
              //           child: Text(
              //             'Save',
              //             style: TextStyle(color: Colors.white),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          );
        },
      ),
    );
  }

  void _showScoreRangeMenu(BuildContext context) {
    final RenderBox renderBox =
        _menuScoreRangeKey.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    showMenu(
      color: secondaryColor,
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + renderBox.size.height,
        offset.dx + renderBox.size.width,
        offset.dy + renderBox.size.height + 200,
      ),
      items: [
        PopupMenuItem(
          enabled: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Score Range',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              gap4px,
              TextField(
                controller: scoreRangeFromController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'From',
                  labelStyle: TextStyle(color: grey, fontSize: 12),
                  isDense: true,
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),

                  floatingLabelStyle: TextStyle(
                    color: primaryColor,
                    fontSize: 12,
                  ),
                ),
              ),
              gap16px,
              TextField(
                controller: scoreRangeToController,
                keyboardType: TextInputType.none,
                decoration: const InputDecoration(
                  labelText: 'To',
                  labelStyle: TextStyle(color: grey, fontSize: 12),
                  isDense: true,
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),
                  floatingLabelStyle: TextStyle(
                    color: primaryColor,
                    fontSize: 12,
                  ),
                ),
              ),
              gap16px,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: primaryColor),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    onPressed: () {
                      scoreRangeFromController.text;
                      scoreRangeToController.text;
                      fetchFilteredPgsList();
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Apply',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showPageSizeMenu(BuildContext context) {
    final RenderBox renderBox =
        _menuPageKey.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    showMenu(
      color: secondaryColor,
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + renderBox.size.height,
        offset.dx + renderBox.size.width,
        offset.dy + renderBox.size.height + 200,
      ),
      items: [
        PopupMenuItem(
          enabled: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: pageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Page',
                  labelStyle: TextStyle(color: grey, fontSize: 12),
                  isDense: true,
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),
                  floatingLabelStyle: TextStyle(
                    color: primaryColor,
                    fontSize: 12,
                  ),
                ),
              ),
              gap16px,
              TextField(
                controller: pageSizeController,
                keyboardType: TextInputType.none,
                decoration: const InputDecoration(
                  labelText: 'Page Size',
                  labelStyle: TextStyle(color: grey, fontSize: 12),
                  isDense: true,
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),
                  floatingLabelStyle: TextStyle(
                    color: primaryColor,
                    fontSize: 12,
                  ),
                ),
              ),
              gap16px,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: primaryColor),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    onPressed: () {
                      pageController.text;
                      pageSizeController.text;
                      fetchFilteredPgsList();
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Apply',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTableHeaderCell(String text, {double fontSize = 12}) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
          textAlign: TextAlign.start,
        ),
      ),
    );
  }

  Widget _buildTableCell(String text, {bool? isDirect}) {
    String displayText = text;
    if (isDirect != null) {
      displayText = isDirect ? 'Direct' : 'Indirect';
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(),
      child: Center(
        child: Text(
          displayText,
          style: const TextStyle(fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildKRA(String textKra, String textKraDescription) {
    String displayKra = textKra;
    String displayDescription = textKraDescription;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              displayKra,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          gap16px,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'KRA Description:',
                style: TextStyle(fontSize: 10, color: grey),
              ),
              Text(
                displayDescription,
                style: const TextStyle(fontSize: 10),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void showAccomplishmentFormDialog(
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

  showDialog(
    context: context,
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
                              "Accomplishment Form - ${deliverable['Start Date']} to ${deliverable['End Date']}",
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
                                "Deliverable: ${deliverable['deliverableName'] ?? 'N/A'}",
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Type: ${deliverable['isDirect'] == true ? 'Direct' : 'Indirect'}",
                              ),
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
                                          "Remarks",
                                          style: TextStyle(color: grey),
                                        ),
                                      ),
                                    ),

                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          "Upload Proof Photo",
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
                        onPressed: () {
                          saveAccomplishmentData(
                            deliverable['pgsDeliverableId'],
                            userId,
                          );
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Save Accomplishments",
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
