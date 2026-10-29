// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/ISO/IQA/audit_report/model/audit_report.dart';
import 'package:imis/ISO/IQA/audit_report/model/audit_report_clause_results.dart';
import 'package:imis/ISO/IQA/audit_report/pages/audit_report_page.dart';
import 'package:imis/ISO/IQA/audit_report/pages/audit_report_print_preview_page.dart';
import 'package:imis/ISO/IQA/audit_report/service/audit_report_service.dart';
import 'package:imis/ISO/IQA/iqa_signatory/model/iqa_signatory.dart';
import 'package:imis/ISO/IQA/widgets/approval_workflow_widgets.dart';
import 'package:imis/ISO/IQA/widgets/iqa_list_toolbar.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/constant/permissions.dart';
// import 'package:imis/utils/print_preview_util.dart';
import 'package:imis/utils/auth_util.dart';
import 'package:imis/utils/permission_service.dart';
import 'package:imis/widgets/common/build_page_header.dart';
import 'package:imis/widgets/common/pagination_controls.dart';
import 'package:imis/widgets/dialog/delete_dialog.dart';
import 'package:motion_toast/motion_toast.dart';

class AuditReportListPage extends StatefulWidget {
  const AuditReportListPage({super.key});

  @override
  State<AuditReportListPage> createState() => _AuditReportListPageState();
}

/// Approval state of one report, derived from its IQA signatory chain.
/// The AuditReportDto carries no status field, so the chain is the only
/// source of truth — same derivation AuditPlan uses.
class _ReportApproval {
  const _ReportApproval({
    required this.isDraft,
    required this.signatories,
    required this.isFullyApproved,
  });

  final bool isDraft;
  final List<IQASignatory> signatories;

  /// True only once every signatory in the chain has approved and none has
  /// disapproved.
  final bool isFullyApproved;

  bool get isDisapproved =>
      signatories.any((s) => s.approvalStatus == 'Disapproved');

  String get statusName {
    if (isDraft) return 'Draft';
    if (isDisapproved) return 'Disapproved';
    if (isFullyApproved) return 'Approved';
    return 'Pending';
  }

