// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:imis/ISO/IQA/audit_checklist/models/audit_checklist.dart';
import 'package:imis/ISO/IQA/audit_checklist/services/audit_checklist_service.dart';
import 'package:imis/ISO/IQA/audit_plan/models/audit_plan.dart';
import 'package:imis/ISO/IQA/audit_plan/services/AuditPlanService.dart';
import 'package:imis/ISO/IQA/audit_programme/models/audit_programme.dart';
import 'package:imis/ISO/IQA/audit_programme/services/audit_programme_service.dart';
import 'package:imis/ISO/IQA/audit_report/model/audit_report.dart';
import 'package:imis/ISO/IQA/audit_report/model/audit_report_clause_results.dart';
import 'package:imis/ISO/IQA/audit_report/pages/audit_report_print_preview_page.dart';
import 'package:imis/ISO/IQA/audit_report/service/audit_report_service.dart';
import 'package:imis/ISO/IQA/audit_schedules/models/audit_schedules.dart';
import 'package:imis/ISO/IQA/audit_schedules/services/audit_schedule_service.dart';
import 'package:imis/ISO/IQA/iqa_signatory/model/iqa_signatory.dart';
import 'package:imis/ISO/IQA/ncar/models/nonconforming_action_report.dart';
import 'package:imis/ISO/IQA/ncar/pages/ncar_print_preview_page.dart';
import 'package:imis/ISO/IQA/ncar/services/ncar_service.dart';
import 'package:imis/ISO/IQA/widgets/iqa_list_toolbar.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/widgets/common/build_page_header.dart';

// =============================================================================
// IQA History
//
// One record per audit cycle: an Audit Programme with everything that came out
// of it — its Audit Plan, each Audit Schedule, the Audit Checklist, the Audit
// Report and the NCARs raised — and where each of those stands. Read-only: it
// only gathers what the other IQA screens already hold.
// =============================================================================

const String _kInProgress = 'In Progress';
const String _kCompleted = 'Completed';
const List<String> _kTabs = [IqaStatus.all, _kInProgress, _kCompleted];

/// Approval state of a report, from its signatory chain (the report carries no
/// status field of its own).
String _chainStatus(List<IQASignatory> chain) {
  if (chain.isEmpty) return 'Draft';
  if (chain.any((s) => s.approvalStatus == 'Disapproved')) return 'Disapproved';
  if (chain.every((s) => s.approvalStatus == 'Approved')) return 'Approved';
  return 'Pending';
}

bool _isApproved(String? status) =>
    const {'Approved', 'Confirmed'}.contains((status ?? '').trim());

/// One schedule and everything downstream of it.
class _ScheduleHistory {
  const _ScheduleHistory({
    required this.schedule,
    required this.office,
    this.checklist,
    this.report,
    this.reportStatus,
    this.findings,
    this.ncars = const [],
  });

  final AuditSchedules schedule;
  final String office;
  final AuditChecklistSummary? checklist;
  final AuditReport? report;
  final String? reportStatus;
  final AuditReportFindingsSummary? findings;
  final List<NonconformingActionReport> ncars;

  bool get complete =>
      _isApproved(schedule.effectiveStatusName) &&
      reportStatus == 'Approved' &&
      ncars.every((n) => n.isClosed);
}

class _PlanHistory {
  const _PlanHistory({required this.plan, required this.schedules});

  final AuditPlan plan;
  final List<_ScheduleHistory> schedules;
}

class _AuditHistory {
  const _AuditHistory({required this.programme, required this.plans});

  final AuditProgramme programme;
  final List<_PlanHistory> plans;

  Iterable<_ScheduleHistory> get schedules => plans.expand((p) => p.schedules);

  int get ncarCount => schedules.fold(0, (n, s) => n + s.ncars.length);
  int get ncarClosed =>
      schedules.fold(0, (n, s) => n + s.ncars.where((c) => c.isClosed).length);

  /// Finished once the programme and plan are approved and every schedule has
  /// an approved report with all of its NCARs closed.
  bool get complete =>
      _isApproved(programme.statusName) &&
      plans.isNotEmpty &&
      plans.every((p) => _isApproved(p.plan.statusName)) &&
      schedules.isNotEmpty &&
      schedules.every((s) => s.complete);
}

