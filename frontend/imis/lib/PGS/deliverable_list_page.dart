import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:imis/PGS/pgs.dart';
import 'package:imis/PGS/pgs_deliverables.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/pgs/pgs_period.dart';
import 'package:imis/pgs/pgs_status.dart';
import 'package:imis/settings/key_result_area/key_result_area.dart';
import 'package:imis/settings/office/office.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DeliverableListPage extends StatefulWidget {
  const DeliverableListPage({super.key});

  @override
  _DeliverableListPageState createState() => _DeliverableListPageState();
}

//Start Strategic Contributions------------------------------------------------------------------------------------------------------
// Helper Function to Format Enum Names
String _formatEnumName(String enumName) {
  return enumName
      .replaceAllMapped(
          RegExp(r'([a-z])([A-Z])'),
          (match) =>
              '${match.group(1)} ${match.group(2)}') // Add space before uppercase letters
      .replaceAll('_', ' ') // Replace underscores with spaces
      .capitalize(); // Capitalize first letter
}

// Capitalize first letter of each word
extension StringExtension on String {
  String capitalize() {
    return split(' ')
        .map((word) =>
            word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '')
        .join(' ');
  }
}
//End Strategic Contributions------------------------------------------------------------------------------------------------------

class _DeliverableListPageState extends State<DeliverableListPage> {
  // List<Map<String, dynamic>> deliverablesList = [];
  List<Map<String, dynamic>> filteredList = [];
  TextEditingController searchController = TextEditingController();
  final FocusNode isSearchFocus = FocusNode();
  final String apiUrl = 'https://localhost:7273/Deliverable';

  Map<int, PgsStatus> selectedStatus = {};
  Map<int, Map<String, dynamic>> selectedKRAObjects = {};

  List<String> kraOptions = []; //KRA Get Settings
  Map<int, bool> selectedDirect = {};
  Map<int, bool> selectedIndirect = {};
  List<int> rows = [];
  Map<int, int?> selectedKRA = {};
  Map<int, String> selectedByWhen = {};
  Map<int, TextEditingController> deliverablesControllers = {};
  Map<int, bool> tempSelectedDirect = {};
  Map<int, bool> tempSelectedIndirect = {};
  Map<int, TextEditingController> selectedByWhenControllers = {};
  Map<int, String> selectedValues = {};
  List<Map<String, dynamic>> options = []; // Store both ID and Name
  int rowIndex = 1;

  List<String> pgsStatusOptions =
      PgsStatus.values.map((e) => e.name).toList(); // New adding Class Test

  List<String> StatusOptions = ['PATIENT', 'RESEARCH', 'LINKAGES', 'HR'];
  Map<int, String> selectedStatusOptions = {};

  late Future<List<Map<String, dynamic>>> deliverables;

  //Start Readiness Rating-Cancer Care------------------------------------------------------------------------------------------------
  TextEditingController competenceScoreController =
      TextEditingController(text: '');
  TextEditingController resourceScoreController =
      TextEditingController(text: '');
  TextEditingController confidenceScoreController =
      TextEditingController(text: '');
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
  //End Readiness Rating-Cancer Care------------------------------------------------------------------------------------------------------

  //Start Strategic Contributions------------------------------------------------------------------------------------------------------
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

  @override
  void dispose() {
    isSearchFocus.dispose();
    super.dispose();
  }
  //End Start Strategic Contributions------------------------------------------------------------------------------------------------------

