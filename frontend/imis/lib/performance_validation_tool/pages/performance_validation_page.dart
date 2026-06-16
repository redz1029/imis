import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:imis/common_services/common_service.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/constant/permissions.dart';
import 'package:imis/office/models/office.dart';
import 'package:imis/operation_review_protocol/services/operation_review_protocol_services.dart';
import 'package:imis/performance_governance_system/deliverable_status_monitoring/services/deliverable_status_monitoring_service.dart';
import 'package:imis/performance_governance_system/models/performance_governance_system.dart';
import 'package:imis/performance_governance_system/services/performance_governance_system_service.dart';
import 'package:imis/performance_validation_tool/pages/performance_validation_dialog.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/auth_util.dart';
import 'package:imis/utils/date_time_converter.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/widgets/common/filter_button_widget.dart';
import 'package:imis/widgets/common/button_filter.dart';
import 'package:imis/widgets/dialog/monthly_review_dialog_widget.dart';
import 'package:imis/widgets/common/pagination_controls.dart';
import 'package:imis/widgets/permission_widget.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/html.dart' as html;

class PerformanceValidationPage extends StatefulWidget {
  const PerformanceValidationPage({super.key});

  @override
  State<PerformanceValidationPage> createState() =>
      OperationReviewProtocolPageState();
}

