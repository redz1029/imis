// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/performance_validation_tool/performance_validation_tool_period/models/performance_validation_tool_period.dart';
import 'package:imis/performance_validation_tool/performance_validation_tool_period/services/performance_validation_tool_service.dart';
import 'package:imis/utils/date_time_converter.dart';
import 'package:imis/widgets/common/build_page_header.dart';
import 'package:imis/widgets/common/pagination_controls.dart';
import 'package:motion_toast/motion_toast.dart';

class PerformanceValidationToolPeriodPage extends StatefulWidget {
  const PerformanceValidationToolPeriodPage({super.key});

  @override
  State<PerformanceValidationToolPeriodPage> createState() =>
      PerformanceValidationToolPeriodPageState();
}

class PerformanceValidationToolPeriodPageState
    extends State<PerformanceValidationToolPeriodPage> {
  bool _isLoading = false;
  int _currentPage = 1;
  final int _pageSize = 15;
  int _totalCount = 0;
  List<PerformanceValidationToolPeriod> performanceValidationToolPeriodList =
      [];
  List<PerformanceValidationToolPeriod> filteredList = [];
  final _formKey = GlobalKey<FormState>();
  final _performanceValidationToolPeriodService =
      PerformanceValidationToolService(Dio());

  @override
  void initState() {
    super.initState();
    fetchValidationPeriod();
  }

  Future<void> fetchValidationPeriod({
    int page = 1,
    String? searchQuery,
  }) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final pageList = await _performanceValidationToolPeriodService
          .getPerformanceValidationToolPeriod(
            page: page,
            pageSize: _pageSize,
            searchQuery: searchQuery,
          );

      if (mounted) {
        setState(() {
          _currentPage = pageList.page;
          _totalCount = pageList.totalCount;
          performanceValidationToolPeriodList = pageList.items;
          filteredList = List.from(performanceValidationToolPeriodList);
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

  void showFormDialog({
    String? id,
    String? startDate,
    String? endDate,
    String? period,
  }) {
    TextEditingController startDateController = TextEditingController(
      text: startDate,
    );
    TextEditingController endDateController = TextEditingController(
      text: endDate,
    );
    TextEditingController periodController = TextEditingController(
      text: period,
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: mainBgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(12.0),
          ),
          titlePadding: EdgeInsets.zero,
          title: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              color: primaryLightColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Text(
              id == null ? 'Create PGS Period' : 'Edit PGS Period',
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
                  width: 350,
                  height: 60,
                  child: TextFormField(
                    controller: startDateController,
                    decoration: InputDecoration(
                      focusColor: primaryColor,
                      labelText: 'Start Date',
                      floatingLabelStyle: TextStyle(color: primaryColor),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
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
                      labelText: 'Start Date',
                      floatingLabelStyle: TextStyle(color: primaryColor),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
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
                gap4px,
                SizedBox(
                  width: 350,
                  height: 60,
                  child: TextFormField(
                    controller: periodController,
                    decoration: InputDecoration(
                      labelText: 'Period Name',
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
              child: Text('Cancel', style: TextStyle(color: primaryColor)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(4),
                ),
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  bool? confirmAction = await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          id == null ? 'Confirm Save' : 'Confirm Update',
                        ),
                        content: Text(
                          id == null
                              ? 'Are you sure you want to save this record'
                              : 'Are you sure you want to update this record',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text(
                              'No',
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
                              'Yes',
                              style: TextStyle(color: primaryColor),
                            ),
                          ),
                        ],
                      );
                    },
                  );

                  if (confirmAction == true) {
                    final validationToolPeriod =
                        PerformanceValidationToolPeriod(
                          int.tryParse(id ?? '0') ?? 0,
                          false,
                          DateTime.parse(startDateController.text),
                          DateTime.parse(endDateController.text),
                        );
                    await _performanceValidationToolPeriodService
                        .createOrUpdatePerformanceValidationToolPeriod(
                          validationToolPeriod,
                        );
                    setState(() {
                      fetchValidationPeriod();
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
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildPageHeader(
            isMobile: isMobile,
            title: 'Performance Validation Tool Period',
            totalCount: _totalCount,
            itemLabel: 'strategy review period',
            icon: Icons.settings,
            actionButton: ElevatedButton.icon(
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
          ),
          const SizedBox(height: 26),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.black.withValues(alpha: .05),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isMobile)
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                "#",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Start Date",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "End Date",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Actions",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: 5),
                    Expanded(
                      child:
                          _isLoading
                              ? Center(
                                child: CircularProgressIndicator(
                                  color: primaryColor,
                                ),
                              )
                              : ListView.builder(
                                itemCount: filteredList.length,
                                itemBuilder: (context, index) {
                                  final stratperiod = filteredList[index];
                                  int itemNumber =
                                      ((_currentPage - 1) * _pageSize) +
                                      index +
                                      1;
                                  if (!isMobile) {
                                    return Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey.shade200,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Text('$itemNumber'),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              DateTimeConverter().toJson(
                                                stratperiod.startDate,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              DateTimeConverter().toJson(
                                                stratperiod.endDate,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Row(
                                              children: [
                                                Tooltip(
                                                  message: 'Edit',
                                                  child: IconButton(
                                                    icon: const Icon(
                                                      size: 18,
                                                      Icons.edit_outlined,
                                                    ),
                                                    onPressed: () {
                                                      showFormDialog(
                                                        id:
                                                            stratperiod.id
                                                                .toString(),
                                                        startDate:
                                                            DateTimeConverter()
                                                                .toJson(
                                                                  stratperiod
                                                                      .startDate,
                                                                ),
                                                        endDate:
                                                            DateTimeConverter()
                                                                .toJson(
                                                                  stratperiod
                                                                      .endDate,
                                                                ),
                                                      );
                                                    },
                                                  ),
                                                ),

                                                IconButton(
                                                  icon: const Icon(
                                                    size: 18,
                                                    CupertinoIcons
                                                        .delete_simple,
                                                    color: Colors.redAccent,
                                                  ),
                                                  onPressed: () {},

                                                  // => showDeleteDialog(
                                                  //   stratperiod.id
                                                  //       .toString(),
                                                  // ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  return null;
                                },
                              ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      color: Theme.of(context).cardColor,
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
                            onPageChanged:
                                (page) => fetchValidationPeriod(page: page),
                          ),
                          const SizedBox(width: 60),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showDeleteDialog(String? id) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text(
            'Are you sure you want to delete this period? This action cannot be undone',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: primaryTextColor)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                try {
                  await _performanceValidationToolPeriodService
                      .deleteValidationPeriod(id);
                  await fetchValidationPeriod();
                  MotionToast.success(
                    toastAlignment: Alignment.topCenter,
                    description: Text('Period deleted successfully'),
                  ).show(context);
                } catch (e) {
                  MotionToast.error(
                    description: Text('Failed to delete period'),
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
}
