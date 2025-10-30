// ignore_for_file: use_build_context_synchronously

import 'package:data_table_2/data_table_2.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:imis/auditor/services/auditor_service.dart';
import 'package:imis/common_services/common_service.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/auditor/models/auditor.dart';
import 'package:imis/user/models/user.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/filter_search_result_util.dart';
import 'package:imis/utils/pagination_util.dart';
import 'package:imis/widgets/pagination_controls.dart';
import 'package:motion_toast/motion_toast.dart';
import '../../widgets/custom_toggle.dart';

class AuditorPage extends StatefulWidget {
  const AuditorPage({super.key});

  @override
  AuditorMainPageState createState() => AuditorMainPageState();
}

class AuditorMainPageState extends State<AuditorPage> {
  final _auditorService = AuditorService(Dio());
  final _paginationUtils = PaginationUtil(Dio());
  late FilterSearchResultUtil<Auditor> auditorSearchUtil;
  final _formKey = GlobalKey<FormState>();
  final _commonService = CommonService(Dio());

  List<Auditor> auditorList = [];
  List<Auditor> filteredList = [];
  TextEditingController searchController = TextEditingController();
  final FocusNode isSearchfocus = FocusNode();

  List<User> userList = [];
  String? _selectedUserId;

  int _currentPage = 1;
  final int _pageSize = 15;
  int _totalCount = 0;
  bool _isLoading = false;

  final dio = Dio();

