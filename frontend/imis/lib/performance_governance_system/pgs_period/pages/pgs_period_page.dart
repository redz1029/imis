import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/performance_governance_system/pgs_period/models/pgs_period.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/date_time_converter.dart';
import 'package:imis/utils/filter_search_result_util.dart';
import 'package:imis/utils/pagination_util.dart';
import 'package:imis/utils/token_expiration_handler.dart';
import 'package:intl/intl.dart';

import '../../../utils/http_util.dart';

class PgsPeriodPage extends StatefulWidget {
  const PgsPeriodPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PgsPeriodPageState createState() => _PgsPeriodPageState();
}

class _PgsPeriodPageState extends State<PgsPeriodPage> {
  final _paginationUtils = PaginationUtil(Dio());
  late FilterSearchResultUtil<PgsPeriod> pgsPeriodSearchUtil;
  final _formKey = GlobalKey<FormState>();
  List<PgsPeriod> pgsPeriodList = [];
  List<PgsPeriod> filteredList = [];
  TextEditingController searchController = TextEditingController();
  final FocusNode isSearchfocus = FocusNode();

  int _currentPage = 1;
  final int _pageSize = 15;
  int _totalCount = 0;
  bool _isLoading = false;

  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  final dio = Dio();

  @override
  void initState() {
    super.initState();
    fetchPGSPeriods();
    pgsPeriodSearchUtil = FilterSearchResultUtil<PgsPeriod>(
      paginationUtils: _paginationUtils,
      endpoint: ApiEndpoint().pgsperiod,
      pageSize: _pageSize,
      fromJson: (json) => PgsPeriod.fromJson(json),
    );

    isSearchfocus.addListener(() {
      setState(() {});
    });
    TokenExpirationHandler(context).checkTokenExpiration();
  }

  //fetch PGS PERIOD list
  Future<void> fetchPGSPeriods({int page = 1, String? searchQuery}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final pageList = await _paginationUtils.fetchPaginatedData<PgsPeriod>(
        endpoint: ApiEndpoint().pgsperiod,
        page: page,
        pageSize: _pageSize,
        searchQuery: searchQuery,
        fromJson: (json) => PgsPeriod.fromJson(json),
      );

      if (mounted) {
        setState(() {
          _currentPage = pageList.page;
          _totalCount = pageList.totalCount;
          pgsPeriodList = pageList.items;
          filteredList = List.from(pgsPeriodList);
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

  Future<void> addOrUpdatePGSPeriod(PgsPeriod period) async {
    var url = ApiEndpoint().pgsperiod;
    try {
      final response = await AuthenticatedRequest.post(
        dio,
        url,
        data: period.toJson(),
      );
      if (response.statusCode == 201) {
        await fetchPGSPeriods();
        setState(() {
          fetchPGSPeriods();
        });
      }
    } catch (e) {
      debugPrint("Error adding/updating pgsPeriod: $e");
    }
  }

  Future<void> deletePGSPeriod(String kraId) async {
    var url = ApiEndpoint().pgsperiod;
    try {
      final response = await AuthenticatedRequest.delete(dio, url);

      if (response.statusCode == 200) {
        await fetchPGSPeriods();
      }
    } catch (e) {
      debugPrint("Error deleting KRA: $e");
    }
  }

  @override
  void dispose() {
    isSearchfocus.dispose();
    super.dispose();
  }

  Future<void> filterByDateRange() async {
    try {
      if (selectedStartDate == null && selectedEndDate == null) {
        setState(() {
          filteredList = List<PgsPeriod>.from(pgsPeriodList);
        });
        return;
      }

      setState(() {
        filteredList =
            pgsPeriodList.where((period) {
              final periodStart = period.startDate;
              final periodEnd = period.endDate;

              if (selectedStartDate == null && selectedEndDate == null) {
                return true;
              }

              if (selectedStartDate != null && selectedEndDate == null) {
                return (periodStart.isAfter(selectedStartDate!) ||
                    periodStart.isAtSameMomentAs(selectedStartDate!));
              }

              if (selectedStartDate == null && selectedEndDate != null) {
                return (periodEnd.isBefore(selectedEndDate!) ||
                    periodEnd.isAtSameMomentAs(selectedEndDate!));
              }

              return (periodStart.isAfter(selectedStartDate!) ||
                      periodStart.isAtSameMomentAs(selectedStartDate!)) &&
                  (periodEnd.isBefore(selectedEndDate!) ||
                      periodEnd.isAtSameMomentAs(selectedEndDate!));
            }).toList();
      });
    } catch (e) {
      debugPrint('Error filtering by date range: $e');
      setState(() {
        filteredList = List<PgsPeriod>.from(pgsPeriodList);
      });
    }
  }

  void showDeleteDialog(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text(
            "Are you sure you want to delete this PGS Period? This action cannot be undone.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: TextStyle(color: primaryTextColor)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await deletePGSPeriod(id);
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
    bool? isDeleted,
    String? startDate,
    String? endDate,
    String? remarkrs,
    String? rowVersion,
  }) {
    TextEditingController startDateController = TextEditingController(
      text: startDate,
    );
    TextEditingController endDateController = TextEditingController(
      text: endDate,
    );
    TextEditingController remarksController = TextEditingController(
      text: remarkrs,
    );

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
            id == null ? 'Add PGS Period' : 'Edit PGS Period',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 350,
                  height: 60,
                  child: TextFormField(
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
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please select a date';
                      }
                      return null;
                    },
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
                                  foregroundColor: primaryColor,
                                ),
                              ),
                            ),
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
                gap2,
                SizedBox(
                  width: 350,
                  height: 60,
                  child: TextFormField(
                    controller: endDateController,
                    decoration: InputDecoration(
                      focusColor: primaryColor,
                      labelText: 'End Date',
                      floatingLabelStyle: TextStyle(color: primaryColor),
                      border: OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please select a date';
                      }
                      return null;
                    },
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
                                  foregroundColor: primaryColor,
                                ),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );

