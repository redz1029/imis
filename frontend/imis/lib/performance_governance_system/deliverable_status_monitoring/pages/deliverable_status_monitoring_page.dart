// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imis/constant/permissions.dart';
import 'package:imis/performance_governance_system/process_core_support/models/key_result_area.dart';
import 'package:imis/performance_governance_system/pgs_period/models/pgs_period.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/utils/permission_service.dart';
import 'package:imis/widgets/filter_widget/filter_bottom_sheet.dart';
import 'package:imis/widgets/no_permission_widget.dart';
import 'package:imis/widgets/permission_widget.dart';
import 'package:imis/constant/constant.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import '../../../common_services/common_service.dart';
import '../../../office/models/office.dart';
import '../../../reports/models/pgs_summary_narrative.dart';
import '../../../reports/pages/manage_summary_narrative_report_page.dart';
import '../../../reports/services/summary_narrative_service.dart';
import '../../../user/models/user_registration.dart';
import '../../../utils/api_endpoint.dart';
import '../../../utils/auth_util.dart';
import '../../../utils/date_time_converter.dart';
import '../../../utils/permission_string.dart';
import '../../../widgets/accomplishment_widget.dart/accomplishment_pgs_auditor_widget.dart';
import '../../../widgets/breakthrough_widget.dart';
import '../../models/pgs_deliverable_score_history.dart';
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
  final ScrollController _kpiScrollController = ScrollController();
  final _deliverableStatusMonitoring = DeliverableStatusMonitoringService(
    Dio(),
  );
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

  final dio = Dio();
  final _commonService = CommonService(Dio());
  final permissionService = PermissionService();

  List<Map<String, dynamic>> deliverableList = [];
  List<KeyResultArea> kraListOptions = [];
  List<PgsPeriod> periodList = [];
  List<Office> officeList = [];

  int? selectedKra;
  int? selectedPeriod;
  String? _selectedOfficeId;
  bool? isDirect;
  String? selectedPeriodText;

  bool isLoading = true;
  bool _isLoading = false;

  int? officeId;
  int? periodId;
  bool _hasAvailableDeliverables = false;
  String? _selectedOffice;
  String? _selectedPeriod;

  int currentPage = 1;
  final int pageSize = 15;

  String userId = "";

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    setState(() => isLoading = true);
    final offices = await _deliverableStatusMonitoring.fetchOffices();
    final period = await _commonService.fetchPgsPeriod();
    final kra = await _commonService.fetchKra();
    await _loadCurrentUserId();
    if (!mounted) return;
    setState(() {
      periodList = period;
      officeList = offices;
      kraListOptions = kra;
      isLoading = false;
    });
    fetchFilteredPgsList();
  }

  Future<void> _loadCurrentUserId() async {
    UserRegistration? user = await AuthUtil.processTokenValidity(dio, context);
    if (mounted) setState(() => userId = user?.id ?? "UserId");
  }

  Future<void> fetchFilteredPgsList() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      final filter = PgsFilter(
        selectedPeriod,
        int.tryParse(_selectedOfficeId ?? ''),
        selectedKra,
        isDirect,
        scoreRangeFromController.text.isNotEmpty
            ? int.tryParse(scoreRangeFromController.text)
            : null,
        scoreRangeToController.text.isNotEmpty
            ? int.tryParse(scoreRangeToController.text)
            : null,
        pageController.text.isNotEmpty
            ? int.tryParse(pageController.text)
            : null,
        pageSizeController.text.isNotEmpty
            ? int.tryParse(pageSizeController.text)
            : null,
      );
      final queryParams =
          filter.toJson()..removeWhere((key, value) => value == null);
      final response = await AuthenticatedRequest.get(
        dio,
        ApiEndpoint().filterBy,
        queryParameters: queryParams,
      );
      if (response.statusCode == 200) {
        final items = (response.data["items"] as List<dynamic>?) ?? [];
        final formattedData =
            items.map((item) {
              String formattedByWhen = '';
              if (item['byWhen'] != null &&
                  item['byWhen'].toString().isNotEmpty) {
                try {
                  formattedByWhen = DateFormat(
                    'MMMM, yyyy',
                  ).format(DateTime.parse(item['byWhen'].toString()));
                } catch (_) {
                  formattedByWhen = item['byWhen'].toString();
                }
              }
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
                'status': item['status'].toString(),
                'remarks': item['remarks'],
                'score': item['score'],
              };
            }).toList();
        if (mounted) setState(() => deliverableList = formattedData);
      }
    } catch (e) {
      debugPrint("Error fetching filtered data: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
    try {
      final filter = PgsFilter(
        int.tryParse(_selectedPeriod!) ?? 0,
        int.tryParse(_selectedOffice!) ?? 0,
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
    }
  }

  void _resetFilters() {
    setState(() {
      selectedPeriod = null;
      selectedPeriodText = null;
      _selectedOfficeId = null;
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
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: _buildTableCard(isMobile),
                    ),
                  ),
                ],
              ),
      floatingActionButton: isMobile ? _buildMobileFAB() : null,
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
                  Icons.monitor_heart_outlined,
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
                      "Deliverables Status Monitoring",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1D23),
                      ),
                    ),
                    // Text(
                    //   "${deliverableList.length} deliverable${deliverableList.length != 1 ? 's' : ''} found",
                    //   style: TextStyle(
                    //     fontSize: 13,
                    //     color: Colors.grey.shade600,
                    //   ),
                    // ),
                  ],
                ),
              ),
              if (!isMobile) _buildHeaderActions(),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildHeaderActions() {
    return Row(
      children: [
        PermissionWidget(
          allowedRoles: [
            PermissionString.pgsAuditor,
            PermissionString.roleAdmin,
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
            PermissionString.pgsAuditor,
            PermissionString.roleAdmin,
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
            _buildOfficeFilter(),
            _buildPeriodFilter(),
            _buildKraFilter(),
            _buildTypeFilter(),
            _buildScoreRangeFilter(),
            _buildPageFilter(),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildOfficeFilter(),
          const SizedBox(width: 8),
          _buildPeriodFilter(),
          const SizedBox(width: 8),
          _buildKraFilter(),
          const SizedBox(width: 8),
          _buildTypeFilter(),
          const SizedBox(width: 8),
          _buildScoreRangeFilter(),
          if (_hasActiveFilters) ...[
            const SizedBox(width: 8),
            _buildClearButton(),
          ],
        ],
      ),
    );
  }

  Widget _buildOfficeFilter() {
    final isActive = _selectedOfficeId != null;
    final label =
        isActive
            ? (officeList
                .firstWhere(
                  (o) => o.id.toString() == _selectedOfficeId,
                  orElse: () => Office(id: 0, name: 'Office'),
                )
                .name)
            : 'Select Office';

    return FilterChipButton(
      label: label,
      icon: Icons.apartment_outlined,
      isActive: isActive,
      isRequired: true,
      onTap: () => _showOfficeBottomSheet(),
    );
  }

  Widget _buildPeriodFilter() {
    final isActive = selectedPeriod != null;
    final label = isActive ? (selectedPeriodText ?? 'Period') : 'All Periods';
    return FilterChipButton(
      label: label,
      icon: Icons.date_range_outlined,
      isActive: isActive,
      isEnabled: true,
      onTap: () => _showPeriodBottomSheet(),
    );
  }

  Widget _buildKraFilter() {
    final isActive = selectedKra != null;
    final label =
        isActive
            ? (kraListOptions
                .firstWhere(
                  (k) => k.id == selectedKra,
                  orElse: () => KeyResultArea(0, 'KRA', '', '', false),
                )
                .name)
            : 'All KRA';
    return FilterChipButton(
      label: label,
      icon: Icons.adjust_outlined,
      isActive: isActive,
      onTap: () => _showKraBottomSheet(),
    );
  }

  Widget _buildTypeFilter() {
    final isActive = isDirect != null;
    final label =
        isDirect == null ? 'All Types' : (isDirect! ? 'Direct' : 'Indirect');
    return FilterChipButton(
      label: label,
      icon: Icons.directions_outlined,
      isActive: isActive,
      onTap: () => _showTypeMenu(),
    );
  }

  Widget _buildScoreRangeFilter() {
    final isActive =
        scoreRangeFromController.text.isNotEmpty &&
        scoreRangeToController.text.isNotEmpty;
    final label =
        isActive
            ? '${scoreRangeFromController.text}–${scoreRangeToController.text}'
            : 'Score Range';
    return FilterChipButton(
      label: label,
      icon: Icons.bar_chart,
      isActive: isActive,
      onTap: () => _showScoreRangeDialog(),
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

  Widget _buildClearButton() {
    return GestureDetector(
      onTap: _resetFilters,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.close, size: 13, color: Colors.red.shade500),
            const SizedBox(width: 4),
            Text(
              'Clear',
              style: TextStyle(
                fontSize: 12,
                color: Colors.red.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOfficeBottomSheet() {
    final TextEditingController search = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (_) => StatefulBuilder(
            builder:
                (ctx, setS) => FilterBottomSheet(
                  title: 'Select Office',
                  subtitle:
                      'Required — select an office to monitor its deliverables',
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                        child: TextField(
                          controller: search,
                          onChanged: (_) => setS(() {}),
                          decoration: InputDecoration(
                            hintText: 'Search offices...',
                            prefixIcon: const Icon(Icons.search, size: 18),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: primaryColor),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            // _officeListTile(null, 'All Office'),
                            ...officeList
                                .where(
                                  (o) => o.name.toLowerCase().contains(
                                    search.text.toLowerCase(),
                                  ),
                                )
                                .map(
                                  (o) =>
                                      _officeListTile(o.id.toString(), o.name),
                                ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
          ),
    );
  }

  Widget _officeListTile(String? id, String name) {
    final selected = _selectedOfficeId == id;
    return ListTile(
      leading: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selected ? primaryColor : Colors.grey.shade100,
        ),
        child: Icon(
          Icons.apartment,
          size: 16,
          color: selected ? Colors.white : Colors.grey.shade500,
        ),
      ),
      title: Text(
        name,
        style: TextStyle(
          fontSize: 14,
          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      trailing:
          selected
              ? Icon(Icons.check_circle, color: primaryColor, size: 18)
              : null,
      onTap: () {
        setState(() => _selectedOfficeId = id?.isEmpty == true ? null : id);
        Navigator.pop(context);
        fetchFilteredPgsList();
      },
    );
  }

  void _showPeriodBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (_) => FilterBottomSheet(
            title: 'Select Period',
            child: ListView(
              shrinkWrap: true,
              children: [
                _periodListTile(null, 'All Periods'),
                ...periodList.map(
                  (p) => _periodListTile(
                    p.id,
                    "${_dateConverter.toJson(p.startDate)} – ${_dateConverter.toJson(p.endDate)}",
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _periodListTile(int? id, String label) {
    final selected = selectedPeriod == id;
    return ListTile(
      leading: Icon(
        Icons.date_range_outlined,
        size: 18,
        color: selected ? primaryColor : Colors.grey.shade500,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      trailing:
          selected
              ? Icon(Icons.check_circle, color: primaryColor, size: 18)
              : null,
      onTap: () {
        setState(() {
          selectedPeriod = id;
          selectedPeriodText = id == null ? null : label;
        });
        Navigator.pop(context);
        fetchFilteredPgsList();
      },
    );
  }

  void _showKraBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (_) => FilterBottomSheet(
            title: 'Select KRA',
            child: ListView(
              shrinkWrap: true,
              children: [
                _kraListTile(null, 'All KRA'),
                ...kraListOptions.map((k) => _kraListTile(k.id, k.name)),
              ],
            ),
          ),
    );
  }

  Widget _kraListTile(int? id, String name) {
    final selected = selectedKra == id;
    return ListTile(
      leading: Icon(
        Icons.adjust_outlined,
        size: 18,
        color: selected ? primaryColor : Colors.grey.shade500,
      ),
      title: Text(
        name,
        style: TextStyle(
          fontSize: 13,
          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      trailing:
          selected
              ? Icon(Icons.check_circle, color: primaryColor, size: 18)
              : null,
      onTap: () {
        setState(() => selectedKra = id);
        Navigator.pop(context);
        fetchFilteredPgsList();
      },
    );
  }

  void _showTypeMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (_) => FilterBottomSheet(
            title: 'Deliverable Type',
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _typeListTile(null, 'All Types', Icons.all_inclusive),
                _typeListTile(true, 'Direct', Icons.arrow_right_alt),
                _typeListTile(false, 'Indirect', Icons.alt_route),
              ],
            ),
          ),
    );
  }

  Widget _typeListTile(bool? value, String label, IconData icon) {
    final selected = isDirect == value;
    return ListTile(
      leading: Icon(
        icon,
        size: 18,
        color: selected ? primaryColor : Colors.grey.shade500,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      trailing:
          selected
              ? Icon(Icons.check_circle, color: primaryColor, size: 18)
              : null,
      onTap: () {
        setState(() => isDirect = value);
        Navigator.pop(context);
        fetchFilteredPgsList();
      },
    );
  }

  // ─── DIALOGS ─────────────────────────────────────────────────────────────────

  void _showScoreRangeDialog() {
    final fromCtrl = TextEditingController(text: scoreRangeFromController.text);
    final toCtrl = TextEditingController(text: scoreRangeToController.text);
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.bar_chart, color: primaryColor, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Score Range',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            content: Row(
              children: [
                Expanded(child: _buildNumberField('From', fromCtrl)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    '–',
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade400),
                  ),
                ),
                Expanded(child: _buildNumberField('To', toCtrl)),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    scoreRangeFromController.clear();
                    scoreRangeToController.clear();
                  });
                  Navigator.pop(context);
                  fetchFilteredPgsList();
                },
                child: const Text(
                  'Clear',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    scoreRangeFromController.text = fromCtrl.text;
                    scoreRangeToController.text = toCtrl.text;
                  });
                  Navigator.pop(context);
                  fetchFilteredPgsList();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Apply',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  void _showPaginationDialog() {
    final pageCtrl = TextEditingController(text: pageController.text);
    final sizeCtrl = TextEditingController(text: pageSizeController.text);
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.layers_outlined, color: primaryColor, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Pagination',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildNumberField('Page number', pageCtrl),
                const SizedBox(height: 12),
                _buildNumberField('Page size', sizeCtrl),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    pageController.text = pageCtrl.text;
                    pageSizeController.text = sizeCtrl.text;
                  });
                  Navigator.pop(context);
                  fetchFilteredPgsList();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Apply',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildNumberField(String label, TextEditingController ctrl) {
    return TextField(
      controller: ctrl,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 13),
        isDense: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryColor),
        ),
      ),
    );
  }

  // ─── TABLE ───────────────────────────────────────────────────────────────────

  Widget _buildTableCard(bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black.withValues(alpha: 0.04),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          if (!isMobile) _buildTableHeader(),
          const Divider(height: 1, thickness: 1, color: Color(0xFFEEEFF2)),
          Expanded(child: _buildTableBody(isMobile)),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(
              '#',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade500,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              'DELIVERABLE DETAILS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade500,
                letterSpacing: 0.5,
              ),
            ),
          ),
          SizedBox(
            width: 220,
            child: Center(
              child: Text(
                'ACTIONS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade500,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableBody(bool isMobile) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: primaryColor),
      );
    }
    if (deliverableList.isEmpty) {
      return _buildEmptyState();
    }
    return Scrollbar(
      controller: _kpiScrollController,
      thumbVisibility: true,
      child: ListView.separated(
        controller: _kpiScrollController,
        itemCount: deliverableList.length,
        separatorBuilder:
            (_, __) => const Divider(
              height: 1,
              thickness: 1,
              color: Color(0xFFEEEFF2),
            ),
        itemBuilder: (context, index) {
          final d = deliverableList[index];
          return _buildDeliverableRow(index, d, isMobile);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
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
                ? 'Use the Office filter above to get started'
                : 'Try adjusting the filters to see more results',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
          ),
          if (_selectedOfficeId == null) ...[
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _showOfficeBottomSheet,
              icon: const Icon(
                Icons.apartment_outlined,
                size: 16,
                color: Colors.white,
              ),
              label: const Text(
                'Select Office',
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
            ),
          ],
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
      // Mobile: card-style stacked layout
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row number + deliverable name
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
                        fontSize: 11,
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    d['deliverableName'] ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1D23),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Period badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${d['Start Date']} – ${d['End Date']}',
                style: TextStyle(
                  fontSize: 11,
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Info chips
            Wrap(
              spacing: 12,
              runSpacing: 6,
              children: [
                _infoChip(
                  Icons.apartment_outlined,
                  d['officeName'] ?? '',
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
            // Full-width action buttons stacked
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
          ),
          Expanded(flex: 5, child: _buildDeliverableDetails(d)),
          SizedBox(width: 220, child: _buildActionButtons(index, d)),
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
            '${d['Start Date']} – ${d['End Date']}',
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
              Icons.apartment_outlined,
              d['officeName'] ?? '',
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

  // Desktop action buttons (original column layout)
  Widget _buildActionButtons(int index, Map<String, dynamic> deliverable) {
    final deliverableId = deliverable['pgsDeliverableId'];
    final startDateStr = deliverable['Start Date'];
    final endDateStr = deliverable['End Date'];

    int monthCount = 1;
    try {
      final startDate = DateFormat('MMM dd, yyyy').parse(startDateStr);
      final endDate = DateFormat('MMM dd, yyyy').parse(endDateStr);
      DateTime curr = DateTime(startDate.year, startDate.month);
      final end = DateTime(endDate.year, endDate.month);
      monthCount = 0;
      while (curr.isBefore(end) || curr.isAtSameMomentAs(end)) {
        monthCount++;
        curr = DateTime(curr.year, curr.month + 1);
      }
    } catch (_) {}

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _actionButton(
          icon: Icons.bar_chart_outlined,
          label: 'Accomplishment',
          color: primaryColor,
          onTap: () async {
            await loadAccomplishments(deliverable['pgsDeliverableId']);
            showAccomplishmentFormDialog(context, deliverable, userId);
          },
        ),
        const SizedBox(height: 6),
        FutureBuilder<bool>(
          future: _hasCompleteAccomplishmentData(deliverableId, monthCount),
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

  // Mobile action buttons — full width, stacked
  Widget _buildMobileActionButtons(
    int index,
    Map<String, dynamic> deliverable,
  ) {
    final deliverableId = deliverable['pgsDeliverableId'];
    final startDateStr = deliverable['Start Date'];
    final endDateStr = deliverable['End Date'];

    int monthCount = 1;
    try {
      final startDate = DateFormat('MMM dd, yyyy').parse(startDateStr);
      final endDate = DateFormat('MMM dd, yyyy').parse(endDateStr);
      DateTime curr = DateTime(startDate.year, startDate.month);
      final end = DateTime(endDate.year, endDate.month);
      monthCount = 0;
      while (curr.isBefore(end) || curr.isAtSameMomentAs(end)) {
        monthCount++;
        curr = DateTime(curr.year, curr.month + 1);
      }
    } catch (_) {}

    return Column(
      children: [
        // Full-width accomplishment button
        SizedBox(
          width: double.infinity,
          child: _actionButton(
            icon: Icons.bar_chart_outlined,
            label: 'View Accomplishment',
            color: primaryColor,
            fullWidth: true,
            onTap: () async {
              await loadAccomplishments(deliverable['pgsDeliverableId']);
              showAccomplishmentFormDialog(context, deliverable, userId);
            },
          ),
        ),
        const SizedBox(height: 8),
        // Full-width breakthrough button
        FutureBuilder<bool>(
          future: _hasCompleteAccomplishmentData(deliverableId, monthCount),
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: fullWidth ? double.infinity : null,
        padding: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: fullWidth ? 10 : 6,
        ),
        decoration: BoxDecoration(
          color: disabled ? Colors.grey.shade50 : color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color:
                disabled ? Colors.grey.shade200 : color.withValues(alpha: 0.3),
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
    );
  }

  Widget _buildMobileFAB() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PermissionWidget(
          allowedRoles: [
            PermissionString.pgsAuditor,
            PermissionString.roleAdmin,
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
            PermissionString.pgsAuditor,
            PermissionString.roleAdmin,
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

  void showReportDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              insetPadding: const EdgeInsets.all(20),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              contentPadding: EdgeInsets.zero,
              content: SizedBox(
                width: 900,
                child: SingleChildScrollView(
                  child: _buildReportCard(setDialogState),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _clearReportForm();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                PermissionWidget(
                  permission: AppPermissions.addPgsDeliverableAccomplishment,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final confirm = await _showConfirmDialog(context);
                        if (confirm == true) {
                          final summaryNarrative = PgsSummaryNarrative(
                            0,
                            int.tryParse(_selectedPeriod ?? '0') ?? 0,
                            _findingsController.text,
                            _recommendationsController.text,
                            _conclusionsController.text,
                            int.tryParse(_selectedOffice ?? '0') ?? 0,
                            isDeleted: false,
                            rowVersion: '',
                          );
                          await _summaryNarrativeService.addSummaryNarrative(
                            summaryNarrative,
                          );
                          _clearReportForm();
                          MotionToast.success(
                            description: const Text("Saved Successfully"),
                            toastAlignment: Alignment.topCenter,
                          ).show(context);
                          Navigator.pop(context);
                        }
                      }
                    },
                    child: const Text(
                      'Save Report',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _clearReportForm() {
    _findingsController.clear();
    _recommendationsController.clear();
    _conclusionsController.clear();
    _selectedOffice = null;
    _selectedPeriod = null;
    officeId = null;
    periodId = null;
  }

  Future<bool?> _showConfirmDialog(BuildContext ctx) {
    return showDialog<bool>(
      context: ctx,
      builder:
          (c) => AlertDialog(
            title: const Text("Confirm Save"),
            content: const Text("Are you sure you want to save this report?"),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(c, false),
                child: const Text("No", style: TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(c, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Yes", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
    );
  }

  Widget _buildReportCard(Function setDialogState) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 900, maxHeight: 900),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FB),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.insert_drive_file_outlined,
                      color: primaryColor,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Summary Narrative Report',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Fill in the details below to create an audit report',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: () {
                      _clearReportForm();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Period & Office — responsive row/column
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FB),
                        border: Border.all(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final isNarrow = constraints.maxWidth < 500;
                          if (isNarrow) {
                            return Column(
                              children: [
                                _buildPeriodDropdown(setDialogState),
                                const SizedBox(height: 16),
                                _buildOfficeDropdown(setDialogState),
                              ],
                            );
                          }
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _buildPeriodDropdown(setDialogState),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: _buildOfficeDropdown(setDialogState),
                              ),
                            ],
                          );
                        },
                      ),
                    ),

                    if (!_hasAvailableDeliverables &&
                        _selectedOffice != null &&
                        _selectedPeriod != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 14,
                              color: Colors.orange.shade700,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "No deliverables found for the selected office and period.",
                              style: TextStyle(
                                color: Colors.orange.shade700,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 24),
                    _buildReportSection(
                      icon: Icons.error_outline_rounded,
                      iconColor: Colors.blue,
                      title: "Auditor Findings",
                      description:
                          "Separate each finding as a distinct point in the report.",
                      controller: _findingsController,
                      disabled: !_hasAvailableDeliverables,
                    ),
                    const SizedBox(height: 20),
                    _buildReportSection(
                      icon: Icons.check_circle_outline,
                      iconColor: Colors.green,
                      title: "Conclusions",
                      description:
                          "Summarize your analysis and overall insights.",
                      controller: _conclusionsController,
                      disabled: !_hasAvailableDeliverables,
                    ),
                    const SizedBox(height: 20),
                    _buildReportSection(
                      icon: Icons.trending_up,
                      iconColor: Colors.deepOrangeAccent,
                      title: "Recommendations",
                      description: "List actionable steps for improvement.",
                      controller: _recommendationsController,
                      disabled: !_hasAvailableDeliverables,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodDropdown(Function setDialogState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text.rich(
          TextSpan(
            text: 'Period ',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            children: [
              TextSpan(text: '*', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        DropdownSearch<PgsPeriod>(
          popupProps: PopupProps.menu(
            showSearchBox: true,
            fit: FlexFit.loose,
            menuProps: const MenuProps(
              backgroundColor: Colors.white,
              elevation: 2,
            ),
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                hintText: 'Search...',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                ),
              ),
            ),
            itemBuilder:
                (ctx, period, _) => ListTile(
                  tileColor: Colors.white,
                  title: Text(
                    "${LongDateOnlyConverter().toJson(period.startDate)} – ${LongDateOnlyConverter().toJson(period.endDate)}",
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
          ),
          items: periodList,
          itemAsString:
              (p) =>
                  "${LongDateOnlyConverter().toJson(p.startDate)} – ${LongDateOnlyConverter().toJson(p.endDate)}",
          selectedItem:
              _selectedPeriod == null
                  ? null
                  : periodList.firstWhere(
                    (p) => p.id.toString() == _selectedPeriod,
                    orElse:
                        () => PgsPeriod(
                          0,
                          false,
                          DateTime.now(),
                          DateTime.now(),
                          '',
                        ),
                  ),
          onChanged: (value) {
            setDialogState(() {
              _selectedPeriod = value?.id.toString();
              _clearReportTextFields();
              _checkDeliverablesAvailability(setDialogState);
            });
          },
          validator: (v) => v == null ? 'Required' : null,
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              labelText: 'Select Period',
              labelStyle: const TextStyle(fontSize: 13),
              filled: true,
              fillColor: Colors.transparent,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: primaryColor),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOfficeDropdown(Function setDialogState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text.rich(
          TextSpan(
            text: 'Office ',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            children: [
              TextSpan(text: '*', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        DropdownSearch<Office>(
          popupProps: PopupProps.menu(
            showSearchBox: true,
            fit: FlexFit.loose,
            menuProps: const MenuProps(
              backgroundColor: Colors.white,
              elevation: 2,
            ),
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                hintText: 'Search...',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                ),
              ),
            ),
            itemBuilder:
                (ctx, office, _) => ListTile(
                  tileColor: Colors.white,
                  title: Text(
                    office.name,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
          ),
          items: officeList,
          itemAsString: (o) => o.name,
          selectedItem:
              _selectedOffice == null
                  ? null
                  : officeList.firstWhere(
                    (o) => o.id.toString() == _selectedOffice,
                    orElse: () => Office(id: 0, name: 'Unknown'),
                  ),
          onChanged: (value) {
            setDialogState(() {
              _selectedOffice = value?.id.toString();
              _clearReportTextFields();
              _checkDeliverablesAvailability(setDialogState);
            });
          },
          validator: (v) => v == null ? 'Required' : null,
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              labelText: 'Select Office',
              labelStyle: const TextStyle(fontSize: 13),
              filled: true,
              fillColor: Colors.transparent,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: primaryColor),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _clearReportTextFields() {
    _findingsController.clear();
    _recommendationsController.clear();
    _conclusionsController.clear();
  }

  Widget _buildReportSection({
    required String title,
    required String description,
    required TextEditingController controller,
    IconData icon = Icons.description_outlined,
    Color iconColor = Colors.black54,
    bool disabled = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: disabled ? Colors.grey.shade300 : iconColor,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color:
                    disabled ? Colors.grey.shade400 : const Color(0xFF1A1D23),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        ),
        const SizedBox(height: 10),
        Container(
          constraints: const BoxConstraints(minHeight: 100, maxHeight: 160),
          width: double.infinity,
          decoration: BoxDecoration(
            color: disabled ? Colors.grey.shade50 : const Color(0xFFF8F9FB),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: disabled ? Colors.grey.shade200 : Colors.grey.shade300,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Scrollbar(
            thumbVisibility: true,
            child: SingleChildScrollView(
              child: TextFormField(
                controller: controller,
                style: TextStyle(
                  fontSize: 13,
                  color:
                      disabled ? Colors.grey.shade400 : const Color(0xFF1A1D23),
                ),
                maxLines: null,
                readOnly: disabled,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText:
                      disabled
                          ? 'Select a period and office first...'
                          : 'Type here...',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 13,
                  ),
                ),
                validator:
                    (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Future<bool?> showAccomplishmentFormDialog(
  BuildContext context,
  Map<String, dynamic> deliverable,
  String userId,
) {
  final startDate = DateFormat('MMM dd, yyyy').parse(deliverable['Start Date']);
  final endDate = DateFormat('MMM dd, yyyy').parse(deliverable['End Date']);

  List<Map<String, dynamic>> monthlyPeriods = [];
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

  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder:
        (context) => Dialog(
          backgroundColor: mainBgColor,
          insetPadding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1500),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  "Accomplishment Form — ${DateFormat('MMM dd, yyyy').format(startDate)} to ${DateFormat('MMM dd, yyyy').format(endDate)}",
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Wrap(
                              spacing: 24,
                              runSpacing: 6,
                              children: [
                                Text(
                                  "Office: ${deliverable['officeName'] ?? 'N/A'}",
                                  style: const TextStyle(fontSize: 13),
                                ),
                                Text(
                                  "KRA: ${deliverable['kra'] ?? 'N/A'}",
                                  style: const TextStyle(fontSize: 13),
                                ),
                                Text(
                                  "Type: ${deliverable['isDirect'] == true ? 'Direct' : 'Indirect'}",
                                  style: const TextStyle(fontSize: 13),
                                ),
                                Text(
                                  "Due: ${deliverable['byWhen'] ?? 'N/A'}",
                                  style: const TextStyle(fontSize: 13),
                                ),
                                Text(
                                  "Periods: ${monthlyPeriods.length} month(s)",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "Deliverable: ${deliverable['deliverableName'] ?? 'N/A'}",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
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
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade50,
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(10),
                                    ),
                                  ),
                                  child: Row(
                                    children: const [
                                      Expanded(
                                        flex: 2,
                                        child: Center(
                                          child: Text(
                                            "Period",
                                            style: TextStyle(
                                              color: grey,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Center(
                                          child: Text(
                                            "Status",
                                            style: TextStyle(
                                              color: grey,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Center(
                                          child: Text(
                                            "% Accomplishment",
                                            style: TextStyle(
                                              color: grey,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Center(
                                          child: Text(
                                            "Remarks (Dept Head)",
                                            style: TextStyle(
                                              color: grey,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Center(
                                          child: Text(
                                            "Proof",
                                            style: TextStyle(
                                              color: grey,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Center(
                                          child: Text(
                                            "Remarks (Auditor)",
                                            style: TextStyle(
                                              color: grey,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ...monthlyPeriods.asMap().entries.map(
                                  (e) => Column(
                                    children: [
                                      const Divider(height: 1),
                                      TrackingRowWidget(
                                        period: e.value['period'],
                                        periodIndex: e.key,
                                        totalPeriods: monthlyPeriods.length,
                                        deliverableId:
                                            deliverable['pgsDeliverableId'],
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
                                  (ctx) => AlertDialog(
                                    title: const Text("Confirm Save"),
                                    content: const Text(
                                      "Save accomplishment data?",
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed:
                                            () => Navigator.of(ctx).pop(false),
                                        child: const Text(
                                          "No",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed:
                                            () => Navigator.of(ctx).pop(true),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: primaryColor,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          "Yes",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                            );
                            if (shouldSave != true) return;
                            MotionToast.success(
                              description: const Text('Saved Successfully'),
                              toastAlignment: Alignment.topCenter,
                            ).show(context);
                            await saveAccomplishmentData(
                              deliverable['pgsDeliverableId'],
                              userId,
                            );
                            Navigator.of(context).pop(true);
                          },
                          child: const Text(
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
        ),
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
    builder: (dialogContext) {
      final size = MediaQuery.of(dialogContext).size;
      final isMobile = size.width < 700;
      return Dialog(
        backgroundColor: const Color(0xFFF3F4F6),
        insetPadding: EdgeInsets.symmetric(
          horizontal: isMobile ? 0 : 24,
          vertical: isMobile ? 0 : 24,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isMobile ? 0 : 16),
        ),
        child: SizedBox(
          width: isMobile ? size.width : 720,
          height: isMobile ? size.height : size.height * 0.90,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              DialogHeader(
                isMobile: isMobile,
                onClose: () => Navigator.pop(dialogContext),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 14 : 24,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Office: ${deliverable['officeName'] ?? 'N/A'}",
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

                      BreakthroughWidget(
                        deliverableId: deliverable['pgsDeliverableId'],
                      ),
                    ],
                  ),
                ),
              ),
              DialogFooter(
                isMobile: isMobile,
                dialogContext: dialogContext,
                deliverableId: deliverable['pgsDeliverableId'],
              ),
            ],
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