  //Start Strategic Contributions------------------------------------------------------------------------------------------------------
  Future<void> fetchDropdownData() async {
    try {
      final response = await http.get(Uri.parse("https://localhost:7273/kra"));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        options = data.map<Map<String, dynamic>>((item) {
          return {
            'id': item['id'] as int, // Ensure ID is int
            'name': item['name'].toString(),
          };
        }).toList();

        print("Fetched Data: $options"); // Debugging output
      } else {
        print("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  //End Strategic Contributions------------------------------------------------------------------------------------------------------

  //Start Strategic Contributions------------------------------------------------------------------------------------------------------
  //Add rows-------------
  void _addRow() {
    setState(() {
      int newRowId = DateTime.now().millisecondsSinceEpoch; // Unique ID
      rows.add(newRowId);
    });
  }

  Future<void> saveDeliverablesToAPI() async {
    List<PgsDeliverables> deliverablesList = getTableDeliverables();

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(deliverablesList
            .map((d) => d.toJson())
            .toList()), // Convert to JSON
      );

      if (response.statusCode == 200) {
        print("Deliverables saved successfully!");

        // After successful save, call setState to clear the list and refresh the page
        setState(() {
          deliverablesList.clear(); // Clear the list
        });
      } else {
        print("Failed to save deliverables: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  List<PgsDeliverables> getTableDeliverables() {
    List<PgsDeliverables> deliverablesList = [];

    deliverablesControllers.forEach((index, controller) {
      var kraData = selectedKRAObjects[index] ??
          {'id': 0, 'name': 'Unknown', 'description': ''};
      var deliverableText = controller.text.isNotEmpty
          ? controller.text
          : "No Name"; // Default to "No Name"
      var isDirect = selectedDirect[index] ?? false; // Default to false
      var byWhen = DateTime.tryParse(selectedByWhen[index] ?? '') ??
          DateTime.now(); // Default to today
      var percentDeliverables = 0.0; // Default to 0.0
      var status = PgsStatus.values.firstWhere(
        (e) =>
            e.toString() ==
            'PgsStatus.${selectedStatus[index] ?? 'notStarted'}',
        orElse: () => PgsStatus.notStarted, // Default status
      );
      var remarks = ""; // Default empty string

      print("🔍 Checking Data at index $index");
      print("  📝 Deliverable: $deliverableText");
      print("  📅 Date: $byWhen");
      print("  📌 Status: $status");

      deliverablesList.add(
        PgsDeliverables(
          index,
          KeyResultArea(kraData['id'], kraData['name'], kraData['description']),
          deliverableText,
          isDirect,
          byWhen,
          percentDeliverables,
          status,
          remarks: remarks,
        ),
      );
    });

    return deliverablesList;
  }

  // Future<void> savePgsToAPI() async {
  //   final String apiUrlAudit = "https://localhost:7273/PgsAuditDetails";

  //   Pgs pgsAuditDetails = getPgsAuditDetails();

  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? token = prefs.getString('accessToken');
  //     String jsonBody = jsonEncode(pgsAuditDetails.toJson());

  //     final response = await http.post(
  //       Uri.parse(apiUrlAudit),
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Authorization": "Bearer $token", //  Add authorization token
  //       },
  //       body:
  //           jsonEncode(pgsAuditDetails.toJson()), //  Corrected JSON conversion
  //     );

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       print(" Pgs data saved successfully!");
  //     } else {
  //       print("❌ Failed to save Pgs data: ${response.statusCode}");
  //       print("Response: ${response.body}");
  //       print("🔑 Access Token: $token"); // Debugging
  //       print("📤 JSON Payload: $jsonBody");
  //     }
  //   } catch (e) {
  //     print("❌ Error: $e");
  //   }
  // }

  // Pgs getPgsAuditDetails() {
  //   return Pgs(
  //     0, // ID
  //     PgsPeriod(
  //       1012,
  //       DateTime.parse("2024-01-01"), // Ensure ISO 8601 format
  //       DateTime.parse("2024-12-31"),
  //       false,
  //       null,
  //     ),
  //     Office(
  //       4017,
  //       "Finance Office",
  //       true, // isActive
  //       false, // isDeleted
  //       rowVersion: "", // rowVersion
  //     ),
  //     remarks: "Audit entry for finance office",
  //     PgsReadiness(
  //       //  Ensure correct class name
  //       0,
  //       false,
  //       null,
  //       2.0, //  Ensure these are double values
  //       3.0,
  //       4.0,
  //       9.0,
  //     ),

  //     false, // isDeleted (for Pgs)
  //     rowVersion: null,
  //   );
  // }

  void _SubmitData() {
    deliverablesControllers.forEach((index, controller) {
      String deliverableText = controller.text;
      if (deliverableText.isNotEmpty) {
        filteredList.add({
          'id': index,
          'deliverableName': deliverableText,
        });
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Data Submitted Successfully')),
    );
    // setState(() {
    //   rows.clear(); // Clear the rows
    //   deliverablesControllers.clear(); // Clear the text controllers
    //   selectedDirect.clear(); // Clear direct selection
    //   selectedIndirect.clear(); // Clear indirect selection
    //   selectedByWhen.clear(); // Clear "By When" dates
    //   selectedStatus.clear(); // Clear status selections
    //   selectedKRA.clear(); // Clear KRA selections
    //   selectedKRAObjects.clear(); // Clear KRA objects
    // });
  }
  //End Strategic Contributions------------------------------------------------------------------------------------------------------

  void showFormDialog() {
    List<int> initialRows = List.from(rows);
    Map<int, TextEditingController> initialControllers =
        Map.from(deliverablesControllers);
    Map<int, bool> initialSelectedDirect = Map.from(selectedDirect);
    Map<int, bool> initialSelectedIndirect = Map.from(selectedIndirect);
    Map<int, String> initialSelectedByWhen = Map.from(selectedByWhen);
    Map<int, PgsStatus> initialSelectedStatus = Map.from(selectedStatus);
    Map<int, int?> initialSelectedKRA = Map.from(selectedKRA);
    Map<int, Map<String, dynamic>> initialSelectedKRAObjects =
        Map.from(selectedKRAObjects);
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: mainBgColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9, // Adjust width
                height:
                    MediaQuery.of(context).size.height * 0.8, // Adjust height
                child: DefaultTabController(
                  length: 3, // Number of tabs
                  child: Column(
                    children: [
                      // Header Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('lib/assets/CRMC.png', height: 90),
                          Text(
                            '    COTABATO REGIONAL AND MEDICAL CENTER\n2025',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ],
                      ),

                      SizedBox(height: 20),
                      TabBar(
                        labelColor: primaryLightColor, // Active tab text color
                        unselectedLabelColor:
                            Colors.black, // Inactive tab text color
                        indicatorColor:
                            primaryColor, // Underline indicator color
                        labelStyle: TextStyle(
                          fontSize: 16, // Font size for active tab
                          fontWeight: FontWeight.w400,
                        ),
                        unselectedLabelStyle: TextStyle(
                          fontSize: 14, // Font size for inactive tab
                          fontWeight: FontWeight.w500,
                        ),
                        tabs: [
                          Tab(text: "Strategic Contributions"), // Tab Name 1
                          Tab(
                              text:
                                  "Readiness Rating-Cancer Care"), // Tab Name 2
                          Tab(text: "PGS Deliverables Status"), // Tab Name 3
                        ],
                      ),

                      //Start Strategic Contributions------------------------------------------------------------------------------------------------------
                      //Start Strategic Contributions------------------------------------------------------------------------------------------------------
                      //First Tab
                      // Tab Views
                      Expanded(
                        child: TabBarView(
                          children: [
                            // First Tab: Table Content
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(height: 20),
                                  Table(
                                    border: TableBorder.all(
                                        color: const Color.fromARGB(
                                            255, 49, 46, 46),
                                        width: 1),
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
                                      _buildMainHeader(),
                                      _buildTableSubHeader(),
                                      ...rows.map((rowId) => _buildTableRow(
                                          rowId,
                                          '',
                                          '',
                                          setState,
                                          setDialogState)),
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
                                                fontWeight: FontWeight.w500),
                                          )
                                        ],
                                      )),
                                ],
                              ),
                            ),
                            //First Tab
                            //End Strategic Contributions------------------------------------------------------------------------------------------------------
                            //End Strategic Contributions------------------------------------------------------------------------------------------------------

                            // Start Readiness Rating-Cancer Care ---------------------------------------------------------------------------------------------------------
                            // Second Tab: Additional Content------------------------------------------------------------------------
                            //Start Readiness Rating-Cancer Care----------------------------------------------------------------------------------
                            Scaffold(
                              backgroundColor: mainBgColor,
                              appBar: AppBar(
                                automaticallyImplyLeading:
                                    false, // Removes the back button
                                title: Row(
                                  children: [
                                    Text(
                                      'READINESS RATING - CANCER CARE',
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white),
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
                                        alignment: Alignment(1.0,
                                            0.0), // Adjust X (left-right) and Y (up-down) positions
                                        padding: EdgeInsets.only(
                                            right:
                                                50.0), // Add spacing from right if needed
                                        child: Text(
                                          'SCORE',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      // Competence Score Dropdown
                                      buildScoreRow(
                                        'COMPETENCE TO DELIVER',
                                        [
                                          'Teams lack adequate skills and training to deliver performance commitments',
                                          'Teams are skilled but lack training to deliver performance commitments ',
                                          'Teams are highly skilled and trained to deliver performance commitments'
                                        ],
                                        competenceScore,
                                      ),

                                      // Resource Availability Dropdown
                                      buildScoreRow(
                                        'RESOURCE AVAILABILITY',
                                        [
                                          'Insufficient; external resources difficult to source',
                                          'Sufficient resources but not available; OR Insufficient but external resources can be tapped',
                                          'Sufficient and available staff and budget'
                                        ],
                                        resourceScore,
                                      ),

                                      // Confidence to Deliver Dropdown
                                      buildScoreRow(
                                        'CONFIDENCE TO DELIVER',
                                        [
                                          'Low confidence because of high degree of organizational change required',
                                          'Moderate confidence',
                                          'High confidence despite organizational change required'
                                        ],
                                        confidenceScore,
                                      ),
                                      // TOTAL SCORE DISPLAY (Automatically Updates)
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .end, // Align to the right side (Score Column)
                                        children: [
                                          ValueListenableBuilder<double>(
                                            valueListenable: competenceScore,
                                            builder: (context, _, __) {
                                              return ValueListenableBuilder<
                                                  double>(
                                                valueListenable: resourceScore,
                                                builder: (context, _, __) {
                                                  return ValueListenableBuilder<
                                                      double>(
                                                    valueListenable:
                                                        confidenceScore,
                                                    builder: (context, _, __) {
                                                      return Padding(
                                                        padding: EdgeInsets.only(
                                                            right:
                                                                60.0), // Adjust right padding if needed
                                                        child: Text(
                                                          'TOTAL SCORE:          ${totalScore.toStringAsFixed(1)}',
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                          ),
                                                          textAlign: TextAlign
                                                              .right, // Ensure text alignment is right
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

                            // Second Tab: Additional Content------------------------------------------------------------------------------------
                            //End Readiness Rating-Cancer Care----------------------------------------------------------------------------------
                            //End Readiness Rating-Cancer Care ---------------------------------------------------------------------------------------------------------

                            // Third Tab: Additional Content
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(height: 20),
                                  Table(
                                    border: TableBorder.all(
                                        color: const Color.fromARGB(
                                            255, 49, 46, 46),
                                        width: 1),
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
                                      ...rows.map((rowId) => _buildTableRow(
                                          rowId,
                                          '',
                                          '',
                                          setState,
                                          setDialogState)),
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

              // Dialog Actions
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      rows = initialRows;
                      deliverablesControllers = initialControllers;
                      selectedDirect = initialSelectedDirect;
                      selectedIndirect = initialSelectedIndirect;
                      selectedByWhen = initialSelectedByWhen;
                      selectedStatus = initialSelectedStatus;
                      selectedKRA = initialSelectedKRA;
                      selectedKRAObjects = initialSelectedKRAObjects;
                    });
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
                      builder: (context) => AlertDialog(
                        title: Text("Confirm Save"),
                        content:
                            Text("Are you sure you want to save this record?"),
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
                      setState(() {
                        saveDeliverablesToAPI();
                      });

                      //  saveDeliverablesToAPI();

                      Navigator.pop(context);
                    }
                  },
                  child: Text('Save as Draft',
                      style: TextStyle(color: primaryColor)),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shadowColor: Colors.transparent,
                        elevation: 0,
                        backgroundColor: secondaryBgButton,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4))),
                    onPressed: () {},
                    child: Text(
                      'Print',
                      style: TextStyle(color: primaryColor),
                    )),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4))),
                  onPressed: () async {
                    bool? confirm = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Confirm Submit"),
                        content: Text(
                            "Are you sure you want to submit this record? You won’t be able to make any changes."),
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
                      _SubmitData();
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Submit',
                      style: TextStyle(
                          color: const Color.fromARGB(255, 255, 255, 255))),
                ),
              ],
            );
          },
        );
      },
    );
  }

// Start Readiness Rating-Cancer Care ---------------------------------------------------------------------------------------------------------
// Start Readiness Rating-Cancer Care ---------------------------------------------------------------------------------------------------------
  Widget buildScoreRow(String title, List<String> descriptions,
      ValueNotifier<double> selectedValue) {
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
                            color: Colors.black),
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
              padding: EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 20,
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                    color: const Color.fromARGB(
                        255, 245, 243, 243)), // Optional: Adds a border
                borderRadius:
                    BorderRadius.circular(1), // Optional: Rounds the corners
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
                        fontWeight: FontWeight
                            .normal), // Ensures selected value is also styled
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
// End Readiness Rating-Cancer Care -------------------------------------------------------------------------------------------------------------
// End Readiness Rating-Cancer Care ---------------------------------------------------------------------------------------------------------

  //Start Strategic Contributions------------------------------------------------------------------------------------------------------
  //Start Strategic Contributions------------------------------------------------------------------------------------------------------
  // PGS Table Row (Body)
  TableRow _buildTableRow(int index, String direct, String indirect,
      Function setState, Function setDialogState) {
    deliverablesControllers.putIfAbsent(index, () => TextEditingController());
    selectedDirect.putIfAbsent(index, () => false);
    selectedIndirect.putIfAbsent(index, () => false);
    selectedByWhen.putIfAbsent(index, () => '');

    // Define alternating row colors
    Color rowColor = (index % 2 == 0) ? mainBgColor : Colors.white;

    return TableRow(
      decoration: BoxDecoration(color: rowColor),
      children: [
        _buildDropdownCell(index),
        _buildCheckboxCell(
            index, selectedDirect, selectedIndirect, setDialogState,
            isDirect: true),
        _buildCheckboxCell(
            index, selectedIndirect, selectedDirect, setDialogState,
            isDirect: false),
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
        value: selectedStatus[index] ??
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
        items: PgsStatus.values.map((PgsStatus value) {
          return DropdownMenuItem<PgsStatus>(
            value: value,
            child: Text(value.name, style: const TextStyle(fontSize: 14)),
          );
        }).toList(),
      ),
    );
  }

  void confirmSelection() {
    setState(() {
      selectedDirect.addAll(tempSelectedDirect);
      selectedIndirect.addAll(tempSelectedIndirect);
      tempSelectedDirect.clear();
      tempSelectedIndirect.clear();
    });
  }

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
              print("✍️ Updated TextField at index $index: $value");
            });
          },
        ),
      ),
    );
  }

  // Kra Dropdown -----------------------------------------------------------------------------------
  Widget _buildDropdownCell(
    int index,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField<int>(
        value: selectedKRA[index] ??
            (options.isNotEmpty ? options.first['id'] : null),
        onChanged: (int? newValue) {
          setState(() {
            selectedKRA[index] = newValue!;
            selectedKRAObjects[index] = options.firstWhere(
              (option) => option['id'] == newValue,
              orElse: () => {
                'id': 0,
                'name': 'Unknown',
                'description': ''
              }, // Default object kung wala
            );
          });
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.all(8.0),
        ),
        items: options.isEmpty
            ? [
                DropdownMenuItem<int>(value: null, child: Text("Loading..."))
              ] // Show loading text
            : options.map<DropdownMenuItem<int>>((Map<String, dynamic> option) {
                return DropdownMenuItem<int>(
                  value: option['id'],
                  child: Text(option['name']),
                );
              }).toList(),
      ),
    );
  }

  Widget _buildDatePickerCell(int index, Function setDialogState) {
    selectedByWhenControllers.putIfAbsent(index, () => TextEditingController());

    // Check if there's already a selected date
    if (selectedByWhen[index] == null ||
        selectedByWhenControllers[index]?.text.isEmpty == true) {
      DateTime now = DateTime.now();
      String defaultDate = DateFormat('yyyy-MM-dd').format(now); // ISO format
      selectedByWhen[index] = defaultDate;
      selectedByWhenControllers[index]?.text =
          DateFormat('MMMM yyyy').format(now); // Display-friendly format
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller:
            selectedByWhenControllers[index], // Use persistent controller
        readOnly: true,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: primaryColor)),
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
                            primary: primaryColor, onPrimary: secondaryColor),
                        textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                                foregroundColor: primaryColor))),
                    child: child!);
              });
          if (pickedDate != null) {
            String formattedDate = DateFormat('yyyy-MM-dd')
                .format(pickedDate); // ISO format for saving
            setDialogState(() {
              selectedByWhen[index] = formattedDate;
              selectedByWhenControllers[index]?.text = DateFormat('MMMM yyyy')
                  .format(pickedDate); // User-friendly format
            });
          }
        },
      ),
    );
  }

  //End Strategic Contributions------------------------------------------------------------------------------------------------------
  //End Strategic Contributions------------------------------------------------------------------------------------------------------

