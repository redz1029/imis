import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/performance_governance_system/key_result_area/models/key_result_area.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/pagination_util.dart';

class KeyResultAreaPage extends StatefulWidget {
  const KeyResultAreaPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _KeyResultAreaPageState createState() => _KeyResultAreaPageState();
}

class _KeyResultAreaPageState extends State<KeyResultAreaPage> {
  final _formKey = GlobalKey<FormState>();
  final _paginationUtils = PaginationUtil(Dio());
  List<Map<String, dynamic>> kraList = [];
  List<Map<String, dynamic>> filteredList = [];
  TextEditingController searchController = TextEditingController();
  int _currentPage = 1;
  final int _pageSize = 15;
  int _totalCount = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchKRAs();
  }

  final dio = Dio();

  //fetch kra list
  Future<void> fetchKRAs({int page = 1, String? searchQuery}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final pageList = await _paginationUtils.fetchPaginatedData<KeyResultArea>(
        endpoint: ApiEndpoint().keyresult,
        page: page,
        pageSize: _pageSize,
        searchQuery: searchQuery,
        fromJson: (json) => KeyResultArea.fromJson(json),
      );

      if (mounted) {
        setState(() {
          _currentPage = pageList.page;
          _totalCount = pageList.totalCount;
          kraList = pageList.items.map((a) => a.toJson()).toList();
          filteredList = List.from(kraList);
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Add or Update KRA list
  Future<void> addOrUpdateKRA(KeyResultArea kra) async {
    var url = ApiEndpoint().keyresult;
    try {
      final response = await dio.post(url, data: kra.toJson());

      if (response.statusCode == 201) {
        await fetchKRAs();
        setState(() {
          fetchKRAs();
        });
      }
    } catch (e) {
      debugPrint("Error adding/updating KRA: $e");
    }
  }

  //Delete KRA LIST

  Future<void> deleteKRA(String kraId) async {
    var url = ApiEndpoint().keyresult;
    try {
      final response = await dio.delete(url);

      if (response.statusCode == 200) {
        await fetchKRAs();
      }
    } catch (e) {
      debugPrint("Error deleting KRA: $e");
    }
  }

  //filtered result
  void filterSearchResults(String query) {
    setState(() {
      filteredList =
          kraList
              .where(
                (kra) =>
                    kra['name']!.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    });
  }

  void showDeleteDialog(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text(
            "Are you sure you want to delete this KRA? This action cannot be undone.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: TextStyle(color: primaryTextColor)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await deleteKRA(id);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Text('Delete', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void showFormDialog({String? id, String? name, String? remarks}) {
    TextEditingController nameController = TextEditingController(text: name);
    TextEditingController remarksController = TextEditingController(
      text: remarks,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: mainBgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          title: Text(
            id == null ? 'Add KRA' : 'Edit KRA',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 350,
                  height: 65,
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'KRA Name',
                      focusColor: primaryColor,
                      floatingLabelStyle: TextStyle(color: primaryColor),
                      border: OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please fill out this field';
                      }
                      return null;
                    },
                  ),
                ),
                gap2,
                SizedBox(
                  width: 350,
                  height: 65,
                  child: TextFormField(
                    controller: remarksController,
                    decoration: InputDecoration(
                      labelText: 'Remarks',
                      focusColor: primaryColor,
                      floatingLabelStyle: TextStyle(color: primaryColor),
                      border: OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please fill out this field';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: secondaryBgButton,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Text('Cancel', style: TextStyle(color: primaryColor)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  bool? confirmAction = await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          id == null ? "Confirm Save" : "Confirm Update",
                        ),
                        content: Text(
                          id == null
                              ? "Are you sure you want to save this record?"
                              : "Are you sure you want to update this record?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text("No"),
                          ),
                          TextButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                Navigator.pop(context, true);
                              }
                            },
                            child: Text("Yes"),
                          ),
                        ],
                      );
                    },
                  );
                  if (confirmAction == true) {
                    final kra = KeyResultArea(
                      int.tryParse(id ?? '0') ?? 0,
                      nameController.text,
                      remarksController.text,
                      false,
                    );

                    addOrUpdateKRA(kra);
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  }
                }
              },
              child: Text(
                id == null ? 'Save' : 'Update',
                style: TextStyle(color: Colors.white),
              ),
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
        title: Text('Key Result Areas'),
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
                        borderSide: BorderSide(color: primaryColor),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelText: 'Search KRA',
                      labelStyle: TextStyle(color: grey, fontSize: 14),
                      prefixIcon: Icon(Icons.search, size: 20),
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
                          child: Text('#', style: TextStyle(color: grey)),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text('Name', style: TextStyle(color: grey)),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text('Remarks', style: TextStyle(color: grey)),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text('Actions', style: TextStyle(color: grey)),
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
                                .map((index, kra) {
                                  int itemNumber =
                                      ((_currentPage - 1) * _pageSize) +
                                      index +
                                      1;
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
                                                itemNumber.toString(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                overflow: TextOverflow.ellipsis,
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
                                                kra['name'],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                overflow: TextOverflow.ellipsis,
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
                                                kra['remarks'],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                overflow: TextOverflow.ellipsis,
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
                                                    onPressed:
                                                        () => showFormDialog(
                                                          id:
                                                              kra['id']
                                                                  .toString(),
                                                          name: kra['name'],
                                                          remarks:
                                                              kra['remarks'],
                                                        ),
                                                  ),
                                                  SizedBox(width: 1),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.delete,
                                                      color: primaryColor,
                                                    ),
                                                    onPressed:
                                                        () => showDeleteDialog(
                                                          kra['id'].toString(),
                                                        ),
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
            Container(
              padding: EdgeInsets.all(10),
              color: secondaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PaginationInfo(
                    currentPage: _currentPage,
                    totalItems: _totalCount,
                    itemsPerPage: _pageSize,
                  ),
                  PaginationControls(
                    currentPage: _currentPage,
                    totalItems: _totalCount,
                    itemsPerPage: _pageSize,
                    isLoading: _isLoading,
                    onPageChanged: (page) => fetchKRAs(page: page),
                  ),
                  Container(width: 60), // For alignment
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
}
