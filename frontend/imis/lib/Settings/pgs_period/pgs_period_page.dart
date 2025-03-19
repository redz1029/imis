import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:imis/constant/constant.dart';

class PgsPeriodPage extends StatefulWidget {
  const PgsPeriodPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PgsPeriodPageState createState() => _PgsPeriodPageState();
}

class _PgsPeriodPageState extends State<PgsPeriodPage> {
  List<Map<String, dynamic>> pgsList = [];
  List<Map<String, dynamic>> filteredList = [];
  TextEditingController searchController = TextEditingController();
  final FocusNode isSearchfocus = FocusNode();
  final String apiUrl =
      'https://localhost:7273/PgsPeriod'; // Your API endpoint for PGS Period

  @override
  void initState() {
    super.initState();
    fetchPGSPeriods();
    isSearchfocus.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    isSearchfocus.dispose();
    super.dispose();
  }

  Future<void> fetchPGSPeriods() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          pgsList = data
              .map((pgs) => {
                    'id': pgs['id'],
                    'startDate': pgs['startDate'],
                    'endDate': pgs['endDate'],
                    'isDeleted': pgs['isDeleted']
                  })
              .toList();
          filteredList = List.from(pgsList);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> addOrUpdatePGSPeriod(
      String? id, String startDate, String endDate) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': id ?? '0',
          'startDate': startDate,
          'endDate': endDate,
          'isDeleted': false, // Default to false
          'rowVersion': '',
        }),
      );
      if (response.statusCode == 201) {
        fetchPGSPeriods();
        print(id);
      }
    } catch (e) {
      print(e);
    }
  }

  void filterSearchResults(String query) {
    setState(() {
      filteredList = pgsList
          .where((pgs) =>
              pgs['startDate']!.toLowerCase().contains(query.toLowerCase()) ||
              pgs['endDate']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void showFormDialog({String? id, String? startDate, String? endDate}) {
    TextEditingController startDateController =
        TextEditingController(text: startDate);
    TextEditingController endDateController =
        TextEditingController(text: endDate);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: mainBgColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          title: Text(id == null ? 'Add PGS Period' : 'Edit PGS Period',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 350,
                height: 60,
                child: TextField(
                  controller: startDateController,
                  decoration: InputDecoration(
                    focusColor: primaryColor,
                    labelText: 'Start Date',
                    floatingLabelStyle: TextStyle(color: primaryColor),
                    border: OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                    ),
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: primaryColor,
                                onPrimary: secondaryColor,
                              ),
                              textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                      foregroundColor: primaryColor))),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) {
                      startDateController.text =
                          picked.toLocal().toString().split(' ')[0];
                    }
                  },
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                width: 350,
                height: 60,
                child: TextField(
                  controller: endDateController,
                  decoration: InputDecoration(
                      labelText: 'End Date',
                      floatingLabelStyle: TextStyle(color: primaryColor),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor),
                      )),
                  readOnly: true,
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null) {
                      endDateController.text =
                          picked.toLocal().toString().split(' ')[0];
                    }
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                  backgroundColor: secondaryBgButton,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4))),
              child: Text('Cancel', style: TextStyle(color: primaryColor)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4))),
              onPressed: () async {
                bool? confirmAction = await showDialog<bool>(
                  // Confirm action dialog
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title:
                          Text(id == null ? "Confirm Save" : "Confirm Update"),
                      content: Text(id == null
                          ? "Are you sure you want to save this record?"
                          : "Are you sure you want to update this record?"),
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
                    );
                  },
                );

                if (confirmAction == true) {
                  addOrUpdatePGSPeriod(
                      id, startDateController.text, endDateController.text);
                  Navigator.pop(context);
                }
              },
              child: Text(id == null ? 'Save' : 'Update',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isMinimized = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: mainBgColor,
      appBar: AppBar(
        backgroundColor: mainBgColor,
        title: Text(
          'PGS Periods',
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
                    focusNode: isSearchfocus,
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
                        color: isSearchfocus.hasFocus ? primaryColor : grey,
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

                // Show 'Add New' button on the right
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
                            child: Text('ID', style: TextStyle(color: grey))),
                        Expanded(
                            flex: 3,
                            child: Text('Start Date',
                                style: TextStyle(color: grey))),
                        Expanded(
                            flex: 3,
                            child: Text('End Date',
                                style: TextStyle(color: grey))),
                        Expanded(
                            flex: 1,
                            child:
                                Text('Actions', style: TextStyle(color: grey))),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: filteredList
                            .asMap()
                            .map((index, period) {
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
                                          child: Text((index + 1).toString())),
                                      Expanded(
                                          flex: 3,
                                          child: Text(period['startDate'])),
                                      Expanded(
                                          flex: 3,
                                          child: Text(period['endDate'])),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.edit,
                                                  color: Color(0xFF1A67A3)),
                                              onPressed: () => showFormDialog(
                                                id: period['id'].toString(),
                                                startDate: period['startDate'],
                                                endDate: period['endDate'],
                                              ),
                                            ),
                                          ],
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
}
