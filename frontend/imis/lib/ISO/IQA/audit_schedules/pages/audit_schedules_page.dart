import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/ISO/IQA/audit_schedules/pages/audit_schedule_print_preview_page.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:imis/ISO/IQA/audit_plan/models/audit_plan.dart';
import 'package:imis/ISO/IQA/audit_plan/models/audit_plan_entry.dart';
import 'package:imis/ISO/IQA/audit_plan/services/AuditPlanService.dart';
import 'package:imis/ISO/IQA/audit_programme/services/audit_programme_service.dart';
import 'package:imis/ISO/IQA/audit_schedules/models/audit_schedules.dart';
import 'package:imis/ISO/IQA/audit_schedules/services/audit_schedule_service.dart';
import 'package:imis/ISO/IQA/widgets/approval_workflow_widgets.dart';
import 'package:imis/ISO/IQA/audit_plan/pages/audit_plan_page.dart'
    show IsoStandardDto, AuditorTeamDto;
import 'package:imis/common_services/common_service.dart';
import 'package:imis/constant/permissions.dart';
import 'package:imis/user/models/user.dart';
import 'package:imis/user/models/user_registration.dart';
import 'package:imis/utils/auth_util.dart';
import 'package:imis/utils/permission_service.dart';

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

/// The Opening Meeting (Day 1 of the Audit Plan) is not an office, so it has
/// no audit schedule of its own and is never fetched into the Audit Schedule.
/// A "Closing Meeting" row saved by an earlier version is skipped as well.
bool _isMeetingRow(AuditPlanEntry e) {
  final processes = e.auditPlanProcesses;
  if (processes == null || processes.isEmpty) return false;
  final name = (processes.first.processName ?? '').trim().toLowerCase();
  return name.startsWith('opening meeting') ||
      name.startsWith('closing meeting');
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

  final AuditPlanService _auditPlanService = AuditPlanService(Dio());
  final AuditProgrammeService _programmeService = AuditProgrammeService(Dio());
  final AuditSchedulesService _scheduleService = AuditSchedulesService(Dio());

  UserRegistration? _currentUser;
  bool _isAdmin = false;
  bool _isLoading = true;
  String? _errorMessage;

  /// True when the signed-in role holds [permission] (Administrators always
  /// pass). Used to gate the workflow actions shown on this page.
  bool _hasPermission(String permission) {
    if (_isAdmin) return true;
    return permissionService.hasPermission(permission);
  }

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

  // Editable ACTIVITY text for the selected office's schedule. The backend
  // stores ONE activity per schedule (= per office), so every row of that
  // office shares this controller.
  final TextEditingController _activityController = TextEditingController();
  String _savedActivity = '';
  bool _isSavingActivity = false;

  @override
  void dispose() {
    _activityController.dispose();
    super.dispose();
  }

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
        } else if (_hasPermission(AppPermissions.addAuditSchedule)) {
          // Only a role that may create schedules materialises the missing
          // one. Read-only roles (QMR, QMS, Department Head) must not create
          // rows as a side effect of opening the page.
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
              if (_hasPermission(AppPermissions.submitAuditSchedule)) {
                await _scheduleService.submitAuditSchedule(created.id, userId: _currentUser?.id);
              }
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
  ///
  /// The Audit Plan's Opening Meeting is not an office, so it is skipped:
  /// only the offices' schedules are fetched into the Audit Schedule.
  List<_OfficeGroup> _buildOfficeGroups(List<AuditPlanEntry> entries) {
    final Map<String, _OfficeGroup> map = {};
    final List<String> orderedKeys = [];

    for (final e in entries) {
      if (_isMeetingRow(e)) continue;

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
    final items = entry.isoStandardAuditPlans ?? const [];
    if (items.isEmpty) return '—';

    final clauseById = {for (final s in _standards) s.id: s.clause};
    final clauses = <String>[];
    for (final item in items) {
      // Prefer the clause reference carried directly on the Audit Plan Entry
      // payload, then fall back to resolving the id against the master
      // ISO-standard list. This keeps CRITERIA populated even if the master
      // list fails to load.
      final nested = item.isoStandard?.clauseRef;
      if (nested != null && nested.isNotEmpty) {
        clauses.add(nested);
        continue;
      }
      final resolved = clauseById[item.isoStandardId];
      if (resolved != null && resolved.isNotEmpty) clauses.add(resolved);
    }

    final unique = clauses.toSet().toList()..sort();
    return unique.isEmpty ? '—' : unique.join(', ');
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
    return _dateForDay(group.entries.first.dayNumber);
  }

  DateTime _dateForDay(int dayNumber) {
    final start = _plan!.startDate;
    return DateTime(
      start.year,
      start.month,
      start.day,
    ).add(Duration(days: dayNumber - 1));
  }

  Future<void> _handleConfirmSchedule(_OfficeGroup group) async {
    var schedId = group.schedule?.id;
    if (schedId == null || schedId <= 0) {
      try {
        final firstEntry = group.entries.first;
        final created = await _scheduleService.addAuditSchedule(
          AuditSchedules(
            purpose: _kFixedPurposeText,
            activity: _kFixedActivityText,
            isActive: true,
            startDate: _plan!.startDate,
            endDate: _plan!.endDate,
            auditPlanId: _plan!.id,
            auditPlanEntryId: firstEntry.id,
          ),
        );
        schedId = created.id;
        group.schedule = created;
      } catch (e) {
        debugPrint('Failed to initialize schedule: $e');
        if (mounted) {
          MotionToast.error(
            toastAlignment: Alignment.topCenter,
            description: Text(
              'Unable to prepare the audit schedule: '
              '${e.toString().replaceFirst('Exception: ', '')}',
            ),
          ).show(context);
        }
        return;
      }
    }
    if (schedId <= 0 || !mounted) {
      if (mounted) {
        MotionToast.error(
          toastAlignment: Alignment.topCenter,
          description: const Text(
            'Unable to confirm: the audit schedule has no valid record.',
          ),
        ).show(context);
      }
      return;
    }

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
    var schedId = group.schedule?.id;
    if (schedId == null || schedId <= 0) {
      try {
        final firstEntry = group.entries.first;
        final created = await _scheduleService.addAuditSchedule(
          AuditSchedules(
            purpose: _kFixedPurposeText,
            activity: _kFixedActivityText,
            isActive: true,
            startDate: _plan!.startDate,
            endDate: _plan!.endDate,
            auditPlanId: _plan!.id,
            auditPlanEntryId: firstEntry.id,
          ),
        );
        schedId = created.id;
        group.schedule = created;
      } catch (e) {
        debugPrint('Failed to initialize schedule: $e');
      }
    }
    if (schedId == null || schedId <= 0 || !mounted) return;

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

  // ===========================================================================
  // Navigation helpers
  // ===========================================================================
  bool get _canGoBack =>
      _selectedOffice != null ||
      (_resolvedAuditPlanId != null && widget.auditPlanId == null);

  void _goBack() {
    if (_selectedOffice != null) {
      setState(() => _selectedOffice = null);
      return;
    }
    if (_resolvedAuditPlanId != null && widget.auditPlanId == null) {
      setState(() {
        _resolvedAuditPlanId = null;
        _plan = null;
        _officeGroups = [];
        _errorMessage = null;
      });
    }
  }

  // ===========================================================================
  // Editable ACTIVITY
  // ===========================================================================

  /// The activity text stored on the office's schedule; falls back to the
  /// standard boilerplate when nothing has been saved yet.
  String _activityFor(_OfficeGroup group) {
    final json = group.schedule?.toJson();
    if (json != null) {
      for (final e in json.entries) {
        if (e.key.toLowerCase() == 'activity') {
          final v = e.value?.toString().trim() ?? '';
          if (v.isNotEmpty) return e.value.toString();
        }
      }
    }
    return _kFixedActivityText;
  }

  void _openOffice(_OfficeGroup group) {
    final text = _activityFor(group);
    setState(() {
      _selectedOffice = group;
      _savedActivity = text;
      _activityController.text = text;
    });
  }

  bool get _activityDirty => _activityController.text != _savedActivity;

  void _cancelActivityEdit() {
    setState(() => _activityController.text = _savedActivity);
  }

  Future<void> _saveActivity(_OfficeGroup group) async {
    final text = _activityController.text.trim();
    if (text.isEmpty) {
      MotionToast.error(
        toastAlignment: Alignment.topCenter,
        description: const Text('Activity cannot be empty.'),
      ).show(context);
      return;
    }

    setState(() => _isSavingActivity = true);
    try {
      AuditSchedules saved;
      final current = group.schedule;

      if (current == null || current.id <= 0) {
        // No backing record yet — create one carrying the edited text.
        saved = await _scheduleService.addAuditSchedule(
          AuditSchedules(
            purpose: _kFixedPurposeText,
            activity: text,
            isActive: true,
            startDate: _plan!.startDate,
            endDate: _plan!.endDate,
            auditPlanId: _plan!.id,
            auditPlanEntryId: group.entries.first.id,
          ),
        );
      } else {
        // Update: round-trip the existing record through JSON so every other
        // field (id, rowVersion, status, ...) is preserved untouched.
        final json = Map<String, dynamic>.from(current.toJson());
        String key = 'activity';
        for (final k in json.keys) {
          if (k.toLowerCase() == 'activity') {
            key = k;
            break;
          }
        }
        json[key] = text;
        saved = await _scheduleService.addAuditSchedule(
          AuditSchedules.fromJson(json),
        );
      }

      AuditSchedules? refreshed;
      if (saved.id > 0) {
        refreshed = await _scheduleService.getAuditScheduleById(saved.id);
      }
      group.schedule = refreshed ?? saved;

      if (!mounted) return;
      setState(() {
        _savedActivity = _activityFor(group);
        _activityController.text = _savedActivity;
      });
      MotionToast.success(
        toastAlignment: Alignment.topCenter,
        description: const Text('Activity saved.'),
      ).show(context);
    } catch (e) {
      if (!mounted) return;
      MotionToast.error(
        toastAlignment: Alignment.topCenter,
        description: Text(
          'Failed to save activity: ${e.toString().replaceFirst('Exception: ', '')}',
        ),
      ).show(context);
    } finally {
      if (mounted) setState(() => _isSavingActivity = false);
    }
  }

  bool get _showFooter =>
      !_isLoading &&
      _errorMessage == null &&
      _resolvedAuditPlanId != null &&
      _selectedOffice != null;

  // ===========================================================================
  // Styling shared with the Audit Programme page
  // ===========================================================================
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: primaryThemeColor,
        fontSize: 13,
        fontWeight: FontWeight.bold,
      ),
      isDense: true,
      filled: true,
      fillColor: const Color(0xFFFBFBFB),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: primaryThemeColor, width: 1.5),
      ),
    );
  }

  InputDecoration _entryDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: Colors.grey.shade700,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: primaryThemeColor,
              letterSpacing: 0.5,
            ),
          ),
          const Divider(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _readOnlyField(String label, Widget child) {
    return InputDecorator(decoration: _inputDecoration(label), child: child);
  }

  Color _statusColor(String status) {
    if (status == 'Confirmed') return Colors.green.shade700;
    if (status == 'Rejected' || status == 'Revision Required') {
      return Colors.red.shade700;
    }
    return Colors.orange.shade800;
  }

  // ===========================================================================
  // Build
  // ===========================================================================
  @override
  Widget build(BuildContext context) {
    // Pop-up dialog — same shell as the Audit Programme page.
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 960,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF4F6F8),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              Expanded(child: _buildBody()),
              if (_showFooter) _buildFooter(_selectedOffice!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final group = _selectedOffice;
    final title =
        group != null
            ? 'AUDIT SCHEDULE - ${group.officeName.toUpperCase()}'
            : (_resolvedAuditPlanId == null
                ? 'SELECT AUDIT PLAN'
                : 'AUDIT SCHEDULE');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: primaryThemeColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      child: Row(
        children: [
          if (_canGoBack && !_isLoading)
            IconButton(
              onPressed: _goBack,
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              tooltip:
                  _selectedOffice != null
                      ? 'Back to offices'
                      : 'Back to Audit Plans',
              splashRadius: 20,
            ),
          Expanded(
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: 0.5,
              ),
            ),
          ),
          if (group != null &&
              !_isLoading &&
              group.schedule?.approvalHistory.isNotEmpty == true)
            TextButton.icon(
              onPressed: () => ApprovalHistoryDialog.show(
                context,
                title: '${group.officeName} Schedule',
                history: group.schedule!.approvalHistory,
              ),
              icon: const Icon(Icons.history, color: Colors.white, size: 18),
              label: const Text(
                'History',
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          if (group != null && !_isLoading && _plan != null)
            IconButton(
              onPressed: () => openAuditSchedulePrintPreview(
                context,
                _plan!.id,
                officeName: group.officeName,
              ),
              icon: const Icon(Icons.print_outlined, color: Colors.white),
              tooltip: 'Print Preview',
              splashRadius: 20,
            ),
          if (Navigator.of(context).canPop())
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close, color: Colors.white),
              tooltip: 'Close',
              splashRadius: 20,
            ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: primaryThemeColor),
      );
    }
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            _errorMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }
    if (_resolvedAuditPlanId == null) return _buildAuditPlanPicker();
    if (_selectedOffice == null) return _buildOfficeList();
    return _buildOfficeDetail(_selectedOffice!);
  }

  // ===========================================================================
  // Footer (same bar as the Audit Programme page)
  // ===========================================================================
  Widget _buildFooter(_OfficeGroup group) {
    final status =
        group.schedule?.effectiveStatusName ?? 'Pending Confirmation';
    final isRejected =
        group.schedule?.latestRejection != null ||
        status == 'Revision Required' ||
        status == 'Rejected';

    // The decision (Confirm / Reject) belongs to the Department Head, who
    // holds the "Audit Schedule Confirm" / "Audit Schedule Reject"
    // permissions. Administrators keep the previous always-visible
    // behaviour, so the page stays usable for support staff.
    final canConfirm = _isAdmin || _hasPermission(AppPermissions.confirmAuditSchedule);
    final canReject = _isAdmin || _hasPermission(AppPermissions.rejectAuditSchedule);
    final canSubmit = _isAdmin || _hasPermission(AppPermissions.submitAuditSchedule);

    final showDecision =
        status == 'Pending' ||
        status == 'Pending Confirmation' ||
        (canConfirm || canReject);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final leftActions = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: _goBack,
                child: const Text(
                  'Back',
                  style: TextStyle(
                    color: primaryThemeColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: _plan == null
                    ? null
                    : () => openAuditSchedulePrintPreview(
                          context,
                          _plan!.id,
                          officeName: group.officeName,
                        ),
                icon: const Icon(
                  Icons.picture_as_pdf_outlined,
                  size: 16,
                  color: primaryThemeColor,
                ),
                label: const Text(
                  'PRINT PREVIEW',
                  style: TextStyle(
                    color: primaryThemeColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: primaryThemeColor),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ],
          );

          Widget rightActions = const SizedBox.shrink();
          if (showDecision) {
            rightActions = Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (canReject)
                  ElevatedButton.icon(
                    onPressed: () => _handleRejectSchedule(group),
                    icon: const Icon(
                      Icons.cancel_outlined,
                      size: 16,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'REJECT',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                if (canReject && canConfirm) const SizedBox(width: 8),
                if (canConfirm)
                  ElevatedButton.icon(
                    onPressed: () => _handleConfirmSchedule(group),
                    icon: const Icon(
                      Icons.check_circle_outline,
                      size: 16,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'CONFIRM SCHEDULE',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
              ],
            );
          } else if (isRejected && canSubmit) {
            rightActions = ElevatedButton.icon(
              onPressed: () => _handleResubmitSchedule(group),
              icon: const Icon(Icons.refresh, size: 16, color: Colors.white),
              label: const Text(
                'RESUBMIT SCHEDULE',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryThemeColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            );
          }

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [leftActions, rightActions],
              ),
            ),
          );
        },
      ),
    );
  }

  // ===========================================================================
  // Step 0 — Audit Plan picker
  // ===========================================================================
  Widget _buildAuditPlanPicker() {
    if (_allAuditPlans.isEmpty) {
      return const Center(child: Text('No Audit Plans found.'));
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: _buildCard(
        title: 'AUDIT PLANS',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final p in _allAuditPlans)
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
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
                    '${p.effectiveStatusName} • '
                    '${DateFormat('MMM d, yyyy').format(p.startDate)} – '
                    '${DateFormat('MMM d, yyyy').format(p.endDate)}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: primaryThemeColor,
                  ),
                  onTap: () => _loadPlanDetail(p),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // Step 1 — Office list
  // ===========================================================================
  Widget _buildOfficeList() {
    if (_officeGroups.isEmpty) {
      return const Center(
        child: Text('This Audit Plan has no scheduled offices yet.'),
      );
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: _buildCard(
        title: 'OFFICES / DEPARTMENTS',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [for (final group in _officeGroups) _buildOfficeTile(group)],
        ),
      ),
    );
  }

  Widget _buildOfficeTile(_OfficeGroup group) {
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
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          side: BorderSide(
            color: isRejected ? Colors.red.shade300 : Colors.grey.shade300,
            width: isRejected ? 1.5 : 1.0,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          foregroundColor: Colors.black87,
          backgroundColor:
              isRejected
                  ? Colors.red.shade50.withValues(alpha: 0.3)
                  : Colors.grey.shade50,
        ),
        onPressed: () => _openOffice(group),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
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
  }

  // ===========================================================================
  // Step 2 — Office detail
  // ===========================================================================
  Widget _buildOfficeDetail(_OfficeGroup group) {
    final teamBreakdown = _teamBreakdownForGroup(group);
    final proposedDate = _proposedDateForGroup(group);
    final sortedEntries = List<AuditPlanEntry>.from(group.entries)
      ..sort((a, b) {
        final d = a.dayNumber.compareTo(b.dayNumber);
        return d != 0 ? d : a.time.compareTo(b.time);
      });
    final status =
        group.schedule?.effectiveStatusName ?? 'Pending Confirmation';

    final Map<int, List<AuditPlanEntry>> byDay = {};
    for (final e in sortedEntries) {
      byDay.putIfAbsent(e.dayNumber, () => []).add(e);
    }
    final days = byDay.keys.toList()..sort();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (group.schedule?.latestRejection != null)
            RejectionBanner(
              rejection: group.schedule!.latestRejection!,
              onViewHistory: () => ApprovalHistoryDialog.show(
                context,
                title: '${group.officeName} Schedule',
                history: group.schedule!.approvalHistory,
              ),
            ),
          _buildCard(
            title: 'SCHEDULE HEADER',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: _readOnlyField(
                        'AUDITEE',
                        Text(
                          group.officeName,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: _readOnlyField(
                        'STATUS',
                        Text(
                          status,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _statusColor(status),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _readOnlyField(
                  'AUDIT TEAM',
                  teamBreakdown.isEmpty
                      ? const Text('—', style: TextStyle(fontSize: 13))
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
                                      'Team ${team.key}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Wrap(
                                      spacing: 4,
                                      runSpacing: 4,
                                      children: [
                                        for (final name in team.value)
                                          Chip(
                                            label: Text(
                                              name,
                                              style: const TextStyle(
                                                fontSize: 11,
                                              ),
                                            ),
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                            visualDensity:
                                                VisualDensity.compact,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 4,
                                            ),
                                            backgroundColor: primaryThemeColor
                                                .withValues(alpha: .08),
                                            labelStyle: const TextStyle(
                                              color: primaryThemeColor,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: _readOnlyField(
                        'PURPOSE',
                        const Text(
                          _kFixedPurposeText,
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: _readOnlyField(
                        'AUDIT DATE',
                        Text(
                          DateFormat('MMMM d, yyyy').format(proposedDate),
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildCard(
            title: 'SCHEDULE',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final day in days)
                  _buildDayGroup(day, byDay[day]!, isLast: day == days.last),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildDayGroup(
    int day,
    List<AuditPlanEntry> dayEntries, {
    required bool isLast,
  }) {
    final date = _dateForDay(day);

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFE5E5E5),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                'DAY $day — ${DateFormat('MMMM d, yyyy').format(date).toUpperCase()}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          for (var i = 0; i < dayEntries.length; i++) ...[
            if (i > 0) const SizedBox(height: 12),
            _buildEntryRow(dayEntries[i]),
          ],
        ],
      ),
    );
  }

  Widget _buildEntryRow(AuditPlanEntry entry) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 800;

          Widget field(String label, String value) => InputDecorator(
                decoration: _entryDecoration(label),
                child: Text(value, style: const TextStyle(fontSize: 12)),
              );

          final timeField = field('TIME', DateFormat('h:mm a').format(entry.time));
          final activityGroup = _selectedOffice;
          final activityField = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _activityController,
                minLines: 9,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                style: const TextStyle(fontSize: 12),
                decoration: _entryDecoration('ACTIVITY').copyWith(
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(
                      color: primaryThemeColor,
                      width: 1.5,
                    ),
                  ),
                ),
                onChanged: (_) => setState(() {}),
              ),
              if (_activityDirty && activityGroup != null) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _isSavingActivity ? null : _cancelActivityEdit,
                      child: const Text(
                        'CANCEL',
                        style: TextStyle(
                          color: primaryThemeColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    ElevatedButton.icon(
                      onPressed: _isSavingActivity
                          ? null
                          : () => _saveActivity(activityGroup),
                      icon: const Icon(Icons.save_outlined,
                          size: 14, color: Colors.white),
                      label: Text(
                        _isSavingActivity ? 'SAVING...' : 'SAVE ACTIVITY',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryThemeColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          );
          final criteriaField = field('CRITERIA', _clauseRefsForEntry(entry));
          final personsField = field(
            'PERSON RESPONSIBLE',
            _joinedResponsibleNames(entry),
          );

          if (isWide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: timeField),
                const SizedBox(width: 8),
                Expanded(flex: 4, child: activityField),
                const SizedBox(width: 8),
                Expanded(flex: 3, child: criteriaField),
                const SizedBox(width: 8),
                Expanded(flex: 3, child: personsField),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              timeField,
              const SizedBox(height: 8),
              activityField,
              const SizedBox(height: 8),
              criteriaField,
              const SizedBox(height: 8),
              personsField,
            ],
          );
        },
      ),
    );
  }

  String _joinedResponsibleNames(AuditPlanEntry entry) {
    final names = _responsibleNamesForEntry(entry);
    return names.isEmpty ? '—' : names.join('\n');
  }
}