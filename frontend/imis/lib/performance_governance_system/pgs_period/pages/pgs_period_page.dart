// ignore_for_file: use_build_context_synchronously

import 'package:data_table_2/data_table_2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/performance_governance_system/pgs_period/models/pgs_period.dart';
import 'package:imis/performance_governance_system/pgs_period/services/pgs_period_service.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/date_time_converter.dart';
import 'package:imis/utils/filter_search_result_util.dart';
import 'package:imis/utils/pagination_util.dart';
import 'package:imis/widgets/pagination_controls.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';

class PgsPeriodPage extends StatefulWidget {
  const PgsPeriodPage({super.key});

  @override
  PgsPeriodPageState createState() => PgsPeriodPageState();
}

class PgsPeriodPageState extends State<PgsPeriodPage> {
  final _paginationUtils = PaginationUtil(Dio());
  final _pgsPeriodService = PgsPeriodService(Dio());
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
  }

  Future<void> fetchPGSPeriods({int page = 1, String? searchQuery}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final pageList = await _pgsPeriodService.getPgsPeriod(
        page: page,
        pageSize: _pageSize,
        searchQuery: searchQuery,
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
      barrierDismissible: false,
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
                try {
                  await _pgsPeriodService.deletePeriod(id);
                  await fetchPGSPeriods();
                  MotionToast.success(
                    toastAlignment: Alignment.topCenter,
                    description: Text('Period deleted successfully'),
                  ).show(context);
                } catch (e) {
                  MotionToast.error(
                    description: Text('Failed to Delete Period'),
                  );
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
              id == null ? 'Create  PGS Period' : 'Edit PGS Period',
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
                gap4px,
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
                    final period = PgsPeriod(
                      int.tryParse(id ?? '0') ?? 0,
                      false,
                      DateTime.parse(startDateController.text),
                      DateTime.parse(endDateController.text),
                      remarksController.text,
                    );
                    await _pgsPeriodService.createOrUpdatePgsPeriod(period);
                    setState(() {
                      fetchPGSPeriods();
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
        title: const Text('PGS Period Information'),
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
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 300,
                          height: 30,
                          child: TextFormField(
                            controller: startDateController,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 12,
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
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
                                initialDate:
                                    selectedStartDate ?? DateTime.now(),
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
                          width: 300,
                          height: 30,
                          child: TextFormField(
                            controller: endDateController,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 12,
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
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
                  child:
                      isMobile
                          ? ListView.separated(
                            itemCount: filteredList.length,
                            separatorBuilder: (context, index) => Divider(),
                            itemBuilder: (context, index) {
                              var period = filteredList[index];
                              int itemNumber =
                                  ((_currentPage - 1) * _pageSize) + index + 1;

                              return Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "$itemNumber",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                        PopupMenuButton<String>(
                                          color: mainBgColor,
                                          tooltip: 'Show actions',
                                          icon: const Icon(
                                            Icons.more_vert_outlined,
                                          ),
                                          onSelected: (value) {
                                            if (value == 'edit') {
                                              showFormDialog(
                                                id: period.id.toString(),
                                                startDate: DateTimeConverter()
                                                    .toJson(period.startDate),
                                                endDate: DateTimeConverter()
                                                    .toJson(period.endDate),
                                                remarkrs:
                                                    period.remarks.toString(),
                                              );
                                            } else if (value == 'delete') {
                                              showDeleteDialog(
                                                period.id.toString(),
                                              );
                                            }
                                          },
                                          itemBuilder:
                                              (context) => [
                                                PopupMenuItem(
                                                  value: 'edit',
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.edit,
                                                        size: 18,
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text('Edit'),
                                                    ],
                                                  ),
                                                ),
                                                const PopupMenuItem(
                                                  value: 'delete',
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.delete,
                                                        size: 18,
                                                        color: primaryColor,
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text('Delete'),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Text(
                                          "Start Date: ",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            DateTimeConverter().toJson(
                                              period.startDate,
                                            ),

                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    gap4px,
                                    Row(
                                      children: [
                                        Text(
                                          "End Date: ",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            DateTimeConverter().toJson(
                                              period.endDate,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    gap4px,
                                    Row(
                                      children: [
                                        Text(
                                          "Remarks ",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        gap4px,
                                        Expanded(
                                          child: Text(period.remarks ?? ''),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                          : DataTable2(
                            columnSpacing: isMobile ? 16 : 40,
                            headingRowColor: WidgetStatePropertyAll(
                              secondaryColor,
                            ),
                            dataRowColor: WidgetStatePropertyAll(mainBgColor),
                            headingTextStyle: const TextStyle(color: grey),
                            horizontalMargin: 12,
                            minWidth: constraints.maxWidth,
                            fixedTopRows: 1,
                            border: TableBorder(
                              horizontalInside: BorderSide(
                                color: Colors.grey.shade100,
                              ),
                            ),
                            columns: const [
                              DataColumn2(label: Text('#'), fixedWidth: 40),
                              DataColumn2(
                                label: Text('Start Date'),
                                size: ColumnSize.L,
                              ),
                              DataColumn(label: Text('End Dare')),
                              DataColumn(label: Text('Remarks')),
                              DataColumn(label: Text('Actions')),
                            ],
                            rows:
                                filteredList.asMap().entries.map((entry) {
                                  int index = entry.key;
                                  var period = entry.value;
                                  int itemNumber =
                                      ((_currentPage - 1) * _pageSize) +
                                      index +
                                      1;

                                  return DataRow(
                                    cells: [
                                      DataCell(Text(itemNumber.toString())),
                                      DataCell(
                                        Text(
                                          DateTimeConverter().toJson(
                                            period.startDate,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          DateTimeConverter().toJson(
                                            period.endDate,
                                          ),
                                        ),
                                      ),
                                      DataCell(Text(period.remarks ?? '')),
                                      DataCell(
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.edit),
                                              onPressed: () {
                                                showFormDialog(
                                                  id: period.id.toString(),
                                                  startDate: DateTimeConverter()
                                                      .toJson(period.startDate),
                                                  endDate: DateTimeConverter()
                                                      .toJson(period.endDate),
                                                  remarkrs:
                                                      period.remarks.toString(),
                                                );
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.delete,
                                                color: primaryColor,
                                              ),
                                              onPressed: () {
                                                showDeleteDialog(
                                                  period.id.toString(),
                                                );
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
                        onPageChanged: (page) => fetchPGSPeriods(page: page),
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
