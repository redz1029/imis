// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/ISO/IQA/audit_schedules/pages/audit_schedules_page.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:imis/ISO/IQA/audit_schedules/models/audit_schedules.dart';
import 'package:imis/ISO/IQA/audit_schedules/models/reschedule_request.dart';
import 'package:imis/ISO/IQA/audit_schedules/services/audit_schedule_service.dart';
import 'package:imis/ISO/IQA/iqa_signatory/model/iqa_approval_history.dart';
import 'package:imis/ISO/IQA/iqa_signatory/services/iqa_signatory_service.dart';
import 'package:imis/ISO/IQA/widgets/approval_workflow_widgets.dart';
import 'package:imis/ISO/IQA/widgets/iqa_list_toolbar.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/constant/permissions.dart';
import 'package:imis/utils/auth_util.dart';
import 'package:imis/utils/permission_service.dart';
import 'package:imis/widgets/common/build_page_header.dart';
import 'package:imis/widgets/common/pagination_controls.dart';

class AuditScheduleListPage extends StatefulWidget {
  const AuditScheduleListPage({super.key});

  @override
  State<AuditScheduleListPage> createState() => _AuditScheduleListPageState();
}

class _AuditScheduleListPageState extends State<AuditScheduleListPage> {
  final _service = AuditSchedulesService(Dio());

  List<AuditSchedules> _allSchedules = [];
  Map<int, RescheduleRequest> _openRequests = const {};
  String _selectedTab = IqaStatus.all;
  DateTimeRange _range = IqaPeriod.currentYear();
  int _currentPage = 1;
  final int _pageSize = 15;
  bool _isLoading = false;

  bool _isAdmin = false;
  Set<int> _myTeamIds = {};

  @override
  void initState() {
    super.initState();
    AuthUtil.isCurrentUserAdmin().then((admin) {
      if (mounted) setState(() => _isAdmin = admin);
    });
    _service.getMyLedTeamIds().then((ids) {
      if (mounted) setState(() => _myTeamIds = ids);
    });
    _fetchSchedules();
  }

