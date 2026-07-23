import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:imis/common_services/common_service.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/constant/permissions.dart';
import 'package:imis/office/models/office.dart';
import 'package:imis/operation_review_protocol/dialog/operations_review_protocol_widget.dart';
import 'package:imis/operation_review_protocol/models/operations_review_protocol.dart';
import 'package:imis/operation_review_protocol/services/operation_review_protocol_services.dart';
import 'package:imis/performance_governance_system/deliverable_status_monitoring/models/pgs_deliverable_accomplishment.dart';
import 'package:imis/performance_governance_system/deliverable_status_monitoring/services/deliverable_status_monitoring_service.dart';
import 'package:imis/performance_governance_system/models/performance_governance_system.dart';
import 'package:imis/performance_governance_system/models/pgs_deliverables.dart';
import 'package:imis/performance_governance_system/pgs_period/models/pgs_period.dart';
import 'package:imis/performance_governance_system/services/performance_governance_system_service.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/auth_util.dart';
import 'package:imis/utils/date_time_converter.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/widgets/common/filter_button_widget.dart';
import 'package:imis/widgets/common/button_filter.dart';
import 'package:imis/widgets/common/pagination_controls.dart';
import 'package:imis/widgets/dialog/delete_dialog.dart';
import 'package:imis/widgets/permission/permission_widget.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/html.dart' as html;

class OperationReviewProtocolPage extends StatefulWidget {
  const OperationReviewProtocolPage({super.key});

  @override
  State<OperationReviewProtocolPage> createState() =>
      OperationReviewProtocolPageState();
}