class IqaHistoryPage extends StatefulWidget {
  const IqaHistoryPage({super.key});

  @override
  State<IqaHistoryPage> createState() => _IqaHistoryPageState();
}

class _IqaHistoryPageState extends State<IqaHistoryPage> {
  List<_AuditHistory> _audits = [];
  bool _loading = true;
  String? _error;
  String _tab = IqaStatus.all;
  DateTimeRange _range = IqaPeriod.currentYear();

  @override
  void initState() {
    super.initState();
    _load();
  }

  /// A lookup that fails leaves its stage blank instead of hiding the history.
  Future<T> _tolerate<T>(Future<T> Function() load, T fallback, String what) async {
    try {
      return await load();
    } catch (e) {
      debugPrint('IQA history: could not load $what: $e');
      return fallback;
    }
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final dio = Dio();
      final reportService = AuditReportService(dio);

      final results = await Future.wait<Object>([
        AuditProgrammeService(dio).getAllAuditProgrammes(),
        _tolerate(
          () => AuditPlanService(dio).getAllAuditPlans(),
          <AuditPlan>[],
          'audit plans',
        ),
        _tolerate(
          () => AuditSchedulesService(dio).getAuditSchedules(),
          <AuditSchedules>[],
          'audit schedules',
        ),
        _tolerate(
          () => AuditChecklistService(dio).getSchedulesWithChecklistData(),
          <AuditChecklistSummary>[],
          'audit checklists',
        ),
        _tolerate(
          () => reportService.getAllAuditReports(),
          <AuditReport>[],
          'audit reports',
        ),
        _tolerate(
          () => reportService.getAllSignatories(),
          <IQASignatory>[],
          'report approvals',
        ),
        _tolerate(
          () => reportService.getFindingsSummaries(),
          <int, AuditReportFindingsSummary>{},
          'report findings',
        ),
        _tolerate(
          () => NcarService(dio).getAllNcars(pageSize: 1000),
          <NonconformingActionReport>[],
          'NCARs',
        ),
      ]);

      final audits = _assemble(
        programmes: results[0] as List<AuditProgramme>,
        plans: results[1] as List<AuditPlan>,
        schedules: results[2] as List<AuditSchedules>,
        checklists: results[3] as List<AuditChecklistSummary>,
        reports: results[4] as List<AuditReport>,
        signatories: results[5] as List<IQASignatory>,
        findings: results[6] as Map<int, AuditReportFindingsSummary>,
        ncars: results[7] as List<NonconformingActionReport>,
      );
      if (mounted) setState(() => _audits = audits);
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  List<_AuditHistory> _assemble({
    required List<AuditProgramme> programmes,
    required List<AuditPlan> plans,
    required List<AuditSchedules> schedules,
    required List<AuditChecklistSummary> checklists,
    required List<AuditReport> reports,
    required List<IQASignatory> signatories,
    required Map<int, AuditReportFindingsSummary> findings,
    required List<NonconformingActionReport> ncars,
  }) {
    final chainByReport = <int, List<IQASignatory>>{};
    for (final s in signatories) {
      if (s.id > 0) chainByReport.putIfAbsent(s.auditEntityId, () => []).add(s);
    }

    final checklistBySchedule = {for (final c in checklists) c.auditScheduleId: c};
    final reportBySchedule = <int, AuditReport>{};
    for (final r in reports) {
      reportBySchedule.putIfAbsent(r.auditScheduleId, () => r);
    }

    final ncarsByReport = <int, List<NonconformingActionReport>>{};
    for (final n in ncars) {
      final reportId = n.auditReportId;
      if (reportId != null) ncarsByReport.putIfAbsent(reportId, () => []).add(n);
    }

    _ScheduleHistory scheduleHistory(AuditSchedules s) {
      final checklist = checklistBySchedule[s.id];
      final report = reportBySchedule[s.id];
      final office = (s.officeName ?? '').trim().isNotEmpty
          ? s.officeName!.trim()
          : (checklist?.officeProcess ?? '').trim();
      return _ScheduleHistory(
        schedule: s,
        office: office,
        checklist: checklist,
        report: report,
        reportStatus:
            report == null ? null : _chainStatus(chainByReport[report.id] ?? []),
        findings: findings[s.id],
        ncars: report == null ? const [] : (ncarsByReport[report.id] ?? const []),
      );
    }

    final plansByProgramme = <int, List<AuditPlan>>{};
    for (final p in plans) {
      if (!p.isDeleted) {
        plansByProgramme.putIfAbsent(p.auditProgrammeId, () => []).add(p);
      }
    }
    final schedulesByPlan = <int, List<AuditSchedules>>{};
    for (final s in schedules) {
      schedulesByPlan.putIfAbsent(s.auditPlanId, () => []).add(s);
    }

    final audits = [
      for (final programme in programmes)
        if (!programme.isDeleted)
          _AuditHistory(
            programme: programme,
            plans: [
              for (final plan in plansByProgramme[programme.id] ?? <AuditPlan>[])
                _PlanHistory(
                  plan: plan,
                  schedules: [
                    for (final s in (schedulesByPlan[plan.id] ?? <AuditSchedules>[])
                      ..sort((a, b) => a.startDate.compareTo(b.startDate)))
                      scheduleHistory(s),
                  ],
                ),
            ],
          ),
    ]..sort((a, b) => b.programme.year.compareTo(a.programme.year));

    return audits;
  }

  // --------------------------------------------------------------- filters --
  List<_AuditHistory> get _inRange => _audits
      .where(
        (a) =>
            a.programme.year >= _range.start.year &&
            a.programme.year <= _range.end.year,
      )
      .toList();

  int _countFor(String tab) {
    switch (tab) {
      case _kCompleted:
        return _inRange.where((a) => a.complete).length;
      case _kInProgress:
        return _inRange.where((a) => !a.complete).length;
      default:
        return _inRange.length;
    }
  }

  List<_AuditHistory> get _visible {
    switch (_tab) {
      case _kCompleted:
        return _inRange.where((a) => a.complete).toList();
      case _kInProgress:
        return _inRange.where((a) => !a.complete).toList();
      default:
        return _inRange;
    }
  }

  // ----------------------------------------------------------------- build --
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final audits = _visible;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildPageHeader(
              isMobile: isMobile,
              title: 'IQA History',
              totalCount: _inRange.length,
              itemLabel: 'audit',
              icon: Icons.history_rounded,
            ),
            const SizedBox(height: 6),
            IqaPeriodFilter(
              range: _range,
              onChanged: (r) => setState(() => _range = r),
              onClear: () => setState(() {
                _range = IqaPeriod.currentYear();
                _tab = IqaStatus.all;
              }),
            ),
            const SizedBox(height: 6),
            IqaStatusTabs(
              tabs: _kTabs,
              selected: _tab,
              countOf: _countFor,
              onSelected: (t) => setState(() => _tab = t),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _loading
                  ? const Center(
                      child: CircularProgressIndicator(color: primaryColor),
                    )
                  : _error != null
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _error!,
                                style: const TextStyle(color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                ),
                                onPressed: _load,
                                child: const Text(
                                  'RETRY',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        )
                      : audits.isEmpty
                          ? const Center(child: Text('No audit history found.'))
                          : RefreshIndicator(
                              onRefresh: _load,
                              child: ListView.builder(
                                itemCount: audits.length,
                                itemBuilder: (_, i) => _AuditCard(audit: audits[i]),
                              ),
                            ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// Widgets
// =============================================================================

Color _statusColor(String? status) =>
    IqaStatus.colorOf(IqaStatus.tabOf(status));

class _Chip extends StatelessWidget {
  const _Chip(this.label, this.value, {this.color, this.onTap});

  final String label;
  final String value;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = color ?? Colors.grey.shade600;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: c.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: c.withValues(alpha: 0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$label: ',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: c,
              ),
            ),
            if (onTap != null) ...[
              const SizedBox(width: 4),
              Icon(Icons.print_outlined, size: 12, color: c),
            ],
          ],
        ),
      ),
    );
  }
}