//Start PGS Deliverable List-----------------------------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    bool isMinimized = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      backgroundColor: mainBgColor,
      appBar: AppBar(
        backgroundColor: mainBgColor,
        title: Text(
          'Deliverable Information',
        ),
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
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 5),
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
                          flex: 3,
                          child: Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text('Description',
                                style: TextStyle(color: grey)),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(right: 1),
                            child:
                                Text('Actions', style: TextStyle(color: grey)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: filteredList
                            .asMap()
                            .map((index, deliverable) {
                              return MapEntry(
                                index,
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 1, horizontal: 16),
                                  decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey.shade300)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: EdgeInsets.only(right: 1),
                                          child: Text(
                                            (index + 1).toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Padding(
                                          padding: EdgeInsets.only(right: 1),
                                          child: Text(
                                            deliverable['deliverableName'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: EdgeInsets.only(right: 1),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              IconButton(
                                                icon: Icon(Icons.delete,
                                                    color: Color.fromARGB(
                                                        255, 221, 79, 79)),
                                                onPressed: () async {
                                                  setState(() {
                                                    filteredList
                                                        .removeAt(index);
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
      // Show FloatingActionButton only when minimized
      floatingActionButton: isMinimized
          ? FloatingActionButton(
              backgroundColor: primaryColor,
              onPressed: () => showFormDialog(),
              child: Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  // Filter search results based on query
  void filterSearchResults(String query) {
    deliverables.then((data) {
      setState(() {
        filteredList = data
            .where((item) => item['deliverableName']
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      });
    });
  }
}

//End PGS Deliverable List-----------------------------------------------------------------------------------------------------------

// Tab End--------------------------

//Start Strategic Contributions------------------------------------------------------------------------------------------------------
// PGS Main Header
TableRow _buildMainHeader() {
  return TableRow(
    decoration: BoxDecoration(color: primaryLightColor),
    children: [
      _buildHeaderCell('Surgery',
          color: Colors.white, fontSize: 20, fontStyle: FontStyle.normal),
      _buildHeaderCell(''),
      _buildHeaderCell(''),
      _buildHeaderCell('STRATEGIC CONTRIBUTIONS',
          color: Colors.white, fontSize: 20, fontStyle: FontStyle.normal),
      _buildHeaderCell('30%',
          color: Colors.white, fontSize: 20, fontStyle: FontStyle.normal),
      _buildHeaderCell(''),
      _buildHeaderCell(''),
    ],
  );
}

// Sub Header
TableRow _buildTableSubHeader() {
  return TableRow(
    decoration: BoxDecoration(color: const Color.fromARGB(255, 255, 254, 254)),
    children: [
      _buildHeaderCell('KRA'),
      _buildHeaderCell('DIRECT'),
      _buildHeaderCell('INDIRECT'),
      _buildHeaderCell('DELIVERABLES'),
      _buildHeaderCell('BY WHEN'),
      _buildHeaderCell('STATUS'),
      _buildHeaderCell('ACTION'),
    ],
  );
}

//PGS DELIVERABLES STATUS tableRow

TableRow _PgsDeliverableHeader() {
  return TableRow(
    children: [
      _buildHeaderCell('Office: OPERATING ROOM COMPLEX (CathLab)',
          fontSize: 20, fontStyle: FontStyle.normal),
      _buildHeaderCell(''),
      _buildHeaderCell(''),
      _buildHeaderCell('STRATEGIC CONTRIBUTIONS',
          fontSize: 20, fontStyle: FontStyle.normal),
      _buildHeaderCell('Percentage', fontSize: 20, fontStyle: FontStyle.normal),
      _buildHeaderCell(''),
      _buildHeaderCell(''),
    ],
  );
}

TableRow _PgsBuildTableSubheader() {
  return TableRow(
    decoration: BoxDecoration(color: const Color.fromARGB(255, 255, 254, 254)),
    children: [
      _buildHeaderCell('KRA'),
      _buildHeaderCell('DIRECT'),
      _buildHeaderCell('INDIRECT'),
      _buildHeaderCell('DELIVERABLES'),
      _buildHeaderCell('WHEN'),
      _buildHeaderCell('STATUS'),
      _buildHeaderCell('REMARKS'),
    ],
  );
}

//END PGS DELIVERABLES STATUS tableRow

// // Check Box
Widget _buildCheckboxCell(int index, Map<int, bool> selectedValues,
    Map<int, bool> oppositeValues, Function setDialogState,
    {required bool isDirect}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
            color: const Color.fromARGB(255, 255, 255, 255), width: 0.5),
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
                // If one is checked, uncheck the other
                oppositeValues[index] = false;
              }

              // Print values in the console for debugging
              print("Index: $index");
              print("${isDirect ? "Direct" : "Indirect"} checked: $newValue");
              print(
                  "${isDirect ? "Indirect" : "Direct"} unchecked: ${oppositeValues[index]}");
            });
          },
          activeColor: Colors.white,
          checkColor: Colors.black,
        ),
      ),
    ),
  );
}

Widget _buildHeaderCell(
  String text, {
  Color color = Colors.black,
  double fontSize = 15,
  FontStyle fontStyle = FontStyle.normal,
}) {
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
          color: color,
          fontStyle: fontStyle,
        ),
      ),
    ),
  );
}
//End Strategic Contributions------------------------------------------------------------------------------------------------------

TableRow _buildRow(List<String> cells, {bool isHeader = false}) {
  return TableRow(
    children: cells.map((cell) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          cell,
          style: TextStyle(
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }).toList(),
  );
}