class OperationReviewProtocolPageState
    extends State<OperationReviewProtocolPage> {
  List<Office> officeList = [];
  List<Office> serviceList = [];
  String? _selectedOfficeId;
  String? _selectedServiceId;
  int _currentPage = 1;
  final int _pageSize = 15;
  int _totalCount = 0;
  bool _isLoading = false;
  String _roleId = '';
  List<PerformanceGovernanceSystem> operationReviewprotocolList = [];
  List<PerformanceGovernanceSystem> filteredList = [];
  String? _selectedPeriodId;
  List<PgsPeriod> pgsPeriodList = [];
  final _deliverableStatusMonitoring = DeliverableStatusMonitoringService(
    Dio(),
  );
  final _commonService = CommonService(Dio());
  final _operationReviewProtocolService = OperationReviewProtocolServices(
    Dio(),
  );
  final _pgsService = PerformanceGovernanceSystemService(Dio());

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> fetchOperationReview({int page = 1, String? searchQuery}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final roleId = await _getRoleId();

      if (roleId.isEmpty) {
        debugPrint('Role ID is empty, aborting fetch.');
        return;
      }

      setState(() => _roleId = roleId);

      final pageList = await _operationReviewProtocolService
          .getOperationReviewProtocolList(
            page: page,
            pageSize: _pageSize,
            searchQuery: searchQuery,
            roleId: roleId,
          );

      if (mounted) {
        setState(() {
          _currentPage = pageList.page;
          _totalCount = pageList.totalCount;
          operationReviewprotocolList = pageList.items;
          filteredList = List.from(operationReviewprotocolList);
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

  Future<void> fetchFilter({int? page, int pageSize = 15}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final targetPage = page ?? _currentPage;
      final roleIdParam = await _getRoleId();

      final result = await _operationReviewProtocolService
          .getOperationReviewProtocolList(
            roleId: roleIdParam,
            page: targetPage,
            pageSize: pageSize,
            officeId: _selectedOfficeId,
            periodId: _selectedPeriodId,
          );

      setState(() {
        operationReviewprotocolList = result.items;
        filteredList = result.items;
        _currentPage = result.page;
        _totalCount = result.totalCount;
      });
    } finally {
      setState(() => _isLoading = false);
    }
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

  Future<void> _initialize() async {
    setState(() => _isLoading = true);
    final roleId = await _getRoleId();
    final offices = await _deliverableStatusMonitoring.fetchOffices(
      roleId: roleId,
    );
    final services = await _commonService.fetchService();
    final periods = await _commonService.fetchPgsPeriod();
    await _commonService.fetchPgsPeriod();

    if (!mounted) return;
    setState(() {
      officeList = offices;
      serviceList = services;
      pgsPeriodList = periods;
      _isLoading = false;
    });
    await fetchOperationReview();
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
                                      Icons.reviews_outlined,
                                      size: 50,
                                      color: Colors.grey.shade400,
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      "No operation review protocol available",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              : ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                itemCount: filteredList.length,
                                itemBuilder: (context, index) {
                                  final pgs = filteredList[index];
                                  return _PgsReviewTile(
                                    pgs: pgs,
                                    pgsService: _pgsService,
                                    deliverableAccomplishmentService:
                                        _deliverableStatusMonitoring,
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
                                (page) => fetchOperationReview(page: page),
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
                  Icons.reviews_outlined,
                  color: primaryColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Operation Review Protocol Information",
                      style: TextStyle(
                        fontSize:
                            isXSmall
                                ? 12
                                : isSmall
                                ? 14
                                : 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1D23),
                      ),
                    ),
                    Text(
                      "$_totalCount operation review protocol${_totalCount != 1 ? 's' : ''} found",

                      style: TextStyle(
                        fontSize: isXSmall ? 10 : 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  bool get _hasActiveFilters =>
      _selectedOfficeId != null ||
      _selectedServiceId != null ||
      _selectedPeriodId != null;
  void _resetFilters() {
    setState(() {
      _selectedOfficeId = null;
      _selectedServiceId = null;
      _selectedPeriodId = null;
      filteredList = List.from(operationReviewprotocolList);
    });
    fetchOperationReview();
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.tune, size: 15, color: Colors.grey.shade600),
            const SizedBox(width: 6),
            Text(
              "Filter by",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
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
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            // buildDropdown(child: _serviceDropdown()),
            buildDropdown(
              child: PermissionWidget(
                permission: AppPermissions.viewOffice,
                child: _officeDropdown(),
              ),
            ),
            buildDropdown(child: _periodDropdown()),
          ],
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
            const Text(
              "Filter by",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: grey,
              ),
            ),
            const Spacer(),
            if (_hasActiveFilters)
              TextButton.icon(
                onPressed: _resetFilters,
                icon: Icon(Icons.refresh, size: 14, color: Colors.red.shade400),
                label: Text(
                  'Clear',
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
        gap8px,
        SizedBox(
          height: 38,
          child: PermissionWidget(
            permission: AppPermissions.viewOffice,
            child: _officeDropdown(),
          ),
        ),
        SizedBox(
          height: 38,
          child: PermissionWidget(
            permission: AppPermissions.viewOffice,
            child: _periodDropdown(),
          ),
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
            fetchFilter();
          },
        ),
      ),
    );
  }

  Widget _periodDropdown() {
    final converter = LongDateOnlyConverter();
    final items = pgsPeriodList.where((p) => !p.isDeleted).toList();
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 150, maxWidth: 400),
      child: SizedBox(
        height: 38,
        child: SearchableDropdown(
          items: [
            "All Periods",
            ...items.map(
              (p) =>
                  "${converter.toJson(p.startDate)} - ${converter.toJson(p.endDate)}",
            ),
          ],
          selectedItem:
              _selectedPeriodId == null
                  ? "All Periods"
                  : (() {
                    final match =
                        items
                            .where((p) => p.id.toString() == _selectedPeriodId)
                            .firstOrNull;
                    if (match == null) return "All Periods";
                    return "${converter.toJson(match.startDate)} - ${converter.toJson(match.endDate)}";
                  })(),
          hintText: "Period",
          searchHint: "Search periods...",
          prefixIcon: Icons.calendar_today_outlined,
          onChanged: (value) {
            setState(() {
              if (value == "All Periods") {
                _selectedPeriodId = null;
              } else {
                final selected = items.firstWhere(
                  (p) =>
                      "${converter.toJson(p.startDate)} - ${converter.toJson(p.endDate)}" ==
                      value,
                );
                _selectedPeriodId = selected.id.toString();
              }
            });
            fetchFilter();
          },
        ),
      ),
    );
  }
}

class _PgsReviewTile extends StatefulWidget {
  final PerformanceGovernanceSystem pgs;
  final PerformanceGovernanceSystemService pgsService;
  final DeliverableStatusMonitoringService deliverableAccomplishmentService;

  const _PgsReviewTile({
    required this.pgs,
    required this.pgsService,
    required this.deliverableAccomplishmentService,
  });

  @override
  State<_PgsReviewTile> createState() => _PgsReviewTileState();
}

class _PgsReviewTileState extends State<_PgsReviewTile> {
  static const _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  bool _expanded = false;
  bool _loading = false;
  bool _loaded = false;
  List<OperationsReviewProtocol> _protocols = [];

  String get _pgsId => widget.pgs.id.toString();

  Future<void> _loadProtocols() async {
    setState(() => _loading = true);
    final list = await widget.pgsService.fetchAllOperationReviewProtocols(
      pgsId: _pgsId,
    );
    if (!mounted) return;
    setState(() {
      _protocols = list;
      _loading = false;
      _loaded = true;
    });
  }

  bool _isSubmitted(OperationsReviewProtocol p) => p.isDraft != true;

  String _monthLabel(DateTime date) =>
      '${_monthNames[date.month - 1]} ${date.year}';

  List<DateTime> get _allMonths {
    final start = widget.pgs.pgsPeriod.startDate;
    final end = widget.pgs.pgsPeriod.endDate;
    final months = <DateTime>[];
    var current = DateTime(start.year, start.month);
    final last = DateTime(end.year, end.month);
    while (!current.isAfter(last)) {
      months.add(current);
      current = DateTime(current.year, current.month + 1);
    }
    return months;
  }

  List<DateTime> get _availableMonths {
    final saved =
        _protocols
            .where((p) => p.postingDate != null)
            .map((p) => DateTime(p.postingDate!.year, p.postingDate!.month))
            .toSet();
    return _allMonths.where((m) => !saved.contains(m)).toList();
  }

  Future<void> _showMonthPicker() async {
    if (_availableMonths.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All months already have a protocol.')),
      );
      return;
    }
    final picked = await showDialog<DateTime>(
      context: context,
      barrierDismissible: false,
      builder:
          (ctx) => Dialog(
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 40,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 400,
                maxHeight: MediaQuery.of(context).size.height * 0.7,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(10),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'SELECT MONTH',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            size: 18,
                            color: Colors.white70,
                          ),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Container(
                      color: Theme.of(context).cardColor,
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        itemCount: _availableMonths.length,
                        separatorBuilder:
                            (_, __) =>
                                Divider(height: 1, color: Colors.grey.shade200),
                        itemBuilder: (context, index) {
                          final m = _availableMonths[index];
                          return InkWell(
                            onTap: () => Navigator.pop(ctx, m),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 13,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today_outlined,
                                    color: primaryColor,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      _monthLabel(m),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.chevron_right,
                                    color: Colors.grey,
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
    if (picked != null) await _openNewReview(picked);
  }

  Future<void> _openNewReview(DateTime month) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => const Center(
            child: CircularProgressIndicator(color: primaryColor),
          ),
    );

    final results = await Future.wait([
      widget.pgsService.fetchIdDeliverable(
        pgsId: _pgsId,
        month: month.month.toString(),
        year: month.year.toString(),
      ),
      widget.pgsService.fetchDeliverablesOnly(pgsId: _pgsId),
    ]);

    if (!mounted) return;
    Navigator.pop(context);

    final accomplishments = results[0] as List<PgsDeliverableAccomplishment>;
    final allDeliverables = results[1] as List<PgsDeliverables>;

    if (accomplishments.length < allDeliverables.length) {
      final missing = allDeliverables.length - accomplishments.length;
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange.shade700,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Incomplete accomplishments',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              content: Text(
                'All deliverables must have accomplishments recorded for '
                '${_monthLabel(month)} before creating an Operations Review Protocol.\n\n'
                '$missing out of ${allDeliverables.length} deliverable(s) '
                '${missing == 1 ? 'has' : 'have'} no accomplishment yet.\n\n'
                'Please encode all accomplishments first.',
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Got it',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
      );
      return;
    }

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => OperationsReviewDialog(
            data: widget.pgs,
            accomplishments: accomplishments,
            month: month,
            existingProtocol: null,
            onSave:
                (request, {Uint8List? minutesBytes, String? minutesFileName}) =>
                    widget.pgsService.saveOperationReviewProtocol(
                      request: request,
                      minutesBytes: minutesBytes,
                      minutesFileName: minutesFileName,
                    ),
            onSaveAccomplishments: (updates) async {
              try {
                await Future.wait(
                  updates.map((u) {
                    final acc = accomplishments.firstWhere((a) => a.id == u.id);
                    return widget.deliverableAccomplishmentService
                        .updateAccomplishmentStatus(acc, u.status);
                  }),
                );
                return true;
              } catch (e) {
                debugPrint('Accomplishment update failed: $e');
                return false;
              }
            },
          ),
    );
    await _loadProtocols();
  }

  Future<void> _openSavedReview(OperationsReviewProtocol saved) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => const Center(
            child: CircularProgressIndicator(color: primaryColor),
          ),
    );

    final postingDate = saved.postingDate ?? DateTime.now();
    final results = await Future.wait([
      widget.pgsService.fetchIdDeliverable(
        pgsId: _pgsId,
        month: postingDate.month.toString(),
        year: postingDate.year.toString(),
      ),
      widget.pgsService.fetchOperationReviewProtocolById(id: saved.id),
    ]);

    if (!mounted) return;
    Navigator.pop(context);

    final accomplishments = results[0] as List<PgsDeliverableAccomplishment>;
    final protocol = results[1] as OperationsReviewProtocol?;

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (_) => OperationsReviewDialog(
            data: widget.pgs,
            accomplishments: accomplishments,
            month: postingDate,
            existingProtocol: protocol,
            onSave:
                (request, {Uint8List? minutesBytes, String? minutesFileName}) =>
                    widget.pgsService.saveOperationReviewProtocol(
                      request: request,
                      minutesBytes: minutesBytes,
                      minutesFileName: minutesFileName,
                    ),
            onSaveAccomplishments: (updates) async {
              try {
                await Future.wait(
                  updates.map((u) {
                    final acc = accomplishments.firstWhere((a) => a.id == u.id);
                    return widget.deliverableAccomplishmentService
                        .updateAccomplishmentStatus(acc, u.status);
                  }),
                );
                return true;
              } catch (e) {
                debugPrint('Accomplishment update failed: $e');
                return false;
              }
            },
          ),
    );
    await _loadProtocols();
  }

  Future<void> _openPrintPreview(OperationsReviewProtocol p) async {
    if (p.postingDate == null) return;

    final dio = Dio();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => const AlertDialog(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: primaryColor),
                SizedBox(width: 16),
                Text(
                  'Generating PDF...',
                  style: TextStyle(color: primaryColor),
                ),
              ],
            ),
          ),
    );

    try {
      final url =
          '${ApiEndpoint().reportProtocol}/${p.id}'
          '?pgsId=$_pgsId&month=${p.postingDate!.month}&year=${p.postingDate!.year}';

      final response = await AuthenticatedRequest.get(
        dio,
        url,
        options: Options(
          responseType: ResponseType.bytes,
          headers: {'Accept': 'application/pdf'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final bytes = Uint8List.fromList(response.data);

        if (kIsWeb) {
          final blob = html.Blob([bytes], 'application/pdf');
          final blobUrl = html.Url.createObjectUrlFromBlob(blob);
          html.window.open(blobUrl, '_blank');
          Future.delayed(const Duration(seconds: 15), () {
            html.Url.revokeObjectUrl(blobUrl);
          });
        } else if (Platform.isAndroid || Platform.isIOS) {
          final tempDir = await getTemporaryDirectory();
          final filePath =
              '${tempDir.path}/operations_review_${p.id}_${p.postingDate!.month}${p.postingDate!.year}.pdf';
          await File(filePath).writeAsBytes(bytes);
          final result = await OpenFile.open(filePath);
          if (result.type != ResultType.done) {
            debugPrint('OpenFile error: ${result.message}');
          }
        } else {
          final dir =
              Platform.isWindows
                  ? await getDownloadsDirectory()
                  : await getApplicationDocumentsDirectory();
          final filePath =
              '${dir!.path}/operations_review_${p.id}_${p.postingDate!.month}${p.postingDate!.year}.pdf';
          await File(filePath).writeAsBytes(bytes);
          final result = await OpenFile.open(filePath);
          if (result.type != ResultType.done) {
            debugPrint('OpenFile error: ${result.message}');
          }
        }
      }
    } catch (e) {
      debugPrint('Error opening Operations Review PDF: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to open PDF. Please try again.'),
          ),
        );
      }
    } finally {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
  }

  void _showDeleteDialog(OperationsReviewProtocol p) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder:
          (ctx) => DeleteDialog(
            title: 'Performance Validation',
            itemName: 'performance validation',
            onDelete: () async {
              Navigator.pop(ctx);
              await widget.pgsService.deleteOperationReviewProtocol(
                p.id.toString(),
              );
              await _loadProtocols();
            },
          ),
    );
  }

  Widget _statusBadge(OperationsReviewProtocol p) {
    final submitted = _isSubmitted(p);
    final color = submitted ? Colors.green.shade600 : Colors.grey.shade600;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Tooltip(
        message:
            submitted
                ? 'Already submitted and can no longer be edited.'
                : 'This item is still editable. You can make changes before submitting.',

        child: Text(
          submitted ? 'Submitted' : 'Draft',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final converter = LongDateOnlyConverter();
    final start = converter.toJson(widget.pgs.pgsPeriod.startDate);
    final end = converter.toJson(widget.pgs.pgsPeriod.endDate);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          childrenPadding: EdgeInsets.zero,
          onExpansionChanged: (open) {
            setState(() => _expanded = open);
            if (open && !_loaded) _loadProtocols();
          },
          leading: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.apartment_rounded,
              color: primaryColor,
              size: 18,
            ),
          ),
          title: Text(
            widget.pgs.office.name,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          ),
          subtitle: Text(
            "$start - $end",
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              PermissionWidget(
                permission: AppPermissions.addOperationReviewProtocol,
                child: IconButton(
                  tooltip: 'Add operation review protocol',
                  icon: const Icon(
                    Icons.note_add_outlined,
                    color: primaryColor,
                    size: 20,
                  ),
                  onPressed: () async {
                    if (!_expanded) setState(() => _expanded = true);
                    if (!_loaded) await _loadProtocols();
                    await _showMonthPicker();
                  },
                ),
              ),
              const SizedBox(width: 6),
              Tooltip(
                message: 'Expand',
                child: const Icon(
                  Icons.expand_more_rounded,
                  color: kMuted,
                  size: 20,
                ),
              ),
            ],
          ),

          children: [
            if (_loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              )
            else if (_protocols.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Text(
                    'No monthly review protocols yet.',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ),
              )
            else
              Container(
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FB),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _protocols.length,
                  separatorBuilder:
                      (_, __) =>
                          Divider(height: 1, color: Colors.grey.shade200),
                  itemBuilder: (_, i) {
                    final p = _protocols[i];
                    final label =
                        p.postingDate != null
                            ? _monthLabel(p.postingDate!)
                            : '—';
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              label,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          _statusBadge(p),
                          const SizedBox(width: 4),
                          IconButton(
                            tooltip: 'View / Edit',
                            icon: const Icon(
                              Icons.reviews_outlined,
                              size: 16,
                              color: Colors.deepOrangeAccent,
                            ),
                            onPressed: () => _openSavedReview(p),
                          ),
                          IconButton(
                            tooltip: 'Print Preview',
                            icon: const Icon(
                              Icons.description_outlined,
                              size: 16,
                              color: Colors.blueAccent,
                            ),
                            onPressed:
                                p.postingDate == null
                                    ? null
                                    : () => _openPrintPreview(p),
                          ),
                          PermissionWidget(
                            permission:
                                AppPermissions.deleteOperationReviewProtocol,
                            child: IconButton(
                              tooltip: 'Delete',
                              icon: const Icon(
                                CupertinoIcons.delete_simple,
                                size: 16,
                                color: Colors.red,
                              ),
                              onPressed: () => _showDeleteDialog(p),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