class _AuditCard extends StatelessWidget {
  const _AuditCard({required this.audit});

  final _AuditHistory audit;

  @override
  Widget build(BuildContext context) {
    final p = audit.programme;
    final schedules = audit.schedules.toList();
    final reports = schedules.where((s) => s.report != null).toList();
    final reportsApproved = reports.where((s) => s.reportStatus == 'Approved').length;
    final done = audit.complete;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          title: Row(
            children: [
              Expanded(
                child: Text(
                  iqaReference('Audit Programme', p.year),
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: primaryColor,
                  ),
                ),
              ),
              Text(
                done ? _kCompleted : _kInProgress,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: done ? kSuccess : Colors.orange.shade800,
                ),
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                _Chip(
                  'Programme',
                  p.statusName ?? 'Draft',
                  color: _statusColor(p.statusName),
                ),
                _Chip(
                  'Plan',
                  audit.plans.isEmpty
                      ? 'None'
                      : audit.plans.first.plan.effectiveStatusName,
                  color: audit.plans.isEmpty
                      ? null
                      : _statusColor(audit.plans.first.plan.statusName),
                ),
                _Chip(
                  'Schedules',
                  '${schedules.where((s) => _isApproved(s.schedule.effectiveStatusName)).length}/${schedules.length} confirmed',
                ),
                _Chip(
                  'Checklists',
                  '${schedules.where((s) => s.checklist != null).length}/${schedules.length}',
                ),
                _Chip('Reports', '$reportsApproved/${reports.length} approved'),
                _Chip('NCARs', '${audit.ncarClosed}/${audit.ncarCount} closed'),
              ],
            ),
          ),
          children: [
            if (audit.plans.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'No audit plan has been made for this programme yet.',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ),
            for (final plan in audit.plans) _PlanSection(plan: plan),
          ],
        ),
      ),
    );
  }
}

