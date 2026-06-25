// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/performance_governance_system/process_core_support/models/key_result_area.dart';
import 'package:imis/performance_governance_system/process_core_support/services/process_core_support_service.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/filter_search_result_util.dart';
import 'package:imis/utils/pagination_util.dart';
import 'package:imis/widgets/common/pagination_controls.dart';
import 'package:imis/widgets/dialog/delete_dialog.dart';
import 'package:imis/widgets/dialog/dialog_field.dart';
import 'package:motion_toast/motion_toast.dart';

class ProcessCoreSupportPage extends StatefulWidget {
  const ProcessCoreSupportPage({super.key});

  @override
  ProcessCoreSupportPageState createState() => ProcessCoreSupportPageState();
}

class ProcessCoreSupportPageState extends State<ProcessCoreSupportPage> {
  final _formKey = GlobalKey<FormState>();
  final _processCoreSupportService = ProcessCoreSupportService(Dio());

  final _paginationUtils = PaginationUtil(Dio());
  late FilterSearchResultUtil<KeyResultArea> kraSearchUtil;
  List<KeyResultArea> kraList = [];
  List<KeyResultArea> filteredList = [];
  TextEditingController searchController = TextEditingController();
  int _currentPage = 1;
  final int _pageSize = 15;
  int _totalCount = 0;
  bool _isLoading = false;
  final FocusNode isSearchfocus = FocusNode();
  final dio = Dio();
  @override
  void initState() {
    super.initState();
    fetchKRA();
    kraSearchUtil = FilterSearchResultUtil<KeyResultArea>(
      paginationUtils: _paginationUtils,
      endpoint: ApiEndpoint().keyresult,
      pageSize: _pageSize,
      fromJson: (json) => KeyResultArea.fromJson(json),
    );
    isSearchfocus.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    isSearchfocus.dispose();
    super.dispose();
  }

