// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/common_services/common_service.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/constant/permissions.dart';
import 'package:imis/office/models/office.dart';
import 'package:imis/performance_governance_system/deliverable_status_monitoring/services/deliverable_status_monitoring_service.dart';
import 'package:imis/performance_governance_system/models/performance_governance_system.dart';
import 'package:imis/performance_governance_system/pgs_period/models/pgs_period.dart';
import 'package:imis/performance_governance_system/pgs_performance_validation_tool/dialog/performance_validation_dialog.dart';
import 'package:imis/performance_governance_system/pgs_performance_validation_tool/models/performance_validation_tool.dart';
import 'package:imis/performance_governance_system/pgs_performance_validation_tool/services/performance_validation_services.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/auth_util.dart';
import 'package:imis/utils/date_time_converter.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/widgets/common/filter_button_widget.dart';
import 'package:imis/widgets/common/button_filter.dart';
import 'package:imis/widgets/common/pagination_controls.dart';
import 'package:imis/widgets/dialog/delete_dialog.dart';
import 'package:imis/widgets/permission/permission_widget.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/html.dart' as html;

class PerformanceValidationPage extends StatefulWidget {
  const PerformanceValidationPage({super.key});

  @override
  State<PerformanceValidationPage> createState() =>
      PerformanceValidationPageState();
}

class PerformanceValidationPageState extends State<PerformanceValidationPage> {
  List<Office> officeList = [];
  List<Office> serviceList = [];
  String? _selectedOfficeId;
  String? _selectedServiceId;
  int _currentPage = 1;
  final int _pageSize = 15;
  int _totalCount = 0;
  bool _isLoading = false;
  List<PerformanceGovernanceSystem> operationReviewprotocolList = [];
  List<PerformanceGovernanceSystem> filteredList = [];
  String? _selectedPeriodId;
  List<PgsPeriod> pgsPeriodList = [];
  final _deliverableStatusMonitoring = DeliverableStatusMonitoringService(
    Dio(),
  );
  final _commonService = CommonService(Dio());
  final _performanceValidation = PerformanceValidationServices(Dio());
  bool _mobileFiltersExpanded = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> fetchPerformanceValidation({
    int page = 1,
    String? searchQuery,
  }) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final roleId = await _getRoleId();

      if (roleId.isEmpty) {
        debugPrint('Role ID is empty, aborting fetch.');
        return;
      }