  /// [silent] refreshes in the background without swapping the rows for a
  /// loading spinner.
  Future<void> _fetchSchedules({bool silent = false}) async {
    if (!silent) setState(() => _isLoading = true);
    try {
      // Requested together with the schedules so the round trips overlap.
      final requestsFuture = _loadOpenRequests();
      final data = await _service.getAuditSchedules();
      final requests = await requestsFuture;
      if (mounted) {
        setState(() {
          _allSchedules = data;
          _openRequests = requests;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) {
        MotionToast.error(
          description: Text(
            'Failed to load audit schedules: '
            '${e.toString().replaceFirst('Exception: ', '')}',
          ),
        ).show(context);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Open reschedule requests by schedule id. A failed lookup only hides the
  /// badges — the list itself must still load.
  Future<Map<int, RescheduleRequest>> _loadOpenRequests() async {
    try {
      final requests = await _service.getOpenRescheduleRequests();
      return {for (final r in requests) r.auditScheduleId: r};
    } catch (e) {
      debugPrint('Failed to load open reschedule requests: $e');
      return const {};
    }
  }

  /// Schedules are ordered by their audit plan, then by their start date, so
  /// the list reads like the printed schedule.
  List<AuditSchedules> get _sortedSchedules {
    final list = [..._allSchedules];
    list.sort((a, b) {
      final planCompare = a.auditPlanId.compareTo(b.auditPlanId);
      if (planCompare != 0) return planCompare;
      final startCompare = a.startDate.compareTo(b.startDate);
      if (startCompare != 0) return startCompare;
      return (a.officeName ?? '').compareTo(b.officeName ?? '');
    });
    return list;
  }

  // A schedule covers its start..end dates; the status tabs count what is
  // inside the selected period.
  List<AuditSchedules> get _inRange =>
      _sortedSchedules
          .where((s) => IqaPeriod.matches(_range, s.startDate, s.endDate))
          .toList();

  /// One row per audit plan: an audit plan of 2026 has one "Audit Schedule
  /// 2026" holding the schedule of every office it audits. The rows keep the
  /// order of the plans.
  List<_PlanGroup> get _groups {
    final byPlan = <int, List<AuditSchedules>>{};
    for (final s in _inRange) {
      byPlan.putIfAbsent(s.auditPlanId, () => <AuditSchedules>[]).add(s);
    }
    return [
      for (final e in byPlan.entries) _PlanGroup(e.key, e.value),
    ];
  }

  int _countFor(String tab) {
    final groups = _groups;
    if (tab == IqaStatus.all) return groups.length;
    return groups.where((g) => g.status == tab).length;
  }

  List<_PlanGroup> get _filtered {
    final groups = _groups;
    if (_selectedTab == IqaStatus.all) return groups;
    return groups.where((g) => g.status == _selectedTab).toList();
  }

  List<_PlanGroup> get _paged {
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

  /// A schedule created from an approved plan has no approval chain until the
  /// Auditor Team Leader of its team submits it. A team leader sees every
  /// schedule but is offered Submit only on the ones of the team they lead.
  bool _canSubmit(AuditSchedules schedule) =>
      schedule.signatories.isEmpty &&
      // Only the Auditor Team Leader of the schedule's team submits: an
      // Administrator has no submit right.
      !_isAdmin &&
      permissionService.hasPermission(AppPermissions.auditScheduleSubmit) &&
      schedule.teamId != null &&
      _myTeamIds.contains(schedule.teamId);

  /// The schedules of the plan the signed-in user may submit.
  List<AuditSchedules> _submittable(_PlanGroup group) =>
      group.schedules.where(_canSubmit).toList();

  /// The trail of every office's schedule in the plan, oldest first: who
  /// submitted it and who confirmed or rejected it, with the office on each line.
  void _showHistory(_PlanGroup group) {
    ApprovalHistoryDialog.showLoaded(
      context,
      title: 'Audit Schedule',
      heading: 'Approval History',
      load: () async {
        final signatories = IQASignatoryService(Dio());
        final lists = await Future.wait([
          for (final s in group.schedules) signatories.getHistory('AuditSchedule', s.id),
        ]);
        final all = <IQAApprovalHistory>[for (final l in lists) ...l]
          ..sort((a, b) => a.actionDate.compareTo(b.actionDate));
        return all;
      },
    );
  }

  Widget _submitButton(_PlanGroup group) {
    final count = _submittable(group).length;
    return IconButton(
      tooltip: count > 1
          ? 'Submit your $count schedules for confirmation'
          : 'Submit for confirmation',
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
      icon: Icon(Icons.send_rounded, size: 16, color: primaryColor),
      onPressed: _isLoading ? null : () => _submitGroup(group),
    );
  }

  Future<void> _submitGroup(_PlanGroup group) async {
    try {
      final user = await AuthUtil.fetchLoggedUser();
      for (final schedule in _submittable(group)) {
        await _service.submitAuditSchedule(schedule.id, userId: user?.id);
      }
      if (!mounted) return;
      MotionToast.success(
        description: const Text('Submitted for confirmation'),
      ).show(context);
      await _fetchSchedules(silent: true);
    } catch (e) {
      if (!mounted) return;
      MotionToast.error(
        description: Text(e.toString().replaceFirst('Exception: ', '')),
      ).show(context);
    }
  }

  /// Opens the read-only schedule viewer for the plan the schedule belongs
  /// to, in a modal dialog — same navigation style as
  /// AuditPlanListPage._openForm.
  Future<void> _openSchedule(_PlanGroup group) async {
    if (group.planId <= 0) return;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AuditSchedulePage(auditPlanId: group.planId),
    );
    // A confirmation, rejection or reschedule decision may have been made in
    // the dialog; bring the rows and badges up to date without a spinner.
    if (mounted) _fetchSchedules(silent: true);
  }

  /// "Reschedule: awaiting Team Leader / Lead Auditor" under the status, for a
  /// schedule that has an open reschedule request.
  Widget _rescheduleBadge(_PlanGroup group) {
    final requests = [
      for (final s in group.schedules)
        if (_openRequests[s.id] != null) _openRequests[s.id]!,
    ];
    if (requests.isEmpty) return const SizedBox.shrink();
    final request = requests.first;
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Tooltip(
        message: requests.length > 1
            ? '${requests.length} reschedule requests are open'
            : 'Requested ${DateFormat('MMM d, yyyy h:mm a').format(request.proposedStartDate)}'
                '${(request.reason ?? '').isNotEmpty ? ' — ${request.reason}' : ''}',
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.orange.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.event_repeat, size: 12, color: Colors.orange.shade800),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  requests.length > 1
                      ? 'Reschedule: ${requests.length} requests open'
                      : request.badgeLabel,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.orange.shade800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    // The workflow names a pending chain "Pending Approval" / "Pending Confirmation";
    // colour and icon follow the tab it belongs to so none falls back to grey.
    final tone = IqaStatus.tabOf(status);
    final color = getStatusColor(tone);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          getStatusIcon(tone),
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
              title: 'Audit Schedule',
              totalCount: _groups.length,
              itemLabel: 'audit schedule',
              icon: Icons.calendar_month_outlined,
              actionButton: ElevatedButton.icon(
                onPressed: _isLoading ? null : _fetchSchedules,
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
                icon: const Icon(Icons.refresh, color: Colors.white),
                label: const Text(
                  'Refresh',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 6),
            IqaPeriodFilter(
              range: _range,
              onChanged: _setRange,
              onClear: _clearFilters,
            ),
            const SizedBox(height: 6),
            IqaStatusTabs(
              tabs: IqaStatus.schedule,
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
                                'Offices',
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
                              width: 100,
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
                                'No audit schedules found',
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
                                final group = paged[index];
                                final rowNumber =
                                    (_currentPage - 1) * _pageSize + index + 1;
                                final dateRange =
                                    group.start == group.end
                                    ? DateFormat('MMM d, yyyy').format(group.start)
                                    : '${DateFormat('MMM d, yyyy').format(group.start)} – '
                                        '${DateFormat('MMM d, yyyy').format(group.end)}';
                                final officeName = group.officesLabel;

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
                                            officeName,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            iqaReference('Audit Schedule', group.start.year),
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
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                _buildStatusChip(group.status),
                                                if (group.progress != null)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          top: 4,
                                                        ),
                                                    child: Text(
                                                      group.progress!,
                                                      style: const TextStyle(
                                                        fontSize: 11,
                                                        color: kMuted,
                                                      ),
                                                    ),
                                                  ),
                                                _rescheduleBadge(group),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: _submittable(group).isNotEmpty ? 140 : 100,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              if (_submittable(group).isNotEmpty)
                                                _submitButton(group),
                                              IconButton(
                                                tooltip: 'History',
                                                padding: EdgeInsets.zero,
                                                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                                                icon: const Icon(Icons.history, size: 16),
                                                onPressed: () => _showHistory(group),
                                              ),
                                              IconButton(
                                                tooltip: 'View Schedule',
                                                padding: EdgeInsets.zero,
                                                constraints:
                                                    const BoxConstraints(
                                                  minWidth: 36,
                                                  minHeight: 36,
                                                ),
                                                icon: const Icon(
                                                  Icons.visibility_outlined,
                                                  size: 16,
                                                ),
                                                onPressed: () =>
                                                    _openSchedule(group),
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
                                              officeName,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              iqaReference('Audit Schedule', group.start.year),
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                            Text(
                                              dateRange,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            _buildStatusChip(group.status),
                                            if (group.progress != null)
                                              Text(
                                                group.progress!,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                            _rescheduleBadge(group),
                                          ],
                                        ),
                                      ),
                                      if (_submittable(group).isNotEmpty)
                                        _submitButton(group),
                                      IconButton(
                                        tooltip: 'History',
                                        icon: Icon(Icons.history, color: Colors.grey.shade500),
                                        onPressed: () => _showHistory(group),
                                      ),
                                      IconButton(
                                        tooltip: 'View Schedule',
                                        icon: Icon(
                                          Icons.visibility_outlined,
                                          color: Colors.grey.shade500,
                                        ),
                                        onPressed: () => _openSchedule(group),
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

/// The schedules of one audit plan: what a row of the list stands for.
class _PlanGroup {
  _PlanGroup(this.planId, this.schedules);

  final int planId;
  final List<AuditSchedules> schedules;

  DateTime get start => schedules
      .map((s) => s.startDate)
      .reduce((a, b) => a.isBefore(b) ? a : b);

  DateTime get end =>
      schedules.map((s) => s.endDate).reduce((a, b) => a.isAfter(b) ? a : b);

  int get _confirmed =>
      schedules.where((s) => s.effectiveStatusName == 'Confirmed').length;

  /// The status of the whole plan: it is Confirmed only when every office's
  /// schedule is; a schedule that needs revision or was rejected shows first.
  String get status {
    bool any(String name) =>
        schedules.any((s) => s.effectiveStatusName == name);
    if (any('Revision Required')) return 'Revision Required';
    if (any('Rejected')) return 'Rejected';
    if (_confirmed == schedules.length) return 'Confirmed';
    return 'Pending Confirmation';
  }

  /// "1 of 2 confirmed" while a plan with several schedules is half way.
  String? get progress => schedules.length > 1 && status != 'Confirmed'
      ? '$_confirmed of ${schedules.length} confirmed'
      : null;

  /// The offices the plan audits ("A, B +1 more").
  String get officesLabel {
    final names = <String>[];
    for (final s in schedules) {
      final name = s.officeName?.trim() ?? '';
      if (name.isNotEmpty && !names.contains(name)) names.add(name);
    }
    if (names.isEmpty) return 'Unspecified Office';
    if (names.length <= 2) return names.join(', ');
    return '${names.take(2).join(', ')} +${names.length - 2} more';
  }
}