  Future<void> fetchKRA({int page = 1, String? searchQuery}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final pageList = await _processCoreSupportService.getKRA(
        page: page,
        pageSize: _pageSize,
        searchQuery: searchQuery,
      );

      if (mounted) {
        setState(() {
          _currentPage = pageList.page;
          _totalCount = pageList.totalCount;
          kraList = pageList.items;
          filteredList = List.from(kraList);
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

  Future<void> filterSearchResults(String query) async {
    final results = await kraSearchUtil.filter(
      query,
      (kra, search) => (kra.name).toLowerCase().contains(search.toLowerCase()),
    );

    setState(() {
      filteredList = results;
    });
  }

  void showDeleteDialog(String id) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) {
        return DeleteDialog(
          title: 'Process (Core&Support)',
          itemName: 'process (core&support)',

          onDelete: () async {
            Navigator.pop(ctx);
            try {
              await _processCoreSupportService.deleteKra(id);
              fetchKRA();
              if (mounted) {
                MotionToast.success(
                  toastAlignment: Alignment.topCenter,
                  description: Text(
                    'Process deleted sucessfully',
                    style: GoogleFonts.plusJakartaSans(),
                  ),
                ).show(context);
              }
            } catch (_) {
              MotionToast.error(
                toastAlignment: Alignment.topCenter,
                description: Text(
                  'Failed to delete process (core&support)',
                  style: GoogleFonts.plusJakartaSans(),
                ),
              );
            }
          },
        );
      },
    );
  }

  void showFormDialog({
    String? id,
    String? name,
    String? remarks,
    String? strategicObjective,
  }) {
    final nameController = TextEditingController(text: name);
    final remarksController = TextEditingController(text: remarks);
    final strategicObjectiveController = TextEditingController(
      text: strategicObjective,
    );
    final isEdit = id != null;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 420,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: kSurface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 32,
                  offset: const Offset(0, 12),
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
                          Icons.track_changes_rounded,
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
                                ? 'Edit Process (Core & Support)'
                                : 'Create Process (Core & Support)',
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w700,
                              fontSize: 17,
                              color: kText,
                            ),
                          ),
                          Text(
                            isEdit
                                ? 'Update Process (Core & Support)'
                                : 'Add a new Process (Core & Support)',
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

                  dialogField(
                    label: 'KRA Name',
                    controller: nameController,
                    validator:
                        (v) =>
                            (v == null || v.trim().isEmpty)
                                ? 'Please fill out this field'
                                : null,
                  ),
                  const SizedBox(height: 12),
                  dialogField(label: 'Remarks', controller: remarksController),
                  const SizedBox(height: 12),
                  dialogField(
                    label: 'Strategic Contribution',
                    controller: strategicObjectiveController,
                  ),
                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: kBorder),
                            padding: const EdgeInsets.symmetric(vertical: 12),
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
                            padding: const EdgeInsets.symmetric(vertical: 12),
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
                                        borderRadius: BorderRadius.circular(16),
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
                                              color: primaryColor.withValues(
                                                alpha: 0.1,
                                              ),
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
                                            style: GoogleFonts.plusJakartaSans(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16,
                                              color: kText,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            isEdit
                                                ? 'Are you sure you want to update this record?'
                                                : 'Are you sure you want to save this record?',
                                            style: GoogleFonts.plusJakartaSans(
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
                                                              FontWeight.w600,
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
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w600,
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
                              final kra = KeyResultArea(
                                int.tryParse(id ?? '0') ?? 0,
                                nameController.text,
                                remarksController.text,
                                strategicObjectiveController.text,
                                false,
                              );
                              await _processCoreSupportService
                                  .createOrUpdateKra(kra);
                              setState(() => fetchKRA());
                              if (!context.mounted) return;
                              MotionToast.success(
                                toastAlignment: Alignment.topCenter,
                                description: const Text('Saved successfully'),
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
  }

  // void showFormDialog({
  //   String? id,
  //   String? name,
  //   String? remarks,
  //   String? strategicObjective,
  // }) {
  //   TextEditingController nameController = TextEditingController(text: name);
  //   TextEditingController remarksController = TextEditingController(
  //     text: remarks,
  //   );

  //   TextEditingController strategicObjectiveController = TextEditingController(
  //     text: strategicObjective,
  //   );

  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) {
  //       return AlertDialog(
  //         backgroundColor: mainBgColor,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(12.0),
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
  //             id == null ? 'Create KRA' : 'Edit KRA',
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
  //                 height: 65,
  //                 child: TextFormField(
  //                   maxLines: null,
  //                   controller: nameController,
  //                   decoration: InputDecoration(
  //                     labelText: 'KRA Name',
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
  //               gap4px,
  //               SizedBox(
  //                 width: 350,
  //                 height: 65,
  //                 child: TextFormField(
  //                   maxLines: null,
  //                   controller: remarksController,
  //                   decoration: InputDecoration(
  //                     labelText: 'Remarks',
  //                     focusColor: primaryColor,
  //                     floatingLabelStyle: TextStyle(color: primaryColor),
  //                     border: OutlineInputBorder(),
  //                     focusedBorder: const OutlineInputBorder(
  //                       borderSide: BorderSide(color: primaryColor),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               gap14px,
  //               SizedBox(
  //                 width: 350,
  //                 height: 65,
  //                 child: TextFormField(
  //                   maxLines: null,
  //                   controller: strategicObjectiveController,
  //                   decoration: InputDecoration(
  //                     labelText: 'Strategic Contribution',
  //                     focusColor: primaryColor,
  //                     floatingLabelStyle: TextStyle(color: primaryColor),
  //                     border: OutlineInputBorder(),
  //                     focusedBorder: const OutlineInputBorder(
  //                       borderSide: BorderSide(color: primaryColor),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             style: ElevatedButton.styleFrom(
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(4),
  //               ),
  //             ),
  //             child: Text('Cancel', style: TextStyle(color: primaryColor)),
  //           ),
  //           ElevatedButton(
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: primaryColor,
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(4),
  //               ),
  //             ),
  //             onPressed: () async {
  //               if (_formKey.currentState!.validate()) {
  //                 bool? confirmAction = await showDialog<bool>(
  //                   context: context,
  //                   builder: (context) {
  //                     return AlertDialog(
  //                       title: Text(
  //                         id == null ? "Confirm Save" : "Confirm Update",
  //                       ),
  //                       content: Text(
  //                         id == null
  //                             ? "Are you sure you want to save this record?"
  //                             : "Are you sure you want to update this record?",
  //                       ),
  //                       actions: [
  //                         TextButton(
  //                           onPressed: () => Navigator.pop(context, false),
  //                           child: Text(
  //                             "No",
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
  //                             "Yes",
  //                             style: TextStyle(color: primaryColor),
  //                           ),
  //                         ),
  //                       ],
  //                     );
  //                   },
  //                 );
  //                 if (confirmAction == true) {
  //                   final kra = KeyResultArea(
  //                     int.tryParse(id ?? '0') ?? 0,
  //                     nameController.text,
  //                     remarksController.text,
  //                     strategicObjectiveController.text,
  //                     false,
  //                   );
  //                   await _processCoreSupportService.createOrUpdateKra(kra);
  //                   setState(() {
  //                     fetchKRA();
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
              "Process (Core&Support) Information",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
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
                                "Core&Support",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              flex: 4,
                              child: Text(
                                "Description",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(width: 25),
                            Expanded(
                              flex: 3,
                              child: Text(
                                "Strategic Objectives",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(width: 25),
                            Expanded(
                              flex: 3,
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
                                  final process = filteredList[index];
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
                                            child: Text(process.name),
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            flex: 4,
                                            child: Text(process.remarks ?? ''),
                                          ),
                                          SizedBox(width: 25),
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              maxLines: 3,
                                              process.strategicObjective ?? '',
                                            ),
                                          ),
                                          SizedBox(width: 25),
                                          Expanded(
                                            flex: 3,
                                            child: Row(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                    size: 18,
                                                    Icons.edit_outlined,
                                                  ),
                                                  onPressed: () {
                                                    showFormDialog(
                                                      id: process.id.toString(),
                                                      name: process.name,
                                                      remarks: process.remarks,

                                                      strategicObjective:
                                                          process
                                                              .strategicObjective,
                                                    );
                                                  },
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
                                                        process.id.toString(),
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
                                              icon: const Icon(Icons.more_vert),
                                              onSelected: (value) {
                                                if (value == 'edit') {
                                                  showFormDialog(
                                                    id: process.id.toString(),
                                                    name: process.name,
                                                    remarks: process.remarks,

                                                    strategicObjective:
                                                        process
                                                            .strategicObjective,
                                                  );
                                                }

                                                if (value == 'delete') {
                                                  showDeleteDialog(
                                                    process.id.toString(),
                                                  );
                                                }
                                              },
                                              itemBuilder:
                                                  (_) => [
                                                    const PopupMenuItem(
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

                                        Text("Core&Support: ${process.name}"),
                                        const SizedBox(height: 6),

                                        Text("Description: ${process.remarks}"),
                                        const SizedBox(height: 6),

                                        Text(
                                          "Strategic Objective: ${process.strategicObjective}",
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                    ),

                    Container(
                      padding: const EdgeInsets.all(10),
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
                            onPageChanged: (page) => fetchKRA(page: page),
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
