// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/auditor/services/auditor_service.dart';
import 'package:imis/common_services/common_service.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/auditor/models/auditor.dart';
import 'package:imis/user/models/user.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/filter_search_result_util.dart';
import 'package:imis/utils/pagination_util.dart';
import 'package:imis/widgets/common/pagination_controls.dart';
import 'package:imis/widgets/common/search_dropdown.dart';
import 'package:imis/widgets/dialog/delete_dialog.dart';
import 'package:imis/widgets/dialog/dialog_field.dart';
import 'package:motion_toast/motion_toast.dart';

class AuditorPage extends StatefulWidget {
  const AuditorPage({super.key});

  @override
  AuditorMainPageState createState() => AuditorMainPageState();
}

class AuditorMainPageState extends State<AuditorPage> {
  final _auditorService = AuditorService(Dio());
  final _paginationUtils = PaginationUtil(Dio());
  late FilterSearchResultUtil<Auditor> auditorSearchUtil;
  final _commonService = CommonService(Dio());

  List<Auditor> auditorList = [];
  List<Auditor> filteredList = [];
  TextEditingController searchController = TextEditingController();
  final FocusNode isSearchfocus = FocusNode();

  List<User> userList = [];
  String? _selectedUserId;

  int _currentPage = 1;
  final int _pageSize = 15;
  int _totalCount = 0;
  bool _isLoading = false;
  // Timer? _debounce;
  final dio = Dio();

  Future<void> fetchAuditors({int? page, String? searchQuery}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);
    final targetPage = page ?? _currentPage;

