// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:imis/office/models/office.dart';
import 'package:imis/performance_governance_system/enum/pgs_status.dart';
import 'package:imis/performance_governance_system/key_result_area/models/key_result_area.dart';
import 'package:imis/reports/models/pgs_summary_narrative.dart';
import 'package:imis/reports/services/summary_narrative_service.dart';
import 'package:imis/utils/permission_service.dart';
import 'package:imis/widgets/accomplishment_auditor_widget.dart';
import 'package:imis/widgets/breakthrough_widget.dart';
import 'package:imis/widgets/filter_button_widget.dart';
import 'package:imis/widgets/no_permission_widget.dart';
import 'package:imis/widgets/permission_widget.dart';
=======
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/constant/permissions.dart';
import 'package:imis/office/models/office_evaluators.dart';
import 'package:imis/performance_governance_system/process_core_support/models/key_result_area.dart';
import 'package:imis/performance_governance_system/pgs_period/models/pgs_period.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/utils/permission_service.dart';
import 'package:imis/widgets/common/filter_bottom_sheet.dart';
import 'package:imis/widgets/common/filter_button_widget.dart';
import 'package:imis/widgets/common/button_filter.dart';
import 'package:imis/widgets/permission/no_permission_to_view_widget.dart';
import 'package:imis/widgets/common/pagination_controls.dart';
import 'package:imis/widgets/permission/permission_widget.dart';
import 'package:imis/constant/constant.dart';
>>>>>>> master
import 'package:intl/intl.dart';
import 'package:imis/constant/constant.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common_services/common_service.dart';
import '../../../reports/pages/manage_summary_narrative_report_page.dart';
import '../../../user/models/user_registration.dart';
import '../../../utils/api_endpoint.dart';
import '../../../utils/auth_util.dart';
import '../../../utils/date_time_converter.dart';
<<<<<<< HEAD
import '../../../utils/http_util.dart';
import '../../../utils/permission_string.dart';
=======
import '../../../utils/permission_role_string.dart';
import '../dialog/accomplishment_pgs_auditor_dialog.dart';
import '../../dialog/breakthrough_dialog.dart';
>>>>>>> master
import '../../models/pgs_deliverable_score_history.dart';
import '../../pgs_period/models/pgs_period.dart';
import '../models/pgs_deliverable_accomplishment.dart';
import '../models/pgs_filter.dart';
import '../services/deliverable_status_monitoring_service.dart';

class DeliverableStatusMonitoringPage extends StatefulWidget {
  const DeliverableStatusMonitoringPage({super.key});

  @override
  State<DeliverableStatusMonitoringPage> createState() =>
      _DeliverableStatusMonitoringPageState();
}

