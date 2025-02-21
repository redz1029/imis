import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PGSPeriodScreen extends StatefulWidget {
  const PGSPeriodScreen({super.key});

  @override
  _PGSPeriodScreenState createState() => _PGSPeriodScreenState();
}

class _PGSPeriodScreenState extends State<PGSPeriodScreen> {
  List<Map<String, dynamic>> pgsList = [];
  List<Map<String, dynamic>> filteredList = [];
  TextEditingController searchController = TextEditingController();
  final String apiUrl = 'https://localhost:44333/PgsPeriod'; // Your API endpoint for PGS Period

  @override
  void initState() {
    super.initState();
    fetchPGSPeriods();
  }

  Future<void> fetchPGSPeriods() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          pgsList = data.map((pgs) => {
            'id': pgs['id'],
            'startDate': pgs['startDate'],
            'endDate': pgs['endDate'],
            'isDeleted': pgs['isDeleted']
          }).toList();
          filteredList = List.from(pgsList);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> addOrUpdatePGSPeriod(String? id, String startDate, String endDate) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': id ?? '0',
          'startDate': startDate,
          'endDate': endDate,
          'isDeleted': false,  // Default to false
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
      filteredList = pgsList.where((pgs) =>
          pgs['startDate']!.toLowerCase().contains(query.toLowerCase()) ||
          pgs['endDate']!.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  void showFormDialog({String? id, String? startDate, String? endDate}) {
    TextEditingController startDateController = TextEditingController(text: startDate);
    TextEditingController endDateController = TextEditingController(text: endDate);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          title: Text(id == null ? 'Add PGS Period' : 'Edit PGS Period', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 350,
                height: 60,
                child: TextField(
                  controller: startDateController,
                  decoration: InputDecoration(
                    labelText: 'Start Date',
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null) {
                      startDateController.text = picked.toLocal().toString().split(' ')[0];
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
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null) {
                      endDateController.text = picked.toLocal().toString().split(' ')[0];
                    }
                  },
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
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF1A67A3)),
              onPressed: () async {
                bool? confirmAction = await showDialog<bool>(  // Confirm action dialog
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(id == null ? "Confirm Save" : "Confirm Update"),
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
                  addOrUpdatePGSPeriod(id, startDateController.text, endDateController.text);
                  Navigator.pop(context);
                }
              },
              child: Text(id == null ? 'Save' : 'Update', style: TextStyle(color: Colors.white)),
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
        title: Text('PGS Periods', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF1A67A3),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search Period',
                prefixIcon: Icon(Icons.search, color: Colors.blue),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
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
                        Expanded(flex: 1, child: Text('#', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                        Expanded(flex: 3, child: Text('Start Date', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                        Expanded(flex: 3, child: Text('End Date', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                        Expanded(flex: 1, child: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: filteredList.asMap().map((index, period) {
                          return MapEntry(
                            index,
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 1, horizontal: 16),
                              decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(flex: 1, child: Text((index + 1).toString())),
                                  Expanded(flex: 3, child: Text(period['startDate'])),
                                  Expanded(flex: 3, child: Text(period['endDate'])),
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.edit, color: Color(0xFF1A67A3)),                                          
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
                        }).values.toList(),
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