class _PlanSection extends StatelessWidget {
  const _PlanSection({required this.plan});

  final _PlanHistory plan;

  @override
  Widget build(BuildContext context) {
    final p = plan.plan;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 20),
        Row(
          children: [
            const Icon(Icons.event_note_outlined, size: 16, color: primaryColor),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                p.planName.isEmpty ? 'Audit Plan' : p.planName,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
            ),
            _Chip('Status', p.effectiveStatusName, color: _statusColor(p.statusName)),
          ],
        ),
        const SizedBox(height: 8),
        if (plan.schedules.isEmpty)
          Text(
            'No audit schedule yet.',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        for (final s in plan.schedules) _ScheduleRow(history: s),
      ],
    );
  }
}

class _ScheduleRow extends StatelessWidget {
  const _ScheduleRow({required this.history});

  final _ScheduleHistory history;

  static final DateFormat _day = DateFormat('MMM d, yyyy');

  @override
  Widget build(BuildContext context) {
    final s = history.schedule;
    final report = history.report;
    final checklist = history.checklist;
    final findings = history.findings;
    final sameDay = DateUtils.isSameDay(s.startDate, s.endDate);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            history.office.isEmpty ? 'Audit Schedule #${s.id}' : history.office,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          ),
          const SizedBox(height: 2),
          Text(
            sameDay
                ? _day.format(s.startDate)
                : '${_day.format(s.startDate)} - ${_day.format(s.endDate)}',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _Chip(
                'Schedule',
                s.effectiveStatusName,
                color: _statusColor(s.effectiveStatusName),
              ),
              _Chip(
                'Checklist',
                checklist == null
                    ? 'Not started'
                    : '${checklist.clauseCount} clause(s)',
                color: checklist == null ? null : Colors.blue.shade600,
              ),
              if (report == null)
                const _Chip('Report', 'Not raised')
              else
                _Chip(
                  'Report',
                  history.reportStatus ?? 'Draft',
                  color: _statusColor(history.reportStatus),
                  onTap: () => openAuditReportPrintPreview(context, report.id),
                ),
              if (findings != null)
                _Chip(
                  'Findings',
                  findings.nonConformingCount == 0
                      ? (findings.pendingCount > 0 ? 'Checklist pending' : 'All conforming')
                      : '${findings.nonConformingCount} NC',
                  color: findings.nonConformingCount == 0
                      ? kSuccess
                      : Colors.red.shade400,
                ),
            ],
          ),
          if (history.ncars.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final n in history.ncars)
                  _Chip(
                    n.referenceNumber.isNotEmpty
                        ? n.referenceNumber
                        : 'NCAR #${n.id}',
                    n.statusDisplay,
                    color: n.isClosed
                        ? kSuccess
                        : (n.approvedDate != null
                            ? Colors.blue.shade600
                            : Colors.orange.shade700),
                    onTap: () => openNcarPrintPreview(context, n.id),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
