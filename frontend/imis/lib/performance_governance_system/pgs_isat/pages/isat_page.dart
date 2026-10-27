// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/common_services/common_service.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/constant/permissions.dart';
import 'package:imis/office/models/office.dart';
import 'package:imis/performance_governance_system/pgs_isat/dialog/isat_approval_timeline_dialog.dart';
import 'package:imis/performance_governance_system/pgs_isat/dialog/isat_dialog.dart';
import 'package:imis/performance_governance_system/pgs_isat/models/isat.dart';
import 'package:imis/performance_governance_system/pgs_isat/services/isat_services.dart';
import 'package:imis/utils/auth_util.dart';
import 'package:imis/utils/date_time_converter.dart';
import 'package:imis/utils/print_preview_util.dart';
import 'package:imis/widgets/common/button_filter.dart';
import 'package:imis/widgets/common/filter_button_widget.dart';
import 'package:imis/widgets/common/pagination_controls.dart';
import 'package:imis/widgets/dialog/delete_dialog.dart';
import 'package:imis/widgets/isat_widget/status_badge.dart';
import 'package:imis/widgets/permission/permission_widget.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IsatPage extends StatefulWidget {
  const IsatPage({super.key});

  @override
  State<IsatPage> createState() => IsatPageState();
}

class IsatPageState extends State<IsatPage> {
  final _isatService = IsatServices(Dio());
  final _commonService = CommonService(Dio());
  final dio = Dio();
  final searchController = TextEditingController();

  static const _fetchSize = 500;
  static const _statuses = ['All', 'Draft', 'Pending', 'Approved'];

  List<Isat> _all = [];
  List<Isat> filteredList = [];
  List<Office> officeList = [];
  int _currentPage = 1;
  final int _pageSize = 15;
  int _totalCount = 0;
  int _reqId = 0;
  bool _isLoading = false;
  bool _mobileFiltersExpanded = false;
  bool _sortAsc = true;
  String roleId = "";
  String userId = "";
  String? _sortColumn;
  String? _selectedOfficeId;
  String _statusFilter = 'All';

  bool get _hasActiveFilters => _selectedOfficeId != null;
  String? get _query {
    final q = searchController.text.trim();
    return q.isEmpty ? null : q;
  }

  Map<String, int> get _statusCounts {
    final c = {for (final s in _statuses) s: 0};
    c['All'] = _all.length;
    for (final i in _all) {
      final l = _statusInfo(i).label;
      c[l] = (c[l] ?? 0) + 1;
    }
    return c;
  }

