

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:imis/ISO/IQA/audit_plan/models/audit_plan.dart';
import 'package:imis/ISO/IQA/audit_plan/pages/audit_plan_page.dart';
import 'package:imis/ISO/IQA/audit_plan/services/AuditPlanService.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/widgets/common/build_page_header.dart';
import 'package:imis/widgets/common/pagination_controls.dart';
import 'package:imis/ISO/IQA/widgets/approval_workflow_widgets.dart';
import 'package:imis/ISO/IQA/widgets/iqa_list_toolbar.dart';

class AuditPlanListPage extends StatefulWidget {
  const AuditPlanListPage({super.key});

  @override
  State<AuditPlanListPage> createState() => _AuditPlanListPageState();
}

class _AuditPlanListPageState extends State<AuditPlanListPage> {
  final _service = AuditPlanService(Dio());

  List<AuditPlan> _allPlans = [];
  String _selectedTab = IqaStatus.all;
  DateTimeRange _range = IqaPeriod.currentYear();
  int _currentPage = 1;
  final int _pageSize = 15;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchPlans();
  }

  /// [silent] refreshes the list in the background (after a save) without
  /// swapping the rows for a loading spinner.
  Future<void> _fetchPlans({bool silent = false}) async {
    if (!silent) setState(() => _isLoading = true);
    try {
      final data = await _service.getAllAuditPlans();
      if (mounted) setState(() => _allPlans = data);
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) {
        MotionToast.error(
          description: Text(
            'Failed to load audit plans: '
            '${e.toString().replaceFirst('Exception: ', '')}',
          ),
        ).show(context);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // A plan covers its start..end dates; the status tabs count what is inside
  // the selected period. The status is the real workflow state
  // (effectiveStatusName), grouped into the shared tabs.
  bool _inPeriod(AuditPlan p) =>
      IqaPeriod.matches(_range, p.startDate, p.endDate);

  List<AuditPlan> get _inRange => _allPlans.where(_inPeriod).toList();

  int _countFor(String tab) {
    if (tab == IqaStatus.all) return _inRange.length;
    return _inRange
        .where((p) => IqaStatus.tabOf(p.effectiveStatusName) == tab)
        .length;
  }

  List<AuditPlan> get _filtered {
    if (_selectedTab == IqaStatus.all) return _inRange;
    return _inRange
        .where((p) => IqaStatus.tabOf(p.effectiveStatusName) == _selectedTab)
        .toList();
  }

  List<AuditPlan> get _paged {
    final filtered = _filtered;
    final start = (_currentPage - 1) * _pageSize;
    if (start >= filtered.length) return [];
    final end = (start + _pageSize).clamp(0, filtered.length);
    return filtered.sublist(start, end);
  }

  void _selectTab(String tab) {
    setState(() {
      _selectedTab = tab;
      _currentPage = 1;
    });
  }

  void _setRange(DateTimeRange range) {
    setState(() {
      _range = range;
      _currentPage = 1;
    });
  }

  void _clearFilters() {
    setState(() {
      _range = IqaPeriod.currentYear();
      _selectedTab = IqaStatus.all;
      _currentPage = 1;
    });
  }

  /// Mirrors AuditProgrammeListPage._openForm exactly — a modal dialog, not
  /// a pushed route, so the ISO section's navigation style stays consistent.
  /// AuditPlanPage requires a programmeId to reload its parent Programme's
  /// context; AuditPlan already carries that via auditProgrammeId.
  Future<void> _openForm({AuditPlan? plan}) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AuditPlanPage(
        programmeId: plan?.auditProgrammeId,
        auditPlanId: plan?.id,
      ),
    );
    _fetchPlans(silent: true);
  }

  Future<void> _deletePlan(AuditPlan plan) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Audit Plan'),
        content: Text(
          'Are you sure you want to delete Audit Plan #${plan.id}? '
          'This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await _service.deleteAuditPlan(plan.id); // <-- must match your service
      if (!mounted) return;
      MotionToast.success(
        description: const Text('Audit plan deleted.'),
      ).show(context);
      _fetchPlans();
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) {
        MotionToast.error(
          description: Text(
            'Failed to delete audit plan: '
            '${e.toString().replaceFirst('Exception: ', '')}',
          ),
        ).show(context);
      }
    }
  }

  Widget _buildStatusChip(String status) {
    final color = getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          getStatusIcon(status),
          const SizedBox(width: 6),
          Text(
            status,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;
    final paged = _paged;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildPageHeader(
              isMobile: isMobile,
              title: 'Audit Plan',
              totalCount: _inRange.length,
              itemLabel: 'plan',
              icon: Icons.event_note_outlined,
              actionButton: const SizedBox.shrink(),
            ),
            const SizedBox(height: 6),
            IqaPeriodFilter(
              range: _range,
              onChanged: _setRange,
              onClear: _clearFilters,
            ),
            const SizedBox(height: 6),
            IqaStatusTabs(
              tabs: IqaStatus.withDraft,
              selected: _selectedTab,
              countOf: _countFor,
              onSelected: _selectTab,
            ),
            const SizedBox(height: 10),
            Expanded(
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
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 12,
                        ),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 40,
                              child: Text(
                                '#',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: kMuted,
                                ),
                              ),
                            ),
                            const Expanded(
                              flex: 2,
                              child: Text(
                                'Reference',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: kMuted,
                                ),
                              ),
                            ),
                            const Expanded(
                              flex: 3,
                              child: Text(
                                'Date Range',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: kMuted,
                                ),
                              ),
                            ),
                            const Expanded(
                              flex: 2,
                              child: Text(
                                'Status',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: kMuted,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 120,
                              child: Text(
                                'Actions',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: kMuted,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (!isMobile) const Divider(height: 1, color: kBorder),
                    Expanded(
                      child: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: primaryColor,
                              ),
                            )
                          : paged.isEmpty
                          ? Center(
                              child: Text(
                                'No audit plans found',
                                style: GoogleFonts.plusJakartaSans(
                                  color: kMuted,
                                ),
                              ),
                            )
                          : ListView.separated(
                              itemCount: paged.length,
                              separatorBuilder: (context, index) => Divider(
                                height: 1,
                                color: Colors.grey.withValues(alpha: 0.2),
                              ),
                              itemBuilder: (context, index) {
                                final plan = paged[index];
                                final rowNumber =
                                    (_currentPage - 1) * _pageSize + index + 1;
                                final dateRange =
                                    '${DateFormat('MMM d, yyyy').format(plan.startDate)} – '
                                    '${DateFormat('MMM d, yyyy').format(plan.endDate)}';

                                if (!isMobile) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 12,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 40,
                                          child: Text('$rowNumber'),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            iqaReference('Audit Plan', IqaPeriod.yearOf(plan.startDate)),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Text(dateRange),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            // FIX: was plan.planStatus (dead
                                            // field) — now the real status.
                                            child: _buildStatusChip(
                                              plan.effectiveStatusName,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 140,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                tooltip: 'View Approval History',
                                                padding: EdgeInsets.zero,
                                                constraints:
                                                    const BoxConstraints(
                                                  minWidth: 32,
                                                  minHeight: 32,
                                                ),
                                                icon: const Icon(
                                                  Icons.history,
                                                  size: 16,
                                                  color: Colors.blueGrey,
                                                ),
                                                onPressed: () =>
                                                    ApprovalHistoryDialog.show(
                                                  context,
                                                  title: 'Audit Plan',
                                                  history:
                                                      plan.approvalHistory,
                                                ),
                                              ),
                                              IconButton(
                                                tooltip: 'Edit',
                                                padding: EdgeInsets.zero,
                                                constraints:
                                                    const BoxConstraints(
                                                  minWidth: 36,
                                                  minHeight: 36,
                                                ),
                                                icon: const Icon(
                                                  Icons.edit_outlined,
                                                  size: 16,
                                                ),
                                                onPressed: () =>
                                                    _openForm(plan: plan),
                                              ),
                                              // IconButton(
                                              //   tooltip: 'PDF Preview',
                                              //   padding: EdgeInsets.zero,
                                              //   constraints:
                                              //       const BoxConstraints(
                                              //     minWidth: 36,
                                              //     minHeight: 36,
                                              //   ),
                                              //   icon: const Icon(
                                              //     Icons.picture_as_pdf_outlined,
                                              //     size: 16,
                                              //   ),
                                              //   onPressed: () =>
                                              //       openAuditPlanReportPreview(
                                              //     plan.id,
                                              //     context: context,
                                              //   ),
                                              // ),
                                              if (plan.effectiveStatusName ==
                                                  'Draft')
                                                IconButton(
                                                  tooltip: 'Delete',
                                                  padding: EdgeInsets.zero,
                                                  constraints:
                                                      const BoxConstraints(
                                                    minWidth: 36,
                                                    minHeight: 36,
                                                  ),
                                                  icon: const Icon(
                                                    Icons.delete_outline,
                                                    size: 16,
                                                    color: Colors.red,
                                                  ),
                                                  onPressed: () =>
                                                      _deletePlan(plan),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 4,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              iqaReference('Audit Plan', IqaPeriod.yearOf(plan.startDate)),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              dateRange,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            // FIX: was plan.planStatus (dead
                                            // field) — now the real status.
                                            _buildStatusChip(
                                              plan.effectiveStatusName,
                                            ),
                                          ],
                                        ),
                                      ),
                                      PopupMenuButton<String>(
                                        color: Theme.of(context).cardColor,
                                        icon: Icon(
                                          Icons.more_vert,
                                          color: Colors.grey.shade500,
                                        ),
                                        // onSelected: (value) {
                                        //   if (value == 'edit') {
                                        //     _openForm(plan: plan);
                                        //   }
                                        //   if (value == 'pdf') {
                                        //     openAuditPlanReportPreview(
                                        //       plan.id,
                                        //       context: context,
                                        //     );
                                        //   }
                                        // },
                                        itemBuilder: (_) => [
                                          const PopupMenuItem(
                                            value: 'edit',
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.edit_outlined,
                                                  size: 18,
                                                ),
                                                SizedBox(width: 8),
                                                Text('Edit'),
                                              ],
                                            ),
                                          ),
                                          const PopupMenuItem(
                                            value: 'pdf',
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.picture_as_pdf_outlined,
                                                  size: 18,
                                                ),
                                                SizedBox(width: 8),
                                                Text('PDF'),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
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
                            totalItems: _filtered.length,
                            itemsPerPage: _pageSize,
                          ),
                          PaginationControls(
                            currentPage: _currentPage,
                            totalItems: _filtered.length,
                            itemsPerPage: _pageSize,
                            isLoading: _isLoading,
                            onPageChanged: (page) =>
                                setState(() => _currentPage = page),
                          ),
                          const SizedBox(width: 60),
                        ],
                      ),
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
}