    try {
      final pageList = await _auditorService.getAuditor(
        page: targetPage,
        pageSize: _pageSize,
        searchQuery: searchQuery,
      );

      if (mounted) {
        setState(() {
          _currentPage = pageList.page;
          _totalCount = pageList.totalCount;
          auditorList = pageList.items;
          filteredList = List.from(auditorList);
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
  void initState() {
    super.initState();
    fetchAuditors();
    auditorSearchUtil = FilterSearchResultUtil<Auditor>(
      paginationUtils: _paginationUtils,
      endpoint: ApiEndpoint().auditor,
      pageSize: _pageSize,
      fromJson: (json) => Auditor.fromJson(json),
    );
    isSearchfocus.addListener(() {
      setState(() {});
    });

    () async {
      final users = await _commonService.fetchUsers();

      if (!mounted) return;

      setState(() {
        userList = users;
        _selectedUserId = users.isNotEmpty ? users[0].id : null;
      });
    }();
  }

  @override
  void dispose() {
    // _debounce?.cancel();
    isSearchfocus.dispose();
    super.dispose();
  }

  Future<void> filterSearchResults(String query) async {
    final results = await auditorSearchUtil.filter(query, (auditor, search) {
      final user = userList.firstWhere(
        (u) => u.id.toString() == auditor.userId.toString(),
        orElse: () => User(id: '', fullName: 'Unknown', position: ''),
      );

      return (auditor.name ?? '').toLowerCase().contains(
            search.toLowerCase(),
          ) ||
          (user.fullName).toLowerCase().contains(search.toLowerCase());
    });

    setState(() {
      filteredList = results;
    });
  }

  void showDeleteDialog(String id) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder:
          (ctx) => DeleteDialog(
            title: 'Auditor',
            itemName: 'auditor',
            onDelete: () async {
              Navigator.pop(ctx);
              try {
                await _auditorService.deleteAuditor(id);
                await fetchAuditors();
                if (mounted) {
                  MotionToast.success(
                    toastAlignment: Alignment.topCenter,
                    description: Text(
                      'auditor deleted successfully',
                      style: GoogleFonts.plusJakartaSans(),
                    ),
                  ).show(context);
                }
              } catch (_) {
                MotionToast.error(
                  toastAlignment: Alignment.topCenter,
                  description: Text(
                    'Failed to delete auditor',
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
    bool isDeleted = false,
    String rowVersion = "",
    String? name,
    bool isActive = false,
    String? selectedUserId,
  }) {
    TextEditingController auditorController = TextEditingController(text: name);
    _selectedUserId = selectedUserId;
    final isEdit = id != null;
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                width: 450,
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
                  key: formKey,
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
                            child: Icon(
                              Icons.business,
                              color: primaryColor,
                              size: 22,
                            ),
                          ),
                          SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isEdit ? 'Edit Auditor' : 'Create Auditor',
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 17,
                                  color: kText,
                                ),
                              ),
                              Text(
                                isEdit
                                    ? 'Update auditor details'
                                    : 'Add a new auditor',
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
                        label: 'Auditor',
                        controller: auditorController,
                      ),
                      SizedBox(height: 20),
                      SearchDropdown<User?>(
                        label: 'User',
                        hintText: 'Search user...',
                        items: userList,
                        itemAsString: (u) => u?.fullName ?? '',
                        selectedItem: userList.cast<User?>().firstWhere(
                          (u) => u?.id == _selectedUserId,
                          orElse: () => null,
                        ),
                        onChanged:
                            (value) => setStateDialog(
                              () => _selectedUserId = value?.id,
                            ),
                        validator:
                            (value) =>
                                value == null ? 'Please select a user' : null,
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
                                  'Active Auditor',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: kText,
                                  ),
                                ),
                                Text(
                                  'Currently active as Auditor',
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
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: kBorder),
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadiusGeometry.circular(
                                    8,
                                  ),
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
                          SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              label: Text(
                                isEdit ? 'Update' : 'Save',
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                elevation: 0,
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () async {
                                if (!formKey.currentState!.validate()) return;
                                final confirmed = await showDialog<bool>(
                                  context: context,
                                  builder:
                                      (ctx) => Dialog(
                                        backgroundColor: Colors.transparent,
                                        child: Container(
                                          width: 340,
                                          padding: EdgeInsets.all(24),
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
                                                offset: Offset(0, 12),
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
                                                child: Icon(
                                                  Icons.help_outline_rounded,
                                                ),
                                              ),
                                              SizedBox(height: 14),
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
                                                    ? 'Are your sure you want to save update this auditor'
                                                    : 'Are you you want to save this auditor',
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                      fontSize: 13,
                                                      color: kMuted,
                                                      height: 1.5,
                                                    ),
                                                textAlign: TextAlign.center,
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: OutlinedButton(
                                                      onPressed:
                                                          () => Navigator.pop(
                                                            ctx,
                                                            false,
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
                                                            EdgeInsets.symmetric(
                                                              vertical: 11,
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
                                  final auditor = Auditor(
                                    id: int.tryParse(id ?? '0') ?? 0,
                                    name: auditorController.text,
                                    isDeleted: isDeleted,
                                    rowVersion: rowVersion,
                                    isActive: isActive,
                                    userId: _selectedUserId,
                                  );
                                  await _auditorService.addOrUpdateAuditor(
                                    auditor,
                                  );
                                  setState(() {
                                    fetchAuditors();
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
            // return AlertDialog(
            //   backgroundColor: mainBgColor,
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(12.0),
            //   ),
            //   titlePadding: EdgeInsets.zero,
            //   title: Container(
            //     width: double.infinity,
            //     padding: const EdgeInsets.symmetric(
            //       vertical: 16,
            //       horizontal: 20,
            //     ),
            //     decoration: BoxDecoration(
            //       color: primaryLightColor,
            //       borderRadius: BorderRadius.only(
            //         topLeft: Radius.circular(12),
            //         topRight: Radius.circular(12),
            //       ),
            //     ),
            //     child: Text(
            //       id == null ? 'Create Auditor' : 'Manage Auditor',
            //       textAlign: TextAlign.center,
            //       style: TextStyle(
            //         fontWeight: FontWeight.bold,
            //         fontSize: 18,
            //         color: Colors.white,
            //       ),
            //     ),
            //   ),

            //   content: Form(
            //     key: _formKey,
            //     child: Column(
            //       mainAxisSize: MainAxisSize.min,
            //       children: [
            //         SizedBox(
            //           width: 450,
            //           child: TextFormField(
            //             controller: auditorController,
            //             decoration: InputDecoration(
            //               labelText: 'Auditor Name',
            //               focusColor: primaryColor,
            //               floatingLabelStyle: TextStyle(color: primaryColor),
            //               border: OutlineInputBorder(),
            //               focusedBorder: const OutlineInputBorder(
            //                 borderSide: BorderSide(color: primaryColor),
            //               ),
            //             ),
            //             validator: (value) {
            //               if (value == null || value.trim().isEmpty) {
            //                 return 'Please fill out this field';
            //               }
            //               return null;
            //             },
            //           ),
            //         ),
            //         gap14px,
            //         SizedBox(
            //           width: 450,
            //           child: DropdownSearch<User?>(
            //             popupProps: PopupProps.menu(
            //               showSearchBox: true,
            //               searchFieldProps: TextFieldProps(
            //                 decoration: InputDecoration(
            //                   hintText: 'Search User Name...',
            //                   filled: true,
            //                   fillColor: mainBgColor,
            //                   prefixIcon: Icon(Icons.search),
            //                   border: OutlineInputBorder(
            //                     borderRadius: BorderRadius.circular(8),
            //                   ),
            //                   focusedBorder: OutlineInputBorder(
            //                     borderSide: BorderSide(color: primaryColor),
            //                   ),
            //                 ),
            //               ),
            //               itemBuilder:
            //                   (context, user, isSelected) => ListTile(
            //                     tileColor: mainBgColor,
            //                     title: Text(user?.fullName ?? ''),
            //                   ),
            //             ),
            //             items: userList,
            //             itemAsString: (u) => u?.fullName ?? '',
            //             selectedItem: userList.cast<User?>().firstWhere(
            //               (u) => u?.id == _selectedUserId,
            //               orElse: () => null,
            //             ),
            //             onChanged:
            //                 (value) =>
            //                     setState(() => _selectedUserId = value?.id),
            //             validator: (value) {
            //               if (value == null) {
            //                 return 'Please select a user';
            //               }
            //               return null;
            //             },
            //             dropdownDecoratorProps: DropDownDecoratorProps(
            //               dropdownSearchDecoration: InputDecoration(
            //                 labelText: 'Assign User',
            //                 filled: true,
            //                 fillColor: mainBgColor,
            //                 floatingLabelBehavior: FloatingLabelBehavior.never,
            //                 border: OutlineInputBorder(
            //                   borderRadius: BorderRadius.circular(8),
            //                 ),
            //                 focusedBorder: OutlineInputBorder(
            //                   borderSide: BorderSide(color: primaryColor),
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ),
            //         gap14px,

            //         CustomToggle(
            //           label: "Active",
            //           value: isActive,
            //           activeColor: primaryColor,
            //           inactiveColor: Colors.grey,
            //           onChanged: (val) {
            //             setState(() {
            //               isActive = val;
            //             });
            //           },
            //         ),
            //       ],
            //     ),
            //   ),
            //   actions: [
            //     TextButton(
            //       onPressed: () => Navigator.pop(context),
            //       style: ElevatedButton.styleFrom(
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(4),
            //         ),
            //       ),
            //       child: Text('Cancel', style: TextStyle(color: primaryColor)),
            //     ),
            //     ElevatedButton(
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: primaryColor,
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(4),
            //         ),
            //       ),
            //       onPressed: () async {
            //         if (_formKey.currentState!.validate()) {
            //           bool? confirmAction = await showDialog<bool>(
            //             context: context,
            //             builder: (context) {
            //               return AlertDialog(
            //                 title: Text(
            //                   id == null ? "Confirm Save" : "Confirm Update",
            //                 ),
            //                 content: Text(
            //                   id == null
            //                       ? "Are you sure you want to save this record?"
            //                       : "Are you sure you want to update this record?",
            //                 ),
            //                 actions: [
            //                   TextButton(
            //                     onPressed: () => Navigator.pop(context, false),
            //                     child: Text(
            //                       "No",
            //                       style: TextStyle(color: primaryColor),
            //                     ),
            //                   ),
            //                   TextButton(
            //                     onPressed: () {
            //                       if (_formKey.currentState!.validate()) {
            //                         Navigator.pop(context, true);
            //                       }
            //                     },
            //                     child: Text(
            //                       "Yes",
            //                       style: TextStyle(color: primaryColor),
            //                     ),
            //                   ),
            //                 ],
            //               );
            //             },
            //           );
            //           if (confirmAction == true) {
            //             final auditor = Auditor(
            //               id: int.tryParse(id ?? '0') ?? 0,
            //               name: auditorController.text,
            //               isDeleted: isDeleted,
            //               rowVersion: rowVersion,
            //               isActive: isActive,
            //               userId: _selectedUserId,
            //             );
            //             await _auditorService.addOrUpdateAuditor(auditor);
            //             setState(() {
            //               fetchAuditors();
            //             });
            //             MotionToast.success(
            //               toastAlignment: Alignment.topCenter,
            //               description: Text('Saved successfully'),
            //             ).show(context);
            //             Navigator.pop(context);
            //           }
            //         }
            //       },
            //       child: Text(
            //         id == null ? 'Save' : 'Update',
            //         style: TextStyle(color: Colors.white),
            //       ),
            //     ),
            //   ],
            // );
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
              "Auditor's Information",
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
                              flex: 3,
                              child: Text(
                                "Auditor",
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
                                  int itemNumber =
                                      ((_currentPage - 1) * _pageSize) +
                                      index +
                                      1;
                                  final auditor = filteredList[index];

                                  final matchUserName = userList.firstWhere(
                                    (user) => user.id == auditor.userId,
                                    orElse:
                                        () => User(
                                          id: '',
                                          fullName: '',
                                          position: '',
                                        ),
                                  );
                                  final userName = matchUserName.fullName;

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
                                            flex: 3,
                                            child: Text(userName),
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
                                                            auditor.id
                                                                .toString(),
                                                        name:
                                                            auditor.name ?? '',
                                                        selectedUserId:
                                                            auditor.userId ??
                                                            '',
                                                        isActive:
                                                            auditor.isActive,
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
                                                        auditor.id.toString(),
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
                                                    id: auditor.id.toString(),
                                                    name: auditor.name ?? '',
                                                    selectedUserId:
                                                        auditor.userId ?? '',
                                                    isActive: auditor.isActive,
                                                  );
                                                }

                                                if (value == 'delete') {
                                                  showDeleteDialog(
                                                    auditor.id.toString(),
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
                                        Text("Name: $userName"),
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
                            onPageChanged: (page) => fetchAuditors(page: page),
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
