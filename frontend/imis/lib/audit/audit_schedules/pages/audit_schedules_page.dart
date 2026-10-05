import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';

import 'package:imis/audit/audit_plan/models/audit_plan.dart';
import 'package:imis/audit/audit_plan/models/audit_plan_entry.dart';
import 'package:imis/audit/audit_plan/services/AuditPlanService.dart';
import 'package:imis/audit/audit_programme/services/audit_programme_service.dart';
import 'package:imis/audit/audit_schedules/models/audit_schedules.dart';
import 'package:imis/audit/audit_schedules/services/audit_schedule_service.dart';
import 'package:imis/audit/widgets/approval_workflow_widgets.dart';
import 'package:imis/audit/audit_plan/pages/audit_plan_page.dart'
    show IsoStandardDto, AuditorTeamDto;
import 'package:imis/common_services/common_service.dart';
import 'package:imis/user/models/user.dart';
import 'package:imis/user/models/user_registration.dart';
import 'package:imis/utils/auth_util.dart';
import 'package:imis/constant/constant.dart';

/// Fixed boilerplate shown in the ACTIVITY column for every entry — the
/// backend has no per-entry "activity" text field. Typed only, never
/// fetched from anywhere.
const String _kFixedActivityText =
    'Opening Activity\n'
    'Introduction of Auditors\n'
    'Audit Proper\n'
    '-Interview\n'
    '-Observation\n'
    '-Documented Information Review\n\n'
    'Closing Meeting\n'
    '-Audit findings';

const String _kFixedPurposeText = 'Internal Quality Audit';

/// One office/department's worth of entries, grouped out of a single Audit
/// Plan's entries by their auditPlanProcesses[0].processName.
class _OfficeGroup {
  final String officeName;
  final List<AuditPlanEntry> entries;
  AuditSchedules? schedule;

  _OfficeGroup({
    required this.officeName,
    required this.entries,
  });
}

class AuditSchedulePage extends StatefulWidget {
  final int? auditPlanId;

  // Kept for backward compatibility with existing navigation call sites.
  // No longer used now that this page is a read-only viewer.
  final int? auditScheduleId;

  const AuditSchedulePage({super.key, this.auditPlanId, this.auditScheduleId});

  @override
  State<AuditSchedulePage> createState() => _AuditSchedulePageState();
}

class _AuditSchedulePageState extends State<AuditSchedulePage> {
  static const Color primaryThemeColor = Color(0xFF883942);
  static const Color headerFillColor = Color(0xFFF3E9EA);

  final AuditPlanService _auditPlanService = AuditPlanService(Dio());
  final AuditProgrammeService _programmeService = AuditProgrammeService(Dio());
  final AuditSchedulesService _scheduleService = AuditSchedulesService(Dio());

  UserRegistration? _currentUser;
  bool _isAdmin = false;
  bool _isLoading = true;
  String? _errorMessage;

  // Step 0 state.
  int? _resolvedAuditPlanId;
  List<AuditPlan> _allAuditPlans = [];

  // Step 1/2 state.
  AuditPlan? _plan;
  List<_OfficeGroup> _officeGroups = [];
  _OfficeGroup? _selectedOffice;

  // Master data needed to resolve names/clauses that come back null on the
  // nested objects (isoAuditors[].team, isoStandardAuditPlans[].isoStandard).
  List<IsoStandardDto> _standards = [];
  List<AuditorTeamDto> _auditorRoster = [];

  @override
  void initState() {
    super.initState();
    _resolvedAuditPlanId = widget.auditPlanId;
    if (_resolvedAuditPlanId != null) {
      _loadAuditPlanList(selectAfterLoadId: _resolvedAuditPlanId);
    } else {
      _loadAuditPlanList();
    }
  }

