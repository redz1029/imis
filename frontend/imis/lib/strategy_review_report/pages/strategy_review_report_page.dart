// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/constant/permissions.dart';
import 'package:imis/roadmap/kra_period_roadmap/models/kra_roadmap_period.dart';
import 'package:imis/strategy_review_report/models/strategy_review_report.dart';
import 'package:imis/strategy_review_report/services/strategy_review_report_services.dart';
import 'package:imis/strategy_review_report/strategy_review_period/models/strategy_review_period.dart';
import 'package:imis/utils/date_time_converter.dart';
import 'package:imis/performance_governance_system/process_core_support/models/key_result_area.dart';
import 'package:imis/roadmap/models/kpi_roadmap.dart';
import 'package:imis/roadmap/models/kra_roadmap_role.dart';
import 'package:imis/roadmap/models/roadmap.dart';
import 'package:imis/roadmap/models/roadmap_deliverables.dart';
import 'package:imis/roadmap/services/roadmap_service.dart';
import 'package:imis/utils/permission_service.dart';
import 'package:imis/utils/print_preview_util.dart';
import 'package:imis/widgets/common/button_filter.dart';
import 'package:imis/widgets/common/filter_button_widget.dart';
import 'package:imis/widgets/dialog/delete_dialog.dart';
import 'package:imis/widgets/permission/no_permission_to_view_widget.dart';
import 'package:imis/widgets/common/pagination_controls.dart';
import 'package:imis/widgets/permission/permission_widget.dart';
import 'package:imis/strategy_review_report/dialog/strategy_review_report_dialog.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common_services/common_service.dart';
import '../../utils/auth_util.dart';

enum _Screen { small, medium, large }

_Screen _screenOf(BuildContext ctx) {
  final w = MediaQuery.of(ctx).size.width;
  if (w < 600) return _Screen.small;
  if (w < 900) return _Screen.medium;
  return _Screen.large;
}

class _ResponsiveDialog extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const _ResponsiveDialog({required this.child, this.maxWidth = 480});

  @override
  Widget build(BuildContext context) {
    final screen = _screenOf(context);
    final size = MediaQuery.of(context).size;
    final hPad = screen == _Screen.small ? 12.0 : 32.0;
    final vPad = screen == _Screen.small ? 8.0 : 40.0;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth,
          maxHeight: size.height * (screen == _Screen.small ? 0.94 : 0.88),
        ),
        child: child,
      ),
    );
  }
}

class _DialogHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback onClose;
  final bool centerTitle;

  const _DialogHeader({
    required this.title,
    this.subtitle,
    required this.onClose,
    this.centerTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
        border: Border(bottom: BorderSide(color: primaryColor)),
      ),
      child: centerTitle ? _buildCentered() : _buildDefault(),
    );
  }

  Widget _buildDefault() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: const TextStyle(fontSize: 12, color: Colors.white54),
                ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close, size: 18, color: Colors.white70),
          onPressed: onClose,
        ),
      ],
    );
  }

  Widget _buildCentered() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: Colors.white60),
                ),
            ],
          ),
        ),
        Positioned(
          right: 0,
          child: IconButton(
            icon: const Icon(Icons.close, size: 18, color: Colors.white70),
            onPressed: onClose,
          ),
        ),
      ],
    );
  }
}

class StrategyReviewReportPage extends StatefulWidget {
  const StrategyReviewReportPage({super.key});

  @override
  State<StrategyReviewReportPage> createState() => RoadmapDialogPageState();
}