      final pageList = await _performanceValidation
          .getPerformanceValidationPageList(
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

      final result = await _performanceValidation
          .getPerformanceValidationPageList(
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

    if (!mounted) return;
    setState(() {
      officeList = offices;
      serviceList = services;
      pgsPeriodList = periods;
      _isLoading = false;
    });
    _applyDefaultActivePeriod();
  }

  void _applyDefaultActivePeriod() {
    final activePeriod =
        pgsPeriodList
            .where((p) => !p.isDeleted && p.isActive == true)
            .firstOrNull;

    if (activePeriod != null) {
      setState(() {
        _selectedPeriodId = activePeriod.id.toString();
      });
    }

    fetchFilter();
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
                                      "No performance validation available",
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
                                  return _PgsValidationTile(
                                    pgs: pgs,
                                    performanceValidationService:
                                        _performanceValidation,
                                    commonService: _commonService,
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
                                (page) =>
                                    fetchPerformanceValidation(page: page),
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
                  Icons.fact_check_outlined,
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
                      "Performance Validation Tool",
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
                    // Text(
                    //   "$_totalCount performance validation${_totalCount != 1 ? 's' : ''} found",
                    //   style: TextStyle(
                    //     fontSize: isXSmall ? 10 : 12,
                    //     color: Colors.grey.shade600,
                    //   ),
                    // ),
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
    fetchPerformanceValidation();
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
                        SizedBox(
                          height: 38,
                          child: PermissionWidget(
                            permission: AppPermissions.viewOffice,
                            child: _periodDropdown(),
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

class _PgsValidationTile extends StatefulWidget {
  final PerformanceGovernanceSystem pgs;
  final PerformanceValidationServices performanceValidationService;
  final CommonService commonService;

  const _PgsValidationTile({
    required this.pgs,
    required this.performanceValidationService,
    required this.commonService,
  });

  @override
  State<_PgsValidationTile> createState() => _PgsValidationTileState();
}

class _PgsValidationTileState extends State<_PgsValidationTile> {
  bool _expanded = false;
  bool _loading = false;
  bool _loaded = false;
  bool _checkingSignatory = false;
  List<PerformanceValidationTool> _validations = [];

  String get _pgsId => widget.pgs.id.toString();

  Future<void> _loadValidations() async {
    setState(() => _loading = true);
    final list = await widget.performanceValidationService
        .fetchAllPerformanceValidationList(pgsId: _pgsId);
    if (!mounted) return;
    setState(() {
      _validations = list;
      _loading = false;
      _loaded = true;
    });
  }

  String _periodLabel(PerformanceValidationTool v) {
    if (v.validateDate != null) {
      return LongDateOnlyConverter().toJson(v.validateDate!);
    }
    return '—';
  }

  Future<void> _showNoSignatoryDialog() async {
    await showDialog(
      context: context,
      builder:
          (ctx) => Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              width: 380,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
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
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.pending_actions_outlined,
                      color: Colors.orange.shade700,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Deliverables Not Yet Submitted',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'The head of ${widget.pgs.office.name} has not submitted their '
                    'deliverables yet. Performance validation cannot be created '
                    'until the head department has submitted.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'OK',
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Future<void> _openNewValidation() async {
    setState(() => _checkingSignatory = true);

    String? headUserId;
    try {
      final signatories = await widget.commonService.fetchPgsSignatories(
        widget.pgs.id,
      );
      if (signatories.isNotEmpty) {
        headUserId = signatories.first.signatoryId;
      }
    } catch (_) {
      headUserId = null;
    }

    if (mounted) setState(() => _checkingSignatory = false);

    if (headUserId == null || headUserId.isEmpty) {
      if (mounted) await _showNoSignatoryDialog();
      return;
    }

    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PerformanceValidationDialog(pgs: widget.pgs),
    ).then((saved) {
      if (saved == true) _loadValidations();
    });
  }

  Future<void> _openSavedValidation(PerformanceValidationTool v) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => const Center(
            child: CircularProgressIndicator(color: primaryColor),
          ),
    );

    final user = await AuthUtil.fetchLoggedUser();

    final results = await Future.wait([
      widget.performanceValidationService.fetchPerformanceValidationToolById(
        id: v.id,
      ),
      if (user != null && user.id != null && user.id!.isNotEmpty)
        widget.performanceValidationService.getPerformanceValidationByUserId(
          userId: user.id!,
          performanceValidationToolId: v.id,
        )
      else
        Future.value(null),
    ]);

    final data = results[0] as PerformanceValidationTool?;

    if (!mounted) return;
    Navigator.pop(context);

    showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (_) => PerformanceValidationDialog(pgs: widget.pgs, existing: data),
    ).then((saved) {
      if (saved == true) _loadValidations();
    });
  }

  void _showDeleteDialog(PerformanceValidationTool v) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder:
          (ctx) => DeleteDialog(
            title: 'Performance Validation',
            itemName: 'performance validation',
            onDelete: () async {
              Navigator.pop(ctx);
              try {
                await widget.performanceValidationService
                    .deletePerformanceValidation(v.id.toString());
                await _loadValidations();
                if (mounted) {
                  MotionToast.success(
                    description: Text(
                      'Performance validation deleted successfully',
                      style: GoogleFonts.plusJakartaSans(),
                    ),
                  ).show(context);
                }
              } catch (_) {
                MotionToast.error(
                  description: Text(
                    'Failed to deleted performance validation tool',
                  ),
                ).show(context);
              }
            },
          ),
    );
  }

  Future<void> _openPrintPreview(PerformanceValidationTool v) async {
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
      final url = '${ApiEndpoint().performanceValidationPdfReport}/${v.id}';

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
          final filePath = '${tempDir.path}/performance_validation_${v.id}.pdf';
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
          final filePath = '${dir!.path}/performance_validation_${v.id}.pdf';
          await File(filePath).writeAsBytes(bytes);
          final result = await OpenFile.open(filePath);
          if (result.type != ResultType.done) {
            debugPrint('OpenFile error: ${result.message}');
          }
        }
      }
    } catch (e) {
      debugPrint('Error opening Performance Validation PDF: $e');
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
            if (open && !_loaded) _loadValidations();
          },
          leading: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.business_outlined,
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
                permission: AppPermissions.addPerformanceValidationTool,
                child:
                    _checkingSignatory
                        ? const Padding(
                          padding: EdgeInsets.all(8),
                          child: SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: primaryColor,
                            ),
                          ),
                        )
                        : IconButton(
                          tooltip: 'Add performance validation',
                          icon: const Icon(
                            Icons.note_add_outlined,
                            color: primaryColor,
                            size: 20,
                          ),
                          onPressed: () async {
                            if (!_expanded) setState(() => _expanded = true);
                            if (!_loaded) await _loadValidations();
                            await _openNewValidation();
                          },
                        ),
              ),
              const SizedBox(width: 6),
              const Tooltip(
                message: 'Expand',
                child: Icon(Icons.expand_more_rounded, color: kMuted, size: 20),
              ),
            ],
          ),
          children: [
            if (_loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              )
            else if (_validations.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Text(
                    'No performance validations yet.',
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
                  itemCount: _validations.length,
                  separatorBuilder:
                      (_, __) =>
                          Divider(height: 1, color: Colors.grey.shade200),
                  itemBuilder: (_, i) {
                    final v = _validations[i];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _periodLabel(v),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          IconButton(
                            tooltip: 'View / Edit',
                            icon: const Icon(
                              Icons.fact_check_outlined,
                              size: 16,
                              color: primaryColor,
                            ),
                            onPressed: () => _openSavedValidation(v),
                          ),
                          IconButton(
                            tooltip: 'Print Preview',
                            icon: const Icon(
                              Icons.description_outlined,
                              size: 16,
                              color: Colors.blueAccent,
                            ),
                            onPressed: () => _openPrintPreview(v),
                          ),
                          PermissionWidget(
                            permission:
                                AppPermissions.deletePerformanceValidationTool,
                            child: IconButton(
                              tooltip: 'Delete',
                              icon: const Icon(
                                CupertinoIcons.delete_simple,
                                size: 16,
                                color: Colors.red,
                              ),
                              onPressed: () => _showDeleteDialog(v),
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
