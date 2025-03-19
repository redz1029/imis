import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:imis/constant/constant.dart';

class KeyResultAreaListPage extends StatefulWidget {
  const KeyResultAreaListPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _KeyResultAreaListPageState createState() => _KeyResultAreaListPageState();
}

class _KeyResultAreaListPageState extends State<KeyResultAreaListPage> {
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
          backgroundColor: mainBgColor,
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
                      focusColor: primaryColor,
                      floatingLabelStyle: TextStyle(color: primaryColor),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor))),
                ),
              ),
              SizedBox(
                width: 350,
                height: 65,
                child: TextField(
                  controller: remarksController,
                  decoration: InputDecoration(
                      focusColor: primaryColor,
                      labelText: 'Remarks',
                      floatingLabelStyle: TextStyle(color: primaryColor),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor))),
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
              child: Text('Cancel',
                  style: TextStyle(
                    color: primaryColor,
                  )),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4))),
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
    bool isMinimized = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      backgroundColor: mainBgColor,
      appBar: AppBar(
        title: Text(
          'Key Result Areas',
        ),
        backgroundColor: mainBgColor,
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
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: lightGrey),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor)),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelText: 'Search KRA',
                      labelStyle: TextStyle(color: grey, fontSize: 14),
                      prefixIcon: Icon(
                        Icons.search,
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
                            child: Text(
                              'ID',
                              style: TextStyle(color: grey),
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
                              style: TextStyle(color: grey),
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
                              style: TextStyle(color: grey),
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
                              style: TextStyle(color: grey),
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
                                                icon: Icon(
                                                  Icons.edit,
                                                ),
                                                onPressed: () => showFormDialog(
                                                    id: kra['id'].toString(),
                                                    name: kra['name'],
                                                    remarks: kra['remarks']),
                                              ),
                                              SizedBox(width: 1),
                                              IconButton(
                                                icon: Icon(Icons.delete,
                                                    color: primaryColor),
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
      floatingActionButton: isMinimized
          ? FloatingActionButton(
              backgroundColor: primaryColor,
              onPressed: () => showFormDialog(),
              child: Icon(Icons.add, color: Colors.white))
          : null,
    );
  }
}