  Future<void> _loadAuditPlanList({int? selectAfterLoadId}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      _allAuditPlans = await _auditPlanService.getAllAuditPlans();
      if (selectAfterLoadId != null) {
        final match = _allAuditPlans.where((p) => p.id == selectAfterLoadId);
        if (match.isNotEmpty) {
          await _loadPlanDetail(match.first);
          return;
        }
      }
    } catch (e) {
      _errorMessage = 'Failed to load Audit Plans: $e';
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loadPlanDetail(AuditPlan planSummary) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _selectedOffice = null;
      _plan = planSummary;
      _resolvedAuditPlanId = planSummary.id;
    });

    try {
      await Future.wait([
        _fetchMasterIsoStandards(),
        _fetchMasterAuditorRoster(),
      ]);

      // Fetch through the parent Audit Programme — the proven path that
      // already returns fully-populated entries (confirmed via the JSON
      // response reviewed in chat).
      final programme = await _programmeService.getAuditProgrammeById(
        planSummary.auditProgrammeId,
      );
      if (programme == null) {
        throw Exception('Parent Audit Programme not found');
      }

      final jsonMap = programme.toJson();
      final plansJson =
          (jsonMap['auditPlan'] as List? ??
              jsonMap['AuditPlans'] as List? ??
              []);
      final match = plansJson.cast<Map<String, dynamic>>().where(
        (p) => (p['id'] ?? p['Id']) == planSummary.id,
      );
      if (match.isEmpty) {
        throw Exception('Audit Plan not found within its Programme');
      }

      final entriesJson =
          (match.first['entries'] as List? ??
              match.first['Entries'] as List? ??
              []);
      final entries =
          entriesJson
              .map((e) => AuditPlanEntry.fromJson(e as Map<String, dynamic>))
              .toList();

      _officeGroups = _buildOfficeGroups(entries);

      _currentUser = await AuthUtil.fetchLoggedUser();
      _isAdmin = await AuthUtil.isCurrentUserAdmin();
      final schedules = await _scheduleService.getAuditSchedulesByPlanId(planSummary.id);

      for (final g in _officeGroups) {
        var matched = schedules.firstWhere(
          (s) => (s.officeName != null && s.officeName!.trim().toLowerCase() == g.officeName.trim().toLowerCase()) ||
                 g.entries.any((e) => e.id != 0 && s.auditPlanEntryId == e.id),
          orElse: () => AuditSchedules(startDate: DateTime(2000), endDate: DateTime(2000)),
        );
        if (matched.id > 0) {
          g.schedule = matched;
        } else {
          try {
            final firstEntry = g.entries.first;
            final created = await _scheduleService.addAuditSchedule(
              AuditSchedules(
                purpose: _kFixedPurposeText,
                activity: _kFixedActivityText,
                isActive: true,
                startDate: planSummary.startDate,
                endDate: planSummary.endDate,
                auditPlanId: planSummary.id,
                auditPlanEntryId: firstEntry.id,
              ),
            );
            if (created.id > 0) {
              await _scheduleService.submitAuditSchedule(created.id, userId: _currentUser?.id);
              final refreshed = await _scheduleService.getAuditScheduleById(created.id);
              g.schedule = refreshed ?? created;
            }
          } catch (e) {
            debugPrint('Auto-schedule creation error: $e');
          }
        }
      }
    } catch (e) {
      _errorMessage = 'Error loading Audit Plan schedule: $e';
      if (mounted) {
        MotionToast.error(
          toastAlignment: Alignment.topCenter,
          description: Text('Failed to load schedule: $e'),
        ).show(context);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchMasterIsoStandards() async {
    try {
      final standards = await _programmeService.getIsoStandards();
      final seen = <int>{};
      _standards =
          standards
              .map((s) => IsoStandardDto.fromJson(s.toJson()))
              .where((s) => seen.add(s.id))
              .toList();
    } catch (e) {
      debugPrint('Failed to load ISO standards: $e');
    }
  }

  /// Mirrors audit_plan_page.dart's _fetchMasterAuditorTeams exactly —
  /// flattens AuditorTeam + User into {teamId, auditorName, isActive}
  /// records, since isoAuditors[].team comes back null from the API.
  Future<void> _fetchMasterAuditorRoster() async {
    try {
      final commonService = CommonService(Dio());
      final teams = await commonService.fetchAuditorTeam();
      final List<User> users = await commonService.fetchUsers();
      final Map<String, String> nameByUserId = {
        for (final u in users) u.id: u.fullName,
      };

      final List<AuditorTeamDto> flattened = [];
      for (final team in teams) {
        for (final auditor in team.auditors) {
          if (auditor.isDeleted) continue;
          flattened.add(
            AuditorTeamDto(
              teamId: team.teamId,
              auditorId: auditor.id,
              auditorName:
                  (auditor.userId != null
                      ? nameByUserId[auditor.userId]
                      : null) ??
                  'Unnamed Auditor',
              isActive: team.isActive && auditor.isActive,
            ),
          );
        }
      }
      _auditorRoster = flattened;
    } catch (e) {
      debugPrint('Failed to load auditor roster: $e');
    }
  }

  /// Groups entries by office (auditPlanProcesses[0].processName), in
  /// chronological (day, then time) order — matching how a printed audit
  /// schedule is naturally read, not alphabetically.
  List<_OfficeGroup> _buildOfficeGroups(List<AuditPlanEntry> entries) {
    final Map<String, _OfficeGroup> map = {};
    final List<String> orderedKeys = [];

    for (final e in entries) {
      final processes = e.auditPlanProcesses;
      String officeName = 'Unspecified Office';
      if (processes != null && processes.isNotEmpty) {
        final name = processes.first.processName?.trim();
        if (name != null && name.isNotEmpty) {
          officeName = name;
        }
      }

      final key = officeName.toLowerCase();
      final existing = map[key];
      if (existing != null) {
        existing.entries.add(e);
      } else {
        map[key] = _OfficeGroup(officeName: officeName, entries: [e]);
        orderedKeys.add(key);
      }
    }

    final list =
        orderedKeys.map((k) => map[k]!).toList()..sort((a, b) {
          final af = a.entries.first;
          final bf = b.entries.first;
          final dayCompare = af.dayNumber.compareTo(bf.dayNumber);
          if (dayCompare != 0) return dayCompare;
          return af.time.compareTo(bf.time);
        });
    return list;
  }

  /// CRITERIA column: resolves isoStandardAuditPlans[].isoStandardId
  /// against the master ISO Standard list's clauseRef, joined and sorted —
  /// exactly mirroring the backend's own ReportGetByIdAsync logic.
  String _clauseRefsForEntry(AuditPlanEntry entry) {
    final ids =
        (entry.isoStandardAuditPlans ?? const [])
            .map((s) => s.isoStandardId)
            .whereType<int>()
            .toSet();
    if (ids.isEmpty) return '—';

    final clauseById = {for (final s in _standards) s.id: s.clause};
    final clauses =
        ids
            .map((id) => clauseById[id])
            .whereType<String>()
            .where((c) => c.isNotEmpty)
            .toList()
          ..sort();
    return clauses.isEmpty ? '—' : clauses.join(', ');
  }

  /// PERSON RESPONSIBLE names for one entry — resolved EXCLUSIVELY from
  /// entry.isoAuditors[].teamId against the flattened team roster. Uses
  /// only the FIRST isoAuditors[0] team, matching how the backend's own
  /// ReportGetByIdAsync resolves "Team Only" for this column.
  List<String> _responsibleNamesForEntry(AuditPlanEntry entry) {
    final auditors = entry.isoAuditors ?? const [];
    if (auditors.isEmpty) return const [];

    final teamId = auditors.first.teamId;

    final roster =
        _auditorRoster.where((a) => a.teamId == teamId && a.isActive).toList()
          ..sort((a, b) => a.auditorName.compareTo(b.auditorName));

    if (roster.isNotEmpty) {
      return roster.map((a) => a.auditorName).toList();
    }
    return ['Team $teamId'];
  }

  /// AUDIT TEAM header block: every distinct team assigned anywhere in this
  /// office's entries, grouped and NUMBERED by teamId (e.g. "1", "2") —
  /// matching the printed form's layout, instead of one flat deduplicated
  /// name list with no team indicator.
  List<MapEntry<int, List<String>>> _teamBreakdownForGroup(_OfficeGroup group) {
    final Map<int, Set<String>> byTeam = {};

    for (final e in group.entries) {
      for (final auditor in (e.isoAuditors ?? const [])) {
        final teamId = auditor.teamId;
        if (teamId == null) continue;

        final roster = _auditorRoster
            .where((a) => a.teamId == teamId && a.isActive)
            .map((a) => a.auditorName);

        byTeam
            .putIfAbsent(teamId, () => <String>{})
            .addAll(roster.isNotEmpty ? roster : {'Team $teamId'});
      }
    }

    final result =
        byTeam.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
    return result
        .map((e) => MapEntry(e.key, e.value.toList()..sort()))
        .toList();
  }

  /// AUDIT DATE: plan.startDate offset by the group's day number — matches
  /// the backend's own FormattedProposedSchedule calculation exactly.
  DateTime _proposedDateForGroup(_OfficeGroup group) {
    final first = group.entries.first;
    final start = _plan!.startDate;
    return DateTime(
      start.year,
      start.month,
      start.day,
    ).add(Duration(days: first.dayNumber - 1));
  }

  Future<void> _handleConfirmSchedule(_OfficeGroup group) async {
    final schedId = group.schedule?.id;
    if (schedId == null || schedId <= 0) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Schedule'),
        content: Text(
          'Are you sure you want to confirm the audit schedule for ${group.officeName}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Confirm', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _isLoading = true);
    try {
      final user = _currentUser ?? await AuthUtil.fetchLoggedUser();
      await _scheduleService.decideAuditSchedule(
        schedId,
        approverId: user?.id ?? '',
        action: 'Confirm',
        officeName: group.officeName,
      );
      if (!mounted) return;
      MotionToast.success(
        toastAlignment: Alignment.topCenter,
        description: Text('Audit schedule for ${group.officeName} confirmed.'),
      ).show(context);
      await _loadPlanDetail(_plan!);
    } catch (e) {
      if (!mounted) return;
      MotionToast.error(
        toastAlignment: Alignment.topCenter,
        description: Text('Failed: $e'),
      ).show(context);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleRejectSchedule(_OfficeGroup group) async {
    final schedId = group.schedule?.id;
    if (schedId == null || schedId <= 0) return;

    final reason = await RejectionDialog.show(
      context,
      title: 'Reject Audit Schedule',
      subtitle:
          'Please provide the reason for rejecting the audit schedule for ${group.officeName}.',
    );
    if (reason == null) return;

    setState(() => _isLoading = true);
    try {
      final user = _currentUser ?? await AuthUtil.fetchLoggedUser();
      await _scheduleService.decideAuditSchedule(
        schedId,
        approverId: user?.id ?? '',
        action: 'Reject',
        comments: reason,
        officeName: group.officeName,
      );
      if (!mounted) return;
      MotionToast.success(
        toastAlignment: Alignment.topCenter,
        description: Text(
          'Audit schedule for ${group.officeName} rejected with comment.',
        ),
      ).show(context);
      await _loadPlanDetail(_plan!);
    } catch (e) {
      if (!mounted) return;
      MotionToast.error(
        toastAlignment: Alignment.topCenter,
        description: Text('Failed: $e'),
      ).show(context);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleResubmitSchedule(_OfficeGroup group) async {
    final schedId = group.schedule?.id;
    if (schedId == null || schedId <= 0) return;

    setState(() => _isLoading = true);
    try {
      final user = _currentUser ?? await AuthUtil.fetchLoggedUser();
      await _scheduleService.submitAuditSchedule(
        schedId,
        userId: user?.id,
      );
      if (!mounted) return;
      MotionToast.success(
        toastAlignment: Alignment.topCenter,
        description: Text(
          'Audit schedule for ${group.officeName} resubmitted for confirmation.',
        ),
      ).show(context);
      await _loadPlanDetail(_plan!);
    } catch (e) {
      if (!mounted) return;
      MotionToast.error(
        toastAlignment: Alignment.topCenter,
        description: Text('Failed: $e'),
      ).show(context);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text('Audit Schedule'),
        backgroundColor: mainBgColor,
        leading: _buildBackButton(),
      ),
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(color: primaryThemeColor),
              )
              : _errorMessage != null
              ? Center(
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              )
              : _resolvedAuditPlanId == null
              ? _buildAuditPlanPicker()
              : _selectedOffice == null
              ? _buildOfficeList()
              : _buildOfficeDetail(_selectedOffice!),
    );
  }

  Widget? _buildBackButton() {
    if (_selectedOffice != null) {
      return IconButton(
        icon: const Icon(Icons.arrow_back),
        tooltip: 'Back to offices',
        onPressed: () => setState(() => _selectedOffice = null),
      );
    }
    if (_resolvedAuditPlanId != null && widget.auditPlanId == null) {
      return IconButton(
        icon: const Icon(Icons.arrow_back),
        tooltip: 'Back to Audit Plans',
        onPressed:
            () => setState(() {
              _resolvedAuditPlanId = null;
              _plan = null;
              _officeGroups = [];
              _errorMessage = null;
            }),
      );
    }
    return null;
  }

  Widget _buildAuditPlanPicker() {
    if (_allAuditPlans.isEmpty) {
      return const Center(child: Text('No Audit Plans found.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: _allAuditPlans.length,
      itemBuilder: (context, i) {
        final p = _allAuditPlans[i];
        final dateRange =
            '${DateFormat('MMM d, yyyy').format(p.startDate)} – ${DateFormat('MMM d, yyyy').format(p.endDate)}';
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            title: Text(
              'Audit Plan #${p.id}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
  '${p.effectiveStatusName} • $dateRange',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            trailing: const Icon(Icons.chevron_right, color: primaryThemeColor),
            onTap: () => _loadPlanDetail(p),
          ),
        );
      },
    );
  }

  Widget _buildOfficeList() {
    if (_officeGroups.isEmpty) {
      return const Center(
        child: Text('This Audit Plan has no scheduled offices yet.'),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: _officeGroups.length,
      itemBuilder: (context, i) {
        final group = _officeGroups[i];
        final status =
            group.schedule?.effectiveStatusName ?? 'Pending Confirmation';
        final isRejected =
            group.schedule?.latestRejection != null ||
            status == 'Revision Required' ||
            status == 'Rejected';

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 16,
              ),
              side: BorderSide(
                color: isRejected ? Colors.red.shade300 : Colors.grey.shade400,
                width: isRejected ? 1.5 : 1.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              foregroundColor: Colors.black87,
              backgroundColor:
                  isRejected
                      ? Colors.red.shade50.withValues(alpha: 0.3)
                      : Colors.white,
            ),
            onPressed: () => setState(() => _selectedOffice = group),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      group.officeName.toUpperCase(),
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Status: $status',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color:
                            isRejected
                                ? Colors.red.shade700
                                : (status == 'Confirmed'
                                    ? Colors.green.shade700
                                    : Colors.orange.shade800),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isRejected)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Needs Revision',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade800,
                          ),
                        ),
                      ),
                    const Icon(Icons.chevron_right, color: primaryThemeColor),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOfficeDetail(_OfficeGroup group) {
    final teamBreakdown = _teamBreakdownForGroup(group);
    final proposedDate = _proposedDateForGroup(group);
    final sortedEntries = List<AuditPlanEntry>.from(group.entries)
      ..sort((a, b) => a.time.compareTo(b.time));
    final status =
        group.schedule?.effectiveStatusName ?? 'Pending Confirmation';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AUDIT SCHEDULE - ${group.officeName.toUpperCase()}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: primaryThemeColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Status: $status',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color:
                            status == 'Confirmed'
                                ? Colors.green.shade700
                                : (status == 'Rejected' ||
                                        status == 'Revision Required'
                                    ? Colors.red.shade700
                                    : Colors.orange.shade800),
                      ),
                    ),
                  ],
                ),
              ),
              if (group.schedule?.approvalHistory.isNotEmpty == true)
                TextButton.icon(
                  onPressed: () => ApprovalHistoryDialog.show(
                    context,
                    title: '${group.officeName} Schedule',
                    history: group.schedule!.approvalHistory,
                  ),
                  icon: const Icon(
                    Icons.history,
                    color: primaryThemeColor,
                    size: 18,
                  ),
                  label: const Text('View History'),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (group.schedule?.latestRejection != null)
            RejectionBanner(
              rejection: group.schedule!.latestRejection!,
              onViewHistory: () => ApprovalHistoryDialog.show(
                context,
                title: '${group.officeName} Schedule',
                history: group.schedule!.approvalHistory,
              ),
            ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(4),
            ),
            clipBehavior: Clip.antiAlias,
            child: Table(
              border: TableBorder(
                horizontalInside: BorderSide(color: Colors.grey.shade400),
                verticalInside: BorderSide(color: Colors.grey.shade400),
              ),
              columnWidths: const {0: FixedColumnWidth(140)},
              children: [
                _headerRow('Auditee:', group.officeName),
                _auditTeamHeaderRow(teamBreakdown),
                _headerRow('Purpose:', _kFixedPurposeText),
                _headerRow(
                  'Audit date:',
                  DateFormat('MMMM d, yyyy').format(proposedDate),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(4),
            ),
            clipBehavior: Clip.antiAlias,
            child: Table(
              border: TableBorder(
                horizontalInside: BorderSide(color: Colors.grey.shade400),
                verticalInside: BorderSide(color: Colors.grey.shade400),
              ),
              columnWidths: const {
                0: FixedColumnWidth(90),
                1: FlexColumnWidth(3),
                2: FlexColumnWidth(2),
                3: FlexColumnWidth(2),
              },
              children: [
                const TableRow(
                  decoration: BoxDecoration(color: headerFillColor),
                  children: [
                    _TableHeaderCell('TIME'),
                    _TableHeaderCell('ACTIVITY'),
                    _TableHeaderCell('CRITERIA'),
                    _TableHeaderCell('PERSON RESPONSIBLE'),
                  ],
                ),
                for (final entry in sortedEntries)
                  TableRow(
                    children: [
                      _TableCell(DateFormat('h:mm a').format(entry.time)),
                      const _TableCell(_kFixedActivityText),
                      _TableCell(_clauseRefsForEntry(entry)),
                      _TableCell(_joinedResponsibleNames(entry)),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          if (status == 'Pending' || status == 'Pending Confirmation' || _isAdmin)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isAdmin ? 'Admin / Department Head Review' : 'Department Head Confirmation',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'Please review this schedule and confirm, note, or reject with a reason.',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () => _handleRejectSchedule(group),
                    icon: const Icon(
                      Icons.cancel_outlined,
                      color: Colors.white,
                      size: 16,
                    ),
                    label: const Text(
                      'REJECT',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () => _handleConfirmSchedule(group),
                    icon: const Icon(
                      Icons.check_circle_outline,
                      color: Colors.white,
                      size: 16,
                    ),
                    label: const Text(
                      'CONFIRM SCHEDULE',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else if (group.schedule?.latestRejection != null ||
              status == 'Revision Required' ||
              status == 'Rejected')
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Schedule was rejected and requires revision.',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.red.shade800,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryThemeColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () => _handleResubmitSchedule(group),
                    icon: const Icon(
                      Icons.refresh,
                      color: Colors.white,
                      size: 16,
                    ),
                    label: const Text(
                      'RESUBMIT SCHEDULE',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
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

  String _joinedResponsibleNames(AuditPlanEntry entry) {
    final names = _responsibleNamesForEntry(entry);
    return names.isEmpty ? '—' : names.join('\n');
  }

  TableRow _headerRow(String label, String value) {
    return TableRow(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          color: headerFillColor,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: primaryThemeColor,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(value, style: const TextStyle(fontSize: 12)),
        ),
      ],
    );
  }

  /// "Audit Team:" row — one numbered block per distinct team (e.g. "1",
  /// "2"), each followed by that team's member names, matching the printed
  /// form's numbered-team layout instead of one flat name list.
  TableRow _auditTeamHeaderRow(
    List<MapEntry<int, List<String>>> teamBreakdown,
  ) {
    return TableRow(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          color: headerFillColor,
          child: const Text(
            'Audit Team:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: primaryThemeColor,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child:
              teamBreakdown.isEmpty
                  ? const Text('—', style: TextStyle(fontSize: 12))
                  : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final team in teamBreakdown)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${team.key}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              for (final name in team.value)
                                Text(
                                  name,
                                  style: const TextStyle(fontSize: 12),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
        ),
      ],
    );
  }
}

class _TableHeaderCell extends StatelessWidget {
  final String text;
  const _TableHeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 11,
          color: Color(0xFF883942),
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  final String text;
  const _TableCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(text, style: const TextStyle(fontSize: 12)),
    );
  }
}