  Future<void> fetchAuditors({int page = 1, String? searchQuery}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final pageList = await _auditorService.getAuditor(
        page: page,
        pageSize: _pageSize,
        searchQuery: searchQuery,
      );

      if (mounted) {
        setState(() {
          _currentPage = pageList.page;
          _totalCount = pageList.totalCount;
          auditorList = pageList.items;
          filteredList = List.from(auditorList);
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

  @override
  void initState() {
    super.initState();
    fetchAuditors();
    auditorSearchUtil = FilterSearchResultUtil<Auditor>(
      paginationUtils: _paginationUtils,
      endpoint: ApiEndpoint().auditor,
      pageSize: _pageSize,
      fromJson: (json) => Auditor.fromJson(json),
    );
    isSearchfocus.addListener(() {
      setState(() {});
    });

    () async {
      final users = await _commonService.fetchUsers();

      if (!mounted) return;

      setState(() {
        userList = users;
        _selectedUserId = users.isNotEmpty ? users[0].id : null;
      });
    }();
  }

  @override
  void dispose() {
    isSearchfocus.dispose();
    super.dispose();
  }

  Future<void> filterSearchResults(String query) async {
    final results = await auditorSearchUtil.filter(query, (auditor, search) {
      final user = userList.firstWhere(
        (u) => u.id.toString() == auditor.userId.toString(),
        orElse: () => User(id: '', fullName: 'Unknown', position: ''),
      );

      return (auditor.name ?? '').toLowerCase().contains(
            search.toLowerCase(),
          ) ||
          (user.fullName).toLowerCase().contains(search.toLowerCase());
    });

    setState(() {
      filteredList = results;
    });
  }

  void showDeleteDialog(String id) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text(
            "Are you sure you want to delete this Auditor? This action cannot be undone.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: TextStyle(color: primaryTextColor)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                try {
                  await _auditorService.deleteAuditor(id);
                  await fetchAuditors();
                  MotionToast.success(
                    toastAlignment: Alignment.topCenter,
                    description: Text('Auditor deleted successfully'),
                  ).show(context);
                } catch (e) {
                  MotionToast.error(description: Text('Failed to Delete Role'));
                }
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

  void showFormDialog({
    String? id,
    bool isDeleted = false,
    String rowVersion = "",
    String? name,
    bool isActive = false,
    String? selectedUserId,
  }) {
    TextEditingController auditorController = TextEditingController(text: name);
    _selectedUserId = selectedUserId;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: mainBgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              titlePadding: EdgeInsets.zero,
              title: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: primaryLightColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Text(
                  id == null ? 'Create Auditor' : 'Manage Auditor',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),

              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 450,
                      child: TextFormField(
                        controller: auditorController,
                        decoration: InputDecoration(
                          labelText: 'Auditor Name',
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
                    gap14px,
                    SizedBox(
                      width: 450,
                      child: DropdownSearch<User?>(
                        popupProps: PopupProps.menu(
                          showSearchBox: true,
                          searchFieldProps: TextFieldProps(
                            decoration: InputDecoration(
                              hintText: 'Search User Name...',
                              filled: true,
                              fillColor: mainBgColor,
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: primaryColor),
                              ),
                            ),
                          ),
                          itemBuilder:
                              (context, user, isSelected) => ListTile(
                                tileColor: mainBgColor,
                                title: Text(user?.fullName ?? ''),
                              ),
                        ),
                        items: userList,
                        itemAsString: (u) => u?.fullName ?? '',
                        selectedItem: userList.cast<User?>().firstWhere(
                          (u) => u?.id == _selectedUserId,
                          orElse: () => null,
                        ),
                        onChanged:
                            (value) =>
                                setState(() => _selectedUserId = value?.id),
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a user';
                          }
                          return null;
                        },
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: 'Assign User',
                            filled: true,
                            fillColor: mainBgColor,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: primaryColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                    gap14px,

                    CustomToggle(
                      label: "Active",
                      value: isActive,
                      activeColor: primaryColor,
                      inactiveColor: Colors.grey,
                      onChanged: (val) {
                        setState(() {
                          isActive = val;
                        });
                      },
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
                                child: Text(
                                  "No",
                                  style: TextStyle(color: primaryColor),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    Navigator.pop(context, true);
                                  }
                                },
                                child: Text(
                                  "Yes",
                                  style: TextStyle(color: primaryColor),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                      if (confirmAction == true) {
                        final auditor = Auditor(
                          id: int.tryParse(id ?? '0') ?? 0,
                          name: auditorController.text,
                          isDeleted: isDeleted,
                          rowVersion: rowVersion,
                          isActive: isActive,
                          userId: _selectedUserId,
                        );
                        await _auditorService.addOrUpdateAuditor(auditor);
                        setState(() {
                          fetchAuditors();
                        });
                        MotionToast.success(
                          toastAlignment: Alignment.topCenter,
                          description: Text('Saved successfully'),
                        ).show(context);
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isMinimized = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      backgroundColor: mainBgColor,
      appBar: AppBar(
        title: const Text('Auditor Information'),
        backgroundColor: mainBgColor,
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = constraints.maxWidth < 600;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                          labelText: 'Search...',
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
                      ElevatedButton.icon(
                        onPressed: () => showFormDialog(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: const Text(
                          'Add New',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: DataTable2(
                    columnSpacing: isMobile ? 16 : 40,
                    headingRowColor: WidgetStatePropertyAll(secondaryColor),
                    dataRowColor: WidgetStatePropertyAll(mainBgColor),
                    headingTextStyle: const TextStyle(color: grey),
                    horizontalMargin: 12,
                    minWidth: constraints.maxWidth,
                    fixedTopRows: 1,
                    border: TableBorder(
                      horizontalInside: BorderSide(color: Colors.grey.shade100),
                    ),
                    columns: const [
                      DataColumn2(label: Text('#'), fixedWidth: 40),
                      DataColumn2(label: Text('Name'), size: ColumnSize.L),
                      DataColumn(label: Text('Description')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows:
                        filteredList.asMap().entries.map((entry) {
                          int index = entry.key;
                          var auditor = entry.value;
                          int itemNumber =
                              ((_currentPage - 1) * _pageSize) + index + 1;
                          final matchUserName = userList.firstWhere(
                            (user) => user.id == auditor.userId,
                            orElse:
                                () => User(
                                  id: 'unknown',
                                  fullName: 'Unknown',
                                  position: 'position',
                                ),
                          );
                          final userName = matchUserName.fullName;
                          return DataRow(
                            cells: [
                              DataCell(Text(itemNumber.toString())),
                              DataCell(Text(auditor.name ?? '')),
                              DataCell(Text(userName)),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        showFormDialog(
                                          id: auditor.id.toString(),
                                          name: auditor.name ?? '',
                                          selectedUserId: auditor.userId ?? '',
                                          isActive: auditor.isActive,
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: primaryColor,
                                      ),
                                      onPressed: () {
                                        showDeleteDialog(auditor.id.toString());
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
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
                        onPageChanged: (page) => fetchAuditors(page: page),
                      ),
                      Container(width: 60),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
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