  @override
  void initState() {
    super.initState();
    _commonService.fetchOffices().then((o) {
      if (mounted) setState(() => officeList = o);
    });

    _loadCurrentRoleId();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentRoleId() async {
    await AuthUtil.processTokenValidity(dio, context);
    final user = await AuthUtil.fetchLoggedUser();
    final roles = await AuthUtil.fetchRoles();
    final prefs = await SharedPreferences.getInstance();
    final selectedRole = prefs.getString('selectedRole');

    var tempRoleId = "";
    if (roles != null && roles.isNotEmpty) {
      final role = roles.firstWhere(
        (r) => r.name == selectedRole,
        orElse: () => roles.first,
      );
      tempRoleId = role.id;
    }
    if (!mounted) return;
    setState(() {
      roleId = tempRoleId;
      userId = user?.id ?? "";
    });
    fetchIsat();
  }

  Future<void> fetchIsat({int page = 1}) async {
    if (roleId.isEmpty || userId.isEmpty) return;
    final id = ++_reqId;
    setState(() => _isLoading = true);
    try {
      final res = await _isatService.getIsatList(
        userId: userId,
        roleId: roleId,
        page: 1,
        pageSize: _fetchSize,
        searchQuery: _query,
        officeId: _selectedOfficeId,
      );
      if (!mounted || id != _reqId) return;
      _all = List.from(res.items);
      _applyView(page);
    } catch (e) {
      debugPrint(e.toString());
      if (mounted && id == _reqId) {
        _all = [];
        _applyView(1);
      }
    } finally {
      if (mounted && id == _reqId) setState(() => _isLoading = false);
    }
  }

  void _applyView(int page) {
    final list =
        _all
            .where(
              (i) =>
                  _statusFilter == 'All' ||
                  _statusInfo(i).label == _statusFilter,
            )
            .toList();
    _sortList(list);

    final maxPage = (list.length / _pageSize).ceil().clamp(1, 1 << 30);
    final p = page.clamp(1, maxPage);
    final start = (p - 1) * _pageSize;
    final end = (start + _pageSize).clamp(0, list.length);

    setState(() {
      _currentPage = p;
      _totalCount = list.length;
      filteredList = start >= list.length ? [] : list.sublist(start, end);
    });
  }

  Future<void> _refresh() => fetchIsat(page: _currentPage);

  ({String label, String? awaiting}) _statusInfo(Isat v) {
    if (v.isDraft == true) return (label: 'Draft', awaiting: null);
    final sigs = v.isatSignatories ?? [];
    final next = sigs.where((s) => s.isNextStatus == true).firstOrNull;
    if (sigs.isNotEmpty && next == null) {
      return (label: 'Approved', awaiting: null);
    }
    return (label: 'Pending', awaiting: next?.signatoryName);
  }

  String _periodText(Isat v) {
    final p = v.isatPeriod;
    if (p == null) return '';
    final c = LongDateOnlyConverter();
    return '${c.toJson(p.startDate)} - ${c.toJson(p.endDate)}';
  }

  Future<void> _openIsat([Isat? entry]) async {
    final saved = await showDialog<bool>(
      context: context,
      barrierDismissible: entry != null,
      builder:
          (_) =>
              entry == null
                  ? const IsatDialog()
                  : IsatDialog(existing: {'id': entry.id}),
    );
    if (saved == true) _refresh();
  }

  void showDeleteDialog(String id) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder:
          (ctx) => DeleteDialog(
            title: 'ISPAM Record',
            itemName: 'ISPAM',
            onDelete: () async {
              Navigator.pop(ctx);
              try {
                await _isatService.deleteIsat(id);
                await _refresh();
                if (mounted) {
                  MotionToast.success(
                    toastAlignment: Alignment.topCenter,
                    description: Text(
                      'ISPAM deleted successfully',
                      style: GoogleFonts.plusJakartaSans(),
                    ),
                  ).show(context);
                }
              } catch (_) {
                MotionToast.error(
                  toastAlignment: Alignment.topCenter,
                  description: Text(
                    'Failed to delete ISPAM',
                    style: GoogleFonts.plusJakartaSans(),
                  ),
                ).show(context);
              }
            },
          ),
    );
  }

  Future<void> _showTimeLine(Isat v) async {
    final steps =
        (v.isatSignatories ?? []).map((s) {
          final j = s.toJson();
          final d = j['dateSigned'];
          final raw =
              d is DateTime
                  ? d
                  : DateTime.tryParse(d?.toString() ?? '') ?? DateTime(1);
          return TimelineStep(
            label: j['label']?.toString() ?? 'Signatory',
            name: j['signatoryName']?.toString() ?? 'Unknown',
            signedDate: raw.year > 1 ? raw : null,
            isNext: j['isNextStatus'] == true,
          );
        }).toList();

    final deleted = await showApprovalTimelineDialog(
      context,
      subtitle: v.office?.name ?? '',
      status: _statusInfo(v).label,
      steps: steps,
      onDelete: () => _isatService.deleteIsatSignatory(v.id.toString()),
    );

    if (deleted == true) _refresh();
  }

  void _onSort(String column) {
    _sortAsc = _sortColumn == column ? !_sortAsc : true;
    _sortColumn = column;
    _applyView(1);
  }

  void _sortList(List<Isat> list) {
    if (_sortColumn == null) return;
    int cmp(Isat a, Isat b) {
      switch (_sortColumn) {
        case 'office':
          return (a.office?.name ?? '').toLowerCase().compareTo(
            (b.office?.name ?? '').toLowerCase(),
          );
        case 'period':
          final ad = a.isatPeriod?.startDate;
          final bd = b.isatPeriod?.startDate;
          if (ad == null || bd == null) return 0;
          return ad.compareTo(bd);
        case 'status':
          return _statusInfo(a).label.compareTo(_statusInfo(b).label);
        default:
          return 0;
      }
    }

    list.sort((a, b) => _sortAsc ? cmp(a, b) : cmp(b, a));
  }

  // ---------- small helpers ----------
  static const _cellStyle = TextStyle(fontSize: 12);
  static const _boldStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 12,
  );

  Widget _cell(String text, int flex) =>
      Expanded(flex: flex, child: Text(text, style: _cellStyle));

  Widget _sortHeader(String label, String column, int flex) {
    final active = _sortColumn == column;
    return Expanded(
      flex: flex,
      child: InkWell(
        onTap: () => _onSort(column),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: _boldStyle.copyWith(color: active ? primaryColor : null),
            ),
            const SizedBox(width: 4),
            Icon(
              !active
                  ? Icons.unfold_more
                  : _sortAsc
                  ? Icons.arrow_upward
                  : Icons.arrow_downward,
              size: 14,
              color: active ? primaryColor : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _action(String tip, IconData icon, VoidCallback onTap, [Color? c]) =>
      Tooltip(
        message: tip,
        child: IconButton(
          icon: Icon(icon, size: 16, color: c),
          onPressed: onTap,
        ),
      );

  PopupMenuItem<String> _menuItem(
    String value,
    IconData icon,
    String label, [
    Color? color,
  ]) => PopupMenuItem(
    value: value,
    child: Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Text(label),
      ],
    ),
  );

  // ---------- status tabs ----------
  IconData _statusTabIcon(String label) {
    switch (label) {
      case 'Draft':
        return Icons.edit_note_rounded;
      case 'Pending':
        return Icons.pending_actions_rounded;
      case 'Approved':
        return Icons.check_circle_rounded;
      default:
        return Icons.list_alt_rounded;
    }
  }

  Color? _statusTabColor(String label) {
    switch (label) {
      case 'Draft':
        return Colors.grey.shade600;
      case 'Pending':
        return Colors.orange.shade600;
      case 'Approved':
        return kSuccess;
      default:
        return null;
    }
  }

  Widget _buildStatusTabs() {
    final counts = _statusCounts;
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children:
              _statuses.map((label) {
                final count = counts[label] ?? 0;
                final color = _statusTabColor(label);
                final isSelected = _statusFilter == label;

                return GestureDetector(
                  onTap: () {
                    _statusFilter = label;
                    _applyView(1);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.only(right: 2),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isSelected ? primaryColor : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _statusTabIcon(label),
                          size: 14,
                          color:
                              isSelected
                                  ? primaryColor
                                  : (color ?? Colors.grey.shade600),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w500,
                            color:
                                isSelected
                                    ? primaryColor
                                    : Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? primaryColor.withValues(alpha: 0.12)
                                    : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '$count',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color:
                                  isSelected
                                      ? primaryColor
                                      : (color ?? Colors.grey.shade600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }

  // ---------- rows ----------
  Widget _desktopRow(Isat isat, int no) {
    final st = _statusInfo(isat);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          _cell('$no', 1),
          _cell(isat.office?.name ?? '', 3),
          _cell(_periodText(isat), 3),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: StatusBadge(
                label: st.label,
                awaiting: st.awaiting,
                onTap: () => _showTimeLine(isat),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                _action(
                  'View / Edit',
                  Icons.edit_outlined,
                  () => _openIsat(isat),
                ),
                _action(
                  'Print Preview',
                  Icons.description_outlined,
                  () => openIsatPrintPreview(isat.id.toString(), ''),
                  blue,
                ),
                _action(
                  'Delete',
                  CupertinoIcons.delete_simple,
                  () => showDeleteDialog(isat.id.toString()),
                  Colors.redAccent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _mobileRow(Isat isat, int no) {
    final st = _statusInfo(isat);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('$no', style: _boldStyle),
              const Spacer(),
              PopupMenuButton<String>(
                color: Theme.of(context).cardColor,
                icon: const Icon(Icons.more_vert),
                onSelected: (v) {
                  if (v == 'edit') _openIsat(isat);
                  if (v == 'preview') {
                    () => openIsatPrintPreview(isat.id.toString(), '');
                  }
                  if (v == 'delete') showDeleteDialog(isat.id.toString());
                },
                itemBuilder:
                    (_) => [
                      _menuItem('edit', Icons.edit_outlined, 'View / Edit'),
                      _menuItem(
                        'preview',
                        Icons.description_outlined,
                        'Print preview',
                        blue,
                      ),
                      _menuItem(
                        'delete',
                        CupertinoIcons.delete_simple,
                        'Delete',
                        Colors.red,
                      ),
                    ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(isat.office?.name ?? '', style: _cellStyle),
          const SizedBox(height: 4),
          Text(_periodText(isat), style: _cellStyle),
          const SizedBox(height: 4),
          StatusBadge(
            label: st.label,
            awaiting: st.awaiting,
            onTap: () => _showTimeLine(isat),
          ),
        ],
      ),
    );
  }

  Widget _buildList(bool isMobile) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: primaryColor));
    }
    if (filteredList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_tree_outlined,
              size: 50,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 10),
            Text(
              _statusFilter == 'All'
                  ? "No ISPAM available"
                  : "No ${_statusFilter.toLowerCase()} ISPAM found",
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }
    return ListView.separated(
      itemCount: filteredList.length,
      separatorBuilder:
          (_, __) =>
              Divider(height: 1, color: Colors.grey.withValues(alpha: .2)),
      itemBuilder: (_, i) {
        final no = ((_currentPage - 1) * _pageSize) + i + 1;
        return isMobile
            ? _mobileRow(filteredList[i], no)
            : _desktopRow(filteredList[i], no);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

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
                    _buildStatusTabs(),
                    if (!isMobile)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Expanded(
                              flex: 1,
                              child: Text("#", style: _boldStyle),
                            ),
                            _sortHeader("Office", 'office', 3),
                            _sortHeader("Period", 'period', 3),
                            _sortHeader("Status", 'status', 2),
                            const Expanded(
                              flex: 2,
                              child: Text("Actions", style: _boldStyle),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 5),
                    Expanded(child: _buildList(isMobile)),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
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
                            onPageChanged: _applyView, // local paging na
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
              ? PermissionWidget(
                permission: AppPermissions.addISAT,
                child: FloatingActionButton(
                  backgroundColor: primaryColor,
                  onPressed: _openIsat,
                  child: const Icon(Icons.add, color: Colors.white),
                ),
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
      padding: EdgeInsets.fromLTRB(20, isXSmall ? 12 : 16, 20, 16),
      child: Row(
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
                  "Individual Strategic Alignment Management (ISPAM)",
                  style: TextStyle(
                    fontSize: isXSmall ? 12 : (isSmall ? 14 : 16),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A1D23),
                  ),
                ),
                Text(
                  "$_totalCount ISPAM${_totalCount != 1 ? 's' : ''} found",
                  style: TextStyle(
                    fontSize: isXSmall ? 10 : 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          if (!isMobile)
            PermissionWidget(
              permission: AppPermissions.addISAT,
              child: ElevatedButton.icon(
                onPressed: _openIsat,
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
            ),
        ],
      ),
    );
  }

  Widget _officeDropdown() {
    final selectedName =
        officeList
            .where((o) => o.id.toString() == _selectedOfficeId)
            .firstOrNull
            ?.name ??
        "All Offices";

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 150, maxWidth: 400),
      child: SizedBox(
        height: 38,
        child: SearchableDropdown(
          items: ["All Offices", ...officeList.map((o) => o.name)],
          selectedItem: selectedName,
          hintText: "Office",
          searchHint: "Search offices...",
          prefixIcon: Icons.apartment_outlined,
          onChanged: (value) {
            setState(() {
              _selectedOfficeId =
                  value == "All Offices"
                      ? null
                      : officeList
                          .firstWhere((o) => o.name == value)
                          .id
                          .toString();
            });
            fetchIsat();
          },
        ),
      ),
    );
  }

  void _resetFilters() {
    setState(() => _selectedOfficeId = null);
    fetchIsat();
  }

  Widget _clearButton({Key? key, bool compact = false}) => TextButton.icon(
    key: key,
    onPressed: _resetFilters,
    icon: Icon(Icons.refresh, size: 14, color: Colors.red.shade400),
    label: Text(
      'Clear filters',
      style: TextStyle(fontSize: 12, color: Colors.red.shade400),
    ),
    style: TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      minimumSize: compact ? Size.zero : null,
      tapTargetSize: compact ? MaterialTapTargetSize.shrinkWrap : null,
    ),
  );

  Widget _buildFilterBar(bool isMobile) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const Divider(height: 1, thickness: 1, color: Color(0xFFEEEFF2)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            child: isMobile ? _buildMobileFilters() : _buildDesktopFilters(),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap:
                  () => setState(
                    () => _mobileFiltersExpanded = !_mobileFiltersExpanded,
                  ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.tune, size: 16, color: primaryColor),
                    const SizedBox(width: 6),
                    Text(
                      'Filters',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(width: 4),
                    AnimatedRotation(
                      turns: _mobileFiltersExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        size: 16,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              child:
                  _hasActiveFilters
                      ? _clearButton(
                        key: const ValueKey('clear'),
                        compact: true,
                      )
                      : const SizedBox.shrink(key: ValueKey('empty')),
            ),
          ],
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child:
              _mobileFiltersExpanded
                  ? Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: _officeDropdown(),
                  )
                  : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildDesktopFilters() {
    return Row(
      children: [
        buildDropdown(child: _officeDropdown()),
        if (_hasActiveFilters) ...[const SizedBox(width: 10), _clearButton()],
      ],
    );
  }
}
