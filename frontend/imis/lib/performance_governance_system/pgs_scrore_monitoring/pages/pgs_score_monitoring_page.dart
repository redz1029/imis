import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/office/models/office.dart';
import 'package:imis/performance_governance_system/enum/pgs_status.dart';
import 'package:imis/performance_governance_system/models/pgs_deliverable_score_history.dart';
import 'package:imis/performance_governance_system/pgs_period/models/pgs_period.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/app_permission.dart';
import 'package:imis/utils/range_input_formatter.dart';
import 'package:imis/widgets/filter_button_widget.dart';
import 'package:imis/widgets/permission_widget.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import '../../../utils/http_util.dart';
import '../models/pgs_filter.dart';

class PgsScoreMonitoringPage extends StatefulWidget {
  const PgsScoreMonitoringPage({super.key});

  @override
  PgsScoreMonitoringPageState createState() => PgsScoreMonitoringPageState();
}

class PgsScoreMonitoringPageState extends State<PgsScoreMonitoringPage> {
  final GlobalKey _menuScoreRangeKey = GlobalKey();
  final GlobalKey _menuPageKey = GlobalKey();
  Map<int, TextEditingController> remarkControllers = {};

  List<Map<String, dynamic>> deliverableList = [];
  List<Map<String, dynamic>> filteredList = [];
  Map<int, String> selectedByWhen = {};

  Map<int, TextEditingController> percentageControllers = {};
  Map<int, int> percentageValues = {};

  List<Map<String, dynamic>> kraListOptions = [];
  Map<int, int?> selectedKRA = {};
  int? selectedKra;

  List<Map<String, dynamic>> officeList = [];
  List<Map<String, dynamic>> filteredListOffice = [];
  String? _selectedOfficeId;

  List<Map<String, dynamic>> periodList = [];
  List<Map<String, dynamic>> filteredListPeriod = [];
  int? selectedPeriod;
  String? selectedPeriodText;

  List<PgsDeliverableHistoryGrouped> deliverableHistoryGrouped = [];
  List<PgsDeliverableHistoryGrouped> deliverableHistoryGroupedfilteredList = [];

  Map<int, PgsStatus> selectedStatus = {};

  TextEditingController scoreRangeToController = TextEditingController();
  TextEditingController scoreRangeFromController = TextEditingController();

  TextEditingController pageController = TextEditingController();
  TextEditingController pageSizeController = TextEditingController();

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
    fetchOffice();
    fetchKra();
    fetchPGSPeriods();
    fetchScoreHistory();
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
                'status': item['status'],
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

