// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/roadmap/kra_period_roadmap/models/kra_roadmap_period.dart';
import 'package:imis/roadmap/kra_period_roadmap/services/kra_period_roadmap_service.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/date_time_converter.dart';
import 'package:imis/utils/filter_search_result_util.dart';
import 'package:imis/utils/pagination_util.dart';
import 'package:imis/widgets/pagination_controls.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';

class KraPeriodRoadmapPage extends StatefulWidget {
  const KraPeriodRoadmapPage({super.key});

  @override
  KraPeriodRoadmapPageState createState() => KraPeriodRoadmapPageState();
}

class KraPeriodRoadmapPageState extends State<KraPeriodRoadmapPage> {
  final _paginationUtils = PaginationUtil(Dio());
  final _pgsPeriodService = KraPeriodRoadmapService(Dio());
  late FilterSearchResultUtil<KraRoadmapPeriod> pgsPeriodSearchUtil;
  final _formKey = GlobalKey<FormState>();
  List<KraRoadmapPeriod> kraPeriodList = [];
  List<KraRoadmapPeriod> filteredList = [];
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
    fetchKRAPeriods();
    pgsPeriodSearchUtil = FilterSearchResultUtil<KraRoadmapPeriod>(
      paginationUtils: _paginationUtils,
      endpoint: ApiEndpoint().pgsperiod,
      pageSize: _pageSize,
      fromJson: (json) => KraRoadmapPeriod.fromJson(json),
    );

    isSearchfocus.addListener(() {
      setState(() {});
    });
  }

  Future<void> fetchKRAPeriods({int page = 1, String? searchQuery}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final pageList = await _pgsPeriodService.getKraPeriod(
        page: page,
        pageSize: _pageSize,
        searchQuery: searchQuery,
      );

      if (mounted) {
        setState(() {
          _currentPage = pageList.page;
          _totalCount = pageList.totalCount;
          kraPeriodList = pageList.items;
          filteredList = List.from(kraPeriodList);
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
          filteredList = List<KraRoadmapPeriod>.from(kraPeriodList);
        });
        return;
      }

      setState(() {
        filteredList =
            kraPeriodList.where((period) {
              final periodStart = period.startYear;
              final periodEnd = period.endYear;

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
        filteredList = List<KraRoadmapPeriod>.from(kraPeriodList);
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
            "Are you sure you want to delete this KRA Period? This action cannot be undone.",
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
                  await _pgsPeriodService.deleteKraPeriod(id);
                  await fetchKRAPeriods();
                  MotionToast.success(
                    toastAlignment: Alignment.topCenter,
                    description: Text('KRA Period deleted successfully'),
                  ).show(context);
                } catch (e) {
                  MotionToast.error(
                    description: Text('Failed to Delete KRA Period'),
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
    String? rowVersion,
  }) {
    TextEditingController startDateController = TextEditingController(
      text: startDate,
    );
    TextEditingController endDateController = TextEditingController(
      text: endDate,
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
              id == null
                  ? 'Create  KRA Roadmap Period'
                  : 'Edit KRA Roadmap Period',
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
                      labelText: 'Start Year',
                      floatingLabelStyle: TextStyle(color: primaryColor),
                      border: OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please select a start year';
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
                      labelText: 'End Year',
                      floatingLabelStyle: TextStyle(color: primaryColor),
                      border: OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please select a year';
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
                    final period = KraRoadmapPeriod(
                      int.tryParse(id ?? '0') ?? 0,
                      DateTime.parse(startDateController.text),
                      DateTime.parse(endDateController.text),
                      isDeleted: false,
                      rowVersion: '',
                    );
                    await _pgsPeriodService.createOrUpdateKraPeriod(period);
                    setState(() {
                      fetchKRAPeriods();
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "KRA Period Information",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
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

                const Spacer(),
                if (!isMobile)
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
            const SizedBox(height: 26),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
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
                    /// DESKTOP HEADER
                    if (!isMobile)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        child: Row(
                          children: const [
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
                    const SizedBox(height: 5),

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
                                  final kraperiod = filteredList[index];
                                  int itemNumber =
                                      ((_currentPage - 1) * _pageSize) +
                                      index +
                                      1;
                                  if (!isMobile) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
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
                                            child: Text("$itemNumber"),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              DateTimeConverter().toJson(
                                                kraperiod.startYear,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              DateTimeConverter().toJson(
                                                kraperiod.endYear,
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
                                                      Icons.edit_outlined,
                                                    ),
                                                    onPressed: () {
                                                      showFormDialog(
                                                        id:
                                                            kraperiod.id
                                                                .toString(),
                                                        startDate:
                                                            DateTimeConverter()
                                                                .toJson(
                                                                  kraperiod
                                                                      .startYear,
                                                                ),
                                                        endDate:
                                                            DateTimeConverter()
                                                                .toJson(
                                                                  kraperiod
                                                                      .endYear,
                                                                ),
                                                      );
                                                    },
                                                  ),
                                                ),

                                                IconButton(
                                                  icon: const Icon(
                                                    CupertinoIcons
                                                        .delete_simple,
                                                    color: Colors.redAccent,
                                                  ),
                                                  onPressed:
                                                      () => showDeleteDialog(
                                                        kraperiod.id.toString(),
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }

                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    margin: const EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey.shade200,
                                        ),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "$itemNumber",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const Spacer(),
                                            PopupMenuButton<String>(
                                              color:
                                                  Theme.of(context).cardColor,
                                              icon: const Icon(Icons.more_vert),
                                              onSelected: (value) async {
                                                if (value == 'edit') {
                                                  showFormDialog(
                                                    id: kraperiod.id.toString(),
                                                    startDate:
                                                        DateTimeConverter()
                                                            .toJson(
                                                              kraperiod
                                                                  .startYear,
                                                            ),
                                                    endDate: DateTimeConverter()
                                                        .toJson(
                                                          kraperiod.endYear,
                                                        ),
                                                  );
                                                } else if (value == 'delete') {
                                                  showDeleteDialog(
                                                    kraperiod.id.toString(),
                                                  );
                                                }
                                              },
                                              itemBuilder:
                                                  (_) => [
                                                    PopupMenuItem(
                                                      value: 'edit',
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.edit_outlined,
                                                            size: 18,
                                                          ),
                                                          SizedBox(width: 8),
                                                          Text('Edit'),
                                                        ],
                                                      ),
                                                    ),

                                                    PopupMenuItem(
                                                      value: 'delete',
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            CupertinoIcons
                                                                .delete_simple,
                                                            color: Colors.red,
                                                            size: 18,
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
                                        const SizedBox(height: 8),
                                        Text(
                                          DateTimeConverter().toJson(
                                            kraperiod.startYear,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          DateTimeConverter().toJson(
                                            kraperiod.endYear,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                      ],
                                    ),
                                  );
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
                                (page) => fetchKRAPeriods(page: page),
                          ),
                          const SizedBox(width: 60),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton:
          isMobile
              ? FloatingActionButton(
                backgroundColor: primaryColor,
                onPressed: () => showFormDialog(),
                child: Icon(Icons.add, color: Colors.white),
              )
              : null,
    );
  }
}
