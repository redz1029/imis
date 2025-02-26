import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class KRAListScreen extends StatefulWidget {
  const KRAListScreen({super.key});

  @override
  _KRAListScreenState createState() => _KRAListScreenState();
}

class _KRAListScreenState extends State<KRAListScreen> {
  List<Map<String, dynamic>> kraList = [];
  List<Map<String, dynamic>> filteredList = [];
  TextEditingController searchController = TextEditingController();
  final String apiUrl = 'https://localhost:7273/Kra';

  @override
  void initState() {
    super.initState();
    fetchKRAs();
  }

  Future<void> fetchKRAs() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          kraList = data
              .map((kra) => {
                    'id': kra['id'],
                    'name': kra['name'],
                    'remarks': kra['remarks'],
                    'isDeleted': kra['isDeleted']
                  })
              .toList();
          filteredList = List.from(kraList);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> addOrUpdateKRA(String? id, String name, String remarks) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': id ?? '0',
          'name': name,
          'remarks': remarks,
          'isDeleted': false, // Default to false
          'rowVersion': '',
        }),
      );
      if (response.statusCode == 201) {
        fetchKRAs();
      }
    } catch (e) {
      print(e);
    }
  }

  void filterSearchResults(String query) {
    setState(() {
      filteredList = kraList
          .where(
              (kra) => kra['name']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void showFormDialog({String? id, String? name, String? remarks}) {
    TextEditingController nameController = TextEditingController(text: name);
    TextEditingController remarksController =
        TextEditingController(text: remarks);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          title: Text(id == null ? 'Add KRA' : 'Edit KRA',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 350,
                height: 65,
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(
                width: 350,
                height: 65,
                child: TextField(
                  controller: remarksController,
                  decoration: InputDecoration(
                    labelText: 'Remarks',
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
                  addOrUpdateKRA(
                      id, nameController.text, remarksController.text);
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

  Future<void> deleteKRA(String id) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': id,
          'isDeleted': true, // Mark as deleted
          'rowVersion': '', // Add rowVersion if needed for concurrency
        }),
      );

      if (response.statusCode == 200) {
        fetchKRAs();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('KRA marked as deleted!'),
          ));
        }
      } else {
        print('Failed to delete KRA. Response: ${response.body}');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to delete KRA.'),
          ));
        }
      }
    } catch (e) {
      print('Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('An error occurred while trying to delete KRA.'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Key Result Areas', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF1A67A3),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search KRA',
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
                              'KRA Name',
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
                              'Remarks',
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
                            .map((index, kra) {
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
                                            kra['name'],
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
                                            kra['remarks'] ?? '',
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
                                                    id: kra['id'].toString(),
                                                    name: kra['name'],
                                                    remarks: kra['remarks']),
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
