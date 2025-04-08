import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/performance_governance_system/office/models/office.dart';
import 'package:imis/performance_governance_system/enum/pgs_status.dart';
import 'package:imis/performance_governance_system/key_result_area/models/key_result_area.dart';
import 'package:imis/performance_governance_system/models/performance_governance_system.dart';
import 'package:imis/performance_governance_system/models/pgs_deliverables.dart';
import 'package:imis/performance_governance_system/models/pgs_readiness.dart';
import 'package:imis/performance_governance_system/pgs_period/models/pgs_period.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/date_time_converter.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PerformanceGovernanceSystemPage extends StatefulWidget {
  const PerformanceGovernanceSystemPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PerformanceGovernanceSystemPageState createState() =>
      _PerformanceGovernanceSystemPageState();
}

class _PerformanceGovernanceSystemPageState
    extends State<PerformanceGovernanceSystemPage> {
  final GlobalKey _menuKey = GlobalKey();
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
  List<Map<String, dynamic>> readinessList = [];
  List<Map<String, dynamic>> filteredList = [];
  List<Map<String, dynamic>> options = [];
  List<String> kraOptions = [];

  List<int> rows = [];
  int rowIndex = 1;

  String officeDisplay = "";
  String officeIdList = "";
  String? selectedOfficeId = "";
  String? selectedPeriodText;

  List<Map<String, dynamic>> periodList = [];
  List<Map<String, dynamic>> filteredListPeriod = [];

  int? selectedPeriod;

  //For search controller
  TextEditingController searchController = TextEditingController();
  final FocusNode isSearchFocus = FocusNode();

  TextEditingController percentage = TextEditingController();

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
  ValueNotifier<double> percentageScore = ValueNotifier(0.0);

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
  Future<void> savePGS(PerformanceGovernanceSystem audit) async {
    var url = ApiEndpoint().performancegovernancesystem;
    if (selectedDirect.isEmpty ||
        selectedIndirect.isEmpty ||
        deliverablesControllers.values.any(
          (controller) => controller.text.trim().isEmpty,
        ) ||
        percentage.text.trim().isEmpty) {
      MotionToast.error(
        title: const Text("Missing Fields"),
        description: const Text(
          "Please complete all required fields before saving.",
        ),
        position: MotionToastPosition.top,
      ).show(context);
      return;
    }

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
        debugPrint("✅ Pgs data saved successfully!");
        Navigator.pop(context);
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

  //fetch pgs
  Future<void> fetchPgs() async {
    var url = ApiEndpoint().performancegovernancesystem;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('accessToken');

      if (token == null || token.isEmpty) {
        debugPrint("Error: Access token is missing!");
        return;
      }

      var response = await dio.get(
        url,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200 && response.data is List) {
        List<Map<String, String>> formattedData =
            (response.data as List).map((pgsJson) {
              PerformanceGovernanceSystem pgs =
                  PerformanceGovernanceSystem.fromJson(pgsJson);

              return {
                'pgsReadinessRatingId': pgs.pgsReadinessRating.id.toString(),

                'id': pgs.id.toString(),
                'name': pgs.office.name,
                'Start Date': DateTimeConverter().toJson(
                  pgs.pgsPeriod.startDate,
                ),
                'End Date': DateTimeConverter().toJson(pgs.pgsPeriod.endDate),
              };
            }).toList();

        if (mounted) {
          setState(() {
            deliverableList = formattedData;
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

  Future<void> fetchPGSPeriods() async {
    var url = ApiEndpoint().pgsperiod;

    try {
      var response = await dio.get(url);

      if (response.statusCode == 200 && response.data is List) {
        List<PgsPeriod> data =
            (response.data as List)
                .map((period) => PgsPeriod.fromJson(period))
                .toList();

        if (mounted) {
          setState(() {
            periodList = data.map((period) => period.toJson()).toList();
            filteredListPeriod = List.from(
              periodList,
            ); // Ensure filtered list is populated
          });
        }
      } else {
        print("Unexpected response format: ${response.data.runtimeType}");
      }
    } on DioException catch (e) {
      print("Dio error: ${e.response?.data ?? e.message}");
    } catch (e) {
      print("Unexpected error: $e");
    }
  }

  Future<void> _loadOfficeName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> officeNames = prefs.getStringList('officeNames') ?? [];
    List<String> officeIds = prefs.getStringList('officeIds') ?? [];
    selectedOfficeId = prefs.getString('selectedOfficeId');

    String selectedOfficeName = "No Office";
    if (officeIds.contains(selectedOfficeId)) {
      int index = officeIds.indexOf(selectedOfficeId!);
      selectedOfficeName = officeNames[index];
    }

    setState(() {
      officeDisplay = selectedOfficeName;
      officeIdList = selectedOfficeId ?? "No Office ID";
    });
  }

  @override
  void initState() {
    super.initState();
    _loadOfficeName();
    fetchPgs();
    fetchPGSPeriods();
    isSearchFocus.addListener(() {
      setState(() {});
    });
    fetchDropdownData().then((_) {
      if (filteredListPeriod.isNotEmpty) {
        selectedPeriod = filteredListPeriod[0]['id'];
        selectedPeriodText =
            "${filteredListPeriod[0]['startDate']} - ${filteredListPeriod[0]['endDate']}";
      }
    });
  }

  Future<void> _selectOffice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> officeNames = prefs.getStringList('officeNames') ?? [];
    List<String> officeIds = prefs.getStringList('officeIds') ?? [];

    if (officeNames.isEmpty || officeIds.isEmpty) {
      return;
    }

    String? selectedOffice = await showDialog<String>(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: secondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.30,
            constraints: BoxConstraints(maxHeight: 250),
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(Icons.close, color: primaryTextColor),
                    onPressed: () => Navigator.pop(context, null),
                  ),
                ),
                Text(
                  "Select an Office",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: officeNames.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: secondaryColor,
                        margin: EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          title: Text(
                            officeNames[index],
                            style: TextStyle(fontSize: 16),
                          ),
                          leading: Icon(
                            Icons.apartment,
                            color: primaryTextColor,
                          ),
                          onTap: () => Navigator.pop(context, officeIds[index]),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selectedOffice == "REMOVE_OFFICE") {
      await prefs.remove('selectedOfficeId');
    } else if (selectedOffice != null) {
      await prefs.setString('selectedOfficeId', selectedOffice);
    }

    setState(() {});
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
      double percentDeliverables = 0.0;
      try {
        percentDeliverables =
            double.tryParse(percentage.text) ??
            0.0; // Default to 0.0 if invalid
      } catch (e) {
        print("Error parsing percentDeliverables: $e");
      }
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

  PerformanceGovernanceSystem getPgsAuditDetails() {
    return PerformanceGovernanceSystem(
      0,
      PgsPeriod(
        selectedPeriod!,
        false,
        rowVersion: "",
        DateTime.now(),
        DateTime.now(),
      ),
      Office(
        int.tryParse(selectedOfficeId!) ?? 0,
        "",
        false,
        false,
        rowVersion: "",
      ),
      getTableDeliverables(),
      PgsReadiness(
        0,
        false,
        null,
        competenceScore.value,
        resourceScore.value,
        confidenceScore.value,
        totalScore,
      ),
      false,
      remarks: "",
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

  void clearAllSelections() {
    rows.clear();
    deliverablesControllers.clear();
    percentage.clear();
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
        title: Text('Performance Governance Information'),
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
                      labelText: 'Search Deliverables',
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

                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      String? selectedOfficeId = prefs.getString(
                        'selectedOfficeId',
                      );

                      if (selectedOfficeId == null ||
                          selectedOfficeId.isEmpty) {
                        await _selectOffice();
                        selectedOfficeId = prefs.getString('selectedOfficeId');

                        if (selectedOfficeId != null &&
                            selectedOfficeId.isNotEmpty) {
                          await _loadOfficeName();
                          showFormDialog();
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (context) => RetrievePeriodPage(),
                          //   ),
                          // );
                        }
                      } else {
                        await _loadOfficeName();
                        showFormDialog();
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => RetrievePeriodPage(),
                        //   ),
                        // );
                      }
                    },
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
                            child: Text('#', style: TextStyle(color: grey)),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(
                              'Office Name',
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
                                .map((index, pgsgovernancesystem) {
                                  final id = pgsgovernancesystem['id'];

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
                                            flex: 1,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                right: 1,
                                              ),
                                              child: Text(
                                                pgsgovernancesystem['name'],
                                                // Display office
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
                                              child: Text(
                                                pgsgovernancesystem['Start Date'],

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
                                              child: Text(
                                                pgsgovernancesystem['End Date'],
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
                                                    icon: Icon(Icons.edit),

                                                    onPressed: () {
                                                      pgsgovernancesystem['id'];
                                                      pgsgovernancesystem['pgsReadinessRatingId'];
                                                      print(
                                                        pgsgovernancesystem['id'],
                                                      );
                                                      print(
                                                        pgsgovernancesystem['pgsReadinessRatingId'],
                                                      );

                                                      // PerformanceGovernanceSystem
                                                      // audit =
                                                      //     getPgsAuditDetails();
                                                      // print(audit);
                                                      // ignore: collection_methods_unrelated_type
                                                      PerformanceGovernanceSystem
                                                      audit =
                                                          getPgsAuditDetails();
                                                      PgsReadiness readiness =
                                                          audit
                                                              .pgsReadinessRating;
                                                      print(readiness);
                                                    },
                                                  ),

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
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  String? selectedOfficeId = prefs.getString(
                    'selectedOfficeId',
                  );

                  if (selectedOfficeId == null || selectedOfficeId.isEmpty) {
                    await _selectOffice();
                    selectedOfficeId = prefs.getString(
                      'selectedOfficeId',
                    ); // Re-fetch

                    if (selectedOfficeId != null &&
                        selectedOfficeId.isNotEmpty) {
                      await _loadOfficeName();
                      showFormDialog();
                    }
                  } else {
                    await _loadOfficeName();
                    showFormDialog();
                  }
                },
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
              content: Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: primaryTextColor,
                        size: 32,
                      ),
                      onPressed: () {
                        clearAllSelections();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: SizedBox(
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
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '    COTABATO REGIONAL AND MEDICAL CENTER',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Container(
                                      width: 250,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      child: DropdownButton<int>(
                                        dropdownColor: mainBgColor,
                                        value: selectedPeriod,
                                        isExpanded: true,
                                        underline: Container(),
                                        icon: Icon(Icons.arrow_drop_down),
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        hint: Text(
                                          selectedPeriodText ??
                                              'Select a period',
                                        ),
                                        onChanged: (int? newValue) {
                                          print(
                                            "Dropdown selected new value: $newValue",
                                          );

                                          if (newValue != null) {
                                            final selected = filteredListPeriod
                                                .firstWhere(
                                                  (period) =>
                                                      period['id'] == newValue,
                                                  orElse:
                                                      () =>
                                                          filteredListPeriod[0], // Default fallback
                                                );

                                            setState(() {
                                              selectedPeriod = newValue;
                                              selectedPeriodText =
                                                  "${selected['startDate']} - ${selected['endDate']}";
                                            });

                                            print(
                                              "After setState: selectedPeriod = $selectedPeriod, selectedPeriodText = $selectedPeriodText",
                                            );
                                          }
                                        },
                                        items:
                                            filteredListPeriod.map<
                                              DropdownMenuItem<int>
                                            >((period) {
                                              return DropdownMenuItem<int>(
                                                value: period['id'],
                                                child: Text(
                                                  "${period['startDate']} - ${period['endDate']}",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              );
                                            }).toList(),
                                      ),
                                    ),
                                  ],
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
                                Tab(
                                  text: "Strategic Contributions",
                                ), // Tab Name 1
                                Tab(
                                  text: "Readiness Rating - $officeDisplay",
                                ), // Tab Name 2
                                Tab(
                                  text: "PGS Deliverables Status",
                                ), // Tab Name 3
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
                                              (rowId) =>
                                                  _buildTableRowStrategic(
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
                                              Icon(
                                                Icons.add,
                                                color: primaryColor,
                                              ),
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
                                            'READINESS RATING - $officeDisplay',
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
                                              padding: EdgeInsets.only(
                                                right: 50.0,
                                              ),
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
                                            buildScoreRow(
                                              'COMPETENCE TO DELIVER',
                                              [
                                                'Teams lack adequate skills and training to deliver performance commitments',
                                                'Teams are skilled but lack training to deliver performance commitments ',
                                                'Teams are highly skilled and trained to deliver performance commitments',
                                              ],
                                              competenceScore,
                                            ),

                                            // Resource Availability Dropdown
                                            buildScoreRow(
                                              'RESOURCE AVAILABILITY',
                                              [
                                                'Insufficient; external resources difficult to source',
                                                'Sufficient resources but not available; OR Insufficient but external resources can be tapped',
                                                'Sufficient and available staff and budget',
                                              ],
                                              resourceScore,
                                            ),

                                            // Confidence to Deliver Dropdown
                                            buildScoreRow(
                                              'CONFIDENCE TO DELIVER',
                                              [
                                                'Low confidence because of high degree of organizational change required',
                                                'Moderate confidence',
                                                'High confidence despite organizational change required',
                                              ],
                                              confidenceScore,
                                            ),

                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                ValueListenableBuilder<double>(
                                                  valueListenable:
                                                      competenceScore,
                                                  builder: (context, _, __) {
                                                    return ValueListenableBuilder<
                                                      double
                                                    >(
                                                      valueListenable:
                                                          resourceScore,
                                                      builder: (
                                                        context,
                                                        _,
                                                        __,
                                                      ) {
                                                        return ValueListenableBuilder<
                                                          double
                                                        >(
                                                          valueListenable:
                                                              confidenceScore,
                                                          builder: (
                                                            context,
                                                            _,
                                                            __,
                                                          ) {
                                                            return Padding(
                                                              padding:
                                                                  EdgeInsets.only(
                                                                    right: 60.0,
                                                                  ), // Adjust right padding if needed
                                                              child: Text(
                                                                'TOTAL SCORE:          ${totalScore.toStringAsFixed(1)}',
                                                                style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color:
                                                                      Colors
                                                                          .black,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .right,
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
                                              (rowId) =>
                                                  _buildTableRowStrategic(
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
                  ),
                ],
              ),
              //End third tab

              // Action Buttons
              actions: [
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
                      PerformanceGovernanceSystem audit = getPgsAuditDetails();
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
                      PerformanceGovernanceSystem audit = getPgsAuditDetails();
                      await savePGS(audit);
                    }
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
  } //end

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
    if (selectedKRA[index] == null && options.isNotEmpty) {
      selectedKRA[index] = options.first['id'];
      selectedKRAObjects[index] = options.first;
    }
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
        GestureDetector(
          key: _menuKey,
          child: BuildHeaderCell(
            text: officeDisplay,
            color: Colors.white,
            fontSize: 20,
            fontStyle: FontStyle.normal,
          ),
        ),

        BuildHeaderCell(text: ''),
        BuildHeaderCell(text: ''),
        BuildHeaderCell(
          text: 'STRATEGIC CONTRIBUTIONS',
          color: Colors.white,
          fontSize: 20,
          fontStyle: FontStyle.normal,
        ),

        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: percentage,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              style: TextStyle(
                color: secondaryColor,
                fontSize: 20,
                fontStyle: FontStyle.normal,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+$')),
              ],
              decoration: InputDecoration(
                hintText: '0',
                suffixText: '%',
                suffixStyle: TextStyle(color: secondaryColor, fontSize: 20),
                hintStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
          ),
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
  // ignore: non_constant_identifier_names
  TableRow _PgsDeliverableHeader() {
    return TableRow(
      children: [
        BuildHeaderCell(
          text: 'Office: $officeDisplay)',
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
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            // child: TextField(
            //   controller: percentage,
            //   decoration: InputDecoration(
            //     hintText: '',
            //     border: OutlineInputBorder(),
            //     filled: true,
            //     fillColor: Colors.white,
            //   ),
            //   style: TextStyle(fontSize: 20, fontStyle: FontStyle.normal),
            // ),
          ),
        ),
        BuildHeaderCell(text: ''),
        BuildHeaderCell(text: ''),
      ],
    );
  }

  // ignore: non_constant_identifier_names
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
          controller: deliverablesControllers[index],
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
