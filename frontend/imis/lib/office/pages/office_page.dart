// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/common_services/common_service.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/office/models/office.dart';
import 'package:imis/office/services/office_service.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/filter_search_result_util.dart';
import 'package:imis/utils/pagination_util.dart';
import 'package:imis/widgets/common/pagination_controls.dart';
import 'package:imis/widgets/common/search_dropdown.dart';
import 'package:imis/widgets/dialog/delete_dialog.dart';
import 'package:imis/widgets/dialog/dialog_field.dart';
import 'package:motion_toast/motion_toast.dart';

class OfficePage extends StatefulWidget {
  const OfficePage({super.key});

  @override
  OfficePageState createState() => OfficePageState();
}

class OfficePageState extends State<OfficePage> {
  final _officeService = OfficeService(Dio());
  final _paginationUtils = PaginationUtil(Dio());
  late FilterSearchResultUtil<Office> officeSearchUtil;
  final _formKey = GlobalKey<FormState>();

  List<Office> officeList = [];
  List<Office> filteredList = [];
  TextEditingController searchController = TextEditingController();
  final FocusNode isSearchfocus = FocusNode();

  List<Map<String, dynamic>> filteredListOfficeType = [];
  List<Map<String, dynamic>> officeTypeList = [];

  List<Map<String, dynamic>> filteredListParentOffice = [];
  List<Map<String, dynamic>> parentOfficeList = [];
  final _commonService = CommonService(Dio());

  int _currentPage = 1;
  final int _pageSize = 15;
  int _totalCount = 0;
  bool _isLoading = false;
  Timer? _debounce;
  final dio = Dio();

  Future<void> fetchOffices({int? page, String? searchQuery}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);
    final targetPage = page ?? _currentPage;