class RoadmapDialogPageState extends State<StrategyReviewReportPage> {
  final FocusNode isSearchfocus = FocusNode();
  final _commonService = CommonService(Dio());
  final _roadmapService = RoadmapService(Dio());
  final _strategyReviewReport = StrategyReviewReportServices(Dio());
  TextEditingController searchController = TextEditingController();
  List<Roadmap> filteredList = [];
  List<Roadmap> roadmapList = [];
  int _currentPage = 1;
  final int _pageSize = 15;
  int _totalCount = 0;
  bool _isLoading = false;
  final dio = Dio();
  String _roleId = '';
  String? _selectedPeriodId;
  List<StrategyReviewPeriod> strategyPeriodList = [];
  final List<DeliverableGroup> deliverables = [];
  List<KeyResultArea> kraList = [];
  List<KraRoadmapRole> kraListRoadmap = [];
  List<KraRoadmapPeriod> kraPeriodList = [];
  final List<KpiRoadmap> kpiList = [];
  final permissionService = PermissionService();
  String selectedFilter = "All Process (Core&Support)";
  List<StrategyReviewReport> _strategyReviewList = [];
  List<StrategyReviewReport> _strategyReviewFilteredList = [];
  final _dateConverter = const LongDateOnlyConverter();
  List<StrategyReviewReport> get _filteredReviews {
    if (selectedFilter == "All Process (Core&Support)") {
      return _strategyReviewList;
    }
    return _strategyReviewList.where((review) {
      final matchedKra = kraListRoadmap.firstWhere(
        (k) => k.kraId == review.kraRoadMapId,
        orElse:
            () => KraRoadmapRole(
              id: 0,
              kraId: 0,
              roleId: '',
              kraName: '',
              strategicObjectives: '',
            ),
      );
      return matchedKra.kraName.trim().toLowerCase() ==
          selectedFilter.trim().toLowerCase();
    }).toList();
  }

  @override
  void initState() {
    super.initState();

    _initialize();
    isSearchfocus.addListener(() => setState(() {}));
    () async {
      final kra = await _commonService.fetchKra();
      final kraPeriod = await _commonService.fetchKraPeriod();
      final kraRoadmap = await _roadmapService.getKraRoadmapByRoleId();
      if (!mounted) return;
      setState(() {
        kraList = kra;
        kraPeriodList = kraPeriod;
        kraListRoadmap = kraRoadmap;
      });
      await fetchStrategyReviews();
    }();
  }

  Future<void> _initialize() async {
    setState(() => _isLoading = true);

    final periods = await _commonService.fetchSrategyPeriod();

    if (!mounted) return;
    setState(() {
      strategyPeriodList = periods;
      _isLoading = false;
    });
  }

