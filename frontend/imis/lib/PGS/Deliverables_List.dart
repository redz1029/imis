import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:imis/PGS/pgs_deliverables.dart';
import 'package:imis/pgs/pgs_status.dart';
import 'package:imis/settings/key_result_area/key_result_area.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;


class Deliverables_List extends StatefulWidget {
  const Deliverables_List({super.key});

  @override
  _DeliverablesScreenState createState() => _DeliverablesScreenState();
}


//Start Strategic Contributions------------------------------------------------------------------------------------------------------
// Helper Function to Format Enum Names
String _formatEnumName(String enumName) {
  return enumName
      .replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (match) => '${match.group(1)} ${match.group(2)}') // Add space before uppercase letters
      .replaceAll('_', ' ') // Replace underscores with spaces
      .capitalize(); // Capitalize first letter
}

// Capitalize first letter of each word
extension StringExtension on String {
  String capitalize() {
    return split(' ')
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '')
        .join(' ');
  }
}
//End Strategic Contributions------------------------------------------------------------------------------------------------------


class _DeliverablesScreenState extends State<Deliverables_List> {
  List<Map<String, dynamic>> deliverablesList = [];
  List<Map<String, dynamic>> filteredList = [];
  TextEditingController searchController = TextEditingController();
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

  List<String> pgsStatusOptions = PgsStatus.values.map((e) => e.name).toList(); // New adding Class Test

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
    fetchDropdownData().then((_) {
      setState(() {});
    });
  }
  //End Start Strategic Contributions------------------------------------------------------------------------------------------------------

  //Start Strategic Contributions------------------------------------------------------------------------------------------------------  
  Future<void> fetchDropdownData() async {
    try {
      final response = await http.get(Uri.parse("https://localhost:7273/Kra"));

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

  
  //Starting Point----------------
  // ignore: unused_element, non_constant_identifier_names
  // void _SaveAllData(Pgs pgs) async {
  //   final response = await http.post(Uri.parse(apiUrl),
  //       headers: {'Content-Type': 'application/json'}, body: pgs.toJson());

  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text('All Data Saved Successfully')),
  //   );
  // }
  
  
//Starting Point----------------
  // ignore: unused_element, non_constant_identifier_names
//   void _SaveAllData(Pgs pgs) async {     
//   try {
//     final response = await http.post(
//       Uri.parse(apiUrl),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode(pgs.toJson()), // Ensure JSON encoding
//     );
    

//     if (!mounted) return; // Prevent calling context after dispose

//     if (response.statusCode == 200) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('All Data Saved Successfully')),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to Save Data: ${response.body}')),
//       );
//     }
//   } catch (e) {
//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Error: $e')),
//     );
//   }
// }


Future<void> saveDeliverablesToAPI() async {
  List<PgsDeliverables> deliverables = getTableDeliverables();

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(deliverables.map((d) => d.toJson()).toList()), // Convert to JSON
    );

    if (response.statusCode == 200) {
      print("Deliverables saved successfully!");
    } else {
      print("Failed to save deliverables: ${response.body}");
    }
  } catch (e) {
    print("Error: $e");
  }
}

// List<PgsDeliverables> getTableDeliverables() {
//   List<PgsDeliverables> deliverablesList = [];

//   deliverablesControllers.forEach((index, controller) {
//     var kraData = selectedKRAObjects[index] ?? {'id': 0, 'name': 'Unknown', 'description': ''};

//     deliverablesList.add(
//       PgsDeliverables(
//         index, // Placeholder ID
//         KeyResultArea(kraData['id'], kraData['name'], kraData['description']), // Buong KRA object
//         controller.text, // Deliverable Name
//         selectedDirect[index] ?? false, // isDirect (Checkbox)
//         DateTime.tryParse(selectedByWhen[index] ?? '') ?? DateTime.now(), // byWhen (DatePicker)
//         0.0, // percentageDeliverable
//         PgsStatus.values.firstWhere(
//           (e) => e.toString() == 'PgsStatus.${selectedStatus[index] ?? 'notStarted'}',
//           orElse: () => PgsStatus.notStarted,
//         ),
//         remarks: "", // Remarks
//       ),
//     );
//   });

//   return deliverablesList;
// }