    try {
      final pageList = await _officeService.getOffice(
        page: targetPage,
        pageSize: _pageSize,
        searchQuery: searchQuery,
      );
      if (mounted) {
        setState(() {
          _currentPage = pageList.page;
          _totalCount = pageList.totalCount;
          officeList = pageList.items;
          filteredList = List.from(officeList);
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
    fetchOffices();
    officeSearchUtil = FilterSearchResultUtil<Office>(
      paginationUtils: _paginationUtils,
      endpoint: ApiEndpoint().office,
      pageSize: _pageSize,
      fromJson: (json) => Office.fromJson(json),
    );
    isSearchfocus.addListener(() {
      setState(() {});
    });
    _officeService
        .getOfficeType()
        .then((data) {
          if (mounted) {
            setState(() {
              officeTypeList =
                  data.map((officeType) => officeType.toJson()).toList();
              filteredListOfficeType = List.from(officeTypeList);
              if (filteredListOfficeType.isNotEmpty) {}
            });
          }
        })
        .catchError((error) {
          debugPrint("Failed to fetch data");
        });

    if (filteredListOfficeType.isNotEmpty) {}

    _officeService
        .getParentOffice()
        .then((data) {
          if (mounted) {
            setState(() {
              parentOfficeList = data.map((office) => office.toJson()).toList();
              filteredListParentOffice = [
                {'id': 0, 'name': 'None'},
                ...parentOfficeList,
              ];
              if (filteredListParentOffice.isNotEmpty) {}
            });
          }
        })
        .catchError((error) {
          debugPrint("Failed to fetch data");
        });
  }

  Future<void> filterSearchResults(String query) async {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () async {
      if (query.trim().isEmpty) {
        setState(() => filteredList = List.from(officeList));
        return;
      }

      try {
        final results = await _officeService.filterOffices(query.trim());
        if (mounted) {
          setState(() => filteredList = results);
        }
      } catch (e) {
        debugPrint('Office filter failed: $e');
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    isSearchfocus.dispose();
    super.dispose();
  }

  void showFormDialog({
    String? id,
    String? name,
    bool isActive = false,
    bool isDeleted = false,
    bool isRowversion = false,
    int? officeType,
    int? parentOffice,
  }) async {
    await _officeService.getParentOffice();

    TextEditingController officeController = TextEditingController(text: name);
    int? selectedOfficeType = officeType;
    int? selectedParentOffice = parentOffice;
    final isEdit = id != null;

    final List<Map<String, dynamic>> officeTypeOptions = [
      {'id': null, 'name': 'None'},
      ...officeTypeList,
    ];

    final List<Map<String, dynamic>> parentOfficeOptions = [
      {'id': null, 'name': 'None'},
      ...parentOfficeList,
    ];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (ctx, setDialog) {
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
                                isEdit ? 'Edit Office' : 'Create Office',
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 17,
                                  color: kText,
                                ),
                              ),
                              Text(
                                isEdit
                                    ? 'Update office details'
                                    : 'Add a new office',
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
                        label: 'Office Name',
                        controller: officeController,
                      ),
                      SizedBox(height: 8),
                      SearchDropdown<Map<String, dynamic>>(
                        label: 'Office Type',
                        hintText: 'Select Office Type',
                        items: officeTypeOptions,
                        itemAsString: (item) => item['name'],
                        selectedItem: officeTypeOptions.firstWhere(
                          (item) => item['id'] == selectedOfficeType,
                          orElse: () => officeTypeOptions.first,
                        ),
                        onChanged: (value) {
                          setDialog(() => selectedOfficeType = value?['id']);
                        },
                      ),
                      SizedBox(height: 8),

                      SearchDropdown<Map<String, dynamic>>(
                        label: 'Parent Office',
                        hintText: 'Select Parent Office',
                        items: parentOfficeOptions,
                        itemAsString: (item) => item['name'],
                        selectedItem: parentOfficeOptions.firstWhere(
                          (item) => item['id'] == selectedParentOffice,
                          orElse: () => parentOfficeOptions.first,
                        ),
                        onChanged: (value) {
                          setDialog(() => selectedParentOffice = value?['id']);
                        },
                      ),

                      const SizedBox(height: 24),
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
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadiusGeometry.circular(
                                    8,
                                  ),
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
                                                  color: primaryColor,
                                                  size: 26,
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
                                                    ? 'Are you sure you want to update this office?'
                                                    : 'Are you sure you want to save this office?',
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
                                                      style:
                                                          OutlinedButton.styleFrom(
                                                            side: BorderSide(
                                                              color: kBorder,
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
                                if (confirmed != true) return;
                                final office = Office(
                                  id: int.tryParse(id ?? '0') ?? 0,
                                  name: officeController.text,
                                  officeTypeId: selectedOfficeType,
                                  parentOfficeId: selectedParentOffice,
                                  isDeleted: false,
                                  isActive: true,
                                );
                                await _officeService.createOrUpdateOffice(
                                  office,
                                );
                                setState(() {
                                  fetchOffices();
                                });
                                MotionToast.success(
                                  toastAlignment: Alignment.topCenter,
                                  description: Text('Saved successfully'),
                                ).show(context);
                                Navigator.pop(context);
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
              "Office Information",
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
                                "Office",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Office Type",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Parent Office",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),

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
                                  final office = filteredList[index];
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
                                            flex: 3,
                                            child: Text(office.name),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              _officeService.getOfficeTypeName(
                                                office.officeTypeId ?? 0,
                                                officeTypeList,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              _officeService
                                                  .getParentOfficeName(
                                                    office.parentOfficeId,
                                                    parentOfficeList,
                                                  ),
                                            ),
                                          ),

                                          Expanded(
                                            flex: 3,
                                            child: Row(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                    size: 18,
                                                    Icons.edit_outlined,
                                                  ),
                                                  onPressed: () async {
                                                    try {
                                                      final fetchedOffice =
                                                          await _commonService
                                                              .getOfficeById(
                                                                office.id
                                                                    .toString(),
                                                              );
                                                      showFormDialog(
                                                        id:
                                                            fetchedOffice.id
                                                                .toString(),
                                                        name:
                                                            fetchedOffice.name,
                                                        officeType:
                                                            fetchedOffice
                                                                .officeTypeId,
                                                        parentOffice:
                                                            fetchedOffice
                                                                .parentOfficeId,
                                                      );
                                                    } catch (e) {
                                                      debugPrint(
                                                        'Failed to fetch office: $e',
                                                      );
                                                      if (mounted) {
                                                        MotionToast.error(
                                                          toastAlignment:
                                                              Alignment
                                                                  .topCenter,
                                                          description: Text(
                                                            'Failed to load office details',
                                                          ),
                                                        ).show(context);
                                                      }
                                                    }
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
                                                        office.id.toString(),
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
                                              onSelected: (value) async {
                                                if (value == 'edit') {
                                                  try {
                                                    final fetchedOffice =
                                                        await _commonService
                                                            .getOfficeById(
                                                              office.id
                                                                  .toString(),
                                                            );
                                                    showFormDialog(
                                                      id:
                                                          fetchedOffice.id
                                                              .toString(),
                                                      name: fetchedOffice.name,
                                                      officeType:
                                                          fetchedOffice
                                                              .officeTypeId,
                                                      parentOffice:
                                                          fetchedOffice
                                                              .parentOfficeId,
                                                    );
                                                  } catch (e) {
                                                    debugPrint(
                                                      'Failed to fetch office: $e',
                                                    );
                                                    if (mounted) {
                                                      MotionToast.error(
                                                        toastAlignment:
                                                            Alignment.topCenter,
                                                        description: Text(
                                                          'Failed to load office details',
                                                        ),
                                                      ).show(context);
                                                    }
                                                  }
                                                }

                                                if (value == 'delete') {
                                                  showDeleteDialog(
                                                    office.id.toString(),
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

                                        Text("Office: ${office.name}"),
                                        const SizedBox(height: 4),

                                        Text(
                                          "Office Type: ${_officeService.getOfficeTypeName(office.officeTypeId ?? 0, officeTypeList)}",
                                        ),
                                        const SizedBox(height: 4),

                                        Text(
                                          "Parent Office: ${_officeService.getParentOfficeName(office.parentOfficeId, parentOfficeList)}",
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
                            onPageChanged: (page) => fetchOffices(page: page),
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

  void showDeleteDialog(String id) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder:
          (ctx) => DeleteDialog(
            title: 'Office',
            itemName: 'office',
            onDelete: () async {
              Navigator.pop(ctx);
              try {
                await _officeService.deleteOffice(id);
                await fetchOffices();
                if (mounted) {
                  MotionToast.success(
                    toastAlignment: Alignment.topCenter,
                    description: Text(
                      'office deleted successfully',
                      style: GoogleFonts.plusJakartaSans(),
                    ),
                  ).show(context);
                }
              } catch (_) {
                MotionToast.error(
                  toastAlignment: Alignment.topCenter,
                  description: Text(
                    'Failed to delete office',
                    style: GoogleFonts.plusJakartaSans(),
                  ),
                );
              }
            },
          ),
    );
  }
}