  Color get statusColor {
    switch (statusName) {
      case 'Approved':
        return Colors.green;
      case 'Disapproved':
        return Colors.redAccent;
      case 'Pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}

class _AuditReportListPageState extends State<AuditReportListPage> {
  final _service = AuditReportService(Dio());

  List<AuditReport> _allReports = [];
  final Map<int, _ReportApproval> _approvalByReportId = {};

  /// Checklist figures per audit schedule: conforming / non-conforming clauses
  /// and the NCARs the non-conforming ones raised.
  Map<int, AuditReportFindingsSummary> _findingsBySchedule = {};
  String _selectedTab = IqaStatus.all;
  DateTimeRange _range = IqaPeriod.currentYear();
  int _currentPage = 1;
  final int _pageSize = 15;
  bool _isLoading = false;
  bool _isAdmin = false;
  final Set<int> _busyReportIds = {};

  // The workflow buttons follow the permissions switched on for the user in
  // Settings > User Roles (the same switches the PGS screens use).
  bool _can(String permission) =>
      _isAdmin || permissionService.hasPermission(permission);
  bool get _canSubmit => _can(AppPermissions.auditReportSubmit);
  bool get _canApprove => _can(AppPermissions.auditReportApprove);
  bool get _canReject => _can(AppPermissions.auditReportReject);
  bool get _canNote => _can(AppPermissions.auditReportNote);

  @override
  void initState() {
    super.initState();
    _fetchReports();
    AuthUtil.isCurrentUserAdmin().then((val) {
      if (mounted) setState(() => _isAdmin = val);
    });
  }

  /// [silent] refreshes the list in the background without swapping the rows
  /// for a loading spinner.
  Future<void> _fetchReports({bool silent = false}) async {
    if (!silent) setState(() => _isLoading = true);
    try {
      // Reports are raised by the audit checklist. Anything saved before that
      // was automatic is raised here first, so the list below is complete.
      await _service.syncFromChecklists();

      // Requested together with the reports so the round trips overlap.
      final chainsFuture = _loadSignatoryChains();
      final findingsFuture = _service.getFindingsSummaries();
      final data = await _service.getAllAuditReports();
      final findings = await findingsFuture;
      if (mounted) {
        setState(() {
          _allReports = data;
          _findingsBySchedule = findings;
          _isLoading = false;
        });
      }
      _applyApprovals(data, await chainsFuture ?? {});
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) {
        MotionToast.error(
          description: Text(
            'Failed to load audit reports: '
            '${e.toString().replaceFirst('Exception: ', '')}',
          ),
        ).show(context);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Fetches every report's signatory chain in a single request (not one per
  /// report, which made the list load time scale with the record count).
  /// Returns null when the lookup fails, so callers decide what to show.
  Future<Map<int, List<IQASignatory>>?> _loadSignatoryChains() async {
    final chainByReportId = <int, List<IQASignatory>>{};
    try {
      for (final s in await _service.getAllSignatories()) {
        if (s.id > 0) chainByReportId.putIfAbsent(s.auditEntityId, () => []).add(s);
      }
    } catch (e) {
      debugPrint('Failed to load report signatories: $e');
      return null;
    }
    return chainByReportId;
  }

  /// After a workflow action only the approval chains change, so just those
  /// are re-read (one small request) instead of the whole report list. A failed
  /// lookup keeps what is on screen.
  Future<void> _refreshApprovals() async {
    final chains = await _loadSignatoryChains();
    if (chains == null) return;
    _applyApprovals(_allReports, chains);
  }

  /// Shows "Pending" the moment a submit succeeds, before the chain is re-read.
  void _markPending(int reportId) {
    if (!mounted) return;
    setState(() {
      _approvalByReportId[reportId] = const _ReportApproval(
        isDraft: false,
        signatories: [],
        isFullyApproved: false,
      );
    });
  }

  void _applyApprovals(
    List<AuditReport> reports,
    Map<int, List<IQASignatory>> chainByReportId,
  ) {
    if (!mounted) return;
    setState(() {
      _approvalByReportId
        ..clear()
        ..addEntries(
          reports.map((report) {
            final active = chainByReportId[report.id] ?? <IQASignatory>[];
            return MapEntry<int, _ReportApproval>(
              report.id,
              _ReportApproval(
                isDraft: active.isEmpty,
                signatories: active,
                isFullyApproved:
                    active.isNotEmpty &&
                    active.every((s) => s.approvalStatus == 'Approved'),
              ),
            );
          }),
        );
    });
  }

  /// Clears the recorded chain and submits again, so a disapproved report can
  /// be reworked and re-enter approval instead of being stuck for good.
  Future<void> _resetAndResubmit(AuditReport report) async {
    final user = await AuthUtil.fetchLoggedUser();
    final userId = user?.id;
    if (userId == null || userId.isEmpty) {
      _toastError('Unable to resolve the current user. Please sign in again.');
      return;
    }

    _setBusy(report.id, true);
    try {
      await _service.resetApprovalChain(report.id);
      await _service.submitForApproval(report.id, userId);
      _toastSuccess('Approval chain reset. Submitted for approval.');
      _markPending(report.id);
    } catch (e) {
      _toastError('Resubmit failed: $e');
    } finally {
      if (mounted) {
        _setBusy(report.id, false);
        _refreshApprovals();
      }
    }
  }

  _ReportApproval _approvalFor(AuditReport report) =>
      _approvalByReportId[report.id] ??
      const _ReportApproval(
        isDraft: true,
        signatories: [],
        isFullyApproved: false,
      );

  // A report belongs to the year of its audit date; one with no audit date
  // cannot be placed on the timeline, so it is never hidden.
  List<AuditReport> get _inRange =>
      _allReports.where((r) => IqaPeriod.matches(_range, r.auditDate)).toList();

  String _tabOf(AuditReport report) =>
      IqaStatus.tabOf(_approvalFor(report).statusName);

  int _countFor(String tab) {
    if (tab == IqaStatus.all) return _inRange.length;
    return _inRange.where((r) => _tabOf(r) == tab).length;
  }

  List<AuditReport> get _filtered {
    if (_selectedTab == IqaStatus.all) return _inRange;
    return _inRange.where((r) => _tabOf(r) == _selectedTab).toList();
  }

  List<AuditReport> get _paged {
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

  Future<void> _openForm({required int reportId}) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AuditReportPage(reportId: reportId),
    );
    _fetchReports(silent: true);
  }

  String _reference(AuditReport report) =>
      iqaReference('Audit Report', report.auditDate?.year);

  String _displayOffice(AuditReport report) {
    if (report.officeAuditedName != null &&
        report.officeAuditedName!.trim().isNotEmpty) {
      return report.officeAuditedName!;
    }
    if (report.planOfficeProcess != null &&
        report.planOfficeProcess!.trim().isNotEmpty) {
      return report.planOfficeProcess!;
    }
    return '—';
  }

  String _displayAuditee(AuditReport report) {
    if (report.auditeeName != null && report.auditeeName!.trim().isNotEmpty) {
      return report.auditeeName!;
    }
    if (report.auditScope != null && report.auditScope!.isNotEmpty) {
      final names =
          report.auditScope!
              .map((s) => s.auditee.trim())
              .where((a) => a.isNotEmpty)
              .toList();
      if (names.isNotEmpty) return names.join(', ');
    }
    return '—';
  }

  void _showDeleteDialog(AuditReport report) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder:
          (ctx) => DeleteDialog(
            title: 'Audit Report',
            itemName:
                _displayOffice(report) != '—'
                    ? _displayOffice(report)
                    : 'this audit report',
            onDelete: () async {
              Navigator.pop(ctx);
              try {
                await _service.delete(report.id);
                await _fetchReports(silent: true);
                if (mounted) {
                  MotionToast.success(
                    description: Text(
                      'Deleted successfully',
                      style: GoogleFonts.plusJakartaSans(),
                    ),
                  ).show(context);
                }
              } catch (e) {
                if (mounted) {
                  MotionToast.error(
                    description: Text(
                      e.toString().replaceFirst('Exception: ', ''),
                    ),
                  ).show(context);
                }
              }
            },
          ),
    );
  }

  String _formatDate(AuditReport report) {
    final serverDate = report.auditDate;
    if (serverDate != null) {
      return '${serverDate.month}/${serverDate.day}/${serverDate.year}';
    }
    final time = report.auditPlanEntry?.time;
    if (time == null) return '—';
    return '${time.month}/${time.day}/${time.year}';
  }

  void _toastError(String message) {
    if (!mounted) return;
    MotionToast.error(
      description: Text(message.replaceFirst('Exception: ', '')),
    ).show(context);
  }

  void _toastSuccess(String message) {
    if (!mounted) return;
    MotionToast.success(
      description: Text(message, style: GoogleFonts.plusJakartaSans()),
    ).show(context);
  }

  void _setBusy(int reportId, bool busy) {
    setState(() {
      if (busy) {
        _busyReportIds.add(reportId);
      } else {
        _busyReportIds.remove(reportId);
      }
    });
  }

  /// Submits the report for approval, which creates one Pending signatory row
  /// per active AuditReport signatory template.
  Future<void> _submitForApproval(AuditReport report) async {
    final user = await AuthUtil.fetchLoggedUser();
    final userId = user?.id;
    if (userId == null || userId.isEmpty) {
      _toastError('Unable to resolve the current user. Please sign in again.');
      return;
    }

    _setBusy(report.id, true);
    try {
      await _service.submitForApproval(report.id, userId);
      _toastSuccess('Submitted for approval.');
      _markPending(report.id);
    } catch (e) {
      _toastError('Submit failed: $e');
    } finally {
      if (mounted) {
        _setBusy(report.id, false);
        _refreshApprovals();
      }
    }
  }

  /// Shows the chain and, when [signatory] is the one whose turn it is, offers
  /// the Approve / Disapprove actions.
  Future<void> _showApprovalDialog(AuditReport report) async {
    final approval = _approvalFor(report);

    await showDialog(
      context: context,
      builder: (ctx) {
        IQASignatory? next;
        for (final s in approval.signatories) {
          if (s.isPending) {
            next = s;
            break;
          }
        }

        return AlertDialog(
          title: const Text('Approval Status'),
          content: SizedBox(
            width: 460,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status: ${approval.statusName}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: approval.statusColor,
                  ),
                ),
                const SizedBox(height: 12),
                if (approval.signatories.isEmpty)
                  const Text(
                    'This report has not been submitted for approval yet.',
                  )
                else
                  ...approval.signatories.map(
                    (s) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 28,
                            child: Text('${s.orderLevel ?? '-'}'),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  s.signatoryLabel ?? s.signatoryName ?? '—',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  s.signatoryName ?? '',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _statusChip(s.approvalStatus),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Close'),
            ),
            if (approval.isDraft && _canSubmit)
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _submitForApproval(report);
                },
                child: const Text('Submit for Approval'),
              ),
            if (!approval.isDraft &&
                !approval.isFullyApproved &&
                !approval.isDisapproved &&
                (next != null || _isAdmin)) ...[
              if (_canReject)
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _recordAdminDecision(report, next, false);
                  },
                  child: const Text('Reject', style: TextStyle(color: Colors.redAccent)),
                ),
              // Noting is recorded as the signatory's approval of their step.
              if (_canApprove || _canNote)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700),
                  onPressed: () {
                    Navigator.pop(ctx);
                    _recordAdminDecision(report, next, true);
                  },
                  child: Text(
                    _canApprove ? 'Approve' : 'Note',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
            ],
            if (approval.isDisapproved && _canSubmit)
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _resetAndResubmit(report);
                },
                child: const Text('Reset & Resubmit'),
              ),
          ],
        );
      },
    );
  }

  Future<void> _recordAdminDecision(
    AuditReport report,
    IQASignatory? nextSignatory,
    bool approve,
  ) async {
    final user = await AuthUtil.fetchLoggedUser();
    final signatoryId = nextSignatory?.signatoryId ?? user?.id ?? '';

    if (!approve) {
      final reason = await RejectionDialog.show(
        context,
        title: 'Reject Audit Report',
        subtitle: 'Please provide the reason for rejecting Audit Report #${report.id}.',
      );
      if (reason == null) return;

      _setBusy(report.id, true);
      try {
        await _service.decide(
          reportId: report.id,
          signatoryId: signatoryId,
          approve: false,
          remarks: reason,
        );
        _toastSuccess('Audit Report rejected with reason.');
      } catch (e) {
        _toastError('Failed to reject report: $e');
      } finally {
        if (mounted) {
          _setBusy(report.id, false);
          _refreshApprovals();
        }
      }
      return;
    }

    _setBusy(report.id, true);
    try {
      await _service.decide(
        reportId: report.id,
        signatoryId: signatoryId,
        approve: true,
      );
      _toastSuccess('Audit Report approved.');
    } catch (e) {
      _toastError('Failed to approve report: $e');
    } finally {
      if (mounted) {
        _setBusy(report.id, false);
        _refreshApprovals();
      }
    }
  }

  Widget _statusChip(String? approvalStatus) {
    final label = approvalStatus ?? 'Pending';
    final color = switch (label) {
      'Approved' => Colors.green,
      'Disapproved' => Colors.redAccent,
      _ => Colors.orange,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(label, style: TextStyle(fontSize: 11, color: color)),
    );
  }

  /// What the audit checklist found: the non-conforming clauses with the NCARs
  /// already raised for them, or "All conforming" / "Checklist pending".
  Widget _findingsCell(AuditReport report) {
    final f = _findingsBySchedule[report.auditScheduleId];

    Widget chip(String text, Color color) => Container(
      margin: const EdgeInsets.only(right: 4, bottom: 2),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );

    if (f == null || f.totalCount == 0 || f.conformingCount + f.nonConformingCount == 0) {
      return chip('Checklist pending', Colors.grey.shade600);
    }
    if (f.nonConformingCount == 0) {
      return chip(
        f.pendingCount > 0
            ? '${f.conformingCount} conforming'
            : 'All conforming',
        Colors.green.shade700,
      );
    }
    return Wrap(
      children: [
        chip('${f.nonConformingCount} NC', Colors.red.shade700),
        chip('${f.ncarCount} NCAR', Colors.purple.shade700),
        if (f.conformingCount > 0)
          chip('${f.conformingCount} conforming', Colors.green.shade700),
      ],
    );
  }

  Widget _approvalBadge(AuditReport report) {
    final approval = _approvalFor(report);
    final busy = _busyReportIds.contains(report.id);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: busy ? null : () => _showApprovalDialog(report),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            child:
                busy
                    ? const SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                    : Text(
                      approval.statusName,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: approval.statusColor,
                      ),
                    ),
          ),
        ),
      ],
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
              title: 'Audit Report',
              totalCount: _inRange.length,
              itemLabel: 'report',
              icon: Icons.fact_check_outlined,
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
                                'Office Audited',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: kMuted,
                                ),
                              ),
                            ),
                            const Expanded(
                              flex: 2,
                              child: Text(
                                'Auditee',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: kMuted,
                                ),
                              ),
                            ),
                            const Expanded(
                              flex: 3,
                              child: Text(
                                'Purpose',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: kMuted,
                                ),
                              ),
                            ),
                            const Expanded(
                              flex: 2,
                              child: Text(
                                'Date of Audit',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: kMuted,
                                ),
                              ),
                            ),
                            const Expanded(
                              flex: 2,
                              child: Text(
                                'Findings',
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
                      child:
                          _isLoading
                              ? const Center(
                                child: CircularProgressIndicator(
                                  color: primaryColor,
                                ),
                              )
                              : paged.isEmpty
                              ? Center(
                                child: Text(
                                  'No audit reports yet. A report appears here '
                                  'automatically once an audit checklist is saved.',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: kMuted,
                                  ),
                                ),
                              )
                              : ListView.separated(
                                itemCount: paged.length,
                                separatorBuilder:
                                    (context, index) => Divider(
                                      height: 1,
                                      color: Colors.grey.withValues(alpha: 0.2),
                                    ),
                                itemBuilder: (context, index) {
                                  final report = paged[index];
                                  final rowNumber =
                                      (_currentPage - 1) * _pageSize +
                                      index +
                                      1;

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
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  _displayOffice(report),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  _reference(report),
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    color: kMuted,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              _displayAuditee(report),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              report.auditPurpose.isNotEmpty
                                                  ? report.auditPurpose
                                                  : '—',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(_formatDate(report)),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: _findingsCell(report),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: _approvalBadge(report),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 120,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.edit_outlined,
                                                    size: 16,
                                                  ),
                                                  onPressed:
                                                      () => _openForm(
                                                        reportId: report.id,
                                                      ),
                                                ),
                                                IconButton(
                                                  tooltip: 'Print Preview',
                                                  icon: const Icon(
                                                    Icons.print_outlined,
                                                    size: 16,
                                                  ),
                                                  onPressed:
                                                      () =>
                                                          openAuditReportPrintPreview(
                                                            context,
                                                            report.id,
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
                                                      () => _showDeleteDialog(
                                                        report,
                                                      ),
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
                                                _displayOffice(report),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
Text(                                                _reference(report),                                                style: const TextStyle(                                                  fontSize: 11,                                                  color: kMuted,                                                ),                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                _displayAuditee(report),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                _formatDate(report),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              _findingsCell(report),
                                              const SizedBox(height: 4),
                                              _approvalBadge(report),
                                            ],
                                          ),
                                        ),
                                        PopupMenuButton<String>(
                                          color: Theme.of(context).cardColor,
                                          icon: Icon(
                                            Icons.more_vert,
                                            color: Colors.grey.shade500,
                                          ),
                                          onSelected: (value) {
                                            if (value == 'edit') {
                                              _openForm(reportId: report.id);
                                            }
                                            if (value == 'delete') {
                                              _showDeleteDialog(report);
                                            }
                                            if (value == 'approval') {
                                              _showApprovalDialog(report);
                                            }
                                            if (value == 'print') {
                                              openAuditReportPrintPreview(
                                                context,
                                                report.id,
                                              );
                                            }
                                          },
                                          itemBuilder:
                                              (_) => [
                                                const PopupMenuItem(
                                                  value: 'print',
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.print_outlined,
                                                        size: 18,
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text('Print Preview'),
                                                    ],
                                                  ),
                                                ),
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
                                                  value: 'approval',
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .how_to_reg_outlined,
                                                        size: 18,
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text('Approval Status'),
                                                    ],
                                                  ),
                                                ),
                                                const PopupMenuItem(
                                                  value: 'delete',
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        CupertinoIcons
                                                            .delete_simple,
                                                        color: Colors.redAccent,
                                                        size: 18,
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
                            onPageChanged:
                                (page) => setState(() => _currentPage = page),
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
