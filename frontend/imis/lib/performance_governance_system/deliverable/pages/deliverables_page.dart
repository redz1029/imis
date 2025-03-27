import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/office/models/office.dart';
import 'package:imis/performance_governance_system/enum/pgs_status.dart';
import 'package:imis/performance_governance_system/key_result_area/models/key_result_area.dart';
import 'package:imis/performance_governance_system/models/pgs_audit_details.dart';
import 'package:imis/performance_governance_system/models/pgs_audit_result.dart';
import 'package:imis/performance_governance_system/models/pgs_deliverables.dart';
import 'package:imis/performance_governance_system/models/pgs_readiness.dart';
import 'package:imis/performance_governance_system/pgs_period/models/pgs_period.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeliverablesPage extends StatefulWidget {
  const DeliverablesPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DeliverablesPageState createState() => _DeliverablesPageState();
}

class _DeliverablesPageState extends State<DeliverablesPage> {
  Map<int, TextEditingController> deliverablesControllers = {};
  Map<int, TextEditingController> selectedByWhenControllers = {};
  Map<int, Map<String, dynamic>> selectedKRAObjects = {};
  late Future<List<Map<String, dynamic>>> deliverables;
  Map<int, PgsStatus> selectedStatus = {};
  Map<int, String> selectedValues = {};
  Map<int, String> selectedByWhen = {};
  Map<int, String> selectedStatusOptions = {};
  Map<int, bool> selectedDirect = {};
  Map<int, bool> selectedIndirect = {};
  Map<int, bool> tempSelectedDirect = {};
  Map<int, bool> tempSelectedIndirect = {};
  Map<int, int?> selectedKRA = {};

  List<Map<String, dynamic>> deliverableList = [];
  List<Map<String, dynamic>> filteredList = [];
  List<Map<String, dynamic>> options = [];
  List<String> kraOptions = [];

  List<int> rows = [];
  int rowIndex = 1;

  //For search controller
  TextEditingController searchController = TextEditingController();
  final FocusNode isSearchFocus = FocusNode();

  List<String> pgsStatusOptions = PgsStatus.values.map((e) => e.name).toList();
  List<String> StatusOptions = ['PATIENT', 'RESEARCH', 'LINKAGES', 'HR'];

  //Start Readiness Rating-Cancer Care------------------------------------------------------------------------------------------------
  TextEditingController competenceScoreController = TextEditingController(
    text: '',
  );
  TextEditingController resourceScoreController = TextEditingController(
    text: '',
  );
  TextEditingController confidenceScoreController = TextEditingController(
    text: '',
  );
  TextEditingController totalScoreController = TextEditingController(text: '');

  // Variables to store dropdown selections
  ValueNotifier<double> competenceScore = ValueNotifier(0.0);
  ValueNotifier<double> resourceScore = ValueNotifier(0.0);
  ValueNotifier<double> confidenceScore = ValueNotifier(0.0);

  double get totalScore =>
      competenceScore.value + resourceScore.value + confidenceScore.value;

  bool isValidInput(String value) {
    return value.isEmpty || value == '0' || value == '0.5' || value == '1';
  }

  final dio = Dio();

