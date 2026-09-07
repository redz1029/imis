// ignore_for_file: use_build_context_synchronously

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/common_services/common_service.dart';
import 'package:imis/performance_governance_system/pgs_servicehead_office/models/service_head_office.dart';
import 'package:imis/performance_governance_system/pgs_servicehead_office/services/service_head_office_service.dart';
import 'package:imis/user/models/user.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/office/models/office.dart';
import 'package:imis/widgets/common/pagination_controls.dart';
import 'package:imis/widgets/common/search_dropdown.dart';
import 'package:imis/widgets/dialog/delete_dialog.dart';
import 'package:motion_toast/motion_toast.dart';

class ServiceHeadOfficePage extends StatefulWidget {
  const ServiceHeadOfficePage({super.key});

  @override
  ServiceHeadOfficePageState createState() => ServiceHeadOfficePageState();
}

class ServiceHeadOfficePageState extends State<ServiceHeadOfficePage> {
  final _commonService = CommonService(Dio());
  final _serviceHeadService = ServiceHeadOfficeService(Dio());

  List<ServiceHeadOffice> serviceHeadOfficeList = [];
  List<User> userList = [];
  List<Office> officenameList = [];

  String? _selectedOfficeId;
  String? _selectedUserId;

  int _currentPage = 1;
  final int _pageSize = 15;
  int _totalCount = 0;
  bool _isLoading = false;

  final TextEditingController searchController = TextEditingController();
  final FocusNode isSearchfocus = FocusNode();

  DateTime _lastSearchRequest = DateTime.now();