class _DeliverableStatusMonitoringPageState
    extends State<DeliverableStatusMonitoringPage> {
  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();
  final ScrollController _headerHorizontalController = ScrollController();
  final _dateConverter = const LongDateOnlyConverter();
  TextEditingController scoreRangeToController = TextEditingController();
  TextEditingController scoreRangeFromController = TextEditingController();
  TextEditingController pageController = TextEditingController();
  TextEditingController pageSizeController = TextEditingController();
  final TextEditingController _findingsController = TextEditingController();
  final TextEditingController _conclusionsController = TextEditingController();
  final TextEditingController _recommendationsController =
      TextEditingController();
  final _summaryNarrativeService = SummaryNarrativeService(Dio());
  final _formKey = GlobalKey<FormState>();
  final GlobalKey _menuScoreRangeKey = GlobalKey();
  final GlobalKey _menuPageKey = GlobalKey();
  final int dataColumns = 8;
  final double numberColumnWidth = 70;
  final double dataColumnWidth = 280;
  final dio = Dio();
  final _commonService = CommonService(Dio());
  final _deliverableStatusMonitoring = DeliverableStatusMonitoringService(
    Dio(),
  );
  final permissionService = PermissionService();
  List<Map<String, dynamic>> deliverableList = [];
  List<Map<String, dynamic>> filteredList = [];
  List<PgsDeliverableHistoryGrouped> deliverableHistoryGrouped = [];
  String userId = "";
  final List<String> headers = [
    "PERIOD",
    "OFFICE",
    "PROCESS (CORE & SUPPORT)",
    "KRA",
    "DIRECT",
    "DELIVERABLES",
    "BY WHEN",
    "ACTIONS",
  ];
  bool isMenuOpenOffice = false;
  bool isMenuOpenPeriod = false;
  bool isMenuOpenPeriodCreateReport = false;
  bool isMenuOpenKra = false;
  bool isMenuOpenType = false;
  bool isMenuScoreRange = false;
  bool isMenuOpenPage = false;
  List<KeyResultArea> kraListOptions = [];
  List<PgsPeriod> periodList = [];
  List<Office> officeList = [];
  List<OfficeEvaluators> serviceList = [];
  int? selectedKra;

  List<Office> officeList = [];
  String? _selectedOfficeId;
  String? _selectedServiceId;
  bool? isDirect;
  List<PgsPeriod> periodList = [];
  int? selectedPeriod;
  int? selectedPeriodCreateReport;
  String? selectedPeriodText;
  String? selectedPeriodTextCreateReport;
  String? _selectedPeriod;
  String? _selectedOffice;
  int? officeId;
  int? periodId;
  bool _hasAvailableDeliverables = false;
  String? _selectedOffice;
  String? _selectedPeriod;
  bool _officeListLoading = false;
  int currentPage = 1;
  final int pageSize = 15;
  int _totalCount = 0;
  String userId = "";

  @override
  void initState() {
    super.initState();
    _headerHorizontalController.addListener(_syncHeaderScroll);
    _horizontalController.addListener(_syncBodyScroll);
    () async {
      final offices = await _deliverableStatusMonitoring.fetchOffices();
      final period = await _commonService.fetchPgsPeriod();
      final kra = await _commonService.fetchKra();
      if (!mounted) return;

      setState(() {
        officeList = offices;
        periodList = period;
        kraListOptions = kra;
      });
    }();
    fetchFilteredPgsList();
    _loadCurrentUserId();
  }

<<<<<<< HEAD
  void _syncHeaderScroll() {
    if (_horizontalController.offset != _headerHorizontalController.offset) {
      _horizontalController.jumpTo(_headerHorizontalController.offset);
    }
  }

  void _syncBodyScroll() {
    if (_headerHorizontalController.offset != _horizontalController.offset) {
      _headerHorizontalController.jumpTo(_horizontalController.offset);
    }
=======
  Future<void> _initialize() async {
    setState(() => isLoading = true);
    await _getRoleId();

    final period = await _commonService.fetchPgsPeriod();
    final kra = await _commonService.fetchKra();
    final service = await _commonService.fetchServiceEvalutors();
    await _loadCurrentUserId();
    if (!mounted) return;

    PgsPeriod? activePeriod;
    for (final p in period) {
      if (p.isActive == true) {
        activePeriod = p;
        break;
      }
    }

    setState(() {
      periodList = period;
      serviceList = service;
      kraListOptions = kra;
      isLoading = false;
      if (activePeriod != null) {
        selectedPeriod = activePeriod.id;
        selectedPeriodText =
            "${_dateConverter.toJson(activePeriod.startDate)} – ${_dateConverter.toJson(activePeriod.endDate)}";
      }
    });
    fetchFilteredPgsList();
  }

  Future<void> _loadOfficesForService(String serviceId) async {
    setState(() {
      _officeListLoading = true;
      officeList = [];
      _selectedOfficeId = null;
    });
    try {
      final offices = await _commonService.fetchOfficesByEvaluatorRole(
        int.tryParse(serviceId) ?? 0,
      );
      if (!mounted) return;
      setState(() => officeList = offices);
    } catch (e) {
      debugPrint('Failed to load offices for service: $e');
    } finally {
      if (mounted) setState(() => _officeListLoading = false);
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

  Future<void> _loadCurrentUserId() async {
    UserRegistration? user = await AuthUtil.processTokenValidity(dio, context);

    setState(() {
      userId = user!.id ?? "UserId";
    });

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _checkDeliverablesAvailability(Function setDialogState) async {
    if (_selectedOffice == null || _selectedPeriod == null) {
      setState(() {
        _hasAvailableDeliverables = false;
      });
      return;
    }

    try {
      officeId = int.tryParse(_selectedOffice!) ?? 0;
      periodId = int.tryParse(_selectedPeriod!) ?? 0;

      final filter = PgsFilter(
        periodId,
        officeId,
        null,
        null,
        null,
        null,
        null,
        null,
      );

      final queryParams =
          filter.toJson()..removeWhere((key, value) => value == null);

      final response = await AuthenticatedRequest.get(
        dio,
        ApiEndpoint().filterBy,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final items = data["items"] as List<dynamic>? ?? [];

        setDialogState(() {
          _hasAvailableDeliverables = items.isNotEmpty;
        });
      } else {
        setDialogState(() {
          _hasAvailableDeliverables = false;
        });
      }
    } catch (e) {
      debugPrint("Error checking deliverables availability: $e");
      setDialogState(() {
        _hasAvailableDeliverables = false;
      });
    }
    setDialogState(() {});
  }

  Future<bool> _hasCompleteAccomplishmentData(
    int deliverableId,
    int expectedPeriods,
  ) async {
    try {
      final List<PgsDeliverableAccomplishment> accomplishments =
          await _deliverableStatusMonitoring.fetchAccomplishments(
            deliverableId,
          );

      if (accomplishments.isEmpty || accomplishments.length < expectedPeriods) {
        return false;
      }

      int completedPeriods = 0;

      for (var i = 0; i < accomplishments.length; i++) {
        var accomplishment = accomplishments[i];

        final status = accomplishment.remarks;

        final attachmentPath = accomplishment.attachmentPath;

        bool hasValidStatus = status != null && status.toString().isNotEmpty;

        bool hasValidAttachment =
            attachmentPath != null && attachmentPath.isNotEmpty;

        bool isComplete = hasValidStatus && hasValidAttachment;

        if (isComplete) {
          completedPeriods++;
        } else {
          if (!hasValidStatus) debugPrint("    - Missing status: $status");
        }
      }

      bool allComplete = completedPeriods >= expectedPeriods;

<<<<<<< HEAD
      return allComplete;
    } catch (e) {
      return false;
    }
  }

  @override
  void dispose() {
    _verticalController.dispose();
    _horizontalController.dispose();
    _headerHorizontalController.dispose();
    super.dispose();
  }

  Future<void> fetchFilteredPgsList() async {
=======
    setState(() => _isLoading = true);
    String? roleId;
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
      roleId = currentRole.id;
    }
>>>>>>> master
    try {
      int? scoreFrom =
          scoreRangeFromController.text.isNotEmpty
              ? int.tryParse(scoreRangeFromController.text)
              : null;
      int? scoreTo =
          scoreRangeToController.text.isNotEmpty
              ? int.tryParse(scoreRangeToController.text)
              : null;

      int? page =
          pageController.text.isNotEmpty
              ? int.tryParse(pageController.text)
              : null;
      int? pageSize =
          pageSizeController.text.isNotEmpty
              ? int.tryParse(pageSizeController.text)
              : null;

      final filter = PgsFilter(
        roleId,
        selectedPeriod,
        int.tryParse(_selectedOfficeId ?? ''),
        int.tryParse(_selectedServiceId ?? ''),
        selectedKra,
        isDirect,

        scoreRangeFromController.text.isNotEmpty
            ? int.tryParse(scoreRangeFromController.text)
            : null,
        scoreRangeToController.text.isNotEmpty
            ? int.tryParse(scoreRangeToController.text)
            : null,
        page,
        pageSize,
      );

      final queryParams =
          filter.toJson()..removeWhere((key, value) => value == null);

      final response = await AuthenticatedRequest.get(
        dio,
        ApiEndpoint().filterBy,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final items = data["items"] as List<dynamic>? ?? [];

        List<Map<String, dynamic>> formattedData =
            items.map((item) {
              String formattedByWhen = '';
              if (item['byWhen'] != null &&
                  item['byWhen'].toString().isNotEmpty) {
                try {
                  DateTime date = DateTime.parse(item['byWhen'].toString());
                  formattedByWhen = DateFormat('MMMM, yyyy').format(date);
                } catch (e) {
                  formattedByWhen = item['byWhen'].toString();
                }
              }

              deliverableHistoryGrouped.firstWhere(
                (h) => h.pgsDeliverableId == item['pgsDeliverableId'],
                orElse: () => PgsDeliverableHistoryGrouped(0, null),
              );

              return {
                'pgsDeliverableId': item['pgsDeliverableId'],
                'kra': item['keyResultArea'],
                'kraDescription': item['kraDescription'],
                'Start Date': item['pgsPeriod']?.split(" - ")?.first ?? '',
                'End Date': item['pgsPeriod']?.split(" - ")?.last ?? '',
                'officeName': item['office'],
                'isDirect': item['isDirect'],
                'deliverableName': item['deliverable'],
                'byWhen': formattedByWhen,
                'status':
                    item['status'] is PgsStatus
                        ? (item['status'] as PgsStatus).name
                        : item['status'].toString(),
                'remarks': item['remarks'],
                'score': item['score'],
              };
            }).toList();

        if (mounted) {
          setState(() {
            deliverableList = formattedData;
            filteredList = List.from(formattedData);
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching filtered data: $e");
<<<<<<< HEAD
=======
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<Map<String, dynamic>> _buildMonthlyPeriods(
    Map<String, dynamic> deliverable,
  ) {
    final startDateStr = deliverable['Start Date'] as String? ?? '';
    final endDateStr = deliverable['End Date'] as String? ?? '';
    List<Map<String, dynamic>> monthlyPeriods = [];
    try {
      final startDate = DateFormat('MMM dd, yyyy').parse(startDateStr);
      final endDate = DateFormat('MMM dd, yyyy').parse(endDateStr);
      DateTime current = DateTime(startDate.year, startDate.month);
      final end = DateTime(endDate.year, endDate.month);
      while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
        monthlyPeriods.add({
          'period': DateFormat('MMMM yyyy').format(current),
          'month': current.month,
          'year': current.year,
        });
        current = DateTime(current.year, current.month + 1);
      }
    } catch (_) {}
    return monthlyPeriods;
  }

  Future<bool> _hasCompleteAccomplishmentData(
    int deliverableId,
    int expectedPeriods,
  ) async {
    try {
      final accomplishments = await _deliverableStatusMonitoring
          .fetchAccomplishments(deliverableId);
      return accomplishments.any(
        (a) =>
            a.auditorRemarks != null && a.auditorRemarks!.toString().isNotEmpty,
      );
    } catch (_) {
      return false;
    }
  }

  Future<void> _checkDeliverablesAvailability(Function setDialogState) async {
    if (_selectedOffice == null || _selectedPeriod == null) {
      setDialogState(() => _hasAvailableDeliverables = false);
      return;
    }
    String? roleId;
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
      roleId = currentRole.id;
    }
    try {
      final filter = PgsFilter(
        roleId,
        int.tryParse(_selectedPeriod!) ?? 0,
        int.tryParse(_selectedOffice!) ?? 0,
        int.tryParse(_selectedOfficeId!) ?? 0,
        null,
        null,
        null,
        null,
        null,
        null,
      );
      final queryParams =
          filter.toJson()..removeWhere((key, value) => value == null);
      final response = await AuthenticatedRequest.get(
        dio,
        ApiEndpoint().filterBy,
        queryParameters: queryParams,
      );
      final items =
          (response.statusCode == 200
              ? (response.data["items"] as List<dynamic>?)
              : null) ??
          [];
      setDialogState(() => _hasAvailableDeliverables = items.isNotEmpty);
    } catch (_) {
      setDialogState(() => _hasAvailableDeliverables = false);
>>>>>>> master
    }
  }

  void _resetFilters() {
    setState(() {
      selectedPeriod = null;
      selectedPeriodText = null;
      _selectedServiceId = null;
      _selectedOfficeId = null;
      officeList = [];
      selectedKra = null;
      isDirect = null;
      scoreRangeFromController.clear();
      scoreRangeToController.clear();
      pageController.clear();
      pageSizeController.clear();
    });
    fetchFilteredPgsList();
  }

  bool get _hasActiveFilters =>
      _selectedServiceId != null ||
      selectedPeriod != null ||
      _selectedOfficeId != null ||
      selectedKra != null ||
      isDirect != null ||
      scoreRangeFromController.text.isNotEmpty ||
      scoreRangeToController.text.isNotEmpty;

  @override
  void dispose() {
    _kpiScrollController.dispose();
    scoreRangeToController.dispose();
    scoreRangeFromController.dispose();
    pageController.dispose();
    pageSizeController.dispose();
    _findingsController.dispose();
    _conclusionsController.dispose();
    _recommendationsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;
    final bool hasPermission = permissionService.hasPermission(
      AppPermissions.viewPgsDeliverableMonitor,
    );
    if (!hasPermission) return noPermissionScreen();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(color: primaryColor),
              )
              : Column(
                children: [
                  _buildPageHeader(isMobile),
                  _buildFilterBar(isMobile),
                  gap6px,
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                      child: _buildTableCard(isMobile),
                    ),
                  ),
                  _buildPagination(),
                ],
              ),
      floatingActionButton: isMobile ? _buildMobileFAB() : null,
    );
  }

  Widget _buildPagination() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      color: Theme.of(context).cardColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PaginationInfo(
            currentPage: currentPage,
            totalItems: _totalCount,
            itemsPerPage: pageSize,
          ),
          PaginationControls(
            currentPage: currentPage,
            totalItems: _totalCount,
            itemsPerPage: pageSize,
            isLoading: _isLoading,
            onPageChanged: (page) => fetchFilteredPgsList(page: page),
          ),
          const SizedBox(width: 60),
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
                  Icons.monitor_heart_outlined,
                  color: primaryColor,
                  size: 22,
                ),
              ),
              SizedBox(width: isXSmall ? 8 : 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Deliverables Status Monitoring",
                      style: TextStyle(
                        fontSize:
                            isXSmall
                                ? 12
                                : isSmall
                                ? 14
                                : 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1D23),
>>>>>>> master
                      ),
                    ),
                  ],
                ),

