// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/common_services/common_service.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/constant/permissions.dart';
import 'package:imis/office/models/office.dart';
import 'package:imis/utils/auth_util.dart';
import 'package:imis/widgets/common/button_filter.dart';
import 'package:imis/widgets/common/filter_button_widget.dart';
import 'package:imis/widgets/common/pagination_controls.dart';
import 'package:imis/widgets/common/search_underline_dropdown.dart';
import 'package:imis/widgets/dialog/delete_dialog.dart';
import 'package:imis/widgets/permission/permission_widget.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ---------------------------------------------------------------------
/// MODELS
/// ---------------------------------------------------------------------

class PagedResult<T> {
  final int page;
  final int totalCount;
  final List<T> items;

  PagedResult({
    required this.page,
    required this.totalCount,
    required this.items,
  });
}

class StrategicPositionArea {
  final int id;
  final int? strategicPositionId;
  bool isDeleted;
  String area;
  String year2020;
  String year2025;
  String year2030;

  StrategicPositionArea({
    this.id = 0,
    this.strategicPositionId,
    this.isDeleted = false,
    this.area = '',
    this.year2020 = '',
    this.year2025 = '',
    this.year2030 = '',
  });

  factory StrategicPositionArea.fromJson(Map<String, dynamic> json) {
    return StrategicPositionArea(
      id: json['id'] ?? 0,
      strategicPositionId: json['strategicPositionId'],
      isDeleted: json['isDeleted'] ?? false,
      area: json['area'] ?? '',
      year2020: json['year2020'] ?? '',
      year2025: json['year2025'] ?? '',
      year2030: json['year2030'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'strategicPositionId': strategicPositionId,
    'isDeleted': isDeleted,
    'area': area,
    'year2020': year2020,
    'year2025': year2025,
    'year2030': year2030,
  };
}

class StrategicPosition {
  final int id;
  int? departmentId;
  String? departmentName;
  bool isDeleted;
  String rowVersion;
  String fromStatement;
  String toStatement;
  DateTime? postingDate;
  List<StrategicPositionArea> areas;

  StrategicPosition({
    this.id = 0,
    this.departmentId,
    this.departmentName,
    this.isDeleted = false,
    this.rowVersion = '',
    this.fromStatement = '',
    this.toStatement = '',
    this.postingDate,
    List<StrategicPositionArea>? areas,
  }) : areas = areas ?? [];

  factory StrategicPosition.fromJson(Map<String, dynamic> json) {
    return StrategicPosition(
      id: json['id'] ?? 0,
      departmentId: json['departmentId'],
      departmentName: json['departmentName'],
      isDeleted: json['isDeleted'] ?? false,
      rowVersion: json['rowVersion'] ?? '',
      fromStatement: json['fromStatement'] ?? '',
      toStatement: json['toStatement'] ?? '',
      postingDate:
          json['postingDate'] != null
              ? DateTime.tryParse(json['postingDate'])
              : null,
      areas:
          (json['areas'] as List<dynamic>? ?? [])
              .map((e) => StrategicPositionArea.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'departmentId': departmentId,
    'isDeleted': isDeleted,
    'rowVersion': rowVersion,
    'fromStatement': fromStatement,
    'toStatement': toStatement,
    'postingDate': postingDate?.toIso8601String(),
    'areas': areas.map((e) => e.toJson()).toList(),
  };
}

/// ---------------------------------------------------------------------
/// SERVICE (dummy — adjust endpoints/response shape to match backend)
/// ---------------------------------------------------------------------

class StrategicPositionService {
  final Dio dio;
  StrategicPositionService(this.dio);

  Future<PagedResult<StrategicPosition>> getStrategicPositions({
    int page = 1,
    int pageSize = 15,
    String? searchQuery,
    String? roleId,
    String? officeId,
    required String userId,
  }) async {
    final response = await dio.get(
      '/api/StrategicPosition',
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
        if (searchQuery != null) 'search': searchQuery,
        if (roleId != null) 'roleId': roleId,
        if (officeId != null) 'officeId': officeId,
        'userId': userId,
      },
    );

    final data = response.data;

    return PagedResult<StrategicPosition>(
      page: data['page'] ?? 1,
      totalCount: data['totalCount'] ?? 0,
      items:
          (data['items'] as List<dynamic>? ?? [])
              .map((e) => StrategicPosition.fromJson(e))
              .toList(),
    );
  }

  Future<StrategicPosition> getStrategicPositionById(String id) async {
    final response = await dio.get('/api/StrategicPosition/$id');
    return StrategicPosition.fromJson(response.data);
  }

  Future<void> createStrategicPosition(StrategicPosition sp) async {
    if (sp.id == 0) {
      await dio.post('/api/StrategicPosition', data: sp.toJson());
    } else {
      await dio.put('/api/StrategicPosition/${sp.id}', data: sp.toJson());
    }
  }

  Future<void> deleteStrategicPosition(String id) async {
    await dio.delete('/api/StrategicPosition/$id');
  }
}

/// ---------------------------------------------------------------------
/// ENTRY HELPER (per-area controllers, mirrors SwotContextEntry pattern)
/// ---------------------------------------------------------------------

class StrategicAreaEntry {
  final int id;
  final TextEditingController areaCtrl;
  final TextEditingController y2020Ctrl;
  final TextEditingController y2025Ctrl;
  final TextEditingController y2030Ctrl;

  StrategicAreaEntry({
    this.id = 0,
    String area = '',
    String y2020 = '',
    String y2025 = '',
    String y2030 = '',
  }) : areaCtrl = TextEditingController(text: area),
       y2020Ctrl = TextEditingController(text: y2020),
       y2025Ctrl = TextEditingController(text: y2025),
       y2030Ctrl = TextEditingController(text: y2030);

  void dispose() {
    areaCtrl.dispose();
    y2020Ctrl.dispose();
    y2025Ctrl.dispose();
    y2030Ctrl.dispose();
  }
}

/// ---------------------------------------------------------------------
/// LIST PAGE
/// ---------------------------------------------------------------------

class StrategicPositionPage extends StatefulWidget {
  const StrategicPositionPage({super.key});

  @override
  State<StrategicPositionPage> createState() => _StrategicPositionPageState();
}

class _StrategicPositionPageState extends State<StrategicPositionPage> {
  int _currentPage = 1;
  final int _pageSize = 15;
  int totalCount = 0;
  bool _isLoading = false;

  List<StrategicPosition> _list = [];

  String? _userId;

  List<Office> officeList = [];
  String? _selectedOfficeId;

  bool _mobileFiltersExpanded = false;

  final _service = StrategicPositionService(Dio());
  final _commonService = CommonService(Dio());

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final user = await AuthUtil.fetchLoggedUser();
    final offices = await _commonService.fetchOffices();

    if (!mounted) return;

    setState(() {
      _userId = user?.id;
      officeList = offices;
    });

    await _fetch();
  }

  Future<String> _getRoleId() async {
    final prefs = await SharedPreferences.getInstance();
    final String? selectedRoleName = prefs.getString('selectedRole');
    final roles = await AuthUtil.fetchRoles();

    if (roles != null && roles.isNotEmpty) {
      var currentRole = roles.first;
      if (selectedRoleName != null) {
        try {
          currentRole = roles.firstWhere((r) => r.name == selectedRoleName);
        } catch (_) {}
      }
      return currentRole.id;
    }
    return '';
  }

  Future<void> _fetch({int page = 1, String? searchQuery}) async {
    if (_isLoading || _userId == null) return;

    setState(() {
      _isLoading = true;
      _list = [];
    });

    try {
      final roleId = await _getRoleId();

      final pageList = await _service.getStrategicPositions(
        page: page,
        pageSize: _pageSize,
        searchQuery: searchQuery,
        roleId: roleId,
        officeId: _selectedOfficeId,
        userId: _userId!,
      );

      if (!mounted) return;

      setState(() {
        _currentPage = pageList.page;
        totalCount = pageList.totalCount;
        _list = pageList.items;
      });
    } on DioException catch (e) {
      debugPrint('Dio error: $e');
    } catch (e) {
      debugPrint('Unexpected error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  bool get _hasActiveFilters => _selectedOfficeId != null;

  void _resetFilters() {
    setState(() => _selectedOfficeId = null);
    _fetch(page: 1);
  }

  void _openDialog({StrategicPosition? existing}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => StrategicPositionDialog(
            existing: existing,
            onSave: (_) => _fetch(page: _currentPage),
          ),
    );
  }

  Future<void> _onEditTap(StrategicPosition sp) async {
    try {
      final full = await _service.getStrategicPositionById(sp.id.toString());
      if (!mounted) return;
      _openDialog(existing: full);
    } catch (e) {
      debugPrint('Failed to fetch Strategic Position by ID: $e');
      if (!mounted) return;
      MotionToast.error(
        title: const Text('Load Failed'),
        description: const Text('Unable to load record for editing.'),
        toastDuration: const Duration(seconds: 4),
        toastAlignment: Alignment.topCenter,
      ).show(context);
    }
  }

  void _showDeleteDialog(String id) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder:
          (ctx) => DeleteDialog(
            title: 'Strategic Position',
            itemName: 'Strategic Position',
            onDelete: () async {
              Navigator.pop(ctx);
              try {
                await _service.deleteStrategicPosition(id);
                await _fetch(page: 1);
                if (mounted) {
                  MotionToast.success(
                    toastAlignment: Alignment.topCenter,
                    description: Text(
                      'Strategic Position deleted successfully',
                      style: GoogleFonts.plusJakartaSans(),
                    ),
                  ).show(context);
                }
              } catch (_) {
                if (!mounted) return;
                MotionToast.error(
                  toastAlignment: Alignment.topCenter,
                  description: Text(
                    'Failed to delete Strategic Position',
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
          _buildHeader(isMobile),
          _buildFilterBar(isMobile),
          gap4px,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
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
                                "Department",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text(
                                "From",
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
                    Expanded(child: _buildList(isMobile)),
                    _buildPagination(),
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
                onPressed: () => _openDialog(),
                child: const Icon(Icons.add, color: Colors.white),
              )
              : null,
    );
  }

  Widget _buildList(bool isMobile) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: primaryColor));
    }

    if (_list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.trending_up_outlined,
              size: 50,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 10),
            const Text(
              'No Strategic Position available',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: _list.length,
      separatorBuilder:
          (_, __) =>
              Divider(height: 1, color: Colors.grey.withValues(alpha: .2)),
      itemBuilder: (context, index) {
        final sp = _list[index];
        final itemNumber = ((_currentPage - 1) * _pageSize) + index + 1;
        return isMobile
            ? _buildMobileRow(sp, itemNumber)
            : _buildDesktopRow(sp, itemNumber);
      },
    );
  }

  Widget _buildDesktopRow(StrategicPosition sp, int itemNumber) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text("$itemNumber", style: const TextStyle(fontSize: 12)),
          ),
          Expanded(
            flex: 3,
            child: Text(
              sp.departmentName ?? '',
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              sp.fromStatement,
              style: const TextStyle(fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Tooltip(
                  message: 'Edit',
                  child: IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    onPressed: () => _onEditTap(sp),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    CupertinoIcons.delete_simple,
                    size: 16,
                    color: Colors.redAccent,
                  ),
                  onPressed: () => _showDeleteDialog(sp.id.toString()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileRow(StrategicPosition sp, int itemNumber) {
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
              Text(
                "$itemNumber",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              PopupMenuButton<String>(
                color: Theme.of(context).cardColor,
                icon: const Icon(Icons.more_vert),
                onSelected: (value) async {
                  if (value == 'edit') await _onEditTap(sp);
                  if (value == 'delete') _showDeleteDialog(sp.id.toString());
                },
                itemBuilder:
                    (_) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: const Row(
                          children: [
                            Icon(Icons.edit_outlined, size: 16),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: const Row(
                          children: [
                            Icon(CupertinoIcons.delete_simple, size: 16),
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
            sp.departmentName ?? '',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            sp.fromStatement,
            style: const TextStyle(fontSize: 12),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      color: Theme.of(context).cardColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PaginationInfo(
            currentPage: _currentPage,
            totalItems: totalCount,
            itemsPerPage: _pageSize,
          ),
          PaginationControls(
            currentPage: _currentPage,
            totalItems: totalCount,
            itemsPerPage: _pageSize,
            isLoading: _isLoading,
            onPageChanged: (page) => _fetch(page: page),
          ),
          const SizedBox(width: 60),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(20, isMobile ? 12 : 16, 20, 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.trending_up_outlined, color: primaryColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Strategic Position',
                  style: TextStyle(
                    fontSize: isMobile ? 14 : 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A1D23),
                  ),
                ),
                Text(
                  '${_list.length} record${_list.length != 1 ? 's' : ''} found',
                  style: TextStyle(
                    fontSize: isMobile ? 10 : 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          if (!isMobile)
            ElevatedButton.icon(
              onPressed: () => _openDialog(),
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
              icon: const Icon(Icons.add, color: Colors.white, size: 16),
              label: const Text(
                'Add New',
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
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
            child: isMobile ? _buildMobileFilters() : _buildDesktopFilters(),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopFilters() {
    return Row(
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [buildDropdown(child: _officeDropdown())],
        ),
        const Spacer(),
        if (_hasActiveFilters)
          TextButton.icon(
            onPressed: _resetFilters,
            icon: Icon(Icons.refresh, size: 14, color: Colors.red.shade400),
            label: Text(
              'Clear filters',
              style: TextStyle(fontSize: 12, color: Colors.red.shade400),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
          ),
      ],
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
            if (_hasActiveFilters)
              TextButton.icon(
                onPressed: _resetFilters,
                icon: Icon(Icons.refresh, size: 14, color: Colors.red.shade400),
                label: Text(
                  'Clear filters',
                  style: TextStyle(fontSize: 12, color: Colors.red.shade400),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
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
                    child: SizedBox(
                      height: 38,
                      child: PermissionWidget(
                        permission: AppPermissions.viewOffice,
                        child: _officeDropdown(),
                      ),
                    ),
                  )
                  : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _officeDropdown() {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 150, maxWidth: 400),
      child: SizedBox(
        height: 38,
        child: SearchableDropdown(
          items: ["All Offices", ...officeList.map((o) => o.name)],
          selectedItem:
              _selectedOfficeId == null
                  ? "All Offices"
                  : (officeList
                          .where((o) => o.id.toString() == _selectedOfficeId)
                          .firstOrNull
                          ?.name ??
                      "All Offices"),
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
            _fetch(page: 1);
          },
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------
/// DIALOG (add / edit)
/// ---------------------------------------------------------------------

class StrategicPositionDialog extends StatefulWidget {
  final StrategicPosition? existing;
  final void Function(StrategicPosition sp) onSave;

  const StrategicPositionDialog({
    super.key,
    this.existing,
    required this.onSave,
  });

  @override
  State<StrategicPositionDialog> createState() =>
      _StrategicPositionDialogState();
}

class _StrategicPositionDialogState extends State<StrategicPositionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _service = StrategicPositionService(Dio());
  final _commonService = CommonService(Dio());

  late TextEditingController _fromCtrl;
  late TextEditingController _toCtrl;

  List<StrategicAreaEntry> _areas = [];

  bool _officeLoading = true;
  List<String> _headOfficeIds = [];
  List<String> _headOfficeNames = [];
  String? _selectedOfficeId;

  bool get _isOfficeLocked => widget.existing != null;

  @override
  void initState() {
    super.initState();

    final existing = widget.existing;

    _fromCtrl = TextEditingController(text: existing?.fromStatement ?? '');
    _toCtrl = TextEditingController(text: existing?.toStatement ?? '');

    _areas =
        existing != null
            ? existing.areas
                .map(
                  (a) => StrategicAreaEntry(
                    id: a.id,
                    area: a.area,
                    y2020: a.year2020,
                    y2025: a.year2025,
                    y2030: a.year2030,
                  ),
                )
                .toList()
            : [
              StrategicAreaEntry(area: 'Service'),
              StrategicAreaEntry(area: 'Training'),
              StrategicAreaEntry(area: 'Research'),
            ];

    _loadOffices();
  }

  Future<void> _loadOffices() async {
    try {
      final officeIds = await AuthUtil.fetchOfficeIds();
      final officeNames = await AuthUtil.fetchOfficeNames();

      if (officeIds == null || officeNames == null || officeIds.isEmpty) {
        if (!mounted) return;
        setState(() => _officeLoading = false);
        return;
      }

      final headIds = <String>[];
      final headNames = <String>[];

      for (int i = 0; i < officeIds.length; i++) {
        final isHead = await AuthUtil.getIsOfficeHead(officeIds[i]);
        if (isHead == true) {
          headIds.add(officeIds[i]);
          headNames.add(officeNames[i]);
        }
      }

      String? selectedId;

      if (_isOfficeLocked) {
        final savedOfficeId = widget.existing?.departmentId?.toString();
        if (savedOfficeId != null && headIds.contains(savedOfficeId)) {
          selectedId = savedOfficeId;
        }
      } else {
        final prefs = await SharedPreferences.getInstance();
        final prefOfficeId = prefs.getString('selectedOfficeId');
        if (prefOfficeId != null && headIds.contains(prefOfficeId)) {
          selectedId = prefOfficeId;
        } else if (headIds.length == 1) {
          selectedId = headIds.first;
        }
      }

      if (!mounted) return;

      setState(() {
        _headOfficeIds = headIds;
        _headOfficeNames = headNames;
        _selectedOfficeId = selectedId;
        _officeLoading = false;
      });
    } catch (e) {
      debugPrint('Failed to load office: $e');
      if (!mounted) return;
      setState(() => _officeLoading = false);
    }
  }

  void _addAreaRow() {
    setState(() => _areas.add(StrategicAreaEntry()));
  }

  void _removeAreaRow(StrategicAreaEntry entry) {
    setState(() {
      _areas.remove(entry);
      entry.dispose();
    });
  }

  Future<void> _saveSp() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_selectedOfficeId == null || _selectedOfficeId!.isEmpty) {
      MotionToast.error(
        title: const Text('Department Required'),
        description: const Text('Please select a Department/Section/Unit.'),
        toastDuration: const Duration(seconds: 4),
        toastAlignment: Alignment.topCenter,
      ).show(context);
      return;
    }

    if (_areas.isEmpty) {
      MotionToast.error(
        title: const Text('Area Required'),
        description: const Text('Please add at least one area.'),
        toastDuration: const Duration(seconds: 4),
        toastAlignment: Alignment.topCenter,
      ).show(context);
      return;
    }

    final bool? confirm = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              width: 380,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: mainBgColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 32,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.save_outlined,
                      color: primaryColor,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Confirm Save',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                      color: primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Are you sure you want to save this Strategic Position?',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(ctx, false),
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
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.pop(ctx, true),
                          icon: const Icon(
                            Icons.save_outlined,
                            color: Colors.white,
                            size: 16,
                          ),
                          label: Text(
                            'Save',
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
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );

    if (confirm != true) return;

    try {
      final sp = StrategicPosition(
        id: widget.existing?.id ?? 0,
        departmentId: int.tryParse(_selectedOfficeId!),
        isDeleted: false,
        rowVersion: '',
        fromStatement: _fromCtrl.text.trim(),
        toStatement: _toCtrl.text.trim(),
        postingDate: DateTime.now(),
        areas:
            _areas
                .map(
                  (e) => StrategicPositionArea(
                    id: e.id,
                    area: e.areaCtrl.text.trim(),
                    year2020: e.y2020Ctrl.text.trim(),
                    year2025: e.y2025Ctrl.text.trim(),
                    year2030: e.y2030Ctrl.text.trim(),
                  ),
                )
                .toList(),
      );

      await _service.createStrategicPosition(sp);

      if (!mounted) return;

      widget.onSave(sp);
      Navigator.pop(context);

      MotionToast.success(
        title: const Text('Success'),
        description: const Text('Strategic Position saved successfully.'),
        toastDuration: const Duration(seconds: 3),
        toastAlignment: Alignment.topCenter,
      ).show(context);
    } catch (e) {
      if (!mounted) return;
      MotionToast.error(
        title: const Text('Save Failed'),
        description: Text('Unable to save Strategic Position.\n$e'),
        toastDuration: const Duration(seconds: 5),
        toastAlignment: Alignment.topCenter,
      ).show(context);
    }
  }

  @override
  void dispose() {
    _fromCtrl.dispose();
    _toCtrl.dispose();
    for (final e in _areas) {
      e.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 700;

    return Dialog(
      backgroundColor: mainBgColor,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isSmall ? 8 : 24,
        vertical: isSmall ? 12 : 24,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 1100,
          maxHeight: size.height * 0.92,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDialogHeader(),
            Expanded(child: _buildDialogBody(isSmall)),
            const Divider(height: 1),
            _buildDialogActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
      decoration: const BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'STRATEGIC POSITION',
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18, color: Colors.white70),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogBody(bool isSmall) {
    if (_officeLoading) {
      return const Center(
        child: CircularProgressIndicator(color: primaryColor),
      );
    }

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            isSmall
                ? Column(
                  children: [
                    _labeledField(
                      'FROM (current state)',
                      _fromCtrl,
                      maxLines: 3,
                      required: true,
                    ),
                    const SizedBox(height: 12),
                    _labeledField(
                      'TO (target by 2030)',
                      _toCtrl,
                      maxLines: 3,
                      required: true,
                    ),
                  ],
                )
                : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _labeledField(
                        'FROM (current state)',
                        _fromCtrl,
                        maxLines: 3,
                        required: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _labeledField(
                        'TO (target by 2030)',
                        _toCtrl,
                        maxLines: 3,
                        required: true,
                      ),
                    ),
                  ],
                ),
            const SizedBox(height: 20),
            _StrategicAreaTable(
              entries: _areas,
              isSmall: isSmall,
              onRemove: _removeAreaRow,
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: _addAreaRow,
                icon: const Icon(Icons.add, size: 16, color: primaryColor),
                label: const Text(
                  'Add Area',
                  style: TextStyle(color: primaryColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogActions() {
    final isEditing = widget.existing != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(foregroundColor: primaryColor),
            child: const Text('Cancel'),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            onPressed: _officeLoading ? null : _saveSp,
            child: Text(isEditing ? 'Update' : 'Save'),
          ),
        ],
      ),
    );
  }

  Widget _labeledField(
    String label,
    TextEditingController ctrl, {
    int maxLines = 1,
    bool required = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: ctrl,
          maxLines: maxLines,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: primaryColor),
            ),
          ),
          validator:
              required
                  ? (value) {
                    if (value == null || value.trim().isEmpty)
                      return 'Required';
                    return null;
                  }
                  : null,
        ),
      ],
    );
  }
}

/// ---------------------------------------------------------------------
/// AREA TABLE (Area | 2020 | 2025 | 2030) — dynamic, add/remove rows
/// ---------------------------------------------------------------------

class _StrategicAreaTable extends StatelessWidget {
  final List<StrategicAreaEntry> entries;
  final bool isSmall;
  final void Function(StrategicAreaEntry entry) onRemove;

  const _StrategicAreaTable({
    required this.entries,
    required this.isSmall,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: const Text(
              'Area Milestones',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          if (entries.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'No areas added yet.',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            )
          else if (!isSmall) ...[
            Container(
              color: Colors.grey.shade100,
              child: Row(
                children: [
                  Expanded(flex: 2, child: _headerCell('Area')),
                  Expanded(flex: 3, child: _headerCell('2020')),
                  Expanded(flex: 3, child: _headerCell('2025')),
                  Expanded(flex: 3, child: _headerCell('2030')),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            Divider(height: 1, color: Colors.grey.shade300),
            ...entries.asMap().entries.map((entryData) {
              final index = entryData.key;
              final entry = entryData.value;
              final isEven = index % 2 == 0;

              return Container(
                decoration: BoxDecoration(
                  color:
                      isEven
                          ? Colors.white
                          : primaryColor.withValues(alpha: 0.05),
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        flex: 2,
                        child: _cell(entry.areaCtrl, showBorder: true),
                      ),
                      Expanded(
                        flex: 3,
                        child: _cell(entry.y2020Ctrl, showBorder: true),
                      ),
                      Expanded(
                        flex: 3,
                        child: _cell(entry.y2025Ctrl, showBorder: true),
                      ),
                      Expanded(
                        flex: 3,
                        child: _cell(entry.y2030Ctrl, showBorder: true),
                      ),
                      SizedBox(
                        width: 40,
                        child: IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            size: 16,
                            color: Colors.redAccent,
                          ),
                          onPressed: () => onRemove(entry),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ] else
            ...entries.map(
              (entry) => Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Area',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            size: 16,
                            color: Colors.redAccent,
                          ),
                          onPressed: () => onRemove(entry),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    _cell(entry.areaCtrl, bordered: true),
                    const SizedBox(height: 8),
                    Text(
                      '2020',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 3),
                    _cell(entry.y2020Ctrl, bordered: true),
                    const SizedBox(height: 8),
                    Text(
                      '2025',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 3),
                    _cell(entry.y2025Ctrl, bordered: true),
                    const SizedBox(height: 8),
                    Text(
                      '2030',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 3),
                    _cell(entry.y2030Ctrl, bordered: true),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _headerCell(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 11,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _cell(
    TextEditingController ctrl, {
    bool bordered = false,
    bool showBorder = false,
  }) {
    return Container(
      constraints: const BoxConstraints(minHeight: 46),
      decoration: BoxDecoration(
        border:
            bordered
                ? Border.all(color: Colors.grey.shade300)
                : showBorder
                ? Border(right: BorderSide(color: Colors.grey.shade300))
                : null,
        borderRadius: bordered ? BorderRadius.circular(4) : null,
      ),
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 10),
      child: TextField(
        controller: ctrl,
        maxLines: null,
        minLines: 1,
        keyboardType: TextInputType.multiline,
        style: GoogleFonts.plusJakartaSans(fontSize: 12),
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
