// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/performance_governance_system/pgs_period/models/pgs_period.dart';
import 'package:imis/performance_governance_system/pgs_period/services/pgs_period_service.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/date_time_converter.dart';
import 'package:imis/utils/filter_search_result_util.dart';
import 'package:imis/utils/pagination_util.dart';
import 'package:imis/widgets/common/pagination_controls.dart';
import 'package:imis/widgets/dialog/delete_dialog.dart';
import 'package:imis/widgets/dialog/dialog_field.dart';
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
      setState(() {
        filteredList = List<PgsPeriod>.from(pgsPeriodList);
      });
    }
  }

  void showDeleteDialog(String id) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder:
          (ctx) => DeleteDialog(
            title: 'PGS period',
            itemName: 'PGS period',
            onDelete: () async {
              Navigator.pop(ctx);
              try {
                await _pgsPeriodService.deletePeriod(id);
                await fetchPGSPeriods();
                if (mounted) {
                  MotionToast.success(
                    toastAlignment: Alignment.topCenter,
                    description: Text('PGS period deleted successfully'),
                  ).show(context);
                }
              } catch (_) {
                MotionToast.error(
                  toastAlignment: Alignment.topCenter,
                  description: Text(
                    'Failed to delete PGS period',
                    style: GoogleFonts.plusJakartaSans(),
                  ),
                );
              }
            },
          ),
    );
  }

  void showFormDialog({
    String? id,
    bool? isDeleted,
    String? startDate,
    String? endDate,
    String? remarkrs,
    bool isActive = false,
    String? rowVersion,
  }) {
    DateTime? selectedFromDate =
        startDate != null ? DateTime.tryParse(startDate) : null;
    DateTime? selectedEndDate =
        endDate != null ? DateTime.tryParse(endDate) : null;
    TextEditingController remarksController = TextEditingController(
      text: remarkrs,
    );
    final isEdit = id != null;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            Future<void> pickDate({required bool isFrom}) async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
                builder:
                    (context, child) => Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.light(
                          primary: primaryColor,
                          onPrimary: Colors.white,
                        ),
                        textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(
                            foregroundColor: primaryColor,
                          ),
                        ),
                      ),
                      child: child!,
                    ),
              );
              if (picked == null) return;
              setStateDialog(() {
                if (isFrom) {
                  selectedFromDate = picked;
                  if (selectedEndDate != null &&
                      selectedEndDate!.isBefore(picked)) {
                    selectedEndDate = null;
                  }
                } else {
                  selectedEndDate = picked;
                }
              });
            }

            Widget dateField({
              required String label,
              required DateTime? value,
              required bool isFrom,
              required String? Function(String?)? validator,
            }) {
              return TextFormField(
                readOnly: true,
                controller: TextEditingController(
                  text: value != null ? "${value.toLocal()}".split(' ')[0] : '',
                ),
                onTap: () async {
                  if (!isFrom && selectedFromDate == null) {
                    MotionToast.warning(
                      toastAlignment: Alignment.topCenter,
                      description: const Text(
                        'Please select a start date first',
                      ),
                    ).show(context);
                    return;
                  }
                  await pickDate(isFrom: isFrom);
                },
                validator: validator,
                style: GoogleFonts.plusJakartaSans(fontSize: 13, color: kText),
                decoration: InputDecoration(
                  labelText: label,
                  labelStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: kMuted,
                  ),
                  floatingLabelStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                  suffixIcon: const Icon(
                    Icons.calendar_today_outlined,
                    size: 18,
                    color: kMuted,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 13,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: kBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: kBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: primaryColor,
                      width: 1.5,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: kDanger),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: kDanger, width: 1.5),
                  ),
                ),
              );
            }

            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                width: 460,
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: kSurface,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 32,
                      offset: Offset(0, 12),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: primaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.calendar_month_outlined,
                              color: primaryColor,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isEdit
                                    ? 'Edit PGS Period'
                                    : 'Create PGS Period',
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 17,
                                  color: kText,
                                ),
                              ),
                              Text(
                                isEdit
                                    ? 'Update PGS period details'
                                    : 'Add a new PGS period',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  color: kMuted,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Divider(color: kBorder, height: 1),
                      const SizedBox(height: 20),
                      dateField(
                        label: 'Start Date',
                        value: selectedFromDate,
                        isFrom: true,
                        validator:
                            (_) => selectedFromDate == null ? 'Required' : null,
                      ),
                      gap12px,
                      dateField(
                        label: 'End Date',
                        value: selectedEndDate,
                        isFrom: false,
                        validator:
                            (_) => selectedEndDate == null ? 'Required' : null,
                      ),
                      gap12px,
                      dialogField(
                        label: 'Remarks',
                        controller: remarksController,
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: kBackground,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: kBorder),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Active Period',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: kText,
                                  ),
                                ),
                                Text(
                                  'Currently active as period',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    color: kMuted,
                                  ),
                                ),
                              ],
                            ),
                            Switch(
                              value: isActive,
                              onChanged:
                                  (val) => setStateDialog(() => isActive = val),
                              activeColor: primaryColor,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: kBorder),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.plusJakartaSans(
                                  color: kMuted,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: Icon(
                                isEdit ? Icons.save_rounded : Icons.add_rounded,
                                size: 16,
                                color: Colors.white,
                              ),
                              label: Text(
                                isEdit ? 'Update' : 'Save',
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () async {
                                if (!_formKey.currentState!.validate()) return;

                                final confirmed = await showDialog<bool>(
                                  context: context,
                                  builder:
                                      (ctx) => Dialog(
                                        backgroundColor: Colors.transparent,
                                        child: Container(
                                          width: 340,
                                          padding: const EdgeInsets.all(24),
                                          decoration: BoxDecoration(
                                            color: kSurface,
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withValues(
                                                  alpha: 0.12,
                                                ),
                                                blurRadius: 32,
                                                offset: const Offset(0, 12),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                width: 48,
                                                height: 48,
                                                decoration: BoxDecoration(
                                                  color: primaryColor
                                                      .withValues(alpha: 0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                ),
                                                child: const Icon(
                                                  Icons.help_outline_rounded,
                                                  color: primaryColor,
                                                  size: 26,
                                                ),
                                              ),
                                              const SizedBox(height: 14),
                                              Text(
                                                isEdit
                                                    ? 'Confirm Update'
                                                    : 'Confirm Save',
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 16,
                                                      color: kText,
                                                    ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                isEdit
                                                    ? 'Are you sure you want to update this announcement?'
                                                    : 'Are you sure you want to save this announcement?',
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                      fontSize: 13,
                                                      color: kMuted,
                                                      height: 1.5,
                                                    ),
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(height: 22),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: OutlinedButton(
                                                      onPressed:
                                                          () => Navigator.pop(
                                                            ctx,
                                                            false,
                                                          ),
                                                      style: OutlinedButton.styleFrom(
                                                        side: const BorderSide(
                                                          color: kBorder,
                                                        ),
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              vertical: 11,
                                                            ),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        'No',
                                                        style:
                                                            GoogleFonts.plusJakartaSans(
                                                              color: kMuted,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      onPressed:
                                                          () => Navigator.pop(
                                                            ctx,
                                                            true,
                                                          ),
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            primaryColor,
                                                        elevation: 0,
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              vertical: 11,
                                                            ),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        'Yes',
                                                        style:
                                                            GoogleFonts.plusJakartaSans(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                );
                                if (confirmed == true) {
                                  final period = PgsPeriod(
                                    int.tryParse(id ?? '0') ?? 0,
                                    false,
                                    selectedFromDate!,
                                    selectedEndDate!,
                                    remarksController.text,
                                    isActive: isActive,
                                  );
                                  await _pgsPeriodService
                                      .createOrUpdatePgsPeriod(period);
                                  setState(() {
                                    fetchPGSPeriods();
                                  });
                                  MotionToast.success(
                                    toastAlignment: Alignment.topCenter,
                                    description: Text('Saved successfully'),
                                  ).show(context);
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
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
              "PGS Period Information",
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
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Start Date",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "End Date",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),

                            Expanded(
                              flex: 2,
                              child: Text(
                                "Actions",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
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
                                  final pgsperiod = filteredList[index];
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
                                                pgsperiod.startDate,
                                              ),
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              DateTimeConverter().toJson(
                                                pgsperiod.endDate,
                                              ),
                                              style: TextStyle(fontSize: 12),
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
                                                      size: 16,
                                                      Icons.edit_outlined,
                                                    ),
                                                    onPressed: () {
                                                      showFormDialog(
                                                        id:
                                                            pgsperiod.id
                                                                .toString(),
                                                        startDate:
                                                            DateTimeConverter()
                                                                .toJson(
                                                                  pgsperiod
                                                                      .startDate,
                                                                ),
                                                        endDate:
                                                            DateTimeConverter()
                                                                .toJson(
                                                                  pgsperiod
                                                                      .endDate,
                                                                ),
                                                        remarkrs:
                                                            pgsperiod.remarks
                                                                .toString(),
                                                        isActive:
                                                            pgsperiod
                                                                .isActive ??
                                                            false,
                                                      );
                                                    },
                                                  ),
                                                ),

                                                IconButton(
                                                  icon: const Icon(
                                                    size: 16,
                                                    CupertinoIcons
                                                        .delete_simple,
                                                    color: Colors.redAccent,
                                                  ),
                                                  onPressed:
                                                      () => showDeleteDialog(
                                                        pgsperiod.id.toString(),
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
                                                fontSize: 12,
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
                                                    id: pgsperiod.id.toString(),
                                                    startDate:
                                                        DateTimeConverter()
                                                            .toJson(
                                                              pgsperiod
                                                                  .startDate,
                                                            ),
                                                    endDate: DateTimeConverter()
                                                        .toJson(
                                                          pgsperiod.endDate,
                                                        ),
                                                    remarkrs:
                                                        pgsperiod.remarks
                                                            .toString(),
                                                  );
                                                } else if (value == 'delete') {
                                                  showDeleteDialog(
                                                    pgsperiod.id.toString(),
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
                                                            size: 16,
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
                                                            size: 16,
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
                                            pgsperiod.startDate,
                                          ),
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          DateTimeConverter().toJson(
                                            pgsperiod.endDate,
                                          ),
                                          style: TextStyle(fontSize: 12),
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
                                (page) => fetchPGSPeriods(page: page),
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