  Future<void> fetchServiceHeadOffices({int page = 1, String? query}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final result = await _serviceHeadService.getPgsPeriod(
        page: page,
        pageSize: _pageSize,
        searchQuery: query,
      );

      if (mounted) {
        setState(() {
          serviceHeadOfficeList = result.items;
          _totalCount = result.totalCount;
          _currentPage = page;
        });
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchServiceHeadOffices();
    isSearchfocus.addListener(() {
      setState(() {});
    });

    () async {
      final offices = await _commonService.fetchAlloffices();
      final users = await _commonService.fetchUsers();

      if (!mounted) return;

      setState(() {
        officenameList = offices;
        userList = users;
        _selectedOfficeId =
            offices.isNotEmpty ? offices[0].id.toString() : null;
        _selectedUserId = users.isNotEmpty ? users[0].id : null;
      });
    }();
  }

  @override
  void dispose() {
    isSearchfocus.dispose();
    searchController.dispose();
    super.dispose();
  }

  void filterSearchResults(String query) async {
    final requestTime = DateTime.now();
    _lastSearchRequest = requestTime;

    await Future.delayed(const Duration(milliseconds: 350));
    if (_lastSearchRequest != requestTime) return; // a newer keystroke fired

    fetchServiceHeadOffices(
      page: 1,
      query: query.trim().isEmpty ? null : query.trim(),
    );
  }

  void showFormDialog({
    String? id,
    bool isDeleted = false,
    String? selectedUserId,
    String? selectedOfficeId,
    bool isActive = true,
    bool isOfficeHead = false,
  }) {
    _selectedUserId = selectedUserId;
    _selectedOfficeId = selectedOfficeId;
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
                                    ? 'Manage User Office'
                                    : 'Create User Office',
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 17,
                                  color: kText,
                                ),
                              ),
                              Text(
                                isEdit
                                    ? 'Update office assigned to this user'
                                    : 'Assign office to a user',
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

                      gap14px,
                      SearchDropdown<Office?>(
                        label: 'Office',
                        hintText: 'Search office...',
                        items: officenameList,
                        itemAsString: (u) => u?.name ?? '',
                        selectedItem:
                            _selectedOfficeId == null
                                ? null
                                : officenameList.firstWhereOrNull(
                                  (item) =>
                                      item.id.toString() == _selectedOfficeId,
                                ),
                        onChanged:
                            (value) => setStateDialog(
                              () => _selectedOfficeId = value?.id.toString(),
                            ),
                        validator:
                            (value) =>
                                value == null ? 'Please select office' : null,
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
                                                    ? 'Are you sure you want to update this user office?'
                                                    : 'Are you sure you want to save this user office?',
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                      fontSize: 13,
                                                      color: kMuted,
                                                      height: 1.5,
                                                    ),
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(height: 20),
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
                                if (confirmed == true) {
                                  final selectedUserId = _selectedUserId ?? '';
                                  final officeIdInt =
                                      int.tryParse(_selectedOfficeId ?? '0') ??
                                      0;

                                  final user = ServiceHeadOffice(
                                    int.tryParse(id ?? '0') ?? 0,
                                    selectedUserId,
                                    officeIdInt,
                                    false,
                                  );

                                  try {
                                    await _serviceHeadService
                                        .addOrUpdateServiceHeadOffice(user);
                                    fetchServiceHeadOffices(page: _currentPage);

                                    MotionToast.success(
                                      toastAlignment: Alignment.topCenter,
                                      description: Text(
                                        id == null
                                            ? 'Saved successfully!'
                                            : 'Updated successfully!',
                                      ),
                                    ).show(context);

                                    Navigator.pop(context);
                                  } catch (e) {
                                    MotionToast.error(
                                      toastAlignment: Alignment.topCenter,
                                      description: const Text(
                                        'Unable to save. This user may already be assigned, or this office already has a Head.',
                                      ),
                                    ).show(context);
                                  }
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
              "User's Office Information",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                SizedBox(
                  height: 36,
                  width: 250,
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
                      contentPadding: const EdgeInsets.symmetric(
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
                        child: const Row(
                          children: [
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
                              flex: 4,
                              child: Text(
                                "Name",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                "Office",
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
                              : ListView.separated(
                                itemCount: serviceHeadOfficeList.length,
                                separatorBuilder:
                                    (context, index) => Divider(
                                      height: 1,
                                      color: Colors.grey.withValues(alpha: 0.2),
                                    ),
                                itemBuilder: (context, index) {
                                  final serviceHeadOffice =
                                      serviceHeadOfficeList[index];
                                  final userName =
                                      serviceHeadOffice.userFullName ?? '';
                                  final initials =
                                      userName.trim().isNotEmpty
                                          ? userName
                                              .trim()
                                              .split(' ')
                                              .map((e) => e[0])
                                              .take(2)
                                              .join()
                                              .toUpperCase()
                                          : '?';
                                  final itemNumber =
                                      ((_currentPage - 1) * _pageSize) +
                                      index +
                                      1;

                                  if (!isMobile) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 4,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              "$itemNumber",
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 36,
                                                  height: 36,
                                                  decoration: BoxDecoration(
                                                    color: primaryColor
                                                        .withValues(alpha: 0.1),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      initials,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: primaryColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Text(
                                                    serviceHeadOffice
                                                            .userFullName ??
                                                        '',
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              serviceHeadOffice.officeName ??
                                                  '',
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Row(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.edit_outlined,
                                                    size: 16,
                                                  ),
                                                  onPressed:
                                                      () => showFormDialog(
                                                        id:
                                                            serviceHeadOffice.id
                                                                .toString(),
                                                        selectedUserId:
                                                            serviceHeadOffice
                                                                .userId,
                                                        selectedOfficeId:
                                                            serviceHeadOffice
                                                                .officeId
                                                                .toString(),
                                                      ),
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                    CupertinoIcons
                                                        .delete_simple,
                                                    size: 16,
                                                    color: Colors.redAccent,
                                                  ),
                                                  onPressed:
                                                      () => showDeleteDialog(
                                                        serviceHeadOffice.id
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

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                      horizontal: 4,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 36,
                                          height: 36,
                                          decoration: BoxDecoration(
                                            color: primaryColor.withValues(
                                              alpha: 0.1,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              initials,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: primaryColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                serviceHeadOffice
                                                        .userFullName ??
                                                    '',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                serviceHeadOffice.officeName ??
                                                    '',
                                                style: TextStyle(
                                                  color: Colors.grey.shade600,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        PopupMenuButton<String>(
                                          color: Theme.of(context).cardColor,
                                          icon: Icon(
                                            Icons.more_vert,
                                            color: Colors.grey.shade500,
                                          ),
                                          onSelected: (value) {
                                            if (value == 'edit') {
                                              showFormDialog(
                                                id:
                                                    serviceHeadOffice.id
                                                        .toString(),
                                                selectedUserId:
                                                    serviceHeadOffice.userId,
                                                selectedOfficeId:
                                                    serviceHeadOffice.officeId
                                                        .toString(),
                                              );
                                            }
                                            if (value == 'delete') {
                                              showDeleteDialog(
                                                serviceHeadOffice.id.toString(),
                                              );
                                            }
                                          },
                                          itemBuilder:
                                              (_) => [
                                                PopupMenuItem(
                                                  value: 'edit',
                                                  child: Row(
                                                    children: const [
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
                                                      const Icon(
                                                        CupertinoIcons
                                                            .delete_simple,
                                                        color: Colors.redAccent,
                                                        size: 16,
                                                      ),
                                                      const SizedBox(width: 8),
                                                      const Text('Delete'),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                        ),
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
                                (page) => fetchServiceHeadOffices(
                                  page: page,
                                  query:
                                      searchController.text.trim().isEmpty
                                          ? null
                                          : searchController.text.trim(),
                                ),
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
                child: const Icon(Icons.add, color: Colors.white),
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
            title: 'User Office',
            itemName: 'user office',
            onDelete: () async {
              Navigator.pop(ctx);
              try {
                await _serviceHeadService.deleteServiceHeadOffice(id);
                await fetchServiceHeadOffices(page: _currentPage);
                if (mounted) {
                  MotionToast.success(
                    description: Text('User Office deleted successfully'),
                  ).show(context);
                }
              } catch (_) {
                MotionToast.error(
                  description: Text('Failed to delete user office'),
                ).show(context);
              }
            },
          ),
    );
  }
}
