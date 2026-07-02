// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/constant/permissions.dart';
import 'package:imis/strategy_review_report/strategy_review_period/models/strategy_review_period.dart';
import 'package:imis/strategy_review_report/strategy_review_period/services/strategy_review_period_service.dart';
import 'package:imis/utils/date_time_converter.dart';
import 'package:imis/widgets/common/build_page_header.dart';
import 'package:imis/widgets/common/pagination_controls.dart';
import 'package:imis/widgets/dialog/delete_dialog.dart';
import 'package:imis/widgets/dialog/dialog_field.dart';
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
      builder:
          (ctx) => DeleteDialog(
            title: 'Strategy Review Period',
            itemName: 'strategy review period',
            onDelete: () async {
              Navigator.pop(ctx);
              try {
                await _strategyPeriodService.deletePeriod(id);
                await fetchStrategyPeriod();
                if (mounted) {
                  MotionToast.success(
                    description: Text('Strategy review deleted successfully'),
                  ).show(context);
                }
              } catch (_) {
                MotionToast.error(
                  description: Text('Failed to delete strategy review period'),
                ).show(context);
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
    String? rowVersion,
  }) {
    TextEditingController quarterController = TextEditingController(
      text: remarkrs,
    );
    DateTime? selectedFromDate =
        startDate != null ? DateTime.tryParse(startDate) : null;
    DateTime? selectedEndDate =
        endDate != null ? DateTime.tryParse(endDate) : null;

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
                                    ? 'Edit Strategy Review Period'
                                    : 'Create Strategy Review Period',
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 17,
                                  color: kText,
                                ),
                              ),
                              Text(
                                isEdit
                                    ? 'Update strategy review period'
                                    : 'Add a new  strategy review period',
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
                        controller: quarterController,
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
                                  final period = StrategyReviewPeriod(
                                    int.tryParse(id ?? '0') ?? 0,
                                    selectedFromDate!,
                                    selectedEndDate!,
                                    false,
                                    quarter: quarterController.text,
                                  );
                                  await _strategyPeriodService
                                      .createOrUpdatePgsPeriod(period);
                                  setState(() {
                                    fetchStrategyPeriod();
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