                      if (picked != null) {
                        endDateController.text =
                            picked.toLocal().toString().split(' ')[0];
                      }
                    },
                  ),
                ),

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
                    final pgs = PgsPeriod(
                      int.tryParse(id ?? '0') ?? 0,
                      false,
                      DateTime.parse(startDateController.text),
                      DateTime.parse(endDateController.text),
                      remarksController.text,
                    );
                    addOrUpdatePGSPeriod(pgs);

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
      appBar: AppBar(backgroundColor: mainBgColor, title: Text('PGS Periods')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 350,
                      height: 30,
                      child: TextFormField(
                        controller: startDateController,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          labelText: 'Search Start Date',
                          labelStyle: TextStyle(color: grey, fontSize: 14),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: lightGrey),
                          ),
                          filled: true,
                          fillColor: secondaryColor,
                          suffixIcon:
                              startDateController.text.isNotEmpty
                                  ? IconButton(
                                    icon: Icon(Icons.close),
                                    onPressed: () {
                                      setState(() {
                                        startDateController.clear();
                                        selectedStartDate = null;
                                        filterByDateRange();
                                      });
                                      FocusScope.of(context).unfocus();
                                    },
                                  )
                                  : Icon(
                                    Icons.calendar_today,
                                    color:
                                        isSearchfocus.hasFocus
                                            ? primaryColor
                                            : grey,
                                  ),
                        ),
                        readOnly: true,
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: selectedStartDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (picked != null) {
                            setState(() {
                              selectedStartDate = picked;
                              startDateController.text = DateFormat(
                                'yyyy-MM-dd',
                              ).format(picked);
                              filterByDateRange();
                            });
                          }
                        },
                      ),
                    ),

                    SizedBox(width: 15),
                    SizedBox(
                      width: 350,
                      height: 30,
                      child: TextFormField(
                        controller: endDateController,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          labelText: 'Search End Date',
                          labelStyle: TextStyle(color: grey, fontSize: 14),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: lightGrey),
                          ),
                          filled: true,
                          fillColor: secondaryColor,
                          suffixIcon:
                              endDateController.text.isNotEmpty
                                  ? IconButton(
                                    icon: Icon(Icons.close),
                                    onPressed: () {
                                      setState(() {
                                        endDateController.clear();
                                        selectedEndDate = null;
                                        filterByDateRange();
                                      });
                                      FocusScope.of(context).unfocus();
                                    },
                                  )
                                  : Icon(
                                    Icons.calendar_today,
                                    color:
                                        isSearchfocus.hasFocus
                                            ? primaryColor
                                            : grey,
                                  ),
                        ),
                        readOnly: true,
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: selectedEndDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (picked != null) {
                            setState(() {
                              selectedEndDate = picked;
                              endDateController.text = DateFormat(
                                'yyyy-MM-dd',
                              ).format(picked);
                              filterByDateRange();
                            });
                          }
                        },
                      ),
                    ),
                  ],
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
                          child: Text(
                            'Start Date',
                            style: TextStyle(color: grey),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            'End Date',
                            style: TextStyle(color: grey),
                          ),
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
                                .map((index, period) {
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
                                                DateTimeConverter().toJson(
                                                  period.startDate,
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
                                                DateTimeConverter().toJson(
                                                  period.endDate,
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
                                                period.remarks.toString(),

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
                                                              period.id
                                                                  .toString(),
                                                          startDate:
                                                              DateTimeConverter()
                                                                  .toJson(
                                                                    period
                                                                        .startDate,
                                                                  ),
                                                          endDate:
                                                              DateTimeConverter()
                                                                  .toJson(
                                                                    period
                                                                        .endDate,
                                                                  ),
                                                          remarkrs:
                                                              period.remarks
                                                                  .toString(),
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
                                                          period.id.toString(),
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
                    onPageChanged: (page) => fetchPGSPeriods(page: page),
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
}