  Future<void> saveData() async {
    var url = ApiEndpoint().pgsScoreMonitoring;
    try {
      final dataToSave = _prepareSaveData();
      final response = await AuthenticatedRequest.put(
        dio,
        url,
        data: {'items': dataToSave},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchFilteredPgsList();
        if (mounted) {
          MotionToast.success(
            title: const Text("Success"),
            description: const Text("Data saved successfully!"),

            // ignore: deprecated_member_use
            position: MotionToastPosition.top,
          ).show(context);
        }
        await fetchScoreHistory();
        setState(() {
          fetchFilteredPgsList();
        });
      }
    } catch (e) {
      debugPrint("Error adding/updating KRA: $e");
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

  List<Map<String, dynamic>> _prepareSaveData() {
    return deliverableList.asMap().entries.map((entry) {
      final int index = entry.key;
      final deliverable = entry.value;

      final score = percentageValues[index] ?? deliverable['score'] ?? 0;
      final status = selectedStatus[index]?.name ?? deliverable['status'] ?? '';
      final remarks =
          remarkControllers[index]?.text ?? deliverable['remarks'] ?? '';

      DateTime? byWhenDate;
      String formattedByWhen = '';

      try {
        if (deliverable['byWhen'] != null &&
            deliverable['byWhen'].toString().isNotEmpty) {
          if (deliverable['byWhen'] is String) {
            byWhenDate = DateTime.tryParse(deliverable['byWhen']);
          }

          byWhenDate ??= DateFormat('MMMM, yyyy').parse(deliverable['byWhen']);

          formattedByWhen = byWhenDate.toIso8601String();
        }
      } catch (e) {
        debugPrint("Error parsing byWhen date: $e");
      }

      return {
        'pgsDeliverableId': deliverable['pgsDeliverableId'] ?? 0,
        'pgsPeriod':
            '${deliverable['Start Date']} - ${deliverable['End Date']}',
        'office': deliverable['officeName'] ?? '',
        'keyResultArea': deliverable['kra'] ?? '',
        'kraDescription': deliverable['kraDescription'] ?? '',
        'isDirect': deliverable['isDirect'] ?? false,
        'deliverable': deliverable['deliverableName'] ?? '',
        'score': score,
        'status': status,
        'remarks': remarks,
        'byWhen': formattedByWhen,
      };
    }).toList();
  }

  Future<void> fetchPGSPeriods() async {
    var url = ApiEndpoint().pgsperiod;

    try {
      var response = await AuthenticatedRequest.get(dio, url);

      if (response.statusCode == 200 && response.data is List) {
        List<PgsPeriod> data =
            (response.data as List)
                .map((period) => PgsPeriod.fromJson(period))
                .toList();

        if (mounted) {
          setState(() {
            periodList = data.map((period) => period.toJson()).toList();
            filteredListPeriod = List.from(periodList);
          });
        }
      } else {
        debugPrint("Unexpected response format: ${response.data.runtimeType}");
      }
    } on DioException catch (e) {
      debugPrint("Dio error: ${e.response?.data ?? e.message}");
    } catch (e) {
      debugPrint("Unexpected error: $e");
    }
  }

  Future<void> fetchKra() async {
    var url = ApiEndpoint().keyresult;
    try {
      var response = await AuthenticatedRequest.get(dio, url);

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;

        kraListOptions =
            data.map<Map<String, dynamic>>((item) {
              return {'id': item['id'] as int, 'name': item['name'].toString()};
            }).toList();
      } else {
        debugPrint("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching data: $e");
    }
  }

  Future<void> fetchOffice() async {
    var url = ApiEndpoint().office;

    try {
      final response = await AuthenticatedRequest.get(dio, url);

      if (response.statusCode == 200 && response.data is List) {
        List<Office> data =
            (response.data as List)
                .map((office) => Office.fromJson(office))
                .toList();

        if (mounted) {
          setState(() {
            officeList = data.map((office) => office.toJson()).toList();
            filteredListOffice = List.from(officeList);

            debugPrint("Auto-selected office: $_selectedOfficeId");
          });
        }
      } else {
        debugPrint("Unexpected response format: ${response.data.runtimeType}");
      }
    } on DioException catch (e) {
      debugPrint("Dio error: ${e.response?.data ?? e.message}");
    } catch (e) {
      debugPrint("Unexpected error: $e");
    }
  }

  void saveStatusToDb(int index, PgsStatus status) {
    int statusIndex = status.index;

    debugPrint('Saving status for index $index: $statusIndex');
  }

  PgsStatus dynamicToPgsStatus(dynamic value) {
    if (value == null) return PgsStatus.notStarted;

    // Handle integer index
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
        debugPrint("Failed to parse status string: $value");
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

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField<PgsStatus>(
        value: selectedStatus[index],
        onChanged: (PgsStatus? newValue) {
          if (newValue != null) {
            setDialogState();
            setState(() {
              selectedStatus[index] = newValue;
            });
            saveStatusToDb(index, newValue);
          }
        },
        isExpanded: true,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.all(8.0),
        ),
        items:
            PgsStatus.values.map((PgsStatus value) {
              return DropdownMenuItem<PgsStatus>(
                value: value,
                child: Text(value.name, style: const TextStyle(fontSize: 13)),
              );
            }).toList(),
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
          backgroundColor: mainBgColor,
          contentPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.all(16),
          title: Stack(
            children: [
              const Text('Score History'),
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
            width: 600,
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
                child: Text(
                  'Date',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  'Score',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 4),

        ...items.map((item) {
          final date = item.date;
          final datePart = DateFormat('MMM, dd, yyyy').format(date);
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

  Widget _buildRemarkCell(int index) {
    if (!remarkControllers.containsKey(index)) {
      final remarks = deliverableList[index]['remarks'];

      remarkControllers[index] = TextEditingController(text: remarks);
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 50.0),
        child: TextField(
          controller: remarkControllers[index],
          maxLines: null,
          keyboardType: TextInputType.multiline,
          style: TextStyle(fontSize: 14.0),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.all(8.0),
          ),
          onChanged: (value) {
            setState(() {
              debugPrint("Updated TextField at index $index: $value");
            });
          },
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

    final int progress = percentageValues[index] ?? 0;
    final double progressFraction = progress / 100.0;

    Color progressColor;
    if (progress < 50) {
      progressColor = Colors.red;
    } else if (progress < 80) {
      progressColor = Colors.orange;
    } else {
      progressColor = Colors.green;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
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
                  valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                ),
              ),
              SizedBox(
                width: 40,
                height: 40,
                child: Center(
                  child: TextField(
                    controller: percentageControllers[index],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      suffixText: '%',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                      RangeInputFormatter(1, 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
          gap,
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainBgColor,
        title: const Text('PGS Score Monitoring'),
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
                                  final selected = filteredListPeriod
                                      .firstWhere(
                                        (period) =>
                                            period['id'] == selectedPeriod,
                                        orElse:
                                            () => {
                                              'startDate': '',
                                              'endDate': '',
                                            },
                                      );
                                  selectedPeriodText =
                                      "${selected['startDate']} - ${selected['endDate']}";
                                  isMenuOpenPeriod = true;
                                }
                                fetchFilteredPgsList();
                              });
                            },
                            itemBuilder: (BuildContext context) {
                              final updatedPeriodList = [
                                {'id': '', 'name': 'All Period'},
                                ...filteredListPeriod.map(
                                  (period) => {
                                    'id': period['id'].toString(),
                                    'name':
                                        "${period['startDate']} - ${period['endDate']}",
                                  },
                                ),
                              ];

                              return updatedPeriodList
                                  .map<PopupMenuItem<String>>((period) {
                                    return PopupMenuItem<String>(
                                      value: period['id'],
                                      child: Text(period['name']!),
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
                                ...filteredListOffice,
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
                                // Scrollable office list
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
                                                          office['name'],
                                                          style: TextStyle(
                                                            color: Colors.black,
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
                                      : filteredListOffice.firstWhere(
                                        (office) =>
                                            office['id'].toString() ==
                                            _selectedOfficeId,
                                        orElse: () => {'name': 'Office'},
                                      )['name'],
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
                                ...kraListOptions,
                              ];

                              return updatedKraList.map<PopupMenuItem<int>>((
                                kra,
                              ) {
                                return PopupMenuItem<int>(
                                  value: kra['id'] as int,
                                  child: Text(kra['name']),
                                );
                              }).toList();
                            },
                            child: FilterButton(
                              label:
                                  selectedKra == null
                                      ? 'All KRA'
                                      : kraListOptions.firstWhere(
                                        (kra) => kra['id'] == selectedKra,
                                        orElse: () => {'name': 'Unknown'},
                                      )['name'],
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
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Table(
                          border: TableBorder.all(
                            color: Colors.black,
                            width: 1.0,
                          ),
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          columnWidths: const {
                            0: FlexColumnWidth(2),
                            1: FlexColumnWidth(2),
                            2: FlexColumnWidth(2),
                            3: FlexColumnWidth(1.5),
                            4: FlexColumnWidth(4),
                            5: FlexColumnWidth(2),
                            6: FlexColumnWidth(2),
                            7: FlexColumnWidth(3),
                            8: FlexColumnWidth(2),
                          },
                          children: [
                            TableRow(
                              children: [
                                _buildTableHeaderCell('PERIOD'),
                                _buildTableHeaderCell('OFFICE'),
                                _buildTableHeaderCell('KRA'),
                                _buildTableHeaderCell('DIRECT'),
                                _buildTableHeaderCell('DELIVERABLES'),
                                _buildTableHeaderCell('BY WHEN'),
                                _buildTableHeaderCell('STATUS'),
                                _buildTableHeaderCell('REMARKS'),
                                _buildTableHeaderCell('SCORE'),
                              ],
                            ),

                            ...deliverableList.asMap().entries.map((entry) {
                              final int index = entry.key;
                              final deliverable = entry.value;

                              return TableRow(
                                children: [
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
                                  _buildTableCell(deliverable['byWhen'] ?? ''),

                                  _buildStatusCell(index, () => (index)),
                                  _buildRemarkCell(index),
                                  _buildScoringCell(index),
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

              PermissionWidget(
                permission: AppPermission.scorePgsDeliverableMonitor,
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          bool? confirmAction = await showDialog<bool>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Confirm Save"),
                                content: Text(
                                  "Are you sure you want to save this record?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.pop(context, false),
                                    child: Text(
                                      "No",
                                      style: TextStyle(color: primaryColor),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      {
                                        Navigator.pop(context, true);
                                      }
                                    },
                                    child: Text(
                                      "Yes",
                                      style: TextStyle(color: primaryColor),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                          if (confirmAction == true) {
                            await saveData();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
              gap2,
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
              gap,
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
              gap,
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
              gap,
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
              gap,
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
      color: primaryLightColor,
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
          displayText, // Use the computed text
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
          gap,
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
