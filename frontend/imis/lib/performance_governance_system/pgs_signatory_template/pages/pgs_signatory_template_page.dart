import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/user/models/user.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/performance_governance_system/pgs_signatory_template/models/pgs_signatory_template.dart';
import 'package:imis/utils/api_endpoint.dart';

import 'package:imis/utils/pagination_util.dart';

class PgsSignatoryTemplatePage extends StatefulWidget {
  const PgsSignatoryTemplatePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PgsSignatoryTemplatePageState createState() =>
      _PgsSignatoryTemplatePageState();
}

class _PgsSignatoryTemplatePageState extends State<PgsSignatoryTemplatePage> {
  final _paginationUtils = PaginationUtil(Dio());
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> signatoryList = [];
  List<Map<String, dynamic>> filteredList = [];
  TextEditingController searchController = TextEditingController();
  final FocusNode isSearchfocus = FocusNode();
  List<Map<String, dynamic>> labelList = [];
  List<User> userList = [];

  int _currentPage = 1;
  final int _pageSize = 15;
  int _totalCount = 0;
  bool _isLoading = false;

  List<User> filteredListUser = [];
  String? _selectedUserId;

  final dio = Dio();

  //fetchAuditors with pagination
  Future<void> fetchSignatory({int page = 1, String? searchQuery}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final pageList = await _paginationUtils
          .fetchPaginatedData<PgsSignatoryTemplate>(
            endpoint: ApiEndpoint().signatoryTemplate,
            page: page,
            pageSize: _pageSize,
            searchQuery: searchQuery,
            fromJson: (json) => PgsSignatoryTemplate.fromJson(json),
          );

      if (mounted) {
        setState(() {
          _currentPage = pageList.page;
          _totalCount = pageList.totalCount;
          signatoryList = pageList.items.map((a) => a.toJson()).toList();
          filteredList = List.from(signatoryList);
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

  Future<void> fetchUser() async {
    var url = ApiEndpoint().users;
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200 && response.data is List) {
        List<User> data =
            (response.data as List)
                .map((userJson) => User.fromJson(userJson))
                .toList();

        if (mounted) {
          setState(() {
            userList = data;
            filteredListUser = List.from(userList);

            // Auto-select first user
            if (filteredListUser.isNotEmpty) {
              _selectedUserId = filteredListUser[0].id;
              debugPrint("Auto-selected user: $_selectedUserId");
            }
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching user: $e");
    }
  }

  String getUserName(String userId) {
    final user = userList.firstWhere(
      (u) => u.id == userId,
      orElse: () => User(id: '', fullName: 'Unknown User'),
    );
    return user.fullName;
  }

  Future<void> addOrUpdateSignatory(
    PgsSignatoryTemplate pgsSignatoryTemplate,
  ) async {
    var url = ApiEndpoint().signatoryTemplate;
    try {
      final response = await dio.post(url, data: pgsSignatoryTemplate.toJson());

      if (response.statusCode == 200) {
        await fetchSignatory();
        setState(() {
          fetchSignatory();
        });
      }
    } catch (e) {
      debugPrint("Error adding/updating pgs: $e");
    }
  }

  //delete
  Future<void> deleteAuditor(String kraId) async {
    var url = ApiEndpoint().signatoryTemplate;
    try {
      final response = await dio.delete(url);

      if (response.statusCode == 200) {
        await fetchSignatory();
      }
    } catch (e) {
      debugPrint("Error deleting KRA: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchSignatory();
    fetchUser();
    isSearchfocus.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    isSearchfocus.dispose();
    super.dispose();
  }

  // Filter search results based on query
  void filterSearchResults(String query) {
    setState(() {
      filteredList =
          signatoryList
              .where(
                (auditor) => auditor['name']!.toLowerCase().contains(
                  query.toLowerCase(),
                ),
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
            "Are you sure you want to delete this Role? This action cannot be undone.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: TextStyle(color: primaryTextColor)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await deleteAuditor(id);
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

  // Show the form to add or update signatory template
  void showFormDialog({
    String? id,
    bool isDeleted = false,
    String rowVersion = "",
    String? status,
    String? signatoryLabel,
    int? orderLevel,
    String? defaultSignatoryId,
    bool isActive = false,
  }) {
    TextEditingController defaultSignatoryController = TextEditingController(
      text: signatoryLabel,
    );
    TextEditingController statusController = TextEditingController(
      text: status,
    );
    TextEditingController orderLevelController = TextEditingController(
      text: orderLevel?.toString() ?? '',
    );

    _selectedUserId =
        userList.any((u) => u.id == defaultSignatoryId)
            ? defaultSignatoryId
            : null;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: mainBgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          title: Text(
            id == null ? 'Add Signatory' : 'Edit Signatory',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 350,
                  child: DropdownButtonFormField<String>(
                    value:
                        filteredListUser.any(
                              (user) => user.id == _selectedUserId,
                            )
                            ? _selectedUserId
                            : null,
                    decoration: InputDecoration(
                      labelText: 'User Name',
                      border: OutlineInputBorder(),
                    ),
                    items:
                        filteredListUser.map((user) {
                          return DropdownMenuItem<String>(
                            value: user.id,
                            child: Text(user.fullName),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedUserId = value;
                      });
                    },
                  ),
                ),
                if (_selectedUserId != null)
                  Positioned.fill(
                    child: AbsorbPointer(
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                gap,
                SizedBox(
                  width: 350,
                  height: 65,
                  child: TextFormField(
                    controller: defaultSignatoryController,
                    decoration: InputDecoration(
                      labelText: 'Label Name',
                      focusColor: primaryColor,
                      floatingLabelStyle: TextStyle(color: primaryColor),
                      border: OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                ),

                SizedBox(
                  width: 350,
                  height: 65,
                  child: TextFormField(
                    controller: statusController,
                    decoration: InputDecoration(
                      labelText: 'Status',
                      focusColor: primaryColor,
                      floatingLabelStyle: TextStyle(color: primaryColor),
                      border: OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                ),

                SizedBox(
                  width: 350,
                  height: 65,
                  child: TextFormField(
                    controller: orderLevelController,
                    decoration: InputDecoration(
                      labelText: 'Order Level',
                      focusColor: primaryColor,
                      floatingLabelStyle: TextStyle(color: primaryColor),
                      border: OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a name';
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
                    final pgsSignatoryTemplate = PgsSignatoryTemplate(
                      int.tryParse(id ?? '0') ?? 0,
                      isDeleted,
                      status: statusController.text,
                      int.tryParse(orderLevelController.text) ?? 0,
                      _selectedUserId ?? '',
                      true,
                      rowVersion: '',
                      signatoryLabel: defaultSignatoryController.text,
                    );
                    addOrUpdateSignatory(pgsSignatoryTemplate);
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
        title: Text('PGS Signatory Template Information'),
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
                      labelText: 'Search PGS Signatory',
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
                          child: Text('ID', style: TextStyle(color: grey)),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Signatory Name',
                            style: TextStyle(color: grey),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Signatory Label',
                            style: TextStyle(color: grey),
                          ),
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
                                .map((index, pgsSignatory) {
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
                                                getUserName(
                                                  pgsSignatory['defaultSignatoryId'] ??
                                                      '',
                                                ),
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
                                                pgsSignatory['signatoryLabel'],
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
                                                              pgsSignatory['id']
                                                                  .toString(),
                                                          defaultSignatoryId:
                                                              pgsSignatory['defaultSignatoryId'],
                                                          signatoryLabel:
                                                              pgsSignatory['signatoryLabel'],
                                                          status:
                                                              pgsSignatory['status'],
                                                          orderLevel:
                                                              pgsSignatory['orderLevel'],
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
                                                          pgsSignatory['id']
                                                              .toString(),
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
                    onPageChanged: (page) => fetchSignatory(page: page),
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
