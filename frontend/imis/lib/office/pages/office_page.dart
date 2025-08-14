import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/office/models/office.dart';
import 'package:imis/office/models/office_type.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/filter_search_result_util.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/utils/pagination_util.dart';

class OfficePage extends StatefulWidget {
  const OfficePage({super.key});

  @override
  OfficePageState createState() => OfficePageState();
}

class OfficePageState extends State<OfficePage> {
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
      final pageList = await _paginationUtils.fetchPaginatedData<Office>(
        endpoint: ApiEndpoint().office,
        page: page,
        pageSize: _pageSize,
        searchQuery: searchQuery,
        fromJson: (json) => Office.fromJson(json),
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

  // Add or update office

  Future<void> addOrUpdateOffice(Office office) async {
    var url = ApiEndpoint().office;

    try {
      final Map<String, dynamic> requestData = office.toJson();
      final response = await AuthenticatedRequest.post(
        dio,
        url,
        data: requestData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchOffices();
      } else {
        debugPrint("Failed to add/update office.");
      }
    } catch (e) {
      debugPrint("Error adding/updating office: $e");
    }
  }

  Future<void> deleteOffice(String kraId) async {
    var url = ApiEndpoint().keyresult;
    try {
      final response = await AuthenticatedRequest.delete(dio, url);

      if (response.statusCode == 200) {
        await fetchOffices();
      }
    } catch (e) {
      debugPrint("Error deleting Office: $e");
    }
  }

  Future<void> fetchOfficeType() async {
    var url = ApiEndpoint().officetype;

    try {
      final response = await AuthenticatedRequest.get(dio, url);

      if (response.statusCode == 200 && response.data is List) {
        List<OfficeType> data =
            (response.data as List)
                .map((officeType) => OfficeType.fromJson(officeType))
                .toList();

        if (mounted) {
          setState(() {
            officeTypeList =
                data.map((officeType) => officeType.toJson()).toList();
            filteredListOfficeType = List.from(officeTypeList);

            if (_selectedOfficeType == null &&
                filteredListOfficeType.isNotEmpty) {
              _selectedOfficeType = filteredListOfficeType[0]['id'].toString();
            }
          });
        }
      } else {
        debugPrint("Unexpected response format: ${response.data.runtimeType}");
      }
    } on DioException catch (e) {
      debugPrint("Dio error: ${e.response?.data ?? e.message}");
    } catch (e) {
      debugPrint("Unexpected error: $e");
    }
  }

  Future<void> fetchParentOffice() async {
    var url = ApiEndpoint().office;

    try {
      final response = await AuthenticatedRequest.get(dio, url);

      if (response.statusCode == 200 && response.data is List) {
        List<Office> data =
            (response.data as List)
                .map((parentOffice) => Office.fromJson(parentOffice))
                .toList();

        if (mounted) {
          setState(() {
            parentOfficeList =
                data.map((parentOffice) => parentOffice.toJson()).toList();

            filteredListParentOffice = [
              {'id': 0, 'name': 'None'},
              ...parentOfficeList,
            ];

            _selectedParentOffice ??= '0';
          });
        }
      } else {
        debugPrint("Unexpected response format: ${response.data.runtimeType}");
      }
    } on DioException {
      debugPrint("Dio error");
    } catch (e) {
      debugPrint("Unexpected error: $e");
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
    fetchOfficeType();
    if (filteredListOfficeType.isNotEmpty) {
      _selectedOfficeType = filteredListOfficeType[0]['id'].toString();
    }
    fetchParentOffice();

    if (filteredListParentOffice.isNotEmpty) {
      _selectedParentOffice = filteredListParentOffice[0]['id'].toString();
    }

    if (filteredListParentOffice.isNotEmpty) {
      _selectedParentOffice = filteredListParentOffice[0]['id'].toString();
    }
  }

  @override
  void dispose() {
    isSearchfocus.dispose();
    super.dispose();
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

  String getOfficeTypeName(int id) {
    final officeType = officeTypeList.firstWhere(
      (type) => type['id'] == id,
      orElse: () => {'name': 'Unknown'},
    );
    return officeType['name'];
  }

  String getParentOfficeName(int? id) {
    if (id == null || id == 0) return 'None';

    final parentOffice = parentOfficeList.firstWhere(
      (office) => office['id'] == id,
      orElse: () => {'name': 'Unknown'},
    );
    return parentOffice['name'];
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
    await fetchParentOffice();

    TextEditingController officeController = TextEditingController(text: name);
    _selectedOfficeType = selectedOfficeType;
    _selectedParentOffice = selectedParentOffice;

    showDialog(
      // ignore: use_build_context_synchronously
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
                gap,
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
                    addOrUpdateOffice(office);
                    await fetchParentOffice();
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
        title: Text('Office Information'),
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
                      labelText: 'Search Office',
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

                    onPressed: () async {
                      await fetchOffices();

                      showFormDialog();
                    },
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
                          child: Text('Office', style: TextStyle(color: grey)),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Office Type',
                            style: TextStyle(color: grey),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Parent Office',
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
                                .map((index, office) {
                                  int itemNumber =
                                      ((_currentPage - 1) * _pageSize) +
                                      index +
                                      1;
                                  return MapEntry(
                                    index,
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 1,
                                        horizontal: 10,
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
                                                office.name,
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
                                                getOfficeTypeName(
                                                  office.officeTypeId ?? 0,
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
                                                getParentOfficeName(
                                                  office.parentOfficeId,
                                                ),
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
                                                              office.id
                                                                  .toString(),
                                                          name: office.name,
                                                          selectedOfficeType:
                                                              office
                                                                  .officeTypeId
                                                                  .toString(),

                                                          selectedParentOffice:
                                                              office
                                                                  .parentOfficeId
                                                                  ?.toString() ??
                                                              '0',
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
                                                          office.id.toString(),
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
                    onPageChanged: (page) => fetchOffices(page: page),
                  ),
                  Container(width: 60),
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

  void showDeleteDialog(String id) {
    showDialog(
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
                await deleteOffice(id);
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
