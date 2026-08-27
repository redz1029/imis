import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/common_services/common_service.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/constant/permissions.dart';
import 'package:imis/office/models/office.dart';
import 'package:imis/performance_validation_tool/pgs_swot/models/swot.dart';
import 'package:imis/performance_validation_tool/pgs_swot/models/swot_ot_deliverable.dart';
import 'package:imis/performance_validation_tool/pgs_swot/models/swot_sw_deliverable.dart';
import 'package:imis/performance_validation_tool/pgs_swot/services/swot_service.dart';
import 'package:imis/performance_validation_tool/pgs_swot/swot_analysis_strength_weakness/services/swot_analysis_strength_weakness_service.dart';
import 'package:imis/performance_validation_tool/pgs_swot/swot_opportunies_threats/services/swot_analysis_opportunities_threats_service.dart';
import 'package:imis/user/models/user.dart';
import 'package:imis/user/models/user_registration.dart';
import 'package:imis/utils/auth_util.dart';
import 'package:imis/widgets/common/button_filter.dart';
import 'package:imis/widgets/common/filter_button_widget.dart';
import 'package:imis/widgets/common/pagination_controls.dart';
import 'package:imis/widgets/permission/permission_widget.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../widgets/common/search_underline_dropdown.dart';

class SwotContextEntry {
  final int id;
  final int? contextId;
  final String label;
  final TextEditingController leftCtrl;
  final TextEditingController rightCtrl;

  SwotContextEntry(
    this.label, {
    this.id = 0,
    this.contextId,
    String left = '',
    String right = '',
  }) : leftCtrl = TextEditingController(text: left),
       rightCtrl = TextEditingController(text: right);

  void dispose() {
    leftCtrl.dispose();
    rightCtrl.dispose();
  }
}

class SwotAnalysis {
  final int? id;
  String department;
  String? departmentId;
  String objectiveStatement;
  List<SwotContextEntry> internal;
  List<SwotContextEntry> external;
  String preparedBy;
  String reviewedBy;
  String validatedBy;
  String? qmrUserId;
  String? serviceHeadUserId;

  SwotAnalysis({
    this.id,
    this.department = '',
    this.departmentId,
    this.objectiveStatement = '',
    List<SwotContextEntry>? internal,
    List<SwotContextEntry>? external,
    this.preparedBy = '',
    this.reviewedBy = '',
    this.validatedBy = '',
    this.qmrUserId,
    this.serviceHeadUserId,
  }) : internal = internal ?? [],
       external = external ?? [];
}

class SwotAnalysisPage extends StatefulWidget {
  const SwotAnalysisPage({super.key});

  @override
  State<SwotAnalysisPage> createState() => _SwotAnalysisPageState();
}

class _SwotAnalysisPageState extends State<SwotAnalysisPage> {
  final List<SwotAnalysis> _items = [];
  int _currentPage = 1;
  final int _pageSize = 15;
  int totalCount = 0;
  bool _isLoading = false;
  List<Swot> swotList = [];
  List<Swot> filteredList = [];
  String? _userId;

  List<Office> officeList = [];
  String? _selectedOfficeId;
  bool _mobileFiltersExpanded = false;

  final _swotService = SwotService(Dio());
  final _commonService = CommonService(Dio());