  Future<void> fetchStrategyReviews({int page = 1, String? searchQuery}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final roleId = await _getRoleId();

      if (roleId.isEmpty) {
        debugPrint('Role ID is empty, aborting fetch.');
        return;
      }

      setState(() => _roleId = roleId);

      final pageList = await _strategyReviewReport.getStrategyReviewReportList(
        page: page,
        pageSize: _pageSize,
        searchQuery: searchQuery,
        roleId: roleId,
      );

      if (mounted) {
        setState(() {
          _currentPage = pageList.page;
          _totalCount = pageList.totalCount;
          _strategyReviewList = pageList.items;
          filteredList = List.from(_strategyReviewList);
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

      final result = await _strategyReviewReport.getStrategyReviewReportList(
        roleId: roleIdParam,
        page: targetPage,
        pageSize: pageSize,
        strategyReviewPeriodId: _selectedPeriodId,
      );
      setState(() {
        _strategyReviewList = result.items;
        _strategyReviewFilteredList = result.items;
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

  Future<void> filterSearchResults(String query) async {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      setState(() => filteredList = List.from(roadmapList));
      return;
    }
    final results =
        roadmapList.where((r) {
          final matchedKra = kraList.firstWhere(
            (kra) => kra.id == r.kraId,
            orElse: () => KeyResultArea(0, '', '', '', false),
          );
          final matchedKraPeriod = kraPeriodList.firstWhere(
            (p) => p.id == r.kraRoadMapPeriodId,
            orElse:
                () => KraRoadmapPeriod(
                  0,
                  DateTime.now(),
                  DateTime.now(),
                  isDeleted: false,
                  rowVersion: '',
                ),
          );
          final periodString =
              '${matchedKraPeriod.startYear.year} - ${matchedKraPeriod.endYear.year}';
          final kpiMatch = (r.kpis ?? []).any(
            (k) => (k.kpiDescription ?? '').toLowerCase().contains(q),
          );
          return matchedKra.name.toLowerCase().contains(q) ||
              periodString.contains(q) ||
              kpiMatch;
        }).toList();
    setState(() => filteredList = results);
  }

  void showPeriodPanel() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (ctx) => _ResponsiveDialog(
            maxWidth: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _DialogHeader(
                  title: 'SELECT PERIOD',
                  onClose: () => Navigator.pop(ctx),
                ),
                Container(
                  color: Theme.of(context).cardColor,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: FutureBuilder<List<KraRoadmapPeriod>>(
                          future: _commonService.fetchKraPeriod(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Padding(
                                padding: EdgeInsets.all(24),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            if (snapshot.hasError) {
                              return const Padding(
                                padding: EdgeInsets.all(16),
                                child: Text('Failed to load periods'),
                              );
                            }
                            final periods = snapshot.data ?? [];
                            if (periods.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.all(16),
                                child: Text('No periods available'),
                              );
                            }
                            return ListView.separated(
                              shrinkWrap: true,
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              itemCount: periods.length,
                              separatorBuilder:
                                  (_, __) => Divider(
                                    height: 1,
                                    color: Colors.grey.shade200,
                                  ),
                              itemBuilder: (context, index) {
                                final period = periods[index];
                                final label =
                                    '${period.startYear.year} - ${period.endYear.year}';
                                return InkWell(
                                  onTap: () {
                                    Navigator.pop(ctx);
                                    showKraListPanel(selectedPeriod: period);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 13,
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.date_range,
                                          color: primaryColor,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            label,
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
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Container(
                  color: Theme.of(context).cardColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          style: TextButton.styleFrom(
                            foregroundColor: primaryColor,
                          ),
                          child: const Text('Cancel'),
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

  void showKraListPanel({required KraRoadmapPeriod selectedPeriod}) {
    final periodLabel =
        '${selectedPeriod.startYear.year} - ${selectedPeriod.endYear.year}';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (ctx) => _ResponsiveDialog(
            maxWidth: 480,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _DialogHeader(
                  title: 'SELECT ROADMAP',
                  subtitle: periodLabel,
                  onClose: () => Navigator.pop(ctx),
                ),
                Container(
                  color: Theme.of(context).cardColor,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: FutureBuilder<List<KraRoadmapRole>>(
                          future: _strategyReviewReport
                              .getStrategyReviewByPeriod(selectedPeriod.id),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Padding(
                                padding: EdgeInsets.all(24),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            if (snapshot.hasError) {
                              return const Padding(
                                padding: EdgeInsets.all(16),
                                child: Text('Failed to load roadmaps'),
                              );
                            }
                            final kras = snapshot.data ?? [];
                            if (kras.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.all(16),
                                child: Text(
                                  'No roadmaps available for this period',
                                ),
                              );
                            }
                            return ListView.separated(
                              shrinkWrap: true,
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              itemCount: kras.length,
                              separatorBuilder:
                                  (_, __) => Divider(
                                    height: 1,
                                    color: Colors.grey.shade200,
                                  ),
                              itemBuilder: (context, index) {
                                final kra = kras[index];
                                return InkWell(
                                  onTap: () async {
                                    Navigator.pop(ctx);
                                    final result =
                                        await showStrategyReviewReportDialog(
                                          context,
                                          kraRoadMapId: kra.id,
                                          year: selectedPeriod.startYear.year,
                                          kraName: kra.kraName,
                                          strategicObjectives:
                                              kra.strategicObjectives ?? '',
                                        );
                                    if (result != null) {
                                      fetchStrategyReviews();
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 13,
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.map_outlined,
                                          color: primaryColor,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            kra.kraName,
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
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Container(
                  color: Theme.of(context).cardColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            Navigator.pop(ctx);
                            showPeriodPanel();
                          },
                          icon: const Icon(Icons.arrow_back, size: 15),
                          label: const Text('Back'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.grey[700],
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          style: TextButton.styleFrom(
                            foregroundColor: primaryColor,
                          ),
                          child: const Text('Cancel'),
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

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;
    final hasPermission = permissionService.hasPermission(
      AppPermissions.viewStrategyReview,
    );

    if (!hasPermission) return noPermissionScreen();

    final displayList = _filteredReviews;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPageHeader(isMobile, displayList.length),
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
                                "Process (Core & Support)",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Quarter",
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
                              : displayList.isEmpty
                              ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.summarize_outlined,
                                      size: 50,
                                      color: Colors.grey.shade400,
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      "No strategy review report available",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              : ListView.separated(
                                itemCount: displayList.length,
                                separatorBuilder:
                                    (_, __) => Divider(
                                      height: 1,
                                      color: Colors.grey.withValues(alpha: .2),
                                    ),
                                itemBuilder: (context, index) {
                                  final review = displayList[index];
                                  final itemNumber = index + 1;

                                  final matchedKra = kraListRoadmap.firstWhere(
                                    (k) => k.kraId == review.kraRoadMapId,
                                    orElse:
                                        () => KraRoadmapRole(
                                          id: 0,
                                          kraId: 0,
                                          roleId: '',
                                          kraName:
                                              'KRA #${review.kraRoadMapId}',
                                          strategicObjectives: '',
                                        ),
                                  );

                                  final postingDate = review.postingDate
                                      .substring(0, 10);

                                  if (!isMobile) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              "$itemNumber",
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              matchedKra.kraName,
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              _dateConverter.toJson(
                                                DateTime.parse(postingDate),
                                              ),
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Row(
                                              children: [
                                                Tooltip(
                                                  message: 'Edit',
                                                  child: IconButton(
                                                    icon: const Icon(
                                                      Icons.edit_outlined,
                                                      size: 16,
                                                    ),
                                                    onPressed: () async {
                                                      final existing =
                                                          await _strategyReviewReport
                                                              .getStrategyReviewById(
                                                                review.id,
                                                              );

                                                      final matchedKra =
                                                          kraListRoadmap.firstWhere(
                                                            (k) =>
                                                                k.kraId ==
                                                                review
                                                                    .kraRoadMapId,
                                                            orElse:
                                                                () => KraRoadmapRole(
                                                                  id: 0,
                                                                  kraId: 0,
                                                                  roleId: '',
                                                                  kraName: '',
                                                                  strategicObjectives:
                                                                      '',
                                                                ),
                                                          );

                                                      await showStrategyReviewReportDialog(
                                                        context,
                                                        kraRoadMapId:
                                                            review.kraRoadMapId,
                                                        year:
                                                            DateTime.parse(
                                                              review
                                                                  .postingDate,
                                                            ).year,
                                                        kraName:
                                                            matchedKra.kraName,
                                                        strategicObjectives:
                                                            review
                                                                .strategicObjective ??
                                                            '',
                                                        existingReview:
                                                            existing,
                                                      );

                                                      fetchStrategyReviews();
                                                    },
                                                  ),
                                                ),
                                                Tooltip(
                                                  message: 'Print preview',
                                                  child: IconButton(
                                                    onPressed: () {
                                                      openStrategyReviewReportPreview(
                                                        review.id.toString(),
                                                        review.kraRoadMapId
                                                            .toString(),
                                                        context: context,
                                                      );
                                                    },
                                                    icon: const Icon(
                                                      Icons
                                                          .description_outlined,
                                                      size: 16,
                                                      color: Colors.blueAccent,
                                                    ),
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
                                                        review.id.toString(),
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
                                                if (value == 'delete') {
                                                  showDeleteDialog(
                                                    review.id.toString(),
                                                  );
                                                }
                                              },
                                              itemBuilder:
                                                  (_) => [
                                                    const PopupMenuItem(
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
                                        const SizedBox(height: 6),
                                        Text(
                                          "Process (Core & Support): ${matchedKra.kraName}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                          ),
                                        ),

                                        const SizedBox(height: 4),
                                        Text(
                                          "Quarter: $postingDate",
                                          style: TextStyle(
                                            color: Colors.grey.shade500,
                                            fontSize: 12,
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
                            onPageChanged:
                                (page) => fetchStrategyReviews(page: page),
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
                onPressed: () => showPeriodPanel(),
                child: const Icon(Icons.add, color: Colors.white),
              )
              : null,
    );
  }

  Widget _buildPageHeader(bool isMobile, int count) {
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.summarize_outlined,
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
                      "Strategy Review Report Information",
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
                      "$count report${count != 1 ? 's' : ''} found",
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
                  permission: AppPermissions.addStrategyReview,
                  child: ElevatedButton.icon(
                    onPressed: () => showPeriodPanel(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 16,
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
                      'Add New',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isXSmall ? 11 : 13,
                      ),
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
      selectedFilter != "All Process (Core&Support)" ||
      _selectedPeriodId != null;
  void _resetFilters() {
    setState(() {
      selectedFilter = "All Process (Core&Support)";
      _selectedPeriodId = null;
    });
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
            buildDropdown(child: _buildRoadmapFilter()),
            buildDropdown(child: _periodDropdown()),
          ],
        ),
      ],
    );
  }

  Widget _buildRoadmapFilter() {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 150, maxWidth: 400),
      child: SizedBox(
        height: 38,
        child: SearchableDropdown(
          items: [
            "All Process (Core&Support)",
            ...kraList.map((kra) => kra.name),
          ],
          prefixIcon: Icons.account_tree_outlined,
          selectedItem: selectedFilter,
          hintText: "Filter KRA",
          searchHint: "Search Process...",
          onChanged: (value) => setState(() => selectedFilter = value),
        ),
      ),
    );
  }

  Widget _buildMobileFilters() {
    return Row(
      children: [
        const Text(
          "Filter by",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SizedBox(
            height: 38,
            child: SearchableDropdown(
              items: [
                "All Process (Core&Support)",
                ...kraList.map((kra) => kra.name),
              ],
              selectedItem: selectedFilter,
              hintText: "Filter KRA",
              searchHint: "Search Process...",
              onChanged: (value) => setState(() => selectedFilter = value),
            ),
          ),
        ),
        SizedBox(
          height: 38,
          child: PermissionWidget(
            permission: AppPermissions.viewOffice,
            child: _periodDropdown(),
          ),
        ),
        if (_hasActiveFilters) ...[
          const SizedBox(width: 4),
          IconButton(
            onPressed: _resetFilters,
            icon: Icon(Icons.refresh, size: 18, color: Colors.red.shade400),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
          ),
        ],
      ],
    );
  }

  Widget _periodDropdown() {
    final converter = LongDateOnlyConverter();
    final items = strategyPeriodList.where((p) => !p.isDeleted).toList();
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

  void showDeleteDialog(String id) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder:
          (ctx) => DeleteDialog(
            title: 'Strategy Review Report',
            itemName: 'strategy review report',
            onDelete: () async {
              Navigator.pop(ctx);
              try {
                await _strategyReviewReport.deleteStrategyReview(id);
                await fetchStrategyReviews();
                if (mounted) {
                  MotionToast.success(
                    toastAlignment: Alignment.topCenter,
                    description: Text(
                      'Strategy Review Report deleted successfully',
                      style: GoogleFonts.plusJakartaSans(),
                    ),
                  ).show(context);
                }
              } catch (_) {
                MotionToast.error(
                  toastAlignment: Alignment.topCenter,
                  description: Text(
                    'Failed to delete roadmap',
                    style: GoogleFonts.plusJakartaSans(),
                  ),
                );
              }
            },
          ),
    );
  }
}
