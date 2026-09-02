// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/performance_governance_system/pgs_evaluator_offices/models/evaluator_offices.dart';
import 'package:imis/performance_governance_system/pgs_evaluator_offices/services/evaluator_offices_service.dart';
import 'package:imis/office/models/office.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/filter_search_result_util.dart';
import 'package:imis/utils/pagination_util.dart';
import 'package:imis/widgets/common/pagination_controls.dart';
import 'package:imis/widgets/common/search_dropdown.dart';
import 'package:imis/widgets/dialog/delete_dialog.dart';
import 'package:motion_toast/motion_toast.dart';
import '../../../common_services/common_service.dart';
import '../../../user/models/user.dart';

class EvaluatorOfficesPage extends StatefulWidget {
  const EvaluatorOfficesPage({super.key});

  @override
  State<EvaluatorOfficesPage> createState() => EvaluatorOfficesPageState();
}

class EvaluatorOfficesPageState extends State<EvaluatorOfficesPage> {
  final FocusNode isSearchfocus = FocusNode();
  final _commonService = CommonService(Dio());
  final _evaluatorOfficeService = EvaluatorOfficesService(Dio());
  final _paginationUtils = PaginationUtil(Dio());
  final dio = Dio();
  TextEditingController searchController = TextEditingController();
  String? _selectedUser;
  String? _selectedOffice;
  List<User> userList = [];
  List<Office> officenameList = [];
  List<EvaluatorOffices> evaluatorOfficeList = [];
  List<EvaluatorOffices> filteredList = [];
  int _currentPage = 1;
  final int _pageSize = 15;
  int _totalCount = 0;
  late FilterSearchResultUtil<EvaluatorOffices> evaluatorOfficeSearchUtil;
  bool _isLoading = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    isSearchfocus.addListener(() {
      setState(() {});
    });
    fetchEvaluatorOffice();
    evaluatorOfficeSearchUtil = FilterSearchResultUtil<EvaluatorOffices>(
      paginationUtils: _paginationUtils,
      endpoint: ApiEndpoint().evaluatorOffices,
      pageSize: _pageSize,
      fromJson: (json) => EvaluatorOffices.fromJson(json),
    );
    () async {
      final users = await _commonService.fetchUsers();
      final offices = await _commonService.fetchAlloffices();

      if (!mounted) return;
      setState(() {
        officenameList = offices;
        _selectedOffice = offices.isNotEmpty ? offices[0].id.toString() : null;

        userList = users;
      });
      displayOfficeName();
    }();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    isSearchfocus.dispose();
    super.dispose();
  }

  Future<void> fetchEvaluatorOffice({int? page, String? searchQuery}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);
    final targetPage = page ?? _currentPage;

    try {
      final pageList = await _evaluatorOfficeService.getEvalutorsOffice(
        page: targetPage,
        pageSize: _pageSize,
        searchQuery: searchQuery,
      );

      if (mounted) {
        setState(() {
          _currentPage = pageList.page;
          _totalCount = pageList.totalCount;
          evaluatorOfficeList = pageList.items;
          filteredList = List.from(evaluatorOfficeList);
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
    final results = await evaluatorOfficeSearchUtil.filter(query, (
      evaluatorOffice,
      search,
    ) {
      final user = userList.firstWhere(
        (u) => u.id.toString() == evaluatorOffice.userId.toString(),
        orElse: () => User(id: '', fullName: '', position: ''),
      );

      final office = officenameList.firstWhere(
        (o) => o.id == evaluatorOffice.officeId,
        orElse:
            () => Office(
              id: 0,
              name: '',
              officeTypeId: 0,
              parentOfficeId: 0,
              isActive: true,
              isDeleted: false,
            ),
      );

      final lowerSearch = search.toLowerCase().trim();
      return user.fullName.toLowerCase().contains(lowerSearch) ||
          office.name.toLowerCase().contains(lowerSearch);
    });

    setState(() {
      filteredList = results;
    });
  }

  void displayOfficeName() {
    for (var userOffice in evaluatorOfficeList) {
      officenameList.firstWhere(
        (office) => office.id == userOffice.officeId,
        orElse:
            () => Office(
              id: 0,
              name: '',
              officeTypeId: 0,
              parentOfficeId: 0,
              isActive: true,
              isDeleted: false,
            ),
      );
    }
  }

  void showFormDialog({
    String? id,
    String? selectedUser,
    String? selectedOffice,
    String? selectedOfficeName,
  }) {
    _selectedUser = selectedUser;
    _selectedOffice = selectedOffice;
    final isEdit = id != null;
    final selectOfficeName = selectedOfficeName;
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
                width: 480,
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
                                isEdit
                                    ? 'Manage Evaluator Office'
                                    : 'Create Evaluator Office',
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 17,
                                  color: kText,
                                ),
                              ),
                              Text(
                                isEdit
                                    ? 'Update evaluator to this office'
                                    : 'Assign evaluator to an office',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  color: kMuted,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Divider(color: kBorder, height: 1),
                      SizedBox(height: 20),
                      SearchDropdown<User?>(
                        label: 'User',
                        hintText: 'Search user...',
                        items: userList,
                        itemAsString: (user) => user?.fullName ?? '',
                        selectedItem:
                            _selectedUser == null
                                ? null
                                : userList.firstWhere(
                                  (user) => user.id == _selectedUser,
                                  orElse:
                                      () => User(
                                        id: '',
                                        fullName: '',
                                        position: '',
                                      ),
                                ),
                        onChanged:
                            (value) =>
                                setStateDialog(() => _selectedUser = value?.id),
                        validator:
                            (value) =>
                                value == null ? 'Please select a user' : null,
                      ),
                      gap14px,
                      SearchDropdown<Office?>(
                        label: 'Office',
                        hintText: 'Search office...',
                        items: officenameList,
                        itemAsString: (u) => u?.name ?? '',
                        selectedItem:
                            _selectedOffice == null
                                ? null
                                : officenameList.firstWhere(
                                  (item) =>
                                      item.id.toString() == _selectedOffice,
                                  orElse:
                                      () => Office(
                                        id:
                                            int.tryParse(
                                              _selectedOffice ?? '0',
                                            ) ??
                                            0,
                                        name: selectOfficeName ?? '',
                                        officeTypeId: 0,
                                        parentOfficeId: 0,
                                        isActive: true,
                                        isDeleted: false,
                                      ),
                                ),
                        onChanged:
                            (value) => setStateDialog(
                              () => _selectedOffice = value?.id.toString(),
                            ),
                        validator:
                            (value) =>
                                value == null
                                    ? 'Please select an office'
                                    : null,
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
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
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
                                                    ? 'Are you sure you want to update this evaluator office?'
                                                    : 'Are you sure you want to save this evaluator office',
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
                                  final evaluatorOffice = EvaluatorOffices(
                                    id: int.tryParse(id ?? '0') ?? 0,
                                    userId: _selectedUser,
                                    officeId:
                                        int.tryParse(_selectedOffice ?? '0') ??
                                        0,
                                    officeName: '',
                                    isDeleted: false,
                                  );
                                  await _evaluatorOfficeService
                                      .addEvaluatorsOffice(evaluatorOffice);
                                  setState(() {
                                    fetchEvaluatorOffice();
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
              "Evaluator Office Information",
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
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                "User",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Office",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),

                            Expanded(
                              flex: 3,
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
                                  final evaluatorOffice = filteredList[index];
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
                                            child: Text(
                                              "$itemNumber",
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              evaluatorOffice.userFullName ??
                                                  '',
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              evaluatorOffice.officeName ?? '',
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Row(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                    size: 16,
                                                    Icons.edit_outlined,
                                                  ),
                                                  onPressed: () {
                                                    showFormDialog(
                                                      id:
                                                          evaluatorOffice.id
                                                              .toString(),
                                                      selectedUser:
                                                          evaluatorOffice.userId
                                                              .toString(),
                                                      selectedOffice:
                                                          evaluatorOffice
                                                              .officeId
                                                              .toString(),
                                                      selectedOfficeName:
                                                          evaluatorOffice
                                                              .officeName,
                                                    );
                                                  },
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
                                                        evaluatorOffice.id
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
                                              onSelected: (value) {
                                                if (value == 'edit') {
                                                  showFormDialog(
                                                    id:
                                                        evaluatorOffice.id
                                                            .toString(),
                                                    selectedUser:
                                                        evaluatorOffice.userId
                                                            .toString(),
                                                    selectedOffice:
                                                        evaluatorOffice.officeId
                                                            .toString(),
                                                  );
                                                }
                                                if (value == 'delete') {
                                                  showDeleteDialog(
                                                    evaluatorOffice.id
                                                        .toString(),
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
                                                            size: 16,
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
                                          evaluatorOffice.userFullName ?? '',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        const SizedBox(height: 4),

                                        Text(
                                          evaluatorOffice.officeName ?? '',
                                          style: TextStyle(fontSize: 12),
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
                            onPageChanged:
                                (page) => fetchEvaluatorOffice(page: page),
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
            title: 'Evaluator Office ',
            itemName: 'evaluator office',
            onDelete: () async {
              Navigator.pop(ctx);
              try {
                await _evaluatorOfficeService.deleteEvaluatorsOffice(id);
                await fetchEvaluatorOffice();
                if (mounted) {
                  MotionToast.success(
                    toastAlignment: Alignment.topCenter,
                    description: Text(
                      'evaluator office deleted successfully',
                      style: GoogleFonts.plusJakartaSans(),
                    ),
                  ).show(context);
                }
              } catch (_) {
                MotionToast.error(
                  toastAlignment: Alignment.topCenter,
                  description: Text(
                    'Failed to delete evaluator office',
                    style: GoogleFonts.plusJakartaSans(),
                  ),
                );
              }
            },
          ),
    );
  }
}