  void _openDialog({SwotAnalysis? existing}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => SwotAnalysisDialog(
            existing: existing,
            onSave: (swot) {
              setState(() {
                if (existing != null) {
                  final index = _items.indexOf(existing);

                  if (index != -1) {
                    _items[index] = swot;
                    return;
                  }
                }

                _items.add(swot);
              });

              fetchSwot(page: _currentPage);
            },
          ),
    );
  }

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

    await fetchSwot();
  }

  Future<void> fetchSwot({int page = 1, String? searchQuery}) async {
    if (_isLoading) return;
    if (_userId == null) return;

    setState(() {
      _isLoading = true;
      swotList = [];
      filteredList = [];
    });

    try {
      final pageList = await _swotService.getSwot(
        page: page,
        pageSize: _pageSize,
        searchQuery: searchQuery,
        userId: _userId!,
        officeId:
            _selectedOfficeId != null ? int.tryParse(_selectedOfficeId!) : null,
      );

      if (mounted) {
        setState(() {
          _currentPage = pageList.page;
          totalCount = pageList.totalCount;
          swotList = pageList.items;
          filteredList = List.from(swotList);
        });
      }
    } on DioException {
      debugPrint("Dio error");
    } catch (e) {
      debugPrint("Unexpected error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  bool get _hasActiveFilters => _selectedOfficeId != null;

  void _resetFilters() {
    setState(() => _selectedOfficeId = null);
    fetchSwot();
  }

  Future<void> _onEditTap(Swot swot) async {
    if (swot.id == null) return;

    try {
      final full = await _swotService.getSwotById(swot.id.toString());
      if (!mounted) return;

      _openDialog(
        existing: SwotAnalysis(
          id: full.id,
          departmentId: full.departmentId.toString(),
          objectiveStatement: full.objectiveStatement ?? '',
          preparedBy: full.departmentChairUserFullName ?? '',
          reviewedBy: full.qmrUserFullName ?? '',
          validatedBy: full.serviceHeadUserFullName ?? '',
          qmrUserId: full.qmrUserId,
          serviceHeadUserId: full.serviceHeadUserId,
          internal:
              (full.swotAnalysisSWDeliverables ?? [])
                  .map(
                    (d) => SwotContextEntry(
                      d.internalContext ?? '',
                      id: d.id ?? 0,
                      contextId: d.internalContextId,
                      left: d.strength ?? '',
                      right: d.weaknesses ?? '',
                    ),
                  )
                  .toList(),
          external:
              (full.swotAnalysisOTDeliverables ?? [])
                  .map(
                    (d) => SwotContextEntry(
                      d.externalContext ?? '',
                      id: d.id ?? 0,
                      contextId: d.externalContextId,
                      left: d.opportunities ?? '',
                      right: d.threats ?? '',
                    ),
                  )
                  .toList(),
        ),
      );
    } catch (e) {
      debugPrint('Failed to fetch SWOT by ID: $e');
      if (!mounted) return;
      MotionToast.error(
        title: const Text('Load Failed'),
        description: const Text('Unable to load SWOT record for editing.'),
        toastDuration: const Duration(seconds: 4),
        toastAlignment: Alignment.topCenter,
      ).show(context);
    }
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
                              : filteredList.isEmpty
                              ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.rocket_launch,
                                      size: 50,
                                      color: Colors.grey.shade400,
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      "No swot available",
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
                                  final roadmap = filteredList[index];

                                  final itemNumber =
                                      ((_currentPage - 1) * _pageSize) +
                                      index +
                                      1;

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
                                              roadmap.departmentName ?? '',
                                              style: const TextStyle(
                                                fontSize: 12,
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
                                                          .editKraRoadMap,
                                                  child: Tooltip(
                                                    message: 'Edit',
                                                    child: IconButton(
                                                      icon: const Icon(
                                                        Icons.edit_outlined,
                                                        size: 16,
                                                      ),
                                                      onPressed:
                                                          () => _onEditTap(
                                                            roadmap,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                                Tooltip(
                                                  message: 'Print Preview',
                                                  child: IconButton(
                                                    icon: const Icon(
                                                      Icons
                                                          .description_outlined,
                                                      size: 16,
                                                      color: Colors.blueAccent,
                                                    ),
                                                    onPressed: () {
                                                      // openRoadmapInNewTab(
                                                      //   roadmap.id.toString(),
                                                      //   roadmap.kra?.name ??
                                                      //       "Roadmap Report",
                                                      //   context: context,
                                                      // );
                                                    },
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
                                              onSelected: (value) async {
                                                if (value == 'edit') {
                                                  await _onEditTap(roadmap);
                                                }
                                              },
                                              itemBuilder:
                                                  (_) => [
                                                    PopupMenuItem(
                                                      value: 'edit',
                                                      child: PermissionWidget(
                                                        permission:
                                                            AppPermissions
                                                                .editKraRoadMap,
                                                        child: const Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .edit_outlined,
                                                              size: 16,
                                                            ),
                                                            SizedBox(width: 8),
                                                            Text('Edit'),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    const PopupMenuItem(
                                                      value: 'preview',
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .description_outlined,
                                                            size: 16,
                                                            color:
                                                                Colors
                                                                    .blueAccent,
                                                          ),
                                                          SizedBox(width: 8),
                                                          Text('Print preview'),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        const SizedBox(height: 4),
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
                            totalItems: totalCount,
                            itemsPerPage: _pageSize,
                          ),
                          PaginationControls(
                            currentPage: _currentPage,
                            totalItems: totalCount,
                            itemsPerPage: _pageSize,
                            isLoading: _isLoading,
                            onPageChanged: (page) => fetchSwot(page: page),
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
                permission: AppPermissions.addSWOTAnalysis,
                child: FloatingActionButton(
                  backgroundColor: primaryColor,
                  onPressed: () => _openDialog(),
                  child: Icon(Icons.add, color: Colors.white),
                ),
              )
              : null,
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
            child: const Icon(Icons.rocket_launch, color: primaryColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SWOT Analysis',
                  style: TextStyle(
                    fontSize: isMobile ? 14 : 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A1D23),
                  ),
                ),
                Text(
                  '${filteredList.length} record${filteredList.length != 1 ? 's' : ''} found',
                  style: TextStyle(
                    fontSize: isMobile ? 10 : 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          if (!isMobile)
            PermissionWidget(
              permission: AppPermissions.addSWOTAnalysis,
              child: ElevatedButton.icon(
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
          children: [
            buildDropdown(
              child: PermissionWidget(
                permission: AppPermissions.viewOffice,
                child: _officeDropdown(),
              ),
            ),
          ],
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
              onTap: () {
                setState(
                  () => _mobileFiltersExpanded = !_mobileFiltersExpanded,
                );
              },
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
                      ? TextButton.icon(
                        key: const ValueKey('clear'),
                        onPressed: _resetFilters,
                        icon: Icon(
                          Icons.refresh,
                          size: 14,
                          color: Colors.red.shade400,
                        ),
                        label: Text(
                          'Clear filters',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.red.shade400,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 38,
                          child: PermissionWidget(
                            permission: AppPermissions.viewOffice,
                            child: _officeDropdown(),
                          ),
                        ),
                      ],
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
            fetchSwot();
          },
        ),
      ),
    );
  }
}

class SwotAnalysisDialog extends StatefulWidget {
  final SwotAnalysis? existing;
  final void Function(SwotAnalysis swot) onSave;

  const SwotAnalysisDialog({super.key, this.existing, required this.onSave});

  @override
  State<SwotAnalysisDialog> createState() => _SwotAnalysisDialogState();
}

class _SwotAnalysisDialogState extends State<SwotAnalysisDialog> {
  final _formKey = GlobalKey<FormState>();

  final _strengthWeaknessService = SwotAnalysisStrengthWeaknessService(Dio());

  final _oppThreatsService = SwotAnalysisOpportunitiesThreatsService(Dio());

  final _swotService = SwotService(Dio());

  final _commonService = CommonService(Dio());

  late TextEditingController _deptCtrl;
  late TextEditingController _objectiveCtrl;
  late TextEditingController _preparedByCtrl;

  List<SwotContextEntry> _internal = [];
  List<SwotContextEntry> _external = [];

  bool _loadingLabels = true;
  String? _loadError;

  List<String> _headOfficeIds = [];
  List<String> _headOfficeNames = [];

  String? _selectedOfficeId;
  bool _officeLoading = true;

  String? _departmentChairUserId;

  // Reviewed by (QMR) / Validated by (Service Head) are now
  // dropdowns backed by CommonService.fetchUsers() instead of
  // free-text fields.
  List<User> _users = [];
  bool _usersLoading = true;
  String? _selectedQmrUserId;
  String? _selectedServiceHeadUserId;

  @override
  void initState() {
    super.initState();

    final existing = widget.existing;

    _deptCtrl = TextEditingController(text: existing?.department ?? '');

    _objectiveCtrl = TextEditingController(
      text: existing?.objectiveStatement ?? '',
    );

    _preparedByCtrl = TextEditingController(text: existing?.preparedBy ?? '');

    _selectedQmrUserId = existing?.qmrUserId;
    _selectedServiceHeadUserId = existing?.serviceHeadUserId;

    if (existing != null) {
      _internal = existing.internal;
      _external = existing.external;
      _loadingLabels = false;
    } else {
      _loadLabels();
    }

    _loadSelectedOffice();
    _loadCurrentUser();
    _loadUsers();
  }

  String _buildFullName(UserRegistration? user) {
    if (user == null) return '';

    final middleInitial =
        (user.middleName != null && user.middleName!.trim().isNotEmpty)
            ? '${user.middleName!.trim()[0].toUpperCase()}.'
            : null;

    final parts = [
      user.prefix,
      user.firstName,
      middleInitial,
      user.lastName,
    ].where((p) => p != null && p.trim().isNotEmpty).map((p) => p!.trim());

    return parts.join(' ');
  }

  Future<void> _loadCurrentUser() async {
    final UserRegistration? user = await AuthUtil.fetchLoggedUser();
    if (!mounted) return;
    setState(() {
      _departmentChairUserId = user?.id;

      if (widget.existing == null) {
        _preparedByCtrl.text = _buildFullName(user);
      }
    });
  }

  Future<void> _loadUsers() async {
    try {
      final users = await _commonService.fetchUsers();
      if (!mounted) return;
      setState(() {
        _users = users;
        _usersLoading = false;
      });
    } catch (e) {
      debugPrint('Failed to load users: $e');
      if (!mounted) return;
      setState(() => _usersLoading = false);
    }
  }

  String _userFullName(String? id) {
    if (id == null) return '';
    final match = _users.where((u) => u.id == id);
    return match.isEmpty ? '' : (match.first.fullName);
  }

  Future<void> _loadSelectedOffice() async {
    try {
      final officeIds = await AuthUtil.fetchOfficeIds();
      final officeNames = await AuthUtil.fetchOfficeNames();

      if (officeIds == null ||
          officeNames == null ||
          officeIds.isEmpty ||
          officeNames.isEmpty) {
        if (!mounted) return;

        setState(() {
          _officeLoading = false;
        });

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

      final savedOfficeId = widget.existing?.departmentId;

      String? selectedId;

      if (savedOfficeId != null && headIds.contains(savedOfficeId)) {
        selectedId = savedOfficeId;
      }

      if (!mounted) return;
      setState(() {
        _headOfficeIds = headIds;
        _headOfficeNames = headNames;
        _selectedOfficeId = selectedId;
        _officeLoading = false;

        if (selectedId != null) {
          final index = headIds.indexOf(selectedId);

          if (index >= 0) {
            _deptCtrl.text = headNames[index];
          }
        }
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _officeLoading = false;
      });
    }
  }

  Future<void> _loadLabels() async {
    try {
      final internalItems =
          await _strengthWeaknessService.getAllOpportunitiesThreats();

      final externalItems =
          await _oppThreatsService.getAllOpportunitiesThreats();

      if (!mounted) return;

      setState(() {
        _internal =
            internalItems
                .map(
                  (e) => SwotContextEntry(
                    e.internalContext ?? '',
                    contextId: e.id,
                  ),
                )
                .toList();

        _external =
            externalItems
                .map(
                  (e) => SwotContextEntry(
                    e.externalContext ?? '',
                    contextId: e.id,
                  ),
                )
                .toList();

        _loadingLabels = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loadError = 'Failed to load context factors: $e';

        _loadingLabels = false;
      });
    }
  }

  Future<void> _saveSwot() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (_selectedOfficeId == null || _selectedOfficeId!.isEmpty) {
      MotionToast.error(
        title: const Text('Department Required'),
        description: const Text('Please select a Department/Section/Unit.'),
        toastDuration: const Duration(seconds: 4),
        toastAlignment: Alignment.topCenter,
      ).show(context);

      return;
    }

    try {
      final int swotId = widget.existing?.id ?? 0;

      final swot = Swot(
        id: swotId,
        departmentId: int.tryParse(_selectedOfficeId!),
        isDeleted: false,
        rowVersion: '',
        objectiveStatement: _objectiveCtrl.text.trim(),
        departmentChairUserId: _departmentChairUserId,
        qmrUserId: _selectedQmrUserId,
        serviceHeadUserId: _selectedServiceHeadUserId,
        postingDate: DateTime.now(),
        swotAnalysisSWDeliverables: _buildInternalDeliverables(),
        swotAnalysisOTDeliverables: _buildExternalDeliverables(),
      );

      await _swotService.createSwot(swot);

      if (!mounted) return;

      final localSwot = SwotAnalysis(
        id: swotId,
        department: _deptCtrl.text.trim(),
        departmentId: _selectedOfficeId,
        objectiveStatement: _objectiveCtrl.text.trim(),
        internal: _internal,
        external: _external,
        preparedBy: _preparedByCtrl.text.trim(),
        reviewedBy: _userFullName(_selectedQmrUserId),
        validatedBy: _userFullName(_selectedServiceHeadUserId),
        qmrUserId: _selectedQmrUserId,
        serviceHeadUserId: _selectedServiceHeadUserId,
      );

      widget.onSave(localSwot);

      Navigator.pop(context);

      MotionToast.success(
        title: const Text('Success'),
        description: const Text('SWOT Analysis saved successfully.'),
        toastDuration: const Duration(seconds: 3),
        toastAlignment: Alignment.topCenter,
      ).show(context);
    } catch (e) {
      if (!mounted) return;

      debugPrint('SWOT SAVE ERROR: $e');

      MotionToast.error(
        title: const Text('Save Failed'),
        description: Text('Unable to save SWOT Analysis.\n$e'),
        toastDuration: const Duration(seconds: 5),
        toastAlignment: Alignment.topCenter,
      ).show(context);
    }
  }

  List<SwotSwDeliverable> _buildInternalDeliverables() {
    return _internal.map((entry) {
      return SwotSwDeliverable(
        id: entry.id,
        internalContextId: entry.contextId,
        internalContext: entry.label,
        isDeleted: false,
        strength: entry.leftCtrl.text.trim(),
        weaknesses: entry.rightCtrl.text.trim(),
      );
    }).toList();
  }

  List<SwotOtDeliverable> _buildExternalDeliverables() {
    return _external.map((entry) {
      return SwotOtDeliverable(
        id: entry.id,
        externalContextId: entry.contextId,
        externalContext: entry.label,
        isDeleted: false,
        opportunities: entry.leftCtrl.text.trim(),
        threats: entry.rightCtrl.text.trim(),
      );
    }).toList();
  }

  @override
  void dispose() {
    _deptCtrl.dispose();
    _objectiveCtrl.dispose();
    _preparedByCtrl.dispose();

    for (final entry in _internal) {
      entry.dispose();
    }

    for (final entry in _external) {
      entry.dispose();
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
              'SWOT ANALYSIS',
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
    if (_loadingLabels || _officeLoading) {
      return const Center(
        child: CircularProgressIndicator(color: primaryColor),
      );
    }

    if (_loadError != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_loadError!),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                setState(() {
                  _loadingLabels = true;
                  _loadError = null;
                });
                _loadLabels();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDepartmentSectionUnitDropdown(),
            const SizedBox(height: 10),
            _labeledField(
              'Objective Statement',
              _objectiveCtrl,
              maxLines: 2,
              required: true,
            ),
            const SizedBox(height: 16),
            _SwotContextTable(
              title: 'Internal Context',
              leftHeader: 'Strengths',
              rightHeader: 'Weaknesses',
              entries: _internal,
              isSmall: isSmall,
            ),
            const SizedBox(height: 20),
            _SwotContextTable(
              title: 'External Context',
              leftHeader: 'Opportunities',
              rightHeader: 'Threats',
              entries: _external,
              isSmall: isSmall,
            ),
            const SizedBox(height: 20),
            _buildSignatureBlock(isSmall),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogActions() {
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
            onPressed:
                (_loadingLabels || _loadError != null || _officeLoading)
                    ? null
                    : _saveSwot,
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildDepartmentSectionUnitDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Department/Section/Unit',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          dropdownColor: mainBgColor,
          value: _selectedOfficeId,
          isExpanded: true,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            color: primaryTextColor,
          ),
          hint: Text(
            'Select Department/Section/Unit',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
          ),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: kBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: kBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: primaryColor, width: 1.5),
            ),
          ),
          items: List.generate(_headOfficeIds.length, (index) {
            return DropdownMenuItem<String>(
              value: _headOfficeIds[index],
              child: Text(
                _headOfficeNames[index],
                overflow: TextOverflow.ellipsis,
              ),
            );
          }),
          onChanged:
              _headOfficeIds.isEmpty
                  ? null
                  : (value) async {
                    if (value == null) {
                      return;
                    }

                    final index = _headOfficeIds.indexOf(value);

                    if (index == -1) {
                      return;
                    }

                    setState(() {
                      _selectedOfficeId = value;
                      _deptCtrl.text = _headOfficeNames[index];
                    });

                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('selectedOfficeId', value);
                    await prefs.setString(
                      'selectedOfficeName',
                      _headOfficeNames[index],
                    );
                  },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Required';
            }
            return null;
          },
        ),
      ],
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
                    if (value == null || value.trim().isEmpty) {
                      return 'Required';
                    }
                    return null;
                  }
                  : null,
        ),
      ],
    );
  }

  Widget _buildSignatureBlock(bool isSmall) {
    final sig = [
      _signatureField('Prepared by:', 'Department Chair', _preparedByCtrl),
      _userDropdownField(
        label: 'Reviewed and Verified by:',
        role: 'Quality Management Representative',
        selectedUserId: _selectedQmrUserId,
        onChanged: (value) => setState(() => _selectedQmrUserId = value),
      ),
      _userDropdownField(
        label: 'Validated by:',
        role: 'Service Head',
        selectedUserId: _selectedServiceHeadUserId,
        onChanged:
            (value) => setState(() => _selectedServiceHeadUserId = value),
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child:
          isSmall
              ? Column(
                children:
                    sig
                        .map(
                          (s) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: s,
                          ),
                        )
                        .toList(),
              )
              : Row(
                children:
                    sig
                        .map(
                          (s) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                              child: s,
                            ),
                          ),
                        )
                        .toList(),
              ),
    );
  }

  Widget _signatureField(
    String label,
    String role,
    TextEditingController ctrl,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          readOnly: true,
          controller: ctrl,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            isDense: true,
            hintText: 'Name',
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 6,
            ),
            border: const UnderlineInputBorder(),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: primaryColor),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.black87,
            fontStyle: FontStyle.italic,
          ),
        ),
        Text(
          role,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _userDropdownField({
    required String label,
    required String role,
    required String? selectedUserId,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _usersLoading
            ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: SizedBox(
                height: 14,
                width: 14,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
            : SearchUnderlineDropdown<String>(
              items: _users.map((u) => u.id).toList(),
              itemLabel: (id) {
                final match = _users.firstWhere(
                  (u) => u.id == id,
                  orElse: () => _users.first,
                );
                return match.fullName;
              },
              selectedValue:
                  _users.any((u) => u.id == selectedUserId)
                      ? selectedUserId
                      : null,
              hintText: 'Select Name',
              onChanged: onChanged,
              validator:
                  (value) =>
                      (value == null || value.isEmpty) ? 'Required' : null,
              maxPopupHeight: 300,
            ),

        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.black87,
            fontStyle: FontStyle.italic,
          ),
        ),
        Text(
          role,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _SwotContextTable extends StatelessWidget {
  final String title;
  final String leftHeader;
  final String rightHeader;
  final List<SwotContextEntry> entries;
  final bool isSmall;

  const _SwotContextTable({
    required this.title,
    required this.leftHeader,
    required this.rightHeader,
    required this.entries,
    required this.isSmall,
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
            child: Text(
              title,
              style: const TextStyle(
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
                'No context factors found.',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            )
          else if (!isSmall) ...[
            Container(
              color: Colors.grey.shade100,
              child: Row(
                children: [
                  Expanded(flex: 2, child: _headerCell('')),
                  Expanded(flex: 3, child: _headerCell(leftHeader)),
                  Expanded(flex: 3, child: _headerCell(rightHeader)),
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
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(color: Colors.grey.shade300),
                            ),
                          ),
                          child: Text(
                            entry.label,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Expanded(flex: 3, child: _cell(entry.leftCtrl)),
                      Expanded(flex: 3, child: _cell(entry.rightCtrl)),
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
                    Text(
                      entry.label,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      leftHeader,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 3),
                    _cell(entry.leftCtrl, bordered: true),
                    const SizedBox(height: 8),
                    Text(
                      rightHeader,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 3),
                    _cell(entry.rightCtrl, bordered: true),
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

  Widget _cell(TextEditingController ctrl, {bool bordered = false}) {
    return Container(
      constraints: const BoxConstraints(minHeight: 46),
      decoration: BoxDecoration(
        border:
            bordered
                ? Border.all(color: Colors.grey.shade300)
                : Border(right: BorderSide(color: Colors.grey.shade300)),
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