<<<<<<< HEAD
                Flexible(fit: FlexFit.tight, child: Container()),
                if (!isMinimized)
                  Row(
                    children: [
                      PermissionWidget(
                        allowedRoles: [
                          PermissionString.pgsAuditor,
                          PermissionString.roleAdmin,
                        ],
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: mainBgColor,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            side: BorderSide(
                              color: Colors.grey.shade400,
                              width: 0.8,
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        ManageSummaryNarrativeReportPage(),
                              ),
                              (route) => false,
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.description_outlined,
                                color: const Color.fromARGB(255, 17, 16, 16),
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Manage Auditor Reports',
                                style: TextStyle(color: primaryTextColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      PermissionWidget(
                        allowedRoles: [
                          PermissionString.pgsAuditor,
                          PermissionString.roleAdmin,
                        ],
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          onPressed: () {
                            showReportDialog();
                          },

                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add, color: Colors.white),
                              SizedBox(width: 5),
                              Text(
                                'Create Report',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          SizedBox(
            height: 60,
            child: SingleChildScrollView(
              controller: _headerHorizontalController,
              scrollDirection: Axis.horizontal,
              child: SizedBox(width: totalWidth, child: _buildHeader()),
            ),
          ),
          Expanded(
            child: Scrollbar(
              controller: _verticalController,
              thumbVisibility: true,
              trackVisibility: true,
              child: Scrollbar(
                controller: _horizontalController,
                thumbVisibility: true,
                trackVisibility: true,
                notificationPredicate: (notif) => notif.depth == 1,
                child: SingleChildScrollView(
                  controller: _verticalController,
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    controller: _horizontalController,
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: totalWidth,
                        minHeight: MediaQuery.of(context).size.height - 160,
                      ),
                      child: _buildTableBody(),
                    ),
                  ),
                ),
              ),
            ),
          ),
=======
  Widget _buildHeaderActions() {
    return Row(
      children: [
        PermissionWidget(
          allowedRoles: [
            PermissionRoleString.pgsAuditor,
            PermissionRoleString.roleAdmin,
          ],
          child: OutlinedButton.icon(
            onPressed:
                () => showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (_) => const ManageSummaryNarrativeDialog(),
                ),
            icon: const Icon(Icons.description_outlined, size: 16),
            label: const Text('Manage Reports', style: TextStyle(fontSize: 13)),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF1A1D23),
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
          ),
        ),
        const SizedBox(width: 10),
        PermissionWidget(
          allowedRoles: [
            PermissionRoleString.pgsAuditor,
            PermissionRoleString.roleAdmin,
          ],
          child: ElevatedButton.icon(
            onPressed: showReportDialog,
            icon: const Icon(Icons.add, size: 16, color: Colors.white),
            label: const Text(
              'Create Report',
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              elevation: 0,
            ),
          ),
        ),
      ],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                buildDropdown(child: _serviceDropdown()),
                buildDropdown(child: _officeDropdown()),
                buildDropdown(child: _periodDropdown()),
                buildDropdown(child: _kraDropdown()),
                buildDropdown(child: _typeDropdown()),
                _buildPageFilter(),
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
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(height: 38, child: _serviceDropdown()),
              const SizedBox(width: 8),
              SizedBox(height: 38, child: _officeDropdown()),
              const SizedBox(width: 8),
              SizedBox(height: 38, child: _periodDropdown()),
              const SizedBox(width: 8),
              SizedBox(height: 38, child: _kraDropdown()),
              const SizedBox(width: 8),
              SizedBox(height: 38, child: _typeDropdown()),
              const SizedBox(width: 8),

              _buildPageFilter(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _serviceDropdown() {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 150, maxWidth: 400),
      child: SizedBox(
        height: 38,
        child: SearchableDropdown(
          items: ["All Service", ...serviceList.map((s) => s.officeName)],
          selectedItem:
              _selectedServiceId == null
                  ? "Select Service"
                  : (serviceList
                          .where(
                            (s) => s.officeId.toString() == _selectedServiceId,
                          )
                          .firstOrNull
                          ?.officeName ??
                      "Select Service"),
          hintText: "Service",
          searchHint: "Search services...",
          prefixIcon: Icons.apartment_outlined,
          onChanged: (value) {
            final newId =
                value == "Select Service"
                    ? null
                    : serviceList
                        .firstWhere((s) => s.officeName == value)
                        .officeId
                        .toString();
            setState(() {
              _selectedServiceId = newId;
              _selectedOfficeId = null;
              officeList = [];
            });
            if (newId != null) {
              _loadOfficesForService(newId);
            }
            fetchFilteredPgsList();
          },
        ),
      ),
    );
  }

  Widget _officeDropdown() {
    final serviceSelected = _selectedServiceId != null;
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 150, maxWidth: 400),
      child: SizedBox(
        height: 38,
        child: Opacity(
          opacity: serviceSelected ? 1 : 0.5,
          child: IgnorePointer(
            ignoring: !serviceSelected || _officeListLoading,
            child: SearchableDropdown(
              items: ["All Offices", ...officeList.map((o) => o.name)],
              selectedItem:
                  _selectedOfficeId == null
                      ? "All Offices"
                      : (officeList
                              .where(
                                (o) => o.id.toString() == _selectedOfficeId,
                              )
                              .firstOrNull
                              ?.name ??
                          "All Offices"),
              hintText: serviceSelected ? "Office" : "Select Service first",
              searchHint: "Search offices...",
              prefixIcon: Icons.business_outlined,
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
                fetchFilteredPgsList();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _periodDropdown() {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 150, maxWidth: 400),
      child: SizedBox(
        height: 38,
        child: SearchableDropdown(
          items: [
            "All Periods",
            ...periodList.map(
              (p) =>
                  "${_dateConverter.toJson(p.startDate)} – ${_dateConverter.toJson(p.endDate)}",
            ),
          ],
          selectedItem:
              selectedPeriod == null
                  ? "All Periods"
                  : (selectedPeriodText ?? "All Periods"),
          hintText: "Period",
          searchHint: "Search periods...",
          prefixIcon: Icons.date_range_outlined,
          onChanged: (value) {
            setState(() {
              if (value == "All Periods") {
                selectedPeriod = null;
                selectedPeriodText = null;
              } else {
                final selected = periodList.firstWhere(
                  (p) =>
                      "${_dateConverter.toJson(p.startDate)} – ${_dateConverter.toJson(p.endDate)}" ==
                      value,
                );
                selectedPeriod = selected.id;
                selectedPeriodText = value;
              }
            });
            fetchFilteredPgsList();
          },
        ),
      ),
    );
  }

  Widget _kraDropdown() {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 150, maxWidth: 400),
      child: SizedBox(
        height: 38,
        child: SearchableDropdown(
          items: ["All KRA", ...kraListOptions.map((k) => k.name)],
          selectedItem:
              selectedKra == null
                  ? "All KRA"
                  : (kraListOptions
                          .where((k) => k.id == selectedKra)
                          .firstOrNull
                          ?.name ??
                      "All KRA"),
          hintText: "KRA",
          searchHint: "Search KRA...",
          prefixIcon: Icons.adjust_outlined,
          onChanged: (value) {
            setState(() {
              selectedKra =
                  value == "All KRA"
                      ? null
                      : kraListOptions.firstWhere((k) => k.name == value).id;
            });
            fetchFilteredPgsList();
          },
        ),
      ),
    );
  }

  Widget _typeDropdown() {
    const items = ["All Alignment", "Direct", "Indirect"];
    final selected =
        isDirect == null
            ? "All Alignment"
            : (isDirect! ? "Direct" : "Indirect");
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 130, maxWidth: 200),
      child: SizedBox(
        height: 38,
        child: SearchableDropdown(
          items: items,
          selectedItem: selected,
          hintText: "Type",
          searchHint: "Search alignment...",
          prefixIcon: Icons.directions_outlined,
          onChanged: (value) {
            setState(() {
              isDirect = value == "All Alignment" ? null : (value == "Direct");
            });
            fetchFilteredPgsList();
          },
        ),
      ),
    );
  }

  Widget _buildPageFilter() {
    final isActive = pageController.text.isNotEmpty;
    final label = isActive ? 'Page ${pageController.text}' : 'Pagination';
    return FilterChipButton(
      label: label,
      icon: Icons.layers_outlined,
      isActive: isActive,
      onTap: () => _showPaginationDialog(),
    );
  }

  void _showPaginationDialog() {
    final pageCtrl = TextEditingController(text: pageController.text);
    final sizeCtrl = TextEditingController(text: pageSizeController.text);
    showDialog(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + renderBox.size.height,
        offset.dx + renderBox.size.width,
        offset.dy + renderBox.size.height + 200,
      ),
      items: [
        PopupMenuItem(
          enabled: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: pageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Page',
                  labelStyle: TextStyle(color: grey, fontSize: 12),
                  isDense: true,
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),
                  floatingLabelStyle: TextStyle(
                    color: primaryColor,
                    fontSize: 12,
                  ),
                ),
              ),
              gap16px,
              TextField(
                controller: pageSizeController,
                keyboardType: TextInputType.none,
                decoration: const InputDecoration(
                  labelText: 'Page Size',
                  labelStyle: TextStyle(color: grey, fontSize: 12),
                  isDense: true,
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),
                  floatingLabelStyle: TextStyle(
                    color: primaryColor,
                    fontSize: 12,
                  ),
                ),
              ),
              gap16px,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: primaryColor),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    onPressed: () {
                      pageController.text;
                      pageSizeController.text;
                      fetchFilteredPgsList();
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Apply',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    final border = TableBorder.all(color: Colors.grey.shade700, width: 1.0);

    Map<int, TableColumnWidth> columnWidths = {
      0: FixedColumnWidth(numberColumnWidth),
    };
    for (int i = 1; i <= dataColumns; i++) {
      columnWidths[i] = FixedColumnWidth(dataColumnWidth);
    }

    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0),
      child: Table(
        border: border,
        columnWidths: columnWidths,
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(
            decoration: const BoxDecoration(color: primaryLightColor),
            children: [
              _cell("#", isHeader: true, align: TextAlign.center),
              for (final h in headers) _cell(h, isHeader: true),
            ],
          ),
        ],
      ),
    );
  }

