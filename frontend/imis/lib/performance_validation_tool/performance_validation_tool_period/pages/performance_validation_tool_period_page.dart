// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/performance_validation_tool/performance_validation_tool_period/models/performance_validation_tool_period.dart';
import 'package:imis/performance_validation_tool/performance_validation_tool_period/services/performance_validation_tool_service.dart';
import 'package:imis/utils/date_time_converter.dart';
import 'package:imis/widgets/common/build_page_header.dart';
import 'package:imis/widgets/common/pagination_controls.dart';
import 'package:imis/widgets/dialog/delete_dialog.dart';
import 'package:imis/widgets/dialog/dialog_field.dart';
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

  // void showFormDialog({
  //   String? id,
  //   String? startDate,
  //   String? endDate,
  //   String? period,
  // }) {
  //   DateTime? selectedFromDate =
  //       startDate != null ? DateTime.tryParse(startDate) : null;
  //   DateTime? selectedEndDate =
  //       endDate != null ? DateTime.tryParse(endDate) : null;

  //   final isEdit = id != null;
  //   TextEditingController periodController = TextEditingController(
  //     text: period,
  //   );
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return StatefulBuilder(builder: (context, setStateDialog){
  //          Future<void> pickDate({required bool isFrom}) async {
  //             final picked = await showDatePicker(
  //               context: context,
  //               initialDate: DateTime.now(),
  //               firstDate: DateTime(2000),
  //               lastDate: DateTime(2101),
  //               builder:
  //                   (context, child) => Theme(
  //                     data: Theme.of(context).copyWith(
  //                       colorScheme: ColorScheme.light(
  //                         primary: primaryColor,
  //                         onPrimary: Colors.white,
  //                       ),
  //                       textButtonTheme: TextButtonThemeData(
  //                         style: TextButton.styleFrom(
  //                           foregroundColor: primaryColor,
  //                         ),
  //                       ),
  //                     ),
  //                     child: child!,
  //                   ),
  //             );
  //             if (picked == null) return;
  //             setStateDialog(() {
  //               if (isFrom) {
  //                 selectedFromDate = picked;
  //                 if (selectedEndDate != null &&
  //                     selectedEndDate!.isBefore(picked)) {
  //                   selectedEndDate = null;
  //                 }
  //               } else {
  //                 selectedEndDate = picked;
  //               }
  //             });
  //           }
  //       return AlertDialog(
  //         backgroundColor: mainBgColor,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadiusGeometry.circular(12.0),
  //         ),
  //         titlePadding: EdgeInsets.zero,
  //         title: Container(
  //           width: double.infinity,
  //           padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
  //           decoration: BoxDecoration(
  //             color: primaryLightColor,
  //             borderRadius: BorderRadius.only(
  //               topLeft: Radius.circular(12),
  //               topRight: Radius.circular(12),
  //             ),
  //           ),
  //           child: Text(
  //             id == null ? 'Create PGS Period' : 'Edit PGS Period',
  //             textAlign: TextAlign.center,
  //             style: TextStyle(
  //               fontWeight: FontWeight.bold,
  //               fontSize: 18,
  //               color: Colors.white,
  //             ),
  //           ),
  //         ),
  //         content: Form(
  //           key: _formKey,
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               SizedBox(
  //                 width: 350,
  //                 height: 60,
  //                 child: TextFormField(
  //                   controller: startDateController,
  //                   decoration: InputDecoration(
  //                     focusColor: primaryColor,
  //                     labelText: 'Start Date',
  //                     floatingLabelStyle: TextStyle(color: primaryColor),
  //                     border: OutlineInputBorder(),
  //                     focusedBorder: OutlineInputBorder(
  //                       borderSide: BorderSide(color: primaryColor),
  //                     ),
  //                   ),
  //                   validator: (value) {
  //                     if (value == null || value.trim().isEmpty) {
  //                       return 'Please select a date';
  //                     }
  //                     return null;
  //                   },
  //                   readOnly: true,
  //                   onTap: () async {
  //                     DateTime? picked = await showDatePicker(
  //                       context: context,
  //                       initialDate: DateTime.now(),
  //                       firstDate: DateTime(2000),
  //                       lastDate: DateTime(2101),
  //                       builder: (context, child) {
  //                         return Theme(
  //                           data: Theme.of(context).copyWith(
  //                             colorScheme: ColorScheme.light(
  //                               primary: primaryColor,
  //                               onPrimary: secondaryColor,
  //                             ),
  //                             textButtonTheme: TextButtonThemeData(
  //                               style: TextButton.styleFrom(
  //                                 foregroundColor: primaryColor,
  //                               ),
  //                             ),
  //                           ),
  //                           child: child!,
  //                         );
  //                       },
  //                     );
  //                     if (picked != null) {
  //                       startDateController.text =
  //                           picked.toLocal().toString().split(' ')[0];
  //                     }
  //                   },
  //                 ),
  //               ),
  //               gap4px,
  //               SizedBox(
  //                 width: 350,
  //                 height: 60,
  //                 child: TextFormField(
  //                   controller: endDateController,
  //                   decoration: InputDecoration(
  //                     focusColor: primaryColor,
  //                     labelText: 'Start Date',
  //                     floatingLabelStyle: TextStyle(color: primaryColor),
  //                     border: OutlineInputBorder(),
  //                     focusedBorder: OutlineInputBorder(
  //                       borderSide: BorderSide(color: primaryColor),
  //                     ),
  //                   ),
  //                   validator: (value) {
  //                     if (value == null || value.trim().isEmpty) {
  //                       return 'Please select a date';
  //                     }
  //                     return null;
  //                   },
  //                   readOnly: true,
  //                   onTap: () async {
  //                     DateTime? picked = await showDatePicker(
  //                       context: context,
  //                       initialDate: DateTime.now(),
  //                       firstDate: DateTime(2000),
  //                       lastDate: DateTime(2101),
  //                       builder: (context, child) {
  //                         return Theme(
  //                           data: Theme.of(context).copyWith(
  //                             colorScheme: ColorScheme.light(
  //                               primary: primaryColor,
  //                               onPrimary: secondaryColor,
  //                             ),
  //                             textButtonTheme: TextButtonThemeData(
  //                               style: TextButton.styleFrom(
  //                                 foregroundColor: primaryColor,
  //                               ),
  //                             ),
  //                           ),
  //                           child: child!,
  //                         );
  //                       },
  //                     );
  //                     if (picked != null) {
  //                       endDateController.text =
  //                           picked.toLocal().toString().split(' ')[0];
  //                     }
  //                   },
  //                 ),
  //               ),
  //               gap4px,
  //               SizedBox(
  //                 width: 350,
  //                 height: 60,
  //                 child: TextFormField(
  //                   controller: periodController,
  //                   decoration: InputDecoration(
  //                     labelText: 'Period Name',
  //                     focusColor: primaryColor,
  //                     floatingLabelStyle: TextStyle(color: primaryColor),
  //                     border: OutlineInputBorder(),
  //                     focusedBorder: const OutlineInputBorder(
  //                       borderSide: BorderSide(color: primaryColor),
  //                     ),
  //                   ),
  //                   validator: (value) {
  //                     if (value == null || value.trim().isEmpty) {
  //                       return 'Please fill out this field';
  //                     }
  //                     return null;
  //                   },
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: Text('Cancel', style: TextStyle(color: primaryColor)),
  //           ),
  //           ElevatedButton(
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: primaryColor,
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadiusGeometry.circular(4),
  //               ),
  //             ),
  //             onPressed: () async {
  //               if (_formKey.currentState!.validate()) {
  //                 bool? confirmAction = await showDialog<bool>(
  //                   context: context,
  //                   builder: (context) {
  //                     return AlertDialog(
  //                       title: Text(
  //                         id == null ? 'Confirm Save' : 'Confirm Update',
  //                       ),
  //                       content: Text(
  //                         id == null
  //                             ? 'Are you sure you want to save this record'
  //                             : 'Are you sure you want to update this record',
  //                       ),
  //                       actions: [
  //                         TextButton(
  //                           onPressed: () => Navigator.pop(context, false),
  //                           child: Text(
  //                             'No',
  //                             style: TextStyle(color: primaryColor),
  //                           ),
  //                         ),
  //                         TextButton(
  //                           onPressed: () {
  //                             if (_formKey.currentState!.validate()) {
  //                               Navigator.pop(context, true);
  //                             }
  //                           },
  //                           child: Text(
  //                             'Yes',
  //                             style: TextStyle(color: primaryColor),
  //                           ),
  //                         ),
  //                       ],
  //                     );
  //                   },
  //                 );

  //                 if (confirmAction == true) {
  //                   final validationToolPeriod =
  //                       PerformanceValidationToolPeriod(
  //                         int.tryParse(id ?? '0') ?? 0,
  //                         false,
  //                         DateTime.parse(startDateController.text),
  //                         DateTime.parse(endDateController.text),
  //                       );
  //                   await _performanceValidationToolPeriodService
  //                       .createOrUpdatePerformanceValidationToolPeriod(
  //                         validationToolPeriod,
  //                       );
  //                   setState(() {
  //                     fetchValidationPeriod();
  //                   });
  //                   MotionToast.success(
  //                     toastAlignment: Alignment.topCenter,
  //                     description: Text('Saved successfully'),
  //                   ).show(context);
  //                   Navigator.pop(context);
  //                 }
  //               }
  //             },
  //             child: Text(
  //               id == null ? 'Save' : 'Update',
  //               style: TextStyle(color: Colors.white),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  void showFormDialog({
    String? id,
    bool? isDeleted,
    String? startDate,
    String? endDate,
    String? period,
    String? rowVersion,
  }) {
    DateTime? selectedFromDate =
        startDate != null ? DateTime.tryParse(startDate) : null;
    DateTime? selectedEndDate =
        endDate != null ? DateTime.tryParse(endDate) : null;
    TextEditingController periodController = TextEditingController(
      text: period,
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
                                    ? 'Edit PVT Period'
                                    : 'Create PVT Period',
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 17,
                                  color: kText,
                                ),
                              ),
                              Text(
                                isEdit
                                    ? 'Update PVT period details'
                                    : 'Add a new PVT period',
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
                        controller: periodController,
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
                                  final period =
                                      PerformanceValidationToolPeriod(
                                        int.tryParse(id ?? '0') ?? 0,
                                        false,
                                        selectedFromDate!,
                                        selectedEndDate!,
                                        period: periodController.text,
                                      );
                                  await _performanceValidationToolPeriodService
                                      .createOrUpdatePerformanceValidationToolPeriod(
                                        period,
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
                                'Remarks',
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
                                  final pvtPeriod = filteredList[index];
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
                                                pvtPeriod.startDate,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              DateTimeConverter().toJson(
                                                pvtPeriod.endDate,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(pvtPeriod.period ?? ''),
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
                                                            pvtPeriod.id
                                                                .toString(),
                                                        startDate:
                                                            DateTimeConverter()
                                                                .toJson(
                                                                  pvtPeriod
                                                                      .startDate,
                                                                ),
                                                        endDate:
                                                            DateTimeConverter()
                                                                .toJson(
                                                                  pvtPeriod
                                                                      .endDate,
                                                                ),
                                                        period:
                                                            pvtPeriod.period,
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
                                                  onPressed:
                                                      () => showDeleteDialog(
                                                        pvtPeriod.id.toString(),
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
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    margin: EdgeInsets.only(bottom: 12),
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
                                                    id: pvtPeriod.id.toString(),
                                                    startDate:
                                                        DateTimeConverter()
                                                            .toJson(
                                                              pvtPeriod
                                                                  .startDate,
                                                            ),
                                                    endDate: DateTimeConverter()
                                                        .toJson(
                                                          pvtPeriod.endDate,
                                                        ),
                                                    period: pvtPeriod.period,
                                                  );
                                                }

                                                if (value == 'delete') {
                                                  showDeleteDialog(
                                                    pvtPeriod.id.toString(),
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
                                          "${DateTimeConverter().toJson(pvtPeriod.startDate)} - ${DateTimeConverter().toJson(pvtPeriod.endDate)}",
                                        ),
                                        const SizedBox(height: 4),
                                        Text(pvtPeriod.period ?? ''),
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
      builder: (ctx) {
        return DeleteDialog(
          title: 'Performance Validation Tool Period',
          itemName: 'performance validation tool period',
          onDelete: () async {
            Navigator.pop(ctx);

            try {
              await _performanceValidationToolPeriodService
                  .deleteValidationPeriod(id);
              await fetchValidationPeriod();
              if (mounted) {
                MotionToast.success(
                  description: Text(
                    'Performance validation tool period deleted successfully',
                    style: GoogleFonts.plusJakartaSans(),
                  ),
                ).show(context);
              }
            } catch (_) {
              MotionToast.error(
                description: Text(
                  'Failed to delete performance validation tool period',
                ),
              ).show(context);
            }
          },
        );
      },
    );
  }
}
