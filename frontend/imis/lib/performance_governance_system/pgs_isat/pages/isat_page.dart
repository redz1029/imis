// ignore_for_file: empty_catches, use_build_context_synchronously

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/utils/date_time_converter.dart';
import 'package:intl/intl.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/performance_governance_system/pgs_isat/dialog/isat_dialog.dart';
import 'package:imis/performance_governance_system/pgs_isat/models/isat.dart';
import 'package:imis/performance_governance_system/pgs_isat/services/isat_services.dart';
import 'package:imis/utils/auth_util.dart';
import 'package:imis/widgets/common/pagination_controls.dart';
import 'package:imis/widgets/dialog/delete_dialog.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IsatPage extends StatefulWidget {
  const IsatPage({super.key});

  @override
  State<IsatPage> createState() => IsatPageState();
}

class IsatPageState extends State<IsatPage> {
  final _isatService = IsatServices(Dio());
  final dio = Dio();
  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  List<Isat> filteredList = [];
  List<Isat> isatList = [];
  int _currentPage = 1;
  final int _pageSize = 15;
  int _totalCount = 0;
  bool _isLoading = false;
  String roleId = "";
  String userId = "";

  @override
  void initState() {
    super.initState();
    _loadCurrentRoleId();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentRoleId() async {
    await AuthUtil.processTokenValidity(dio, context);
    final user = await AuthUtil.fetchLoggedUser();
    final roles = await AuthUtil.fetchRoles();
    final prefs = await SharedPreferences.getInstance();
    final String? selectedRoleName = prefs.getString('selectedRole');
    String tempRoleId = "";
    if (roles != null && roles.isNotEmpty) {
      var currentRole = roles.first;
      if (selectedRoleName != null) {
        try {
          currentRole = roles.firstWhere((r) => r.name == selectedRoleName);
        } catch (e) {}
      }
      tempRoleId = currentRole.id;
    }
    if (mounted) {
      setState(() {
        roleId = tempRoleId;
        userId = user?.id ?? "";
      });
      if (roleId.isNotEmpty && userId.isNotEmpty) fetchIsat();
    }
  }

  Future<void> fetchIsat({int page = 1, String? searchQuery}) async {
    if (_isLoading || roleId.isEmpty || userId.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      final pageList = await _isatService.getIsatList(
        userId: userId,
        roleId: roleId,
        page: page,
        pageSize: _pageSize,
        searchQuery: searchQuery,
      );
      if (mounted) {
        setState(() {
          _currentPage = pageList.page;
          _totalCount = pageList.totalCount;
          isatList = pageList.items;
          filteredList = List.from(isatList);
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      final q = value.trim();
      fetchIsat(page: 1, searchQuery: q.isEmpty ? null : q);
    });
  }

  Future<void> _refresh() {
    final q = searchController.text.trim();
    return fetchIsat(page: _currentPage, searchQuery: q.isEmpty ? null : q);
  }

  String _status(Isat v) => v.isDraft == true ? 'Draft' : 'Submitted';

  Color _statusColor(String s) =>
      s == 'Draft' ? Colors.grey.shade600 : Colors.green.shade600;

  Future<void> _openNewIsat() async {
    final saved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const IsatDialog(),
    );
    if (saved == true) _refresh();
  }

  Future<void> _openIsat(Isat entry) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => Center(child: CircularProgressIndicator(color: primaryColor)),
    );

    Map<String, dynamic>? existing;
    try {
      final full = await _isatService.getIsatbyId(entry.id);
      existing = full.toJson();
    } catch (e, st) {
      debugPrint('OPEN ISAT ERROR: $e\n$st');
    }

    if (!mounted) return;
    Navigator.pop(context);

    if (existing == null) {
      MotionToast.error(
        toastAlignment: Alignment.topCenter,
        description: Text(
          'Failed to load ISAT',
          style: GoogleFonts.plusJakartaSans(),
        ),
      ).show(context);
      return;
    }

    final saved = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (_) => IsatDialog(existing: existing),
    );
    if (saved == true) _refresh();
  }

  void _openPrintPreview(Isat entry) {
    MotionToast.info(
      description: const Text('Print preview not wired up yet.'),
    ).show(context);
  }

  void showDeleteDialog(String id) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder:
          (ctx) => DeleteDialog(
            title: 'ISAT Record',
            itemName: 'ISAT',
            onDelete: () async {
              Navigator.pop(ctx);
              try {
                // await _isatService.deleteIsat(id);
                await _refresh();
                if (mounted) {
                  MotionToast.success(
                    toastAlignment: Alignment.topCenter,
                    description: Text(
                      'ISAT deleted successfully',
                      style: GoogleFonts.plusJakartaSans(),
                    ),
                  ).show(context);
                }
              } catch (_) {
                MotionToast.error(
                  toastAlignment: Alignment.topCenter,
                  description: Text(
                    'Failed to delete ISAT',
                    style: GoogleFonts.plusJakartaSans(),
                  ),
                ).show(context);
              }
            },
          ),
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
          _buildPageHeader(isMobile),
          _buildFilterBar(isMobile),
          gap4px,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 32,
                ),
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
                              flex: 3,
                              child: Text(
                                "Period",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Status",
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
                              : filteredList.isEmpty
                              ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.account_tree_outlined,
                                      size: 50,
                                      color: Colors.grey.shade400,
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      "No ISAT available",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              : ListView.separated(
                                itemCount: filteredList.length,
                                separatorBuilder:
                                    (_, __) => Divider(
                                      height: 1,
                                      color: Colors.grey.withValues(alpha: .2),
                                    ),
                                itemBuilder: (context, index) {
                                  final isat = filteredList[index];
                                  final itemNumber =
                                      ((_currentPage - 1) * _pageSize) +
                                      index +
                                      1;
                                  final status = _status(isat);
                                  final startDate = isat.isatPeriod!.startDate;
                                  final endDate = isat.isatPeriod!.endDate;
                                  final converter = LongDateOnlyConverter();
                                  final start = converter.toJson(startDate);
                                  final end = converter.toJson(endDate);
                                  if (!isMobile) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              "$itemNumber",
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              isat.office!.name,
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              "$start - $end",
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              status,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: _statusColor(status),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Row(
                                              children: [
                                                Tooltip(
                                                  message: 'View / Edit',
                                                  child: IconButton(
                                                    icon: const Icon(
                                                      Icons.edit_outlined,
                                                      size: 16,
                                                    ),
                                                    onPressed:
                                                        () => _openIsat(isat),
                                                  ),
                                                ),
                                                Tooltip(
                                                  message: 'Print Preview',
                                                  child: IconButton(
                                                    icon: const Icon(
                                                      Icons
                                                          .description_outlined,
                                                      size: 16,
                                                      color: blue,
                                                    ),
                                                    onPressed:
                                                        () => _openPrintPreview(
                                                          isat,
                                                        ),
                                                  ),
                                                ),
                                                Tooltip(
                                                  message: 'Delete',
                                                  child: IconButton(
                                                    icon: const Icon(
                                                      CupertinoIcons
                                                          .delete_simple,
                                                      size: 16,
                                                      color: Colors.redAccent,
                                                    ),
                                                    onPressed:
                                                        () => showDeleteDialog(
                                                          isat.id.toString(),
                                                        ),
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
                                                  _openIsat(isat);
                                                }
                                                if (value == 'preview') {
                                                  _openPrintPreview(isat);
                                                }
                                                if (value == 'delete') {
                                                  showDeleteDialog(
                                                    isat.id.toString(),
                                                  );
                                                }
                                              },
                                              itemBuilder:
                                                  (_) => const [
                                                    PopupMenuItem(
                                                      value: 'edit',
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.edit_outlined,
                                                            size: 16,
                                                          ),
                                                          SizedBox(width: 8),
                                                          Text('View / Edit'),
                                                        ],
                                                      ),
                                                    ),
                                                    PopupMenuItem(
                                                      value: 'preview',
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .description_outlined,
                                                            size: 16,
                                                            color: blue,
                                                          ),
                                                          SizedBox(width: 8),
                                                          Text('Print preview'),
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
                                          isat.office!.name,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Period: ",
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Status: $status",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: _statusColor(status),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
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
                            onPageChanged: (page) {
                              final q = searchController.text.trim();
                              fetchIsat(
                                page: page,
                                searchQuery: q.isEmpty ? null : q,
                              );
                            },
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
      floatingActionButton:
          isMobile
              ? FloatingActionButton(
                backgroundColor: primaryColor,
                onPressed: _openNewIsat,
                child: const Icon(Icons.add, color: Colors.white),
              )
              : null,
    );
  }

  Widget _buildPageHeader(bool isMobile) {
    final width = MediaQuery.of(context).size.width;
    final isSmall = width < 900;
    final isXSmall = width < 700;
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(20, isXSmall ? 12 : 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(isXSmall ? 6 : 8),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.account_tree_outlined,
                  color: primaryColor,
                  size: isXSmall ? 18 : 22,
                ),
              ),
              SizedBox(width: isXSmall ? 8 : 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Individual Strategic Alignment Tree (ISAT)",
                      style: TextStyle(
                        fontSize:
                            isXSmall
                                ? 12
                                : isSmall
                                ? 14
                                : 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A1D23),
                      ),
                    ),
                    Text(
                      "$_totalCount ISAT${_totalCount != 1 ? 's' : ''} found",
                      style: TextStyle(
                        fontSize: isXSmall ? 10 : 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isMobile)
                ElevatedButton.icon(
                  onPressed: _openNewIsat,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: EdgeInsets.symmetric(
                      vertical: isXSmall ? 8 : 10,
                      horizontal: isXSmall ? 10 : 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: isXSmall ? 14 : 16,
                  ),
                  label: Text(
                    isXSmall ? 'Add' : 'Add New',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isXSmall ? 11 : 13,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildFilterBar(bool isMobile) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const Divider(height: 1, thickness: 1, color: Color(0xFFEEEFF2)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            child: Row(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: 150,
                    maxWidth: isMobile ? 300 : 400,
                  ),
                  child: SizedBox(
                    height: 38,
                    width: isMobile ? 260 : 400,
                    child: TextField(
                      controller: searchController,
                      onChanged: _onSearchChanged,
                      decoration: InputDecoration(
                        hintText: 'Search office or period...',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 13,
                        ),
                        prefixIcon: const Icon(Icons.search, size: 18),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: primaryColor),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