<<<<<<< HEAD
  Widget _buildTableBody() {
    final border = TableBorder.all(color: Colors.grey.shade700, width: 1.0);

    Map<int, TableColumnWidth> columnWidths = {
      0: FixedColumnWidth(numberColumnWidth),
    };
    for (int i = 1; i <= dataColumns; i++) {
      columnWidths[i] = FixedColumnWidth(dataColumnWidth);
    }

    if (deliverableList.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text("No data available"),
        ),
      );
    }

    List<TableRow> rows =
        deliverableList.asMap().entries.map((entry) {
          final int index = entry.key;
          final deliverable = entry.value;

          return TableRow(
            children: [
              _cell("${index + 1}", align: TextAlign.center),
              _cell(
                "${deliverable['Start Date']} - ${deliverable['End Date']}",
              ),
              _cell(deliverable['officeName'] ?? ''),
              _buildCoreSupport(deliverable['kra']),
              _buildKRA(deliverable['kraDescription']),
              _cell(deliverable['isDirect'] ? "Direct" : "Indirect"),
              _cell(deliverable['deliverableName'] ?? ''),
              _cell(deliverable['byWhen'] ?? ''),
              _buildCreateAccomplishmentAndBreakthroughCell(index, () {
                debugPrint(
                  "Create tapped for ID: ${deliverable['pgsDeliverableId']}",
                );
              }),
            ],
          );
        }).toList();

    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 12.0),
      child: Table(
        border: border,
        columnWidths: columnWidths,
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: rows,
      ),
    );
  }

  Widget _cell(
    String text, {
    bool isHeader = false,
    TextAlign align = TextAlign.left,
  }) {
=======
  Widget _buildTableCard(bool isMobile) {
>>>>>>> master
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Center(
        child: Text(
          text,
          textAlign: align,
          style: TextStyle(
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildCoreSupport(String? kra) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
<<<<<<< HEAD
          Center(
            child: Text(
              kra ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold),
=======
          SizedBox(
            width: 40,
            child: Text(
              '#',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              'Deliverable Details',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
          SizedBox(
            width: 220,
            child: Center(
              child: Text(
                'Actions',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
>>>>>>> master
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKRA(String? description) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [if (description != null) Text(description)],
      ),
    );
  }

  Widget _buildCreateAccomplishmentAndBreakthroughCell(
    int index,
    VoidCallback onPressed,
  ) {
    final deliverable = deliverableList[index];
    final deliverableId = deliverable['pgsDeliverableId'];

    final startDateStr = deliverable['Start Date'];
    final endDateStr = deliverable['End Date'];
    final startDate = DateFormat('MMM dd, yyyy').parse(startDateStr);
    final endDate = DateFormat('MMM dd, yyyy').parse(endDateStr);

    List<Map<String, dynamic>> monthlyPeriods = [];
    DateTime current = DateTime(startDate.year, startDate.month);
    DateTime end = DateTime(endDate.year, endDate.month);

    while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
      monthlyPeriods.add({
        'period': DateFormat('MMMM yyyy').format(current),
        'month': current.month,
        'year': current.year,
      });
      current = DateTime(current.year, current.month + 1);
    }
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.inbox_outlined,
              size: 40,
              color: Colors.grey.shade300,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _selectedOfficeId == null
                ? 'Select an office to monitor deliverables'
                : 'No deliverables found',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _selectedOfficeId == null
                ? 'Use the filter above to get started'
                : 'Try adjusting the filters to see more results',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliverableRow(
    int index,
    Map<String, dynamic> d,
    bool isMobile,
  ) {
    if (isMobile) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  margin: const EdgeInsets.only(top: 1, right: 8),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      '${(currentPage - 1) * pageSize + index + 1}',
                      style: TextStyle(
                        color: hasCompleteData ? primaryTextColor : Colors.grey,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
<<<<<<< HEAD
              );
            },
=======
                Expanded(
                  child: Text(
                    d['deliverableName'] ?? '',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1D23),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                d['officeName'] ?? '',
                style: TextStyle(
                  fontSize: 11,
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 6,
              children: [
                _infoChip(
                  Icons.calendar_month,
                  '${d['Start Date']} – ${d['End Date']}',
                  Colors.lightBlue,
                ),
                _infoChip(Icons.adjust_outlined, d['kra'] ?? '', Colors.green),
                _infoChip(
                  Icons.insights,
                  d['kraDescription'] ?? '',
                  Colors.orange,
                ),
                _infoChip(
                  d['isDirect'] == true
                      ? Icons.arrow_right_alt
                      : Icons.alt_route,
                  d['isDirect'] == true ? 'Direct' : 'Indirect',
                  d['isDirect'] == true ? Colors.purple : Colors.teal,
                ),
                if (d['byWhen'] != null && d['byWhen'].toString().isNotEmpty)
                  _infoChip(
                    Icons.calendar_month_outlined,
                    d['byWhen'],
                    Colors.red,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            _buildMobileActionButtons(index, d),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 40,
            child: Text(
              '${(currentPage - 1) * pageSize + index + 1}',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
>>>>>>> master
          ),
        ],
      ),
    );
  }

  Widget _buildDeliverableDetails(Map<String, dynamic> d) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            d['officeName'] ?? '',

            style: TextStyle(
              fontSize: 11,
              color: primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          d['deliverableName'] ?? '',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1D23),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 16,
          runSpacing: 6,
          children: [
            _infoChip(
              Icons.calendar_month,
              '${d['Start Date']} – ${d['End Date']}',
              Colors.blue,
            ),
            _infoChip(Icons.adjust_outlined, d['kra'] ?? '', Colors.green),
            _infoChip(Icons.insights, d['kraDescription'] ?? '', Colors.orange),
            _infoChip(
              d['isDirect'] == true ? Icons.arrow_right_alt : Icons.alt_route,
              d['isDirect'] == true ? 'Direct' : 'Indirect',
              d['isDirect'] == true ? Colors.purple : Colors.teal,
            ),
            if (d['byWhen'] != null && d['byWhen'].toString().isNotEmpty)
              _infoChip(Icons.calendar_month_outlined, d['byWhen'], Colors.red),
          ],
        ),
      ],
    );
  }

  Widget _infoChip(IconData icon, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 4),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 200),
          child: Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(int index, Map<String, dynamic> deliverable) {
    final deliverableId = deliverable['pgsDeliverableId'];
    final monthlyPeriods = _buildMonthlyPeriods(deliverable);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _actionButton(
          icon: Icons.bar_chart_outlined,
          label: 'Accomplishment',
          color: primaryColor,
          onTap: () async {
            await loadAccomplishments(deliverableId, monthlyPeriods);
            showAccomplishmentFormDialog(
              context,
              deliverable,
              userId,
              monthlyPeriods,
            );
          },
        ),
        const SizedBox(height: 6),
        FutureBuilder<bool>(
          future: _hasCompleteAccomplishmentData(
            deliverableId,
            monthlyPeriods.length,
          ),
          builder: (ctx, snap) {
            final hasData = snap.data ?? false;
            return Tooltip(
              message:
                  hasData
                      ? 'Open Breakthrough Scoring'
                      : 'Complete accomplishment data first',
              child: _actionButton(
                icon: Icons.star_outline,
                label: 'Breakthrough',
                color: hasData ? primaryColor : Colors.grey,
                onTap:
                    hasData
                        ? () async {
                          await loadBreakThrough(deliverableId);
                          showBreakthroughFormDialog(
                            context,
                            deliverable,
                            userId,
                          );
                        }
                        : null,
                disabled: !hasData,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMobileActionButtons(
    int index,
    Map<String, dynamic> deliverable,
  ) {
    final deliverableId = deliverable['pgsDeliverableId'];
    final monthlyPeriods = _buildMonthlyPeriods(deliverable);

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: _actionButton(
            icon: Icons.bar_chart_outlined,
            label: 'View Accomplishment',
            color: primaryColor,
            fullWidth: true,
            onTap: () async {
              await loadAccomplishments(deliverableId, monthlyPeriods);
              showAccomplishmentFormDialog(
                context,
                deliverable,
                userId,
                monthlyPeriods,
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        FutureBuilder<bool>(
          future: _hasCompleteAccomplishmentData(
            deliverableId,
            monthlyPeriods.length,
          ),
          builder: (ctx, snap) {
            final hasData = snap.data ?? false;
            return SizedBox(
              width: double.infinity,
              child: Tooltip(
                message:
                    hasData
                        ? 'Open Breakthrough Scoring'
                        : 'Complete accomplishment data first',
                child: _actionButton(
                  icon: Icons.star_outline,
                  label: 'Breakthrough Scoring',
                  color: hasData ? Colors.amber.shade700 : Colors.grey,
                  fullWidth: true,
                  onTap:
                      hasData
                          ? () async {
                            await loadBreakThrough(deliverableId);
                            showBreakthroughFormDialog(
                              context,
                              deliverable,
                              userId,
                            );
                          }
                          : null,
                  disabled: !hasData,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onTap,
    bool disabled = false,
    bool fullWidth = false,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: fullWidth ? double.infinity : null,
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: fullWidth ? 10 : 6,
          ),
          decoration: BoxDecoration(
            color:
                disabled ? Colors.grey.shade50 : color.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color:
                  disabled
                      ? Colors.grey.shade200
                      : color.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment:
                fullWidth ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 13,
                color: disabled ? Colors.grey.shade400 : color,
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: disabled ? Colors.grey.shade400 : color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileFAB() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PermissionWidget(
          allowedRoles: [
            PermissionRoleString.pgsAuditor,
            PermissionRoleString.roleAdmin,
          ],
          child: FloatingActionButton.extended(
            heroTag: "manage_audit",
            backgroundColor: Colors.white,
            elevation: 2,
            onPressed:
                () => showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (_) => const ManageSummaryNarrativeDialog(),
                ),
            icon: Icon(
              Icons.description_outlined,
              color: primaryColor,
              size: 18,
            ),
            label: Text(
              'Manage Reports',
              style: TextStyle(color: primaryColor, fontSize: 13),
            ),
          ),
        ),
        const SizedBox(height: 10),
        PermissionWidget(
          allowedRoles: [
            PermissionRoleString.pgsAuditor,
            PermissionRoleString.roleAdmin,
          ],
          child: FloatingActionButton.extended(
            heroTag: "create_report",
            backgroundColor: primaryColor,
            elevation: 2,
            onPressed: showReportDialog,
            icon: const Icon(Icons.add, color: Colors.white, size: 18),
            label: const Text(
              'Create Report',
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        ),
      ],
    );
  }
>>>>>>> master

  DateTime current = DateTime(startDate.year, startDate.month);
  DateTime end = DateTime(endDate.year, endDate.month);

  while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
    monthlyPeriods.add({
      'period': DateFormat('MMMM yyyy').format(current),
      'month': current.month,
      'year': current.year,
    });

    current = DateTime(current.year, current.month + 1);
  }

  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        backgroundColor: mainBgColor,
        insetPadding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1500),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Accomplishment Form - ${DateFormat('MMMM dd, yyyy').format(startDate)} to ${DateFormat('MMMM dd, yyyy').format(endDate)}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Office: ${deliverable['officeName'] ?? 'N/A'}",
                                  ),
                                  Text(
                                    "Monthly Tracking Periods: ${monthlyPeriods.length} month(s)",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("KRA: ${deliverable['kra'] ?? 'N/A'}"),
                                  Text(
                                    "Due: ${deliverable['byWhen'] ?? 'N/A'}",
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Type: ${deliverable['isDirect'] == true ? 'Direct' : 'Indirect'}",
                              ),
                              Text(
                                "Deliverable: ${deliverable['deliverableName'] ?? 'N/A'}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Section title
                        const Row(
                          children: [
                            Icon(Icons.bar_chart_outlined, size: 18),
                            SizedBox(width: 8),
                            Text(
                              "Monthly Accomplishment Tracking",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Dynamic table
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              // Headers
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  ),
                                ),
                                child: Row(
                                  children: const [
                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          "Period",
                                          style: TextStyle(color: grey),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          "Status",
                                          style: TextStyle(color: grey),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          "Percent Accomplishment",
                                          style: TextStyle(color: grey),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Center(
                                        child: Text(
                                          "Remarks (Department Head)",
                                          style: TextStyle(color: grey),
                                        ),
                                      ),
                                    ),

                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          "Proof",
                                          style: TextStyle(color: grey),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Center(
                                        child: Text(
                                          "Remarks (Auditor)",
                                          style: TextStyle(color: grey),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ...monthlyPeriods.asMap().entries.map((entry) {
                                final index = entry.key;
                                final period = entry.value;
                                return Column(
                                  children: [
                                    const Divider(height: 1),
                                    TrackingRowWidget(
                                      period: period['period'],
                                      periodIndex: index,
                                      totalPeriods: monthlyPeriods.length,
                                      deliverableId:
                                          deliverable['pgsDeliverableId'],
                                    ),
                                  ],
                                );
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                PermissionWidget(
                  allowedRoles: [
                    PermissionString.pgsAuditor,
                    PermissionString.roleAdmin,
                  ],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: primaryColor),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        onPressed: () async {
                          final shouldSave = await showDialog<bool>(
                            context: context,
                            builder:
                                (ctx) => AlertDialog(
                                  title: Text("Confirm Save"),
                                  content: Text(
                                    "Are you sure you want to save this data?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.of(ctx).pop(false),
                                      child: Text(
                                        "No",
                                        style: TextStyle(color: primaryColor),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed:
                                          () => Navigator.of(ctx).pop(true),
                                      child: Text(
                                        "Yes",
                                        style: TextStyle(color: primaryColor),
                                      ),
                                    ),
                                  ],
                                ),
                          );

                          if (shouldSave != true) return;
                          MotionToast.success(
                            description: Text('Saved Successfully'),
                            toastAlignment: Alignment.topCenter,
                          ).show(context);
                          await saveAccomplishmentData(
                            deliverable['pgsDeliverableId'],
                            userId,
                          );

                          Navigator.of(context).pop(true);
                        },
                        child: Text(
                          "Save Accomplishment",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Future<bool?> showBreakthroughFormDialog(
  BuildContext context,
  Map<String, dynamic> deliverable,
  String userId,
) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        backgroundColor: mainBgColor,
        insetPadding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Breakthrough Form",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Info section
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Office: ${deliverable['officeName'] ?? 'N/A'}",
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("KRA: ${deliverable['kra'] ?? 'N/A'}"),
                                ],
                              ),
                              const SizedBox(height: 4),

                              Text(
                                "Type: ${deliverable['isDirect'] == true ? 'Direct' : 'Indirect'}",
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Deliverable: ${deliverable['deliverableName'] ?? 'N/A'}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        const Row(
                          children: [
                            Icon(Icons.star_outline, size: 18),
                            SizedBox(width: 8),
                            Text(
                              "Breakthrough Scoring",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Dynamic table
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              // Headers
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  ),
                                ),
                                child: Row(
                                  children: const [
                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          "Percent Accomplishment",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          "Target Achievement",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          "Strategic Contribution ",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          "Breakthrough Impact",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),

                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          "Final Score",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
<<<<<<< HEAD
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          "Final Grade",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Column(
                                children: [
                                  const Divider(height: 1),
                                  BreakthroughWidget(
                                    deliverableId:
                                        deliverable['pgsDeliverableId'],
=======
                                    ],
                                  ),
                                ),
                                ...monthlyPeriods.asMap().entries.map(
                                  (e) => Column(
                                    children: [
                                      const Divider(height: 1),
                                      AccomplishmentPgsAuditorDialog(
                                        period: e.value['period'],
                                        periodIndex: e.key,
                                        totalPeriods: monthlyPeriods.length,
                                        deliverableId:
                                            deliverable['pgsDeliverableId'],
                                        periodMonth: e.value['month'] as int,
                                        periodYear: e.value['year'] as int,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  PermissionWidget(
                    allowedRoles: [
                      PermissionRoleString.evaluator,
                      PermissionRoleString.roleAdmin,
                    ],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () async {
                            final shouldSave = await showDialog<bool>(
                              context: context,
                              builder:
                                  (ctx) => Dialog(
                                    backgroundColor: Colors.transparent,
                                    child: Container(
                                      width: 380,
                                      padding: EdgeInsets.all(24),
                                      decoration: BoxDecoration(
                                        color: kSurface,
                                        borderRadius: BorderRadius.circular(16),
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
                                            width: 56,
                                            height: 56,
                                            decoration: BoxDecoration(
                                              color: kPrimaryBg,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: Icon(
                                              Icons.save_outlined,
                                              color: primaryColor,
                                              size: 28,
                                            ),
                                          ),
                                          gap16px,
                                          Text(
                                            'Confirm Save',
                                            style: GoogleFonts.plusJakartaSans(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 17,
                                              color: kText,
                                            ),
                                          ),
                                          gap8px,
                                          Text(
                                            'Are you sure you want to save ths accomplishment?',
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 13,
                                              color: kMuted,
                                              height: 1.5,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          gap24px,
                                          Row(
                                            children: [
                                              Expanded(
                                                child: OutlinedButton(
                                                  onPressed:
                                                      () => Navigator.pop(
                                                        ctx,
                                                        false,
                                                      ),
                                                  style: OutlinedButton.styleFrom(
                                                    side: BorderSide(
                                                      color: kBorder,
                                                    ),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          vertical: 12,
                                                        ),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    'Cancel',
                                                    style:
                                                        GoogleFonts.plusJakartaSans(
                                                          color: kMuted,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Expanded(
                                                child: ElevatedButton.icon(
                                                  onPressed:
                                                      () => Navigator.pop(
                                                        ctx,
                                                        true,
                                                      ),
                                                  label: Text(
                                                    'Save',
                                                    style:
                                                        GoogleFonts.plusJakartaSans(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                  ),
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        primaryColor,
                                                    elevation: 0,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          vertical: 12,
                                                        ),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
>>>>>>> master
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20),
                PermissionWidget(
                  allowedRoles: [
                    PermissionString.pgsAuditor,
                    PermissionString.roleAdmin,
                  ],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: primaryColor),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
<<<<<<< HEAD
                        ),
                        onPressed: () async {
                          final shouldSave = await showDialog<bool>(
                            context: context,
                            builder:
                                (ctx) => AlertDialog(
                                  title: Text("Confirm Save"),
                                  content: Text(
                                    "Are you sure you want to save this data?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.of(ctx).pop(false),
                                      child: Text(
                                        "No",
                                        style: TextStyle(color: primaryColor),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed:
                                          () => Navigator.of(ctx).pop(true),
                                      child: Text(
                                        "Yes",
                                        style: TextStyle(color: primaryColor),
                                      ),
                                    ),
                                  ],
                                ),
                          );

                          if (shouldSave != true) return;
                          MotionToast.success(
                            description: Text('Saved Successfully'),
                            toastAlignment: Alignment.topCenter,
                          ).show(context);
                          await saveBreakthroughData(
                            deliverable['pgsDeliverableId'],
                          );
                          Navigator.of(context).pop(true);
                        },
                        child: Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        ),
=======
                        ],
                      ),
                      const SizedBox(height: 12),
                      BreakthroughDialog(
                        deliverableId: deliverable['pgsDeliverableId'],
>>>>>>> master
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class PgsDeliverableHistoryGrouped {
  final int pgsDeliverableId;
  final List<PgsDeliverableScoreHistory>? scoreHistory;

  PgsDeliverableHistoryGrouped(this.pgsDeliverableId, this.scoreHistory);

  factory PgsDeliverableHistoryGrouped.fromJson(Map<String, dynamic> json) {
    return PgsDeliverableHistoryGrouped(
      json['pgsDeliverableId'] as int,
      json['scoreHistory'] != null
          ? (json['scoreHistory'] as List)
              .map((e) => PgsDeliverableScoreHistory.fromJson(e))
              .toList()
          : null,
    );
  }
}
