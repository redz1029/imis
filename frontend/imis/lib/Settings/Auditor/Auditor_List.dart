import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuditorListScreen extends StatefulWidget {
  const AuditorListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AuditorListScreenState createState() => _AuditorListScreenState();
}

class _AuditorListScreenState extends State<AuditorListScreen> {
  // ignore: non_constant_identifier_names
  List<Map<String, dynamic>> AuditorList = [];
  List<Map<String, dynamic>> filteredList = [];
  TextEditingController searchController = TextEditingController();
  final String apiUrl = 'https://localhost:7273/auditors';

  @override
  void initState() {
    super.initState();
    // Fetch auditors when the screen is initialized
    fetchAuditors();
  }

  // Fetch auditors from the API
  Future<void> fetchAuditors() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        // Parse the response and assign the data to AuditorList
        List<dynamic> data = json.decode(response.body);
        setState(() {
          AuditorList =
              data.map((auditor) => auditor as Map<String, dynamic>).toList();
          filteredList = List.from(AuditorList); // Initially show all auditors
        });
      } else {
        if (kDebugMode) {
          print('Failed to load auditors');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  // Add or update auditor
  Future<void> addOrUpdateAuditor(String? id, String name) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': id ?? '0',
          'name': name,
          'isActive': true,
          'isTeamLeader': false,
          'isOfficeHead': false,
          'isDeleted': false, // Default to false
          'rowVersion': '',
        }),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        fetchAuditors();
        Navigator.pop(context); // Close the dialog
      } else {
        if (kDebugMode) {
          print('Failed to add or update auditor');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  // Filter search results based on query
  void filterSearchResults(String query) {
    setState(() {
      filteredList = AuditorList.where((auditor) =>
              auditor['name']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  // Show the form to add or update auditor
  void showFormDialog({String? id, String? name}) {
    TextEditingController AuditorController = TextEditingController(text: name);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          title: Text(id == null ? 'Add Auditor' : 'Edit Auditor',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 350,
                height: 65,
                child: TextField(
                  controller: AuditorController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: Color(0xFF1A67A3)),
              onPressed: () async {
                bool? confirmAction = await showDialog<bool>(
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
                  addOrUpdateAuditor(id, AuditorController.text);
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
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Auditor Information', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF1A67A3),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search Auditor',
                prefixIcon: Icon(Icons.search, color: Colors.blue),
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
                            child: Text(
                              '#',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(
                              'Auditor Name',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(right: 1),
                            child: Text(
                              'Actions',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              overflow: TextOverflow.ellipsis,
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
                        children: filteredList
                            .asMap()
                            .map((index, auditor) {
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
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Padding(
                                          padding: EdgeInsets.only(right: 1),
                                          child: Text(
                                            auditor['name'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal),
                                            overflow: TextOverflow.ellipsis,
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
                                                icon: Icon(Icons.edit,
                                                    color: Color(0xFF1A67A3)),
                                                onPressed: () => showFormDialog(
                                                    id: auditor['id']
                                                        .toString(),
                                                    name: auditor['name']),
                                              ),
                                              SizedBox(width: 1),
                                              IconButton(
                                                icon: Icon(Icons.delete,
                                                    color: Color.fromARGB(
                                                        255, 221, 79, 79)),
                                                onPressed: () async {},
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
}
