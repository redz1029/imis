// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/constant/permissions.dart';
import 'package:imis/strategy_review_report/strategy_review_period/models/strategy_review_period.dart';
import 'package:imis/strategy_review_report/strategy_review_period/services/strategy_review_period_service.dart';
import 'package:imis/utils/date_time_converter.dart';
import 'package:imis/widgets/common/build_page_header.dart';
import 'package:imis/widgets/common/pagination_controls.dart';
import 'package:imis/widgets/permission/permission_widget.dart';
import 'package:motion_toast/motion_toast.dart';

class StrategyReviewPeriodPage extends StatefulWidget {
  const StrategyReviewPeriodPage({super.key});

  @override
  State<StrategyReviewPeriodPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<StrategyReviewPeriodPage> {
  List<StrategyReviewPeriod> strategyPeriodList = [];
  List<StrategyReviewPeriod> filteredList = [];
  final _strategyPeriodService = StrategyReviewPeriodService(Dio());
  int _currentPage = 1;
  final int _pageSize = 15;
  bool _isLoading = false;
  int _totalCount = 0;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchStrategyPeriod();
    // pgsPeriodSearchUtil = FilterSearchResultUtil<PgsPeriod>(
    //   paginationUtils: _paginationUtils,
    //   endpoint: ApiEndpoint().pgsperiod,
    //   pageSize: _pageSize,
    //   fromJson: (json) => PgsPeriod.fromJson(json),
    // );

    // isSearchfocus.addListener(() {
    //   setState(() {});
    // });
  }

  Future<void> fetchStrategyPeriod({int page = 1, String? searchQuery}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final pageList = await _strategyPeriodService.getPgsPeriod(
        page: page,
        pageSize: _pageSize,
        searchQuery: searchQuery,
      );

      if (mounted) {
        setState(() {
          _currentPage = pageList.page;
          _totalCount = pageList.totalCount;
          strategyPeriodList = pageList.items;
          filteredList = List.from(strategyPeriodList);
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
                  await _strategyPeriodService.deletePeriod(id);
                  await fetchStrategyPeriod();
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
    TextEditingController quarterController = TextEditingController(
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
                    controller: quarterController,
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
                    final period = StrategyReviewPeriod(
                      int.tryParse(id ?? '0') ?? 0,
                      DateTime.parse(startDateController.text),
                      DateTime.parse(endDateController.text),
                      false,
                      quarter: quarterController.text,
                    );
                    await _strategyPeriodService.createOrUpdatePgsPeriod(
                      period,
                    );
                    setState(() {
                      fetchStrategyPeriod();
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
            title: 'Strategy Review Period Information',
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
                                                PermissionWidget(
                                                  permission:
                                                      AppPermissions
                                                          .editStrategyReview,
                                                  child: Tooltip(
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
                                                          remarkrs:
                                                              stratperiod
                                                                  .quarter
                                                                  .toString(),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),

                                                IconButton(
                                                  icon: const Icon(
                                                    size: 18,
                                                    CupertinoIcons
                                                        .delete_simple,
                                                    color: Colors.redAccent,
                                                  ),
                                                  onPressed:
                                                      () => showDeleteDialog(
                                                        stratperiod.id
                                                            .toString(),
                                                      ),
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
                                (page) => fetchStrategyPeriod(page: page),
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
}