class OperationReviewProtocolPageState
    extends State<PerformanceValidationPage> {
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

  // Future<void> fetchOperationReview({int page = 1, String? searchQuery}) async {
  //   if (_isLoading) return;

  //   setState(() => _isLoading = true);

  //   try {
  //     final roleId = await _getRoleId();

  //     if (roleId.isEmpty) {
  //       debugPrint('Role ID is empty, aborting fetch.');
  //       return;
  //     }

  //     setState(() => _roleId = roleId);

  //     final pageList = await _operationReviewProtocolService
  //         .getOperationReviewProtocolList(
  //           page: page,
  //           pageSize: _pageSize,
  //           searchQuery: searchQuery,
  //           roleId: roleId,
  //         );

  //     if (mounted) {
  //       setState(() {
  //         _currentPage = pageList.page;
  //         _totalCount = pageList.totalCount;
  //         operationReviewprotocolList = pageList.items;
  //         _applyFilters(pageList.items);
  //       });
  //     }
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   } finally {
  //     if (mounted) {
  //       setState(() => _isLoading = false);
  //     }
  //   }
  // }

  void _applyFilters(List<PerformanceGovernanceSystem> source) {
    var result = List<PerformanceGovernanceSystem>.from(source);

    if (_selectedOfficeId != null) {
      result =
          result
              .where((pgs) => pgs.office.id.toString() == _selectedOfficeId)
              .toList();
    }

    if (_selectedServiceId != null) {
      result =
          result
              .where((pgs) => pgs.office.id.toString() == _selectedServiceId)
              .toList();
    }

    filteredList = result;
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
    await _commonService.fetchPgsPeriod();

    if (!mounted) return;
    setState(() {
      officeList = offices;
      serviceList = services;
      _isLoading = false;
    });
    // await fetchOperationReview();
  }

  void _openMonthlyReviewDialog(PerformanceGovernanceSystem pgs) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (_) => MonthlyReviewListDialog(
            pgsId: pgs.id.toString(),
            startDate: pgs.pgsPeriod.startDate,
            endDate: pgs.pgsPeriod.endDate,
            data: pgs,
            onFetch:
                (id, month, year) => _pgsService.fetchIdDeliverable(
                  pgsId: id,
                  month: month,
                  year: year,
                ),
            onFetchDeliverables:
                (pgsId) => _pgsService.fetchDeliverablesOnly(pgsId: pgsId),
            onFetchAll:
                (pgsId) =>
                    _pgsService.fetchAllOperationReviewProtocols(pgsId: pgsId),
            onFetchById:
                (id) => _pgsService.fetchOperationReviewProtocolById(id: id),
            onSave:
                (request, {Uint8List? minutesBytes, String? minutesFileName}) =>
                    _pgsService.saveOperationReviewProtocol(
                      request: request,
                      minutesBytes: minutesBytes,
                      minutesFileName: minutesFileName,
                    ),
          ),
    );
  }

  Future<void> _openPrintPreview(PerformanceGovernanceSystem pgs) async {
    if (_roleId.isEmpty) {
      debugPrint('Role ID is empty, aborting print preview.');
      return;
    }

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
      final url = '${ApiEndpoint().operationReviewProtocol}/$_roleId';

      if (kIsWeb) {
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
          final blob = html.Blob([bytes], 'application/pdf');
          final blobUrl = html.Url.createObjectUrlFromBlob(blob);
          html.window.open(blobUrl, '_blank');
          Future.delayed(const Duration(seconds: 15), () {
            html.Url.revokeObjectUrl(blobUrl);
          });
        }
      } else if (Platform.isAndroid || Platform.isIOS) {
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
          final tempDir = await getTemporaryDirectory();
          final filePath = '${tempDir.path}/operation_review_${pgs.id}.pdf';
          await File(filePath).writeAsBytes(bytes);
          final result = await OpenFile.open(filePath);
          if (result.type != ResultType.done) {
            debugPrint('OpenFile error: ${result.message}');
          }
        }
      } else {
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
          final dir =
              Platform.isWindows
                  ? await getDownloadsDirectory()
                  : await getApplicationDocumentsDirectory();
          final filePath = '${dir!.path}/operation_review_${pgs.id}.pdf';
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
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
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
                                "Period",
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
                                      "No performance validation tool available",
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
                                  final itemNumber =
                                      ((_currentPage - 1) * _pageSize) +
                                      index +
                                      1;
                                  final pgs = filteredList[index];
                                  final officeName = pgs.office.name;
                                  final startDate = pgs.pgsPeriod.startDate;
                                  final endDate = pgs.pgsPeriod.endDate;
                                  final converter = LongDateOnlyConverter();
                                  final start = converter.toJson(startDate);
                                  final end = converter.toJson(endDate);

                                  if (!isMobile) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 6,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Text("$itemNumber"),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Text(officeName),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text("$start - $end"),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Row(
                                              children: [
                                                PermissionWidget(
                                                  permission:
                                                      AppPermissions
                                                          .viewOperationReviewProtocol,
                                                  child: Tooltip(
                                                    message:
                                                        'Operations Review Protocol',
                                                    child: IconButton(
                                                      icon: const Icon(
                                                        Icons.reviews_outlined,
                                                        size: 18,
                                                        color:
                                                            Colors
                                                                .deepOrangeAccent,
                                                      ),
                                                      onPressed:
                                                          () =>
                                                              _openMonthlyReviewDialog(
                                                                pgs,
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
                                                if (value == 'review') {
                                                  _openMonthlyReviewDialog(pgs);
                                                } else if (value == 'preview') {
                                                  await _openPrintPreview(pgs);
                                                }
                                              },
                                              itemBuilder:
                                                  (_) => [
                                                    const PopupMenuItem(
                                                      value: 'review',
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .reviews_outlined,
                                                            size: 18,
                                                            color:
                                                                Colors
                                                                    .deepOrangeAccent,
                                                          ),
                                                          SizedBox(width: 8),
                                                          Text(
                                                            'Operations Review',
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text("Office: $officeName"),
                                        const SizedBox(height: 4),
                                        Text("Period: $start - $end"),
                                      ],
                                    ),
                                  );
                                },
                              ),
                    ),
                    // Container(
                    //   padding: const EdgeInsets.all(10),
                    //   color: Theme.of(context).cardColor,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       PaginationInfo(
                    //         currentPage: _currentPage,
                    //         totalItems: _totalCount,
                    //         itemsPerPage: _pageSize,
                    //       ),
                    //       PaginationControls(
                    //         currentPage: _currentPage,
                    //         totalItems: _totalCount,
                    //         itemsPerPage: _pageSize,
                    //         isLoading: _isLoading,
                    //         onPageChanged:
                    //             (page) => fetchOperationReview(page: page),
                    //       ),
                    //       const SizedBox(width: 60),
                    //     ],
                    //   ),
                    // ),
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
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.assessment_outlined,
                  color: primaryColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Performance Validation Tool Information",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1D23),
                      ),
                    ),
                    Text(
                      "${filteredList.length} operation review protocol${filteredList.length != 1 ? 's' : ''} found",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isMobile)
                PermissionWidget(
                  permission: AppPermissions.addKraRoadMap,
                  child: ElevatedButton.icon(
                    onPressed:
                        () => showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => const PerformanceValidationDialog(),
                        ),
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
                ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  bool get _hasActiveFilters =>
      _selectedOfficeId != null || _selectedServiceId != null;

  void _resetFilters() {
    setState(() {
      _selectedOfficeId = null;
      _selectedServiceId = null;
      filteredList = List.from(operationReviewprotocolList);
    });
  }

  Widget _buildFilterBar(bool isMobile) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const Divider(height: 1, thickness: 1, color: Color(0xFFEEEFF2)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
            buildDropdown(child: _serviceDropdown()),
            buildDropdown(
              child: PermissionWidget(
                permission: AppPermissions.viewOffice,
                child: _officeDropdown(),
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
        gap8px,
        SizedBox(height: 38, child: _serviceDropdown()),
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
            // fetchOperationReview(page: 1);
          },
        ),
      ),
    );
  }

  Widget _serviceDropdown() {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 150, maxWidth: 400),
      child: SizedBox(
        height: 38,
        child: SearchableDropdown(
          items: ["All Services", ...serviceList.map((s) => s.name)],
          selectedItem:
              _selectedServiceId == null
                  ? "All Services"
                  : (serviceList
                          .where((s) => s.id.toString() == _selectedServiceId)
                          .firstOrNull
                          ?.name ??
                      "All Services"),
          hintText: "Service",
          searchHint: "Search services...",
          prefixIcon: Icons.miscellaneous_services_outlined,
          onChanged: (value) {
            setState(() {
              _selectedServiceId =
                  value == "All Services"
                      ? null
                      : serviceList
                          .firstWhere((s) => s.name == value)
                          .id
                          .toString();
            });
            // fetchOperationReview(page: 1);
          },
        ),
      ),
    );
  }
}