List<PgsDeliverables> getTableDeliverables() {
  List<PgsDeliverables> deliverablesList = [];

  deliverablesControllers.forEach((index, controller) {
    var kraData = selectedKRAObjects[index] ?? {'id': 0, 'name': 'Unknown', 'description': ''};
    var deliverableText = controller.text.isNotEmpty ? controller.text : "No Name"; // Default to "No Name"
    var isDirect = selectedDirect[index] ?? false; // Default to false
    var byWhen = DateTime.tryParse(selectedByWhen[index] ?? '') ?? DateTime.now(); // Default to today
    var percentDeliverables = 0.0; // Default to 0.0
    var status = PgsStatus.values.firstWhere(
      (e) => e.toString() == 'PgsStatus.${selectedStatus[index] ?? 'notStarted'}',
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


void sendDeliverables() async {
  final deliverables = getTableDeliverables(); // Kunin ang list ng data
 final jsonData = jsonEncode(deliverables.map((d) => d.toJson()).toList()); 
  
  print("📌 JSON Data to Send: $jsonData"); // I-check kung tama
  
  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {"Content-Type": "application/json"},
    body: jsonData,
  );

  print("📡 Response Status: ${response.statusCode}");
  print("🔍 Response Body: ${response.body}");
}





  // ignore: non_constant_identifier_names
  void _SubmitData() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Data Submitted Successfully')),
    );
  }
  //End Strategic Contributions------------------------------------------------------------------------------------------------------

  void showFormDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
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
                        labelColor:
                            Colors.redAccent.shade100, // Active tab text color
                        unselectedLabelColor:
                            Colors.black, // Inactive tab text color
                        indicatorColor: Colors
                            .redAccent.shade100, // Underline indicator color
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
                                        color: Colors.black, width: 1.2),
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
                                  ElevatedButton(
                                    onPressed: () {
                                      setDialogState(() {
                                        _addRow();
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Colors.redAccent.shade100),
                                    child: Text("Add Row",
                                        style: TextStyle(color: Colors.white)),
                                  ),
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
                                backgroundColor: Color(0xFFD46A6A),
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
                            Center(
                              child: Text("Additional"),
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
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text('Cancel', style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1A67A3)),
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
                      // _SaveAllData();

                      // saveDeliverablesToAPI();
                      sendDeliverables();

                      Navigator.pop(context);
                    }
                  },
                  child: Text('Save as Draft',
                      style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 26, 163, 110)),
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
      Color(0xFFF4E3E3),
      Color(0xFFE4B9B9),
      Color(0xFFD46A6A),
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
  Color rowColor = (index % 2 == 0)
      ? const Color.fromARGB(255, 255, 255, 255)
      : Colors.white;

  return TableRow(
    decoration: BoxDecoration(color: rowColor),
    children: [
      _buildDropdownCell(index),
      _buildCheckboxCell(index, selectedDirect, selectedIndirect, setDialogState, isDirect: true),
      _buildCheckboxCell(index, selectedIndirect, selectedDirect, setDialogState, isDirect: false),
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
    child: DropdownButtonFormField<String>(
      value: selectedStatusOptions[index] ?? pgsStatusOptions[0], // Default value
      onChanged: (String? newValue) {
        if (newValue != null) {
          setDialogState(); // Ensure UI updates
          selectedStatusOptions[index] = newValue; // Store selection per row
        }
      },
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.all(8.0),
      ),
      items: pgsStatusOptions.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            _formatEnumName(value), // Optional: Format display text
            style: const TextStyle(fontSize: 14),
          ),
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
        controller: deliverablesControllers[index], // Gamitin ang tamang index
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
            (options.isNotEmpty
                ? options.first['id']
                : null),         
          onChanged: (int? newValue) {
          setState(() {
            selectedKRA[index] = newValue!;
            selectedKRAObjects[index] = options.firstWhere(
              (option) => option['id'] == newValue,
              orElse: () => {'id': 0, 'name': 'Unknown', 'description': ''}, // Default object kung wala
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
      String defaultDate = DateFormat('MMMM yyyy').format(now);
      selectedByWhen[index] = defaultDate;
      selectedByWhenControllers[index]?.text = defaultDate; // Set default text
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller:
            selectedByWhenControllers[index], // Use persistent controller
        readOnly: true,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.all(8.0),
          suffixIcon: Icon(Icons.calendar_today),
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          if (pickedDate != null) {
            String formattedDate = DateFormat('MMMM yyyy').format(pickedDate);
            setDialogState(() {
              selectedByWhen[index] = formattedDate;
              selectedByWhenControllers[index]?.text =
                  formattedDate; // Update text field
            });
            // saveDataToAPI(index); // Call save function after selecting the date
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Deliverable Information',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF1A67A3),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search Deliverable',
                prefixIcon:
                    Icon(Icons.search, color: Color.fromARGB(255, 44, 45, 46)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onChanged: filterSearchResults,
            ),
            SizedBox(height: 20),
            Expanded(
              child: Column(
                children: [
                  Container(
                    color: Color(0xFF1A67A3),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text('#',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text('Description',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(right: 1),
                            child: Text('Actions',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF1A67A3),
        onPressed: () => showFormDialog(),
        child: Icon(Icons.add, color: Colors.white),
      ),
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
    decoration: BoxDecoration(color: Colors.redAccent.shade100),
    children: [
      _buildHeaderCell('Surgery', color: Colors.white, fontSize: 20, fontStyle: FontStyle.normal),
      _buildHeaderCell(''),
      _buildHeaderCell(''),
      _buildHeaderCell('STRATEGIC CONTRIBUTIONS', color: Colors.white, fontSize: 20, fontStyle: FontStyle.normal),
      _buildHeaderCell('30%', color: Colors.white, fontSize: 20, fontStyle: FontStyle.normal),
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

  // // Check Box
  Widget _buildCheckboxCell(
      int index,
      Map<int, bool> selectedValues,
      Map<int, bool> oppositeValues,
      Function setDialogState,
      {required bool isDirect}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: const Color.fromARGB(255, 255, 255, 255), width: 0.5),
          color:const Color.fromARGB(255, 255, 255, 255), 
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
                print("${isDirect ? "Indirect" : "Direct"} unchecked: ${oppositeValues[index]}");
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
 