  //Save pgs
  Future<void> savePGS(PgsAuditDetails audit) async {
    var url = ApiEndpoint().pgsauditdetails;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('accessToken');

      if (token == null || token.isEmpty) {
        debugPrint("Error: Access token is missing!");
        return;
      }

      final Map<String, dynamic> requestData = audit.toJson();

      final response = await dio.post(
        url,
        data: requestData,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // await fetchPgs();
        // setState(() {
        //   fetchPgs();
        // });
        debugPrint("✅ Pgs data saved successfully!");
        clearAllSelections();
      } else {
        debugPrint("Failed to save Pgs data: ${response.statusCode}");
        debugPrint("Response: ${response.data}");
      }
    } on DioException catch (e) {
      debugPrint(
        "Dio error: ${e.response?.statusCode} - ${e.response?.data ?? e.message}",
      );
    } catch (e) {
      debugPrint("Unexpected error: $e");
    }
  }

  //fetch
  Future<void> fetchPgs() async {
    var url = ApiEndpoint().pgsauditdetails;

    try {
      var response = await dio.get(url);

      if (response.statusCode == 200 && response.data is List) {
        List<AuditResult> data =
            (response.data as List)
                .map((deliverable) => AuditResult.fromJson(deliverable))
                .toList();

        if (mounted) {
          setState(() {
            deliverableList =
                data.map((deliverable) => deliverable.toJson()).toList();
            filteredList = List.from(deliverableList);
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

  //Save deliverables
  Future<void> saveDeliverables() async {
    var url = ApiEndpoint().deliverables;
    List<PgsDeliverables> deliverablesList = getTableDeliverables();

    try {
      var response = await dio.get(url);

      if (response.statusCode == 200 && response.data is List) {
        List<PgsDeliverables> data =
            (response.data as List)
                .map((deliverable) => PgsDeliverables.fromJson(deliverable))
                .toList();

        if (mounted) {
          setState(() {
            deliverablesList = data;
            filteredList = List.from(deliverablesList);
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

  Future<void> fetchDropdownData() async {
    var url = ApiEndpoint().keyresult;

    try {
      var response = await dio.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;

        options =
            data.map<Map<String, dynamic>>((item) {
              return {'id': item['id'] as int, 'name': item['name'].toString()};
            }).toList();

        debugPrint("Fetched Data: $options");
      } else {
        debugPrint("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching data: $e");
    }
  }

  List<PgsDeliverables> getTableDeliverables() {
    List<PgsDeliverables> deliverablesList = [];

    deliverablesControllers.forEach((index, controller) {
      var kraData =
          selectedKRAObjects[index] ??
          {'id': 1, 'name': 'Unknown', 'description': ''};
      var deliverableText =
          controller.text.isNotEmpty ? controller.text : "No Name";
      var isDirect = selectedDirect[index] ?? false;
      var byWhen =
          DateTime.tryParse(selectedByWhen[index] ?? '') ?? DateTime.now();
      var percentDeliverables = 0.0;
      var status = PgsStatus.values.firstWhere(
        (e) => e.index == (selectedStatus[index] ?? PgsStatus.notStarted.index),
        orElse: () => PgsStatus.notStarted,
      );
      var remarks = "";

      deliverablesList.add(
        PgsDeliverables(
          0,
          KeyResultArea(
            kraData['id'],
            kraData['name'],
            remarks,
            true,
            rowVersion: "",
          ),
          deliverableText,
          isDirect,
          byWhen,
          percentDeliverables,
          status,
          remarks: remarks,
          rowVersion: "",
        ),
      );
    });

    return deliverablesList;
  }

  PgsAuditDetails getPgsAuditDetails() {
    return PgsAuditDetails(
      0,
      PgsPeriod(
        1,
        false,
        rowVersion: "",
        DateTime.parse("2024-01-01"),
        DateTime.parse("2024-12-31"),
      ),
      Office(1, "osm", true, false, rowVersion: ""),
      getTableDeliverables(),
      PgsReadiness(0, false, null, 2.0, 3.0, 4.0, 9.0),
      false,
      remarks: "Audit entry for finance office",
      rowVersion: "",
    );
  }

  //Add rows-------------
  void _addRow() {
    setState(() {
      int newRowId = DateTime.now().millisecondsSinceEpoch; // Unique ID
      rows.add(newRowId);
    });
  }

  @override
  void initState() {
    super.initState();
    isSearchFocus.addListener(() {
      setState(() {});
    });
    fetchDropdownData().then((_) {
      setState(() {});
    });
  }

  void clearAllSelections() {
    rows.clear();
    deliverablesControllers.clear();
    selectedDirect.clear();
    selectedIndirect.clear();
    selectedByWhen.clear();
    selectedStatus.clear();
    selectedKRA.clear();
    selectedKRAObjects.clear();
  }

  void confirmSelection() {
    setState(() {
      selectedDirect.addAll(tempSelectedDirect);
      selectedIndirect.addAll(tempSelectedIndirect);
      tempSelectedDirect.clear();
      tempSelectedIndirect.clear();
    });
  }

  @override
  void dispose() {
    isSearchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isMinimized = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      backgroundColor: mainBgColor,
      appBar: AppBar(
        backgroundColor: mainBgColor,
        title: Text('Deliverable Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 30,
                  width: 300,
                  child: TextField(
                    focusNode: isSearchFocus,
                    controller: searchController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: lightGrey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelStyle: TextStyle(color: grey, fontSize: 14),
                      labelText: 'Search Period',
                      prefixIcon: Icon(
                        Icons.search,
                        color: isSearchFocus.hasFocus ? primaryColor : grey,
                        size: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      filled: true,
                      fillColor: secondaryColor,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 5,
                      ),
                    ),
                    onChanged: filterSearchResults,
                  ),
                ),
                if (!isMinimized)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    onPressed: () => showFormDialog(),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, color: Colors.white),
                        SizedBox(width: 5),
                        Text('Add New', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
              ],
            ),
            gap,
            Expanded(
              child: Column(
                children: [
                  Container(
                    color: secondaryColor,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text('ID', style: TextStyle(color: grey)),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(
                              'Office',
                              style: TextStyle(color: grey),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(
                              'Start Date',
                              style: TextStyle(color: grey),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(
                              'End Date',
                              style: TextStyle(color: grey),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(right: 1),
                            child: Text(
                              'Actions',
                              style: TextStyle(color: grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children:
                            filteredList
                                .asMap()
                                .map((index, deliverable) {
                                  return MapEntry(
                                    index,
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 1,
                                        horizontal: 16,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                right: 1,
                                              ),
                                              child: Text(
                                                (index + 1).toString(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                right: 1,
                                              ),
                                              child: Text(
                                                deliverable['officeName'],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                right: 1,
                                              ),
                                              child: Text(
                                                deliverable['startDate'],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                right: 1,
                                              ),
                                              child: Text(
                                                deliverable['endDate'],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                right: 1,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.delete,
                                                      color: Color.fromARGB(
                                                        255,
                                                        221,
                                                        79,
                                                        79,
                                                      ),
                                                    ),
                                                    onPressed: () async {
                                                      setState(() {
                                                        filteredList.removeAt(
                                                          index,
                                                        );
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                })
                                .values
                                .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton:
          isMinimized
              ? FloatingActionButton(
                backgroundColor: primaryColor,
                onPressed: () => showFormDialog(),
                child: Icon(Icons.add, color: Colors.white),
              )
              : null,
    );
  }

  //Dialog to add PGS
  void showFormDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: mainBgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.8,
                child: DefaultTabController(
                  length: 3, // Number of tabs
                  child: Column(
                    children: [
                      // Header Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('assets/CRMC.png', height: 90),
                          Text(
                            '    COTABATO REGIONAL AND MEDICAL CENTER\n2025',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20),
                      TabBar(
                        labelColor: primaryLightColor,
                        unselectedLabelColor: Colors.black,
                        indicatorColor: primaryColor,
                        labelStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        unselectedLabelStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        tabs: [
                          Tab(text: "Strategic Contributions"), // Tab Name 1
                          Tab(
                            text: "Readiness Rating-Cancer Care",
                          ), // Tab Name 2
                          Tab(text: "PGS Deliverables Status"), // Tab Name 3
                        ],
                      ),

                      //First Tab Strategic Contributions
                      Expanded(
                        child: TabBarView(
                          children: [
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(height: 20),
                                  Table(
                                    border: TableBorder.all(
                                      color: const Color.fromARGB(
                                        255,
                                        49,
                                        46,
                                        46,
                                      ),
                                      width: 1,
                                    ),
                                    columnWidths: const {
                                      0: FlexColumnWidth(1.5),
                                      1: FlexColumnWidth(0.7),
                                      2: FlexColumnWidth(0.7),
                                      3: FlexColumnWidth(2),
                                      4: FlexColumnWidth(1),
                                      5: FlexColumnWidth(1),
                                      6: FlexColumnWidth(0.7),
                                    },
                                    children: [
                                      _buildMainHeaderStrategic(),
                                      _buildTableSubHeaderStrategic(),
                                      ...rows.map(
                                        (rowId) => _buildTableRowStrategic(
                                          rowId,
                                          '',
                                          '',
                                          setState,
                                          setDialogState,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  TextButton(
                                    onPressed: () {
                                      setDialogState(() {
                                        _addRow();
                                      });
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.add, color: primaryColor),
                                        Text(
                                          'Add Row',
                                          style: TextStyle(
                                            color: primaryColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //End First Tab

                            //Second Tab  Readiness Rating-Cancer Care
                            Scaffold(
                              backgroundColor: mainBgColor,
                              appBar: AppBar(
                                automaticallyImplyLeading: false,
                                title: Row(
                                  children: [
                                    Text(
                                      'READINESS RATING - CANCER CARE',
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                toolbarHeight: 60,
                                backgroundColor: primaryLightColor,
                              ),
                              body: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Container(
                                        alignment: Alignment(1.0, 0.0),
                                        padding: EdgeInsets.only(right: 50.0),
                                        child: Text(
                                          'SCORE',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      // Competence Score Dropdown
                                      buildScoreRow('COMPETENCE TO DELIVER', [
                                        'Teams lack adequate skills and training to deliver performance commitments',
                                        'Teams are skilled but lack training to deliver performance commitments ',
                                        'Teams are highly skilled and trained to deliver performance commitments',
                                      ], competenceScore),

                                      // Resource Availability Dropdown
                                      buildScoreRow('RESOURCE AVAILABILITY', [
                                        'Insufficient; external resources difficult to source',
                                        'Sufficient resources but not available; OR Insufficient but external resources can be tapped',
                                        'Sufficient and available staff and budget',
                                      ], resourceScore),

                                      // Confidence to Deliver Dropdown
                                      buildScoreRow('CONFIDENCE TO DELIVER', [
                                        'Low confidence because of high degree of organizational change required',
                                        'Moderate confidence',
                                        'High confidence despite organizational change required',
                                      ], confidenceScore),

                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          ValueListenableBuilder<double>(
                                            valueListenable: competenceScore,
                                            builder: (context, _, __) {
                                              return ValueListenableBuilder<
                                                double
                                              >(
                                                valueListenable: resourceScore,
                                                builder: (context, _, __) {
                                                  return ValueListenableBuilder<
                                                    double
                                                  >(
                                                    valueListenable:
                                                        confidenceScore,
                                                    builder: (context, _, __) {
                                                      return Padding(
                                                        padding: EdgeInsets.only(
                                                          right: 60.0,
                                                        ), // Adjust right padding if needed
                                                        child: Text(
                                                          'TOTAL SCORE:          ${totalScore.toStringAsFixed(1)}',
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                          ),
                                                          textAlign:
                                                              TextAlign.right,
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            //End Second Tab

                            // Third Tab: PGS Deliverable Status
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(height: 20),
                                  Table(
                                    border: TableBorder.all(
                                      color: const Color.fromARGB(
                                        255,
                                        49,
                                        46,
                                        46,
                                      ),
                                      width: 1,
                                    ),
                                    columnWidths: const {
                                      0: FlexColumnWidth(1.5),
                                      1: FlexColumnWidth(0.7),
                                      2: FlexColumnWidth(0.7),
                                      3: FlexColumnWidth(2),
                                      4: FlexColumnWidth(1),
                                      5: FlexColumnWidth(1),
                                      6: FlexColumnWidth(0.7),
                                    },
                                    children: [
                                      _PgsDeliverableHeader(),
                                      _PgsBuildTableSubheader(),
                                      ...rows.map(
                                        (rowId) => _buildTableRowStrategic(
                                          rowId,
                                          '',
                                          '',
                                          setState,
                                          setDialogState,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //End third tab

              // Action Buttons
              actions: [
                TextButton(
                  onPressed: () {
                    clearAllSelections();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Text('Cancel', style: TextStyle(color: primaryColor)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.transparent,
                    elevation: 0,
                    backgroundColor: secondaryBgButton,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: () async {
                    bool? confirm = await showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: Text("Confirm Save"),
                            content: Text(
                              "Are you sure you want to save this record?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text("No"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text("Yes"),
                              ),
                            ],
                          ),
                    );

                    if (confirm == true) {
                      PgsAuditDetails audit = getPgsAuditDetails();
                      await savePGS(audit);
                    }
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Save as Draft',
                    style: TextStyle(color: primaryColor),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.transparent,
                    elevation: 0,
                    backgroundColor: secondaryBgButton,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: () {},
                  child: Text('Print', style: TextStyle(color: primaryColor)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: () async {
                    bool? confirm = await showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: Text("Confirm Submit"),
                            content: Text(
                              "Are you sure you want to submit this record? You won’t be able to make any changes.",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text("No"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text("Yes"),
                              ),
                            ],
                          ),
                    );

                    if (confirm == true) {
                      PgsAuditDetails audit = getPgsAuditDetails();
                      await savePGS(audit);
                    }
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildDatePickerCell(int index, Function setDialogState) {
    selectedByWhenControllers.putIfAbsent(index, () => TextEditingController());

    if (selectedByWhen[index] == null ||
        selectedByWhenControllers[index]?.text.isEmpty == true) {
      DateTime now = DateTime.now();
      String defaultDate = DateFormat('yyyy-MM-dd').format(now); // ISO format
      selectedByWhen[index] = defaultDate;
      selectedByWhenControllers[index]?.text = DateFormat(
        'MMMM yyyy',
      ).format(now);
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller:
            selectedByWhenControllers[index], // Use persistent controller
        readOnly: true,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
          ),
          contentPadding: EdgeInsets.all(8.0),
          suffixIcon: Icon(Icons.calendar_today),
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                    primary: primaryColor,
                    onPrimary: secondaryColor,
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(foregroundColor: primaryColor),
                  ),
                ),
                child: child!,
              );
            },
          );
          if (pickedDate != null) {
            String formattedDate = DateFormat(
              'yyyy-MM-dd',
            ).format(pickedDate); // ISO format for saving
            setDialogState(() {
              selectedByWhen[index] = formattedDate;
              selectedByWhenControllers[index]?.text = DateFormat(
                'MMMM yyyy',
              ).format(pickedDate); // User-friendly format
            });
          }
        },
      ),
    );
  }

  // Kra Dropdown
  Widget _buildDropdownKraCell(int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField<int>(
        value:
            selectedKRA[index] ??
            (options.isNotEmpty ? options.first['id'] : null),
        onChanged: (int? newValue) {
          setState(() {
            selectedKRA[index] = newValue!;
            selectedKRAObjects[index] = options.firstWhere(
              (option) => option['id'] == newValue,
              orElse: () => {'id': 0, 'name': 'Unknown', 'description': ''},
            );
          });
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.all(8.0),
        ),
        items:
            options.isEmpty
                ? [
                  DropdownMenuItem<int>(value: null, child: Text("Loading...")),
                ]
                : options.map<DropdownMenuItem<int>>((
                  Map<String, dynamic> option,
                ) {
                  return DropdownMenuItem<int>(
                    value: option['id'],
                    child: Text(option['name']),
                  );
                }).toList(),
      ),
    );
  }

  //Start Strategic Contributions
  // Strategic Contribution Main Header
  TableRow _buildMainHeaderStrategic() {
    return TableRow(
      decoration: BoxDecoration(color: primaryLightColor),
      children: [
        BuildHeaderCell(
          text: 'Surgery',
          color: Colors.white,
          fontSize: 20,
          fontStyle: FontStyle.normal,
        ),
        BuildHeaderCell(text: ''),
        BuildHeaderCell(text: ''),
        BuildHeaderCell(
          text: 'STRATEGIC CONTRIBUTIONS',
          color: Colors.white,
          fontSize: 20,
          fontStyle: FontStyle.normal,
        ),
        BuildHeaderCell(
          text: '30%',
          color: Colors.white,
          fontSize: 20,
          fontStyle: FontStyle.normal,
        ),
        BuildHeaderCell(text: ''),
        BuildHeaderCell(text: ''),
      ],
    );
  }

  // Sub Header
  TableRow _buildTableSubHeaderStrategic() {
    return TableRow(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 254, 254),
      ),
      children: [
        BuildHeaderCell(text: 'KRA'),
        BuildHeaderCell(text: 'DIRECT'),
        BuildHeaderCell(text: 'INDIRECT'),
        BuildHeaderCell(text: 'DELIVERABLES'),
        BuildHeaderCell(text: 'BY WHEN'),
        BuildHeaderCell(text: 'STATUS'),
        BuildHeaderCell(text: 'ACTION'),
      ],
    );
  }

  // PGS Table Row  Strategic
  TableRow _buildTableRowStrategic(
    int index,
    String direct,
    String indirect,
    Function setState,
    Function setDialogState,
  ) {
    deliverablesControllers.putIfAbsent(index, () => TextEditingController());
    selectedDirect.putIfAbsent(index, () => false);
    selectedIndirect.putIfAbsent(index, () => false);
    selectedByWhen.putIfAbsent(index, () => '');

    // Define alternating row colors
    Color rowColor = (index % 2 == 0) ? mainBgColor : Colors.white;

    return TableRow(
      decoration: BoxDecoration(color: rowColor),
      children: [
        _buildDropdownKraCell(index),
        _buildCheckboxCell(
          index,
          selectedDirect,
          selectedIndirect,
          setDialogState,
          isDirect: true,
        ),
        _buildCheckboxCell(
          index,
          selectedIndirect,
          selectedDirect,
          setDialogState,
          isDirect: false,
        ),
        _buildExpandableTextAreaCell(index),
        _buildDatePickerCell(index, setDialogState),
        _buildDropdownCellStatus(index, () => (index)), // Save on status change
        _buildRemoveButton(index, setDialogState),
      ],
    );
  }

  Widget _buildDropdownCellStatus(int index, VoidCallback setDialogState) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField<PgsStatus>(
        value:
            selectedStatus[index] ??
            PgsStatus.notStarted, // ✅ Use PgsStatus enum
        onChanged: (PgsStatus? newValue) {
          if (newValue != null) {
            setDialogState();
            selectedStatus[index] = newValue; // ✅ Directly store as enum
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
                child: Text(value.name, style: const TextStyle(fontSize: 14)),
              );
            }).toList(),
      ),
    );
  }

  // // Check Box
  Widget _buildCheckboxCell(
    int index,
    Map<int, bool> selectedValues,
    Map<int, bool> oppositeValues,
    Function setDialogState, {
    required bool isDirect,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: const Color.fromARGB(255, 255, 255, 255),
            width: 0.5,
          ),
          color: const Color.fromARGB(255, 255, 255, 255),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Checkbox(
            value: selectedValues[index] ?? false, // Read from state
            onChanged: (bool? newValue) {
              if (newValue == null) return;

              setDialogState(() {
                selectedValues[index] = newValue;

                if (newValue) {
                  oppositeValues[index] = false;
                }

                debugPrint("Index: $index");
                debugPrint(
                  "${isDirect ? "Direct" : "Indirect"} checked: $newValue",
                );
                debugPrint(
                  "${isDirect ? "Indirect" : "Direct"} unchecked: ${oppositeValues[index]}",
                );
              });
            },
            activeColor: Colors.white,
            checkColor: Colors.black,
          ),
        ),
      ),
    );
  }

  //Readiness Rating-Cancer Care Table
  Widget buildScoreRow(
    String title,
    List<String> descriptions,
    ValueNotifier<double> selectedValue,
  ) {
    List<Color> boxColors = [
      const Color.fromARGB(197, 235, 235, 235),
      secondaryBgButton,
      primaryLightColor,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            for (int i = 0; i < descriptions.length; i++)
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(8),
                  height: 120,
                  decoration: BoxDecoration(
                    color: boxColors[i],
                    borderRadius: BorderRadius.circular(1),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${i * 0.5}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        descriptions[i],
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            Container(
              width: 150,
              height: 100,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromARGB(255, 245, 243, 243),
                ), // Optional: Adds a border
                borderRadius: BorderRadius.circular(
                  1,
                ), // Optional: Rounds the corners
              ),
              child: ValueListenableBuilder<double>(
                valueListenable: selectedValue,
                builder: (context, value, child) {
                  return DropdownButton<double>(
                    value: value,
                    onChanged: (newValue) {
                      selectedValue.value = newValue!;
                    },
                    items: List.generate(descriptions.length, (index) {
                      return DropdownMenuItem(
                        value: index * 0.5,
                        child: Center(
                          // Centers the text inside the dropdown
                          child: Text(
                            '${index * 0.5}',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }),
                    underline: Container(),
                    isExpanded: true,
                    alignment:
                        Alignment.center, // Ensures dropdown aligns correctly
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ), // Ensures selected value is also styled
                  );
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
      ],
    );
  }
  // End Readiness Rating-Cancer Care

  //PGS DELIVERABLES STATUS
  TableRow _PgsDeliverableHeader() {
    return TableRow(
      children: [
        BuildHeaderCell(
          text: 'Office: OPERATING ROOM COMPLEX (CathLab)',
          fontSize: 20,
          fontStyle: FontStyle.normal,
        ),
        BuildHeaderCell(text: ''),
        BuildHeaderCell(text: ''),
        BuildHeaderCell(
          text: 'STRATEGIC CONTRIBUTIONS',
          fontSize: 20,
          fontStyle: FontStyle.normal,
        ),
        BuildHeaderCell(
          text: 'Percentage',
          fontSize: 20,
          fontStyle: FontStyle.normal,
        ),
        BuildHeaderCell(text: ''),
        BuildHeaderCell(text: ''),
      ],
    );
  }

  TableRow _PgsBuildTableSubheader() {
    return TableRow(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 254, 254),
      ),
      children: [
        BuildHeaderCell(text: 'KRA'),
        BuildHeaderCell(text: 'DIRECT'),
        BuildHeaderCell(text: 'INDIRECT'),
        BuildHeaderCell(text: 'DELIVERABLES'),
        BuildHeaderCell(text: 'WHEN'),
        BuildHeaderCell(text: 'STATUS'),
        BuildHeaderCell(text: 'REMARKS'),
      ],
    );
  } //END PGS DELIVERABLES STATUS

  // Removed Rows
  Widget _buildRemoveButton(int index, Function setDialogState) {
    return IconButton(
      icon: Icon(Icons.delete, color: Colors.red),
      onPressed: () {
        setDialogState(() {
          // Update UI after removal
          rows.remove(index);
          deliverablesControllers.remove(index);
          selectedKRA.remove(index);
          selectedDirect.remove(index);
          selectedIndirect.remove(index);
        });
      },
    );
  }

  Widget _buildExpandableTextAreaCell(int index) {
    if (!deliverablesControllers.containsKey(index)) {
      deliverablesControllers[index] = TextEditingController();
      print("✅ Initialized new controller at index: $index");
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 50.0),
        child: TextField(
          controller:
              deliverablesControllers[index], // Gamitin ang tamang index
          maxLines: null,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.all(8.0),
          ),
          onChanged: (value) {
            setState(() {
              print("Updated TextField at index $index: $value");
            });
          },
        ),
      ),
    );
  }

  // Filter search results based on query
  void filterSearchResults(String query) {
    deliverables.then((data) {
      setState(() {
        filteredList =
            data
                .where(
                  (item) => item['deliverableName'].toLowerCase().contains(
                    query.toLowerCase(),
                  ),
                )
                .toList();
      });
    });
  }
}

// Capitalize first letter of each word
extension StringExtension on String {
  String capitalize() {
    return split(' ')
        .map(
          (word) =>
              word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '',
        )
        .join(' ');
  }
}
