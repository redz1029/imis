// ignore_for_file: use_build_context_synchronously

import 'package:data_table_2/data_table_2.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/office/models/office.dart';
import 'package:imis/office/services/office_service.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/filter_search_result_util.dart';
import 'package:imis/utils/pagination_util.dart';
import 'package:imis/widgets/pagination_controls.dart';
import 'package:motion_toast/motion_toast.dart';

class OfficePage extends StatefulWidget {
  const OfficePage({super.key});

  @override
  OfficePageState createState() => OfficePageState();
}

class OfficePageState extends State<OfficePage> {
  final _officeService = OfficeService(Dio());
  final _paginationUtils = PaginationUtil(Dio());
  late FilterSearchResultUtil<Office> officeSearchUtil;
  final _formKey = GlobalKey<FormState>();

  List<Office> officeList = [];
  List<Office> filteredList = [];
  TextEditingController searchController = TextEditingController();
  final FocusNode isSearchfocus = FocusNode();

  List<Map<String, dynamic>> filteredListOfficeType = [];
  List<Map<String, dynamic>> officeTypeList = [];
  String? _selectedOfficeType;

  List<Map<String, dynamic>> filteredListParentOffice = [];
  List<Map<String, dynamic>> parentOfficeList = [];
  String? _selectedParentOffice;

  int _currentPage = 1;
  final int _pageSize = 15;
  int _totalCount = 0;
  bool _isLoading = false;

  final dio = Dio();

  Future<void> fetchOffices({int page = 1, String? searchQuery}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final pageList = await _officeService.getOffice(
        page: page,
        pageSize: _pageSize,
        searchQuery: searchQuery,
      );

      if (mounted) {
        setState(() {
          _currentPage = pageList.page;
          _totalCount = pageList.totalCount;
          officeList = pageList.items;
          filteredList = List.from(officeList);
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
    fetchOffices();
    officeSearchUtil = FilterSearchResultUtil<Office>(
      paginationUtils: _paginationUtils,
      endpoint: ApiEndpoint().office,
      pageSize: _pageSize,
      fromJson: (json) => Office.fromJson(json),
    );
    isSearchfocus.addListener(() {
      setState(() {});
    });
    _officeService
        .getOfficeType()
        .then((data) {
          if (mounted) {
            setState(() {
              officeTypeList =
                  data.map((officeType) => officeType.toJson()).toList();
              filteredListOfficeType = List.from(officeTypeList);
              if (filteredListOfficeType.isNotEmpty) {
                _selectedOfficeType =
                    filteredListOfficeType[0]['id'].toString();
              }
            });
          }
        })
        .catchError((error) {
          debugPrint("Failed to fetch data");
        });

    if (filteredListOfficeType.isNotEmpty) {
      _selectedOfficeType = filteredListOfficeType[0]['id'].toString();
    }

    _officeService
        .getParentOffice()
        .then((data) {
          if (mounted) {
            setState(() {
              parentOfficeList = data.map((office) => office.toJson()).toList();
              filteredListParentOffice = [
                {'id': 0, 'name': 'None'},
                ...parentOfficeList,
              ];
              if (filteredListParentOffice.isNotEmpty) {
                _selectedParentOffice =
                    filteredListParentOffice[0]['id'].toString();
              }
            });
          }
        })
        .catchError((error) {
          debugPrint("Failed to fetch data");
        });
  }

  Future<void> filterSearchResults(String query) async {
    final results = await officeSearchUtil.filter(
      query,
      (office, search) =>
          (office.name).toLowerCase().contains(search.toLowerCase()),
    );

    setState(() {
      filteredList = results;
    });
  }

  @override
  void dispose() {
    isSearchfocus.dispose();
    super.dispose();
  }

  void showFormDialog({
    String? id,
    String? name,
    bool isActive = false,
    bool isDeleted = false,
    bool isRowversion = false,
    String? selectedOfficeType,
    String? selectedParentOffice,
  }) async {
    await _officeService.getParentOffice();

    TextEditingController officeController = TextEditingController(text: name);
    _selectedOfficeType = selectedOfficeType;
    _selectedParentOffice = selectedParentOffice;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: mainBgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          titlePadding: EdgeInsets.zero,
          title: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              color: primaryLightColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Text(
              id == null ? 'Create Office' : 'Edit Office',
              textAlign: TextAlign.center,
              style: const TextStyle(
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
                  width: 480,
                  height: 65,
                  child: TextFormField(
                    controller: officeController,
                    decoration: InputDecoration(
                      labelText: 'Office Name',
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

                SizedBox(
                  width: 480,
                  child: DropdownButtonFormField<String>(
                    value: _selectedOfficeType,
                    decoration: InputDecoration(
                      labelText: 'Office Type',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      floatingLabelStyle: TextStyle(color: primaryColor),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor),
                      ),
                    ),

                    items:
                        filteredListOfficeType.map((officeTypeData) {
                          return DropdownMenuItem<String>(
                            value: officeTypeData['id'].toString(),
                            child: Text(officeTypeData['name']),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedOfficeType = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select an office';
                      }
                      return null;
                    },
                  ),
                ),
                gap16px,
                SizedBox(
                  width: 480,
                  child: DropdownSearch<Map<String, dynamic>>(
                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      searchFieldProps: TextFieldProps(
                        decoration: InputDecoration(
                          hintText: 'Search Office Name...',
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
                          (context, office, isSelected) => ListTile(
                            tileColor: mainBgColor,
                            title: Text(office['name']),
                          ),
                    ),
                    items: filteredListParentOffice,
                    itemAsString: (office) => office['name'],
                    selectedItem:
                        _selectedParentOffice == null
                            ? null
                            : filteredListParentOffice.firstWhere(
                              (office) =>
                                  office['id'].toString() ==
                                  _selectedParentOffice,
                              orElse: () => <String, dynamic>{},
                            ),

                    onChanged: (value) {
                      setState(() {
                        _selectedParentOffice = value?['id'].toString();
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select parent office';
                      }
                      return null;
                    },
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: 'Select Parent Office',
                        filled: true,
                        fillColor: mainBgColor,
                        floatingLabelStyle: TextStyle(color: primaryColor),
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
                    final office = Office(
                      id: int.tryParse(id ?? '0') ?? 0,
                      name: officeController.text,
                      officeTypeId:
                          int.tryParse(_selectedOfficeType ?? '0') ?? 0,
                      parentOfficeId:
                          _selectedParentOffice == '0'
                              ? null
                              : int.tryParse(_selectedParentOffice ?? '0'),
                      isDeleted: false,
                      isActive: true,
                    );
                    await _officeService.createOrUpdateOffice(office);
                    setState(() {
                      fetchOffices();
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
  }

  @override
  Widget build(BuildContext context) {
    bool isMinimized = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      backgroundColor: mainBgColor,
      appBar: AppBar(
        title: const Text('Office Information'),
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
                      DataColumn2(label: Text('Office'), size: ColumnSize.L),
                      DataColumn(label: Text('Office Type')),
                      DataColumn(label: Text('Parent Office')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows:
                        filteredList.asMap().entries.map((entry) {
                          int index = entry.key;
                          var office = entry.value;
                          int itemNumber =
                              ((_currentPage - 1) * _pageSize) + index + 1;

                          return DataRow(
                            cells: [
                              DataCell(Text(itemNumber.toString())),
                              DataCell(Text(office.name)),
                              DataCell(
                                Text(
                                  _officeService.getOfficeTypeName(
                                    office.officeTypeId ?? 0,
                                    officeTypeList,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  _officeService.getParentOfficeName(
                                    office.parentOfficeId,
                                    parentOfficeList,
                                  ),
                                ),
                              ),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed:
                                          () => showFormDialog(
                                            id: office.id.toString(),
                                            name: office.name,
                                            selectedOfficeType:
                                                office.officeTypeId.toString(),

                                            selectedParentOffice:
                                                office.parentOfficeId
                                                    ?.toString() ??
                                                '0',
                                          ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: primaryColor,
                                      ),
                                      onPressed: () {
                                        showDeleteDialog(office.id.toString());
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
                        onPageChanged: (page) => fetchOffices(page: page),
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

  void showDeleteDialog(String id) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text(
            "Are you sure you want to delete this Office? This action cannot be undone.",
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
                  await _officeService.deleteOffice(id);
                  await fetchOffices();
                  MotionToast.success(
                    toastAlignment: Alignment.topCenter,
                    description: Text('Officedeleted successfully'),
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
}
