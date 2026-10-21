// lib/audit/audit_plan/pages/audit_plan_page.dart

// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/ISO/IQA/audit_plan/pages/audit_plan_print_preview_page.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:imis/ISO/IQA/audit_plan/models/audit_plan.dart';
import 'package:imis/ISO/IQA/audit_plan/services/AuditPlanService.dart';
import 'package:imis/ISO/IQA/audit_programme/services/audit_programme_service.dart';
import 'package:imis/ISO/IQA/widgets/approval_workflow_widgets.dart';
import 'package:imis/common_services/common_service.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/user/models/user.dart';
import 'package:imis/user/models/user_registration.dart';
import 'package:imis/utils/auth_util.dart';
import 'package:imis/widgets/common/build_page_header.dart';
import 'package:imis/widgets/common/pagination_controls.dart';

// =============================================================================
// 1. DATA MODELS
// =============================================================================

class AuditPlanEntryRow {
  int? id;
  int dayNumber;
  TimeOfDay time;

  int? selectedOfficeId;
  final TextEditingController officeTextController;
  final FocusNode officeFocusNode;

  final TextEditingController standardTextController;
  List<int> selectedIsoStandardIds;

  int? selectedTeamId;
  List<TextEditingController> responsiblePersonControllers;

  final int? sourceProgrammeEntryId;

  AuditPlanEntryRow({
    this.id,
    required this.dayNumber,
    TimeOfDay? time,
    this.selectedOfficeId,
    String? officeText,
    String? standardText,
    List<int>? selectedIsoStandardIds,
    this.selectedTeamId,
    List<String>? responsiblePersons,
    this.sourceProgrammeEntryId,
  })  : time = time ?? const TimeOfDay(hour: 9, minute: 0),
        selectedIsoStandardIds = selectedIsoStandardIds ?? <int>[],
        officeTextController = TextEditingController(text: officeText ?? ''),
        officeFocusNode = FocusNode(),
        standardTextController =
            TextEditingController(text: standardText ?? ''),
        responsiblePersonControllers = (responsiblePersons ?? const <String>[])
            .map((n) => TextEditingController(text: n))
            .toList();

  void addResponsiblePerson([String text = '']) {
    responsiblePersonControllers.add(TextEditingController(text: text));
  }

  void removeResponsiblePersonAt(int index) {
    responsiblePersonControllers.removeAt(index).dispose();
  }

  void populateResponsiblePersonsFromTeam(
    List<AuditorTeamDto> allAuditorTeams,
  ) {
    if (selectedTeamId == null) return;
    final roster = allAuditorTeams
        .where((a) => a.teamId == selectedTeamId && a.isActive)
        .toList()
      ..sort((a, b) => a.auditorName.compareTo(b.auditorName));
    if (roster.isEmpty) return;

    for (final c in responsiblePersonControllers) {
      c.dispose();
    }
    responsiblePersonControllers = roster
        .map((a) => TextEditingController(text: a.auditorName))
        .toList();
  }

  void dispose() {
    officeTextController.dispose();
    officeFocusNode.dispose();
    standardTextController.dispose();
    for (final c in responsiblePersonControllers) {
      c.dispose();
    }
  }

  factory AuditPlanEntryRow.fromProgrammeEntry(
    ProgrammeEntrySummary pe, {
    required List<IsoStandardDto> allStandards,
  }) {
    final clauseLabels = pe.standardIds
        .map((id) {
          final match = allStandards.where((s) => s.id == id);
          if (match.isEmpty) return null;
          final s = match.first;
          return s.clause.isNotEmpty ? s.clause : s.displayLabel;
        })
        .whereType<String>()
        .where((s) => s.isNotEmpty)
        .toList();

    return AuditPlanEntryRow(
      dayNumber: pe.dayNumber,
      time: pe.time,
      selectedOfficeId: pe.officeId,
      officeText: pe.processText,
      standardText: clauseLabels.join(', '),
      selectedIsoStandardIds: List<int>.from(pe.standardIds),
      selectedTeamId: pe.teamId,
      sourceProgrammeEntryId: pe.id,
    );
  }

  factory AuditPlanEntryRow.fromJson(
    Map<String, dynamic> json, {
    required List<IsoStandardDto> allStandards,
  }) {
    int? officeId;
    String officeName = '';
    final processes = json['auditPlanProcesses'] ?? json['AuditPlanProcesses'];
    if (processes != null && (processes as List).isNotEmpty) {
      final item = processes[0];
      officeId =
          (item['officeId'] ?? item['OfficeId'] ?? item['office']?['id'])
              as int?;
      final rawName =
          item['processName'] ?? item['ProcessName'] ?? item['office']?['name'];
      officeName = rawName?.toString() ?? '';
    }

    String standardText =
        (json['standardText'] ?? json['StandardText'] ?? '').toString();
    final loadedStandardIds = <int>[];
    {
      final standards =
          json['isoStandardAuditPlans'] ?? json['IsoStandardAuditPlans'];
      if (standards != null) {
        for (final item in (standards as List)) {
          final rawId = item['isoStandardId'] ?? item['IsoStandardId'];
          if (rawId == null) continue;
          final parsed = rawId is int ? rawId : int.tryParse(rawId.toString());
          if (parsed != null && !loadedStandardIds.contains(parsed)) {
            loadedStandardIds.add(parsed);
          }
        }
      }
    }
    if (standardText.isEmpty) {
      final standards =
          json['isoStandardAuditPlans'] ?? json['IsoStandardAuditPlans'];
      if (standards != null) {
        final labels = <String>[];
        for (final item in (standards as List)) {
          final directLabel = item['clauseRef'] ??
              item['ClauseRef'] ??
              item['isoStandard']?['clauseRef'] ??
              item['isoStandard']?['ClauseRef'];
          if (directLabel != null) {
            labels.add(directLabel.toString());
            continue;
          }

          final rawId = item['isoStandardId'] ?? item['IsoStandardId'];
          if (rawId == null) continue;
          final parsedId =
              rawId is int ? rawId : int.tryParse(rawId.toString());
          if (parsedId == null) continue;

          final match = allStandards.where((s) => s.id == parsedId);
          if (match.isEmpty) continue;
          final s = match.first;
          final label = s.clause.isNotEmpty ? s.clause : s.displayLabel;
          if (label.isNotEmpty) labels.add(label);
        }
        standardText = labels.join(', ');
      }
    }

    int? teamId;
    final auditors = json['isoAuditors'] ?? json['IsoAuditors'];
    if (auditors != null && (auditors as List).isNotEmpty) {
      final item = auditors[0];
      teamId =
          (item['teamId'] ?? item['TeamId'] ?? item['team']?['id']) as int?;
    }

    final List<String> responsibleNames = [];
    final responsible =
        json['responsiblePersons'] ?? json['ResponsiblePersons'];
    if (responsible != null) {
      for (final item in (responsible as List)) {
        final name = (item is String)
            ? item
            : (item['name'] ?? item['Name'] ?? '').toString();
        if (name.isNotEmpty) responsibleNames.add(name);
      }
    }

    TimeOfDay time = const TimeOfDay(hour: 9, minute: 0);
    final rawTime = json['time'] ?? json['Time'];
    if (rawTime != null) {
      final parsed = DateTime.tryParse(rawTime.toString());
      if (parsed != null) {
        time = TimeOfDay(
          hour: parsed.toLocal().hour,
          minute: parsed.toLocal().minute,
        );
      }
    }

    return AuditPlanEntryRow(
      id: (json['id'] ?? json['Id']) as int?,
      dayNumber: (json['dayNumber'] ?? json['DayNumber'] ?? 1) as int,
      time: time,
      selectedOfficeId: officeId,
      officeText: officeName,
      standardText: standardText,
      selectedIsoStandardIds: loadedStandardIds,
      selectedTeamId: teamId,
      responsiblePersons: responsibleNames,
    );
  }

  Map<String, dynamic> toBackendDtoJson(
    int auditPlanId, {
    required DateTime dayDate,
    required List<IsoStandardDto> allStandards,
  }) {
    final trimmedOfficeText = officeTextController.text.trim();
    final combined = DateTime(
      dayDate.year,
      dayDate.month,
      dayDate.day,
      time.hour,
      time.minute,
    );

    final resolvedIds = <int>{...selectedIsoStandardIds};
    if (allStandards.isNotEmpty) {
      final clauseByLabel = {
        for (final s in allStandards) s.clause.trim().toLowerCase(): s.id,
      };
      final tokens = standardTextController.text
          .split(RegExp(r'[,;\n]+'))
          .map((t) => t.trim())
          .where((t) => t.isNotEmpty);
      for (final token in tokens) {
        final matchId = clauseByLabel[token.toLowerCase()];
        if (matchId != null) resolvedIds.add(matchId);
      }
    }

    return {
      'id': id ?? 0,
      'auditPlanId': auditPlanId,
      'dayNumber': dayNumber,
      'time': combined.toIso8601String(),
      'standardText': standardTextController.text.trim(),
      'isoStandardAuditPlans': resolvedIds
          .map((sid) => {'id': 0, 'isoStandardId': sid})
          .toList(),
      'auditPlanProcesses': trimmedOfficeText.isNotEmpty
          ? [
              {
                'id': 0,
                'officeId': selectedOfficeId,
                'processName': trimmedOfficeText,
                'auditPlanEntryId': 0,
              },
            ]
          : [],
      'isoAuditors': selectedTeamId != null
          ? [
              {'id': 0, 'teamId': selectedTeamId},
            ]
          : [],
      'responsiblePersons': responsiblePersonControllers
          .map((c) => c.text.trim())
          .where((s) => s.isNotEmpty)
          .map((name) => {'id': 0, 'name': name})
          .toList(),
    };
  }
}

class ProgrammeEntrySummary {
  final int id;
  final int dayNumber;
  final DateTime? date;
  final TimeOfDay time;
  final int? officeId;
  final String processText;
  final List<int> standardIds;
  final int? teamId;

  ProgrammeEntrySummary({
    required this.id,
    required this.dayNumber,
    this.date,
    required this.time,
    this.officeId,
    required this.processText,
    required this.standardIds,
    this.teamId,
  });

  factory ProgrammeEntrySummary.fromJson(Map<String, dynamic> json) {
    int? officeId;
    String processText = '';
    final processes = json['auditPlanProcesses'] ?? json['AuditPlanProcesses'];
    if (processes != null && (processes as List).isNotEmpty) {
      final item = processes[0];
      officeId = (item['officeId'] ?? item['OfficeId']) as int?;
      processText =
          (item['processName'] ?? item['ProcessName'] ?? '').toString();
    }

    final List<int> standardIds = [];
    final standards =
        json['isoStandardAuditPlans'] ?? json['IsoStandardAuditPlans'];
    if (standards != null) {
      for (final item in (standards as List)) {
        final rawId = item['isoStandardId'] ?? item['IsoStandardId'];
        if (rawId != null) {
          final parsed = rawId is int ? rawId : int.tryParse(rawId.toString());
          if (parsed != null) standardIds.add(parsed);
        }
      }
    }

    int? teamId;
    final auditors = json['isoAuditors'] ?? json['IsoAuditors'];
    if (auditors != null && (auditors as List).isNotEmpty) {
      teamId = (auditors[0]['teamId'] ?? auditors[0]['TeamId']) as int?;
    }

    DateTime? date;
    TimeOfDay time = const TimeOfDay(hour: 9, minute: 0);
    final rawTime = json['time'] ?? json['Time'];
    if (rawTime != null) {
      final parsed = DateTime.tryParse(rawTime.toString());
      if (parsed != null) {
        final local = parsed.toLocal();
        date = DateTime(local.year, local.month, local.day);
        time = TimeOfDay(hour: local.hour, minute: local.minute);
      }
    }

    return ProgrammeEntrySummary(
      id: (json['id'] ?? json['Id'] ?? 0) as int,
      dayNumber: (json['dayNumber'] ?? json['DayNumber'] ?? 1) as int,
      date: date,
      time: time,
      officeId: officeId,
      processText: processText.isNotEmpty ? processText : 'Untitled Process',
      standardIds: standardIds,
      teamId: teamId,
    );
  }
}

class OfficeDto {
  final int id;
  final String name;
  OfficeDto({required this.id, required this.name});
  factory OfficeDto.fromJson(Map<String, dynamic> json) => OfficeDto(
        id: json['id'] ?? json['Id'] ?? 0,
        name: json['name'] ?? json['Name'] ?? 'Unnamed Office',
      );
}

class IsoStandardDto {
  final int id;
  final String clause;
  final String? name;
  IsoStandardDto({required this.id, required this.clause, this.name});
  String get displayLabel =>
      clause.isNotEmpty && name != null && name!.isNotEmpty
          ? '$clause - $name'
          : (clause.isNotEmpty ? clause : (name ?? ''));
  factory IsoStandardDto.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'] ?? json['Id'] ?? 0;
    return IsoStandardDto(
      id: rawId is int ? rawId : int.parse(rawId.toString()),
      clause: json['clauseRef'] ??
          json['ClauseRef'] ??
          json['clause'] ??
          json['Clause'] ??
          '',
      name: json['name'] ?? json['Name'],
    );
  }
}

class TeamDto {
  final int id;
  final String name;
  TeamDto({required this.id, required this.name});
  factory TeamDto.fromJson(Map<String, dynamic> json) => TeamDto(
        id: json['id'] ?? json['Id'] ?? 0,
        name: json['name'] ?? json['Name'] ?? 'Unnamed Team',
      );
}

class AuditorTeamDto {
  final int teamId;
  final int? auditorId;
  final String auditorName;
  final bool isActive;
  AuditorTeamDto({
    required this.teamId,
    this.auditorId,
    required this.auditorName,
    required this.isActive,
  });
  factory AuditorTeamDto.fromJson(Map<String, dynamic> json) => AuditorTeamDto(
        teamId: (json['teamId'] ?? json['TeamId'] ?? 0) as int,
        auditorId: (json['auditorId'] ?? json['AuditorId']) as int?,
        auditorName:
            (json['auditorName'] ?? json['AuditorName'] ?? 'Unnamed Auditor')
                .toString(),
        isActive: (json['isActive'] ?? json['IsActive'] ?? true) == true,
      );
}

// =============================================================================
// 2. AUDIT PLAN LIST PAGE
// =============================================================================

class AuditPlanListPage extends StatefulWidget {
  const AuditPlanListPage({super.key});

  @override
  State<AuditPlanListPage> createState() => _AuditPlanListPageState();
}

class _AuditPlanListPageState extends State<AuditPlanListPage> {
  static const List<String> _statusTabs = [
    'All',
    'Draft',
    'Pending',
    'Approved',
    'Revision Required',
    'Rejected',
  ];

  final _service = AuditPlanService(Dio());

  List<AuditPlan> _allPlans = [];
  String _selectedTab = 'All';
  int _currentPage = 1;
  final int _pageSize = 15;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchPlans();
  }

  Future<void> _fetchPlans() async {
    setState(() => _isLoading = true);
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

  int _countFor(String tab) {
    if (tab == 'All') return _allPlans.length;
    return _allPlans.where((p) => p.effectiveStatusName == tab).length;
  }

  List<AuditPlan> get _filtered {
    if (_selectedTab == 'All') return _allPlans;
    return _allPlans
        .where((p) => p.effectiveStatusName == _selectedTab)
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

  Future<void> _openForm({AuditPlan? plan}) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AuditPlanPage(
        programmeId: plan?.auditProgrammeId,
        auditPlanId: plan?.id,
      ),
    );
    _fetchPlans();
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
      await _service.deleteAuditPlan(plan.id);
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

  Widget _buildTab(String tab) {
    final isActive = tab == _selectedTab;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _selectTab(tab),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? primaryColor.withValues(alpha: 0.1) : null,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isActive ? primaryColor : kBorder,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                tab,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isActive ? primaryColor : kMuted,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 1,
                ),
                decoration: BoxDecoration(
                  color: isActive ? primaryColor : kBorder,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${_countFor(tab)}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isActive ? Colors.white : kMuted,
                  ),
                ),
              ),
            ],
          ),
        ),
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
              totalCount: _allPlans.length,
              itemLabel: 'plan',
              icon: Icons.event_note_outlined,
              actionButton: const SizedBox.shrink(),
            ),
            const SizedBox(height: 6),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _statusTabs.map(_buildTab).toList(),
              ),
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
                                'Plan',
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
                              width: 140,
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
                                        (_currentPage - 1) * _pageSize +
                                            index +
                                            1;
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
                                                'Audit Plan #${plan.id}',
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
                                                    tooltip:
                                                        'View Approval History',
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
                                                  IconButton(
                                                    tooltip: 'PDF Preview',
                                                    padding: EdgeInsets.zero,
                                                    constraints:
                                                        const BoxConstraints(
                                                      minWidth: 36,
                                                      minHeight: 36,
                                                    ),
                                                    icon: const Icon(
                                                      Icons
                                                          .picture_as_pdf_outlined,
                                                      size: 16,
                                                    ),
                                                    onPressed: () =>
                                                        openAuditPlanPrintPreview(
                                                      context,
                                                      plan.id,
                                                    ),
                                                  ),
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
                                                  'Audit Plan #${plan.id}',
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
                                            onSelected: (value) {
                                              if (value == 'edit') {
                                                _openForm(plan: plan);
                                              }
                                              if (value == 'pdf') {
                                                openAuditPlanPrintPreview(
                                                  context,
                                                  plan.id,
                                                );
                                              }
                                            },
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
                                                      Icons
                                                          .picture_as_pdf_outlined,
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

// =============================================================================
// 3. AUDIT PLAN FORM (dialog — same layout as the Audit Programme form)
// =============================================================================

class AuditPlanPage extends StatefulWidget {
  final int? programmeId;
  final int? auditPlanId;

  const AuditPlanPage({super.key, this.programmeId, this.auditPlanId});

  @override
  State<AuditPlanPage> createState() => _AuditPlanPageState();
}

class _AuditPlanPageState extends State<AuditPlanPage> {
  static const Color primaryThemeColor = Color(0xFF883942);
  static const Color headerFillColor = Color(0xFFF3E9EA);

  final AuditProgrammeService _service = AuditProgrammeService(Dio());
  final AuditPlanService _auditPlanService = AuditPlanService(Dio());

  bool _isLoading = true;
  String? _errorMessage;

  int? _resolvedProgrammeId;
  List<dynamic> _allProgrammes = [];

  String _programmeTitle = '';
  String _programmeObjectives = '';
  String _programmeScope = '';

  final Map<int, DateTime> _dayDates = {};
  final List<AuditPlanEntryRow> _entries = [];

  List<OfficeDto> _offices = [];
  List<IsoStandardDto> _standards = [];
  List<TeamDto> _teams = [];
  List<AuditorTeamDto> _auditorTeams = [];

  AuditPlan? _loadedPlan;
  UserRegistration? _currentUser;
  bool _isAdmin = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _resolvedProgrammeId = widget.programmeId;
    if (_resolvedProgrammeId != null) {
      _load();
    } else {
      _loadProgrammeList();
    }
  }

  @override
  void dispose() {
    for (final e in _entries) {
      e.dispose();
    }
    super.dispose();
  }

  Future<void> _loadProgrammeList() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      _allProgrammes = await _service.getAllAuditProgrammes();
    } catch (e) {
      _errorMessage = 'Failed to load Audit Programmes: $e';
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// The Opening Meeting row of the original Audit Plan form: Day 1, 9:00 AM,
  /// with the standard list of persons.
  AuditPlanEntryRow _newOpeningMeetingRow() {
    return AuditPlanEntryRow(
      dayNumber: 1,
      time: const TimeOfDay(hour: 9, minute: 0),
      officeText: kOpeningMeetingLabel,
      responsiblePersons: kOpeningMeetingPersons,
    );
  }

  bool _isOpening(AuditPlanEntryRow e) =>
      e.officeTextController.text.trim().toLowerCase().startsWith('opening');

  /// A programme row with only typed text: no office from the list, no clause
  /// and no team (e.g. "Reporting").
  bool _isProgrammeTextOnly(ProgrammeEntrySummary pe) {
    final text = pe.processText.trim();
    return (pe.officeId == null || pe.officeId == 0) &&
        pe.standardIds.isEmpty &&
        pe.teamId == null &&
        text.isNotEmpty &&
        text != 'Untitled Process';
  }

  /// Key that identifies a programme typed-text row (e.g. "Reporting").
  String _textOnlyKey(int dayNumber, String text) =>
      '$dayNumber|${text.trim().toLowerCase()}';

  /// Makes the schedule match the original form:
  ///  1. Day 1 opens with the Opening Meeting.
  ///  2. Rows saved without a time (00:00) get sensible times — the Opening
  ///     Meeting 9:00 AM, then one row per hour from 10:00 AM on Day 1
  ///     (9:00 AM on the other days). Rows with a real time keep it.
  ///  3. Rows are kept in day / time order.
  void _normalizeSchedule() {
    if (_entries.isEmpty) return;

    final firstDay1 = _entries.indexWhere((e) => e.dayNumber == 1);
    if (firstDay1 != -1 &&
        !_entries.any((e) => e.dayNumber == 1 && _isOpening(e))) {
      _entries.insert(firstDay1, _newOpeningMeetingRow());
    }

    final days = _entries.map((e) => e.dayNumber).toSet().toList()..sort();
    for (final day in days) {
      var cursor = day == 1 ? 10 * 60 : 9 * 60;
      for (final e in _entries.where((e) => e.dayNumber == day)) {
        final m = e.time.hour * 60 + e.time.minute;
        if (m != 0) {
          if (m + 60 > cursor) cursor = m + 60;
          continue;
        }
        if (_isOpening(e)) {
          e.time = const TimeOfDay(hour: 9, minute: 0);
          continue;
        }
        e.time = TimeOfDay(hour: cursor ~/ 60, minute: cursor % 60);
        cursor += 60;
      }
    }

    final indexed = _entries.asMap().entries.toList()
      ..sort((a, b) {
        final d = a.value.dayNumber.compareTo(b.value.dayNumber);
        if (d != 0) return d;
        final t = (a.value.time.hour * 60 + a.value.time.minute)
            .compareTo(b.value.time.hour * 60 + b.value.time.minute);
        return t != 0 ? t : a.key.compareTo(b.key);
      });
    final sorted = indexed.map((e) => e.value).toList();
    _entries
      ..clear()
      ..addAll(sorted);
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      _currentUser = await AuthUtil.fetchLoggedUser();
      _isAdmin = await AuthUtil.isCurrentUserAdmin();
      await Future.wait([
        _fetchMasterOffices(),
        _fetchMasterIsoStandards(),
        _fetchMasterTeams(),
        _fetchMasterAuditorTeams(),
      ]);

      if (widget.auditPlanId != null) {
        _loadedPlan =
            await _auditPlanService.getAuditPlanById(widget.auditPlanId!);
      }

      final programme = await _service.getAuditProgrammeById(
        _resolvedProgrammeId!,
      );
      if (programme == null) throw Exception('Audit Programme not found');

      final jsonMap = programme.toJson();
      _programmeTitle =
          (jsonMap['for'] ?? jsonMap['For'] ?? 'Audit Programme').toString();
      _programmeScope =
          (jsonMap['scopeOfAudit'] ?? jsonMap['ScopeOfAudit'] ?? '').toString();

      final loadedObjectives =
          jsonMap['objectives'] as List? ?? jsonMap['Objectives'] as List? ?? [];
      _programmeObjectives = loadedObjectives
          .map((o) => (o['description'] ?? o['Description'] ?? '').toString())
          .where((s) => s.isNotEmpty)
          .join('\n');

      final sourcePlans =
          (jsonMap['auditPlan'] as List? ?? jsonMap['AuditPlans'] as List? ?? []);

      final List<ProgrammeEntrySummary> programmeEntries = [];
      for (final plan in sourcePlans) {
        final planMap = plan as Map<String, dynamic>;
        final entriesList =
            (planMap['entries'] as List? ?? planMap['Entries'] as List? ?? []);
        for (final e in entriesList) {
          programmeEntries.add(
            ProgrammeEntrySummary.fromJson(e as Map<String, dynamic>),
          );
        }
      }

      // Typed-text rows of the programme (e.g. "Reporting") are not part of
      // the Audit Plan: they are never fetched into it.
      final programmeTextOnlyKeys = <String>{};
      programmeEntries.removeWhere((pe) {
        if (_isProgrammeTextOnly(pe)) {
          programmeTextOnlyKeys.add(_textOnlyKey(pe.dayNumber, pe.processText));
          return true;
        }
        return false;
      });

      if (widget.auditPlanId != null) {
        final plans =
            (jsonMap['auditPlan'] as List? ?? jsonMap['AuditPlans'] as List? ?? []);
        final match = plans.cast<Map<String, dynamic>>().where(
              (p) => (p['id'] ?? p['Id']) == widget.auditPlanId,
            );
        if (match.isNotEmpty) {
          final plan = match.first;
          final entriesList =
              (plan['entries'] as List? ?? plan['Entries'] as List? ?? []);
          for (final e in entriesList) {
            final row = AuditPlanEntryRow.fromJson(
              e as Map<String, dynamic>,
              allStandards: _standards,
            );

            // A row that was fetched earlier from a programme typed-text row
            // (e.g. "Reporting") is dropped; saving the plan removes it.
            final isFetchedTextOnly = row.selectedOfficeId == null &&
                row.selectedTeamId == null &&
                row.selectedIsoStandardIds.isEmpty &&
                row.standardTextController.text.trim().isEmpty &&
                programmeTextOnlyKeys.contains(
                  _textOnlyKey(
                    row.dayNumber,
                    row.officeTextController.text,
                  ),
                );
            if (isFetchedTextOnly) {
              row.dispose();
              continue;
            }

            _entries.add(row);
            _dayDates.putIfAbsent(row.dayNumber, () {
              final rawTime = e['time'] ?? e['Time'];
              final parsed = rawTime != null
                  ? DateTime.tryParse(rawTime.toString())
                  : null;
              return parsed != null
                  ? DateTime(parsed.year, parsed.month, parsed.day)
                  : DateTime.now();
            });
          }
        }
      }

      if (_entries.isEmpty) {
        if (programmeEntries.isEmpty) {
          _dayDates[1] = DateTime.now();
          _entries.add(_newOpeningMeetingRow());
        } else {
          final days = programmeEntries.map((e) => e.dayNumber).toSet().toList()
            ..sort();

          for (final day in days) {
            final dayEntries =
                programmeEntries.where((e) => e.dayNumber == day).toList()
                  ..sort(
                    (a, b) => (a.time.hour * 60 + a.time.minute).compareTo(
                      b.time.hour * 60 + b.time.minute,
                    ),
                  );

            _dayDates[day] = dayEntries
                    .firstWhere(
                      (e) => e.date != null,
                      orElse: () => dayEntries.first,
                    )
                    .date ??
                DateTime.now();

            if (day == 1) {
              _entries.add(_newOpeningMeetingRow());
            }

            for (final pe in dayEntries) {
              final row = AuditPlanEntryRow.fromProgrammeEntry(
                pe,
                allStandards: _standards,
              );
              row.populateResponsiblePersonsFromTeam(_auditorTeams);
              _entries.add(row);
            }
          }
        }
      }

      _normalizeSchedule();
    } catch (e) {
      _errorMessage = 'Error loading Audit Plan: $e';
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchMasterOffices() async {
    try {
      final offices = await _service.getOffices();
      final seen = <int>{};
      _offices = offices
          .map((o) => OfficeDto.fromJson(o.toJson()))
          .where((o) => seen.add(o.id))
          .toList();
    } catch (e) {
      debugPrint('Failed to load offices: $e');
    }
  }

  Future<void> _fetchMasterIsoStandards() async {
    try {
      final standards = await _service.getIsoStandards();
      final seen = <int>{};
      _standards = standards
          .map((s) => IsoStandardDto.fromJson(s.toJson()))
          .where((s) => seen.add(s.id))
          .toList();
    } catch (e) {
      debugPrint('Failed to load ISO standards: $e');
    }
  }

  Future<void> _fetchMasterTeams() async {
    try {
      final teams = await _service.getTeams();
      final seen = <int>{};
      _teams = teams
          .map((t) => TeamDto.fromJson(t.toJson()))
          .where((t) => seen.add(t.id))
          .toList();
    } catch (e) {
      debugPrint('Failed to load teams: $e');
    }
  }

  Future<void> _fetchMasterAuditorTeams() async {
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
              auditorName: (auditor.userId != null
                      ? nameByUserId[auditor.userId]
                      : null) ??
                  'Unnamed Auditor',
              isActive: team.isActive && auditor.isActive,
            ),
          );
        }
      }
      _auditorTeams = flattened;
    } catch (e) {
      debugPrint('Failed to load auditor teams: $e');
    }
  }

  int get _nextDayNumber => _dayDates.keys.isEmpty
      ? 1
      : (_dayDates.keys.reduce((a, b) => a > b ? a : b) + 1);

  void _addDay() {
    setState(() {
      final day = _nextDayNumber;
      final lastDate = _dayDates.values.isEmpty
          ? DateTime.now()
          : _dayDates.values.reduce((a, b) => a.isAfter(b) ? a : b);
      _dayDates[day] = lastDate.add(const Duration(days: 1));
      _entries.add(AuditPlanEntryRow(dayNumber: day));
    });
  }

  void _addRowToDay(int day) {
    setState(() => _entries.add(AuditPlanEntryRow(dayNumber: day)));
  }

  void _removeEntry(AuditPlanEntryRow entry) {
    setState(() {
      entry.dispose();
      _entries.remove(entry);
    });
  }

  void _removeDay(int day) {
    setState(() {
      final toRemove = _entries.where((e) => e.dayNumber == day).toList();
      for (final e in toRemove) {
        e.dispose();
      }
      _entries.removeWhere((e) => e.dayNumber == day);
      _dayDates.remove(day);
    });
  }

  Future<void> _pickDayDate(int day) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dayDates[day] ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryThemeColor,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _dayDates[day] = picked);
  }

  Future<void> _pickTime(AuditPlanEntryRow entry) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: entry.time,
    );
    if (picked != null) setState(() => entry.time = picked);
  }

  void _openPrintPreview() {
    final id = widget.auditPlanId;
    if (id == null) return;
    openAuditPlanPrintPreview(context, id);
  }

  /// Back to the programme picker (only when the programme was picked here).
  void _backToPicker() {
    setState(() {
      _resolvedProgrammeId = null;
      _errorMessage = null;
      for (final e in _entries) {
        e.dispose();
      }
      _entries.clear();
      _dayDates.clear();
    });
    if (_allProgrammes.isEmpty) _loadProgrammeList();
  }

  Widget _buildOfficeCombo(AuditPlanEntryRow entry) {
    return RawAutocomplete<OfficeDto>(
      textEditingController: entry.officeTextController,
      focusNode: entry.officeFocusNode,
      optionsBuilder: (value) {
        if (value.text.trim().isEmpty) return _offices;
        final query = value.text.trim().toLowerCase();
        return _offices.where((o) => o.name.toLowerCase().contains(query));
      },
      displayStringForOption: (o) => o.name,
      onSelected: (selection) =>
          setState(() => entry.selectedOfficeId = selection.id),
      fieldViewBuilder: (context, textController, focusNode, onFieldSubmitted) {
        return TextFormField(
          controller: textController,
          focusNode: focusNode,
          style: const TextStyle(fontSize: 12),
          decoration: _decoration('ORGANIZATIONAL UNIT AND PROCESS').copyWith(
            hintText: 'Select an office, or type e.g. "Opening Meeting"',
            hintStyle: const TextStyle(fontSize: 11),
            suffixIcon: const Icon(
              Icons.arrow_drop_down,
              color: primaryThemeColor,
            ),
          ),
          onChanged: (val) {
            final match = _offices.where((o) => o.name == val);
            entry.selectedOfficeId = match.isNotEmpty ? match.first.id : null;
          },
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(6),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 220, minWidth: 260),
              child: options.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        'No matches — your typed text will be saved as-is',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: options.length,
                      itemBuilder: (context, i) {
                        final option = options.elementAt(i);
                        return InkWell(
                          onTap: () => onSelected(option),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            child: Text(
                              option.name,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        );
      },
    );
  }

  InputDecoration _decoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: primaryThemeColor,
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
      isDense: true,
      filled: true,
      fillColor: const Color(0xFFFBFBFB),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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

  Future<int?> _save({bool showToast = true}) async {
    if (_resolvedProgrammeId == null) return null;

    final allDates = _dayDates.values.toList()..sort();
    final startDate = allDates.isNotEmpty ? allDates.first : DateTime.now();
    final endDate = allDates.isNotEmpty ? allDates.last : DateTime.now();

    final payload = {
      'id': widget.auditPlanId ?? 0,
      'planName': _programmeTitle.isNotEmpty
          ? '$_programmeTitle - Audit Plan'
          : 'Audit Plan',
      'auditProgrammeId': _resolvedProgrammeId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'entries': _entries
          .map(
            (e) => e.toBackendDtoJson(
              widget.auditPlanId ?? 0,
              dayDate: _dayDates[e.dayNumber] ?? DateTime.now(),
              allStandards: _standards,
            ),
          )
          .toList(),
    };

    setState(() => _isSaving = true);
    try {
      final res = await _auditPlanService.saveAuditPlanRaw(payload);
      final savedId = (res['id'] ?? widget.auditPlanId ?? 0) as int;
      if (showToast && mounted) {
        MotionToast.success(
          toastAlignment: Alignment.topCenter,
          description: const Text('Audit Plan saved'),
        ).show(context);
      }
      return savedId;
    } catch (e) {
      if (mounted) {
        MotionToast.error(
          toastAlignment: Alignment.topCenter,
          description: Text('Failed to save: $e'),
        ).show(context);
      }
      return null;
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _submitPlan() async {
    final hasRejection = _loadedPlan?.latestRejection != null;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(hasRejection ? 'Confirm Resubmit' : 'Confirm Submit'),
        content: Text(
          hasRejection
              ? 'Are you sure you want to resubmit this Audit Plan for approval?'
              : 'Are you sure you want to submit this Audit Plan for approval?',
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: primaryThemeColor),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(hasRejection ? 'Resubmit' : 'Submit',
                style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final planId = await _save(showToast: false);
    if (planId == null || planId <= 0) return;

    setState(() => _isSaving = true);
    try {
      final user = _currentUser ?? await AuthUtil.fetchLoggedUser();
      await _auditPlanService.submitAuditPlan(planId, userId: user?.id);
      if (!mounted) return;
      MotionToast.success(
        toastAlignment: Alignment.topCenter,
        description: Text(hasRejection
            ? 'Resubmitted for approval'
            : 'Submitted for approval'),
      ).show(context);
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      MotionToast.error(
        toastAlignment: Alignment.topCenter,
        description: Text('Failed: $e'),
      ).show(context);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _handleReject() async {
    if (widget.auditPlanId == null) return;
    final reason = await RejectionDialog.show(
      context,
      title: 'Reject Audit Plan',
      subtitle: 'Please provide the reason for rejecting this audit plan.',
    );
    if (reason == null) return;

    setState(() => _isSaving = true);
    try {
      final user = _currentUser ?? await AuthUtil.fetchLoggedUser();
      await _auditPlanService.decideAuditPlan(
        widget.auditPlanId!,
        approverId: user?.id ?? '',
        action: 'Reject',
        comments: reason,
      );
      if (!mounted) return;
      MotionToast.success(
        toastAlignment: Alignment.topCenter,
        description: const Text('Audit Plan rejected with comment.'),
      ).show(context);
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      MotionToast.error(
        toastAlignment: Alignment.topCenter,
        description: Text('Failed: $e'),
      ).show(context);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _handleDecide(String action) async {
    if (widget.auditPlanId == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Confirm $action'),
        content: Text('Are you sure you want to mark this Audit Plan as $action?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: action == 'Approve'
                  ? Colors.green.shade700
                  : primaryThemeColor,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(action, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _isSaving = true);
    try {
      final user = _currentUser ?? await AuthUtil.fetchLoggedUser();
      await _auditPlanService.decideAuditPlan(
        widget.auditPlanId!,
        approverId: user?.id ?? '',
        action: action,
      );
      if (!mounted) return;
      MotionToast.success(
        toastAlignment: Alignment.topCenter,
        description: Text('Audit Plan $action-d successfully.'),
      ).show(context);
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      MotionToast.error(
        toastAlignment: Alignment.topCenter,
        description: Text('Failed: $e'),
      ).show(context);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // ===========================================================================
  // Layout — identical shell to AuditProgrammePage
  // ===========================================================================
  @override
  Widget build(BuildContext context) {
    final showFooter =
        !_isLoading && _errorMessage == null && _resolvedProgrammeId != null;

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
              if (showFooter) _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final canBackToPicker =
        _resolvedProgrammeId != null && widget.programmeId == null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: primaryThemeColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      child: Row(
        children: [
          if (canBackToPicker)
            IconButton(
              tooltip: 'Back to list',
              onPressed: _backToPicker,
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              splashRadius: 20,
            ),
          Expanded(
            child: Text(
              widget.auditPlanId == null
                  ? 'CREATE AUDIT PLAN'
                  : 'EDIT AUDIT PLAN',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: 0.5,
              ),
            ),
          ),
          if (_loadedPlan?.approvalHistory.isNotEmpty == true)
            TextButton.icon(
              onPressed: () => ApprovalHistoryDialog.show(
                context,
                title: 'Audit Plan',
                history: _loadedPlan!.approvalHistory,
              ),
              icon: const Icon(Icons.history, color: Colors.white, size: 18),
              label: const Text(
                'History',
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          if (widget.auditPlanId != null)
            IconButton(
              onPressed: _openPrintPreview,
              icon: const Icon(Icons.print_outlined, color: Colors.white),
              tooltip: 'Print Preview',
              splashRadius: 20,
            ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, color: Colors.white),
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
    if (_resolvedProgrammeId == null) return _buildProgrammePicker();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_loadedPlan?.latestRejection != null)
            RejectionBanner(
              rejection: _loadedPlan!.latestRejection!,
              onViewHistory: () => ApprovalHistoryDialog.show(
                context,
                title: 'Audit Plan',
                history: _loadedPlan!.approvalHistory,
              ),
            ),
          if (_loadedPlan?.signatories.isNotEmpty == true)
            _buildSignatoriesCard(),
          _buildOverviewCard(),
          const SizedBox(height: 16),
          _buildScheduleCard(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    final status = _loadedPlan?.effectiveStatusName ?? 'Draft';
    final hasRejection = _loadedPlan?.latestRejection != null ||
        status == 'Revision Required' ||
        status == 'Rejected';
    final canShowDecisions = widget.auditPlanId != null &&
        (_isAdmin ||
            status == 'Pending' ||
            _loadedPlan?.signatories.isNotEmpty == true);

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
                onPressed: _isSaving ? null : () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: primaryThemeColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (widget.auditPlanId != null) ...[
                OutlinedButton.icon(
                  onPressed: _isSaving ? null : _openPrintPreview,
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
                const SizedBox(width: 8),
              ],
              OutlinedButton(
                onPressed: _isSaving ? null : () => _save(),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: primaryThemeColor),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  'SAVE AS DRAFT',
                  style: TextStyle(
                    color: primaryThemeColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _isSaving ? null : () => _submitPlan(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryThemeColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Text(
                  hasRejection
                      ? 'RESUBMIT FOR APPROVAL'
                      : 'SUBMIT FOR APPROVAL',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );

          final currentUserId = _currentUser?.id ?? '';
          final signatories = _loadedPlan?.signatories ?? [];
          final matchingSig =
              signatories.where((s) => s.signatoryId == currentUserId);
          final sigLabel = matchingSig.isNotEmpty
              ? (matchingSig.first.signatoryLabel ?? '').toUpperCase()
              : '';

          final canShowNoted =
              _isAdmin || sigLabel.contains('NOTE') || sigLabel.contains('QMS');
          final canShowApproveReject = _isAdmin ||
              sigLabel.contains('APPROV') ||
              sigLabel.contains('QMR');

          final rightActions = canShowDecisions
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (canShowNoted)
                      OutlinedButton.icon(
                        onPressed:
                            _isSaving ? null : () => _handleDecide('Noted'),
                        icon: const Icon(Icons.info_outline, size: 16),
                        label: const Text('NOTED'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: primaryThemeColor,
                          side: const BorderSide(color: primaryThemeColor),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    if (canShowApproveReject) ...[
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: _isSaving ? null : () => _handleReject(),
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
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed:
                            _isSaving ? null : () => _handleDecide('Approve'),
                        icon: const Icon(
                          Icons.check_circle_outline,
                          size: 16,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'APPROVE',
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
                  ],
                )
              : const SizedBox.shrink();

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  leftActions,
                  rightActions,
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProgrammePicker() {
    final approvedProgrammes = _allProgrammes.where((p) {
      final json = p.toJson();
      final status = (json['statusName'] ?? json['StatusName'])?.toString();
      return status == 'Approved';
    }).toList();

    if (approvedProgrammes.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'No Approved Audit Programmes found.\nSubmit a programme and have it approved before creating an Audit Plan.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: approvedProgrammes.length,
      itemBuilder: (context, i) {
        final p = approvedProgrammes[i];
        final json = p.toJson();
        final forText = (json['for'] ?? json['For'] ?? 'Untitled').toString();
        final year = (json['year'] ?? json['Year'] ?? '').toString();
        final id = (json['id'] ?? json['Id']) as int;

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
              '$forText — $year',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              'Approved • ${(json['purpose'] ?? json['Purpose'] ?? '').toString()}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: const Icon(Icons.chevron_right, color: primaryThemeColor),
            onTap: () {
              setState(() => _resolvedProgrammeId = id);
              _load();
            },
          ),
        );
      },
    );
  }

  Widget _buildSignatoriesCard() {
    final signatories = _loadedPlan?.signatories ?? [];
    if (signatories.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          Row(
            children: [
              const Icon(Icons.verified_user_outlined,
                  color: primaryThemeColor, size: 18),
              const SizedBox(width: 8),
              const Text(
                'IQA APPROVAL SIGNATORIES',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: primaryThemeColor,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              if (_loadedPlan?.approvalHistory.isNotEmpty == true)
                TextButton.icon(
                  onPressed: () => ApprovalHistoryDialog.show(
                    context,
                    title: 'Audit Plan',
                    history: _loadedPlan!.approvalHistory,
                  ),
                  icon: const Icon(Icons.history,
                      size: 16, color: primaryThemeColor),
                  label: const Text('View History',
                      style:
                          TextStyle(fontSize: 12, color: primaryThemeColor)),
                ),
            ],
          ),
          const Divider(height: 16),
          ...signatories.map((s) {
            final label = s.signatoryLabel ?? 'Signatory';
            final name = s.signatoryName ?? 'Unassigned';
            final status = s.approvalStatus ?? 'Pending';
            final date = s.dateSigned != null
                ? DateFormat('MMM d, yyyy h:mm a')
                    .format(s.dateSigned!.toLocal())
                : null;

            Color statusColor;
            IconData statusIcon;
            switch (status.toLowerCase()) {
              case 'approved':
                statusColor = Colors.green.shade700;
                statusIcon = Icons.check_circle_outline;
                break;
              case 'noted':
                statusColor = Colors.blue.shade700;
                statusIcon = Icons.info_outline;
                break;
              case 'rejected':
              case 'disapproved':
                statusColor = Colors.redAccent;
                statusIcon = Icons.cancel_outlined;
                break;
              default:
                statusColor = Colors.orange.shade800;
                statusIcon = Icons.access_time;
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Container(
                    width: 130,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3E9EA),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      label.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: primaryThemeColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                        if (date != null)
                          Text(
                            'Signed: $date',
                            style: TextStyle(
                                fontSize: 11, color: Colors.grey.shade600),
                          ),
                        if (s.remarks != null && s.remarks!.isNotEmpty)
                          Text(
                            '"${s.remarks}"',
                            style: TextStyle(
                                fontSize: 11,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey.shade700),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: statusColor.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusIcon, size: 14, color: statusColor),
                        const SizedBox(width: 4),
                        Text(
                          status,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildOverviewCard() {
    return _card(
      title: 'FOR: $_programmeTitle',
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(4),
        ),
        clipBehavior: Clip.antiAlias,
        child: Table(
          border: TableBorder(
            horizontalInside: BorderSide(color: Colors.grey.shade400),
          ),
          columnWidths: const {0: FixedColumnWidth(160)},
          children: [
            _overviewRow('Audit Objectives:', _programmeObjectives),
            _overviewRow('Scope of Audit:', _programmeScope),
          ],
        ),
      ),
    );
  }

  TableRow _overviewRow(String label, String value) {
    return TableRow(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
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
          padding: const EdgeInsets.all(12),
          child: Text(
            value.isNotEmpty ? value : '—',
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Schedule — same structure as the Audit Programme's schedule section:
  // a card with an "Add Day" button, a grey "DAY n — DATE" banner per day and
  // one bordered row card per entry.
  // ---------------------------------------------------------------------------
  Widget _buildScheduleCard() {
    final Map<int, List<int>> dayToIndices = {};
    for (var i = 0; i < _entries.length; i++) {
      dayToIndices.putIfAbsent(_entries[i].dayNumber, () => []).add(i);
    }
    final sortedDays = dayToIndices.keys.toList()..sort();

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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'SCHEDULE',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: primaryThemeColor,
                  letterSpacing: 0.5,
                ),
              ),
              ElevatedButton.icon(
                onPressed: _addDay,
                icon: const Icon(
                  Icons.calendar_month,
                  size: 16,
                  color: Colors.white,
                ),
                label: const Text(
                  'Add Day',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryThemeColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          for (final day in sortedDays) _buildDayGroup(day, dayToIndices[day]!),
        ],
      ),
    );
  }

  Widget _buildDayGroup(int day, List<int> indices) {
    final date = _dayDates[day] ?? DateTime.now();
    final fromProgramme = day == 1 &&
        _entries.any(
          (e) => e.dayNumber == 1 && e.sourceProgrammeEntryId != null,
        );

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFE5E5E5),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _pickDayDate(day),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'DAY $day — ${DateFormat('MMMM d, yyyy').format(date).toUpperCase()}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.edit_calendar,
                              size: 14,
                              color: primaryThemeColor,
                            ),
                          ],
                        ),
                        if (fromProgramme)
                          const Padding(
                            padding: EdgeInsets.only(top: 2),
                            child: Text(
                              'Date fetched from Audit Programme schedule',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                if (_dayDates.length > 1)
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      size: 18,
                      color: Colors.redAccent,
                    ),
                    tooltip: 'Remove Day',
                    onPressed: () => _removeDay(day),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          for (var k = 0; k < indices.length; k++) ...[
            if (k > 0) const SizedBox(height: 12),
            _buildEntryCard(indices[k], indices.length),
          ],
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => _addRowToDay(day),
              icon: const Icon(Icons.add, size: 16, color: primaryThemeColor),
              label: Text(
                'Add Row to Day $day',
                style: const TextStyle(fontSize: 12, color: primaryThemeColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntryCard(int index, int rowsInThisDay) {
    final entry = _entries[index];
    final safeTeamValue = _teams.any((t) => t.id == entry.selectedTeamId)
        ? entry.selectedTeamId
        : null;
    final hasRosterForTeam = entry.selectedTeamId != null &&
        _auditorTeams.any(
          (a) => a.teamId == entry.selectedTeamId && a.isActive,
        );

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

          final time = _timeCell(entry, rowsInThisDay);
          final office = _buildOfficeCombo(entry);
          final team = _teamAndResponsibleCell(
            entry,
            safeTeamValue,
            hasRosterForTeam,
          );
          final standard = _standardCell(entry);

          if (isWide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: time),
                const SizedBox(width: 8),
                Expanded(flex: 3, child: office),
                const SizedBox(width: 8),
                Expanded(flex: 4, child: team),
                const SizedBox(width: 8),
                Expanded(flex: 3, child: standard),
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              time,
              const SizedBox(height: 8),
              office,
              const SizedBox(height: 8),
              team,
              const SizedBox(height: 8),
              standard,
            ],
          );
        },
      ),
    );
  }

  Widget _timeCell(AuditPlanEntryRow entry, int rowsInThisDay) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (rowsInThisDay > 1)
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.redAccent,
                size: 16,
              ),
              tooltip: 'Remove Row',
              onPressed: () => _removeEntry(entry),
            ),
          ),
        InkWell(
          onTap: () => _pickTime(entry),
          child: InputDecorator(
            decoration: _decoration('TIME'),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  entry.time.format(context),
                  style: const TextStyle(fontSize: 12),
                ),
                const Icon(
                  Icons.access_time,
                  size: 14,
                  color: primaryThemeColor,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _standardCell(AuditPlanEntryRow entry) {
    return TextFormField(
      controller: entry.standardTextController,
      maxLines: null,
      minLines: 3,
      style: const TextStyle(fontSize: 12),
      decoration: _decoration('STANDARD').copyWith(
        hintText: 'e.g. 4.1, 4.2, 5.1, 6.2',
        hintStyle: const TextStyle(fontSize: 11),
      ),
    );
  }

  Widget _teamAndResponsibleCell(
    AuditPlanEntryRow entry,
    int? safeTeamValue,
    bool hasRosterForTeam,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<int>(
          initialValue: safeTeamValue,
          isExpanded: true,
          hint: const Text('Select Team', style: TextStyle(fontSize: 12)),
          decoration: _decoration('AUDIT TEAM'),
          items: _teams.isEmpty
              ? [
                  const DropdownMenuItem<int>(
                    value: null,
                    child: Text(
                      'No options available',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ]
              : _teams
                  .map(
                    (t) => DropdownMenuItem<int>(
                      value: t.id,
                      child: Text(
                        t.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  )
                  .toList(),
          onChanged: _teams.isEmpty
              ? null
              : (val) => setState(() => entry.selectedTeamId = val),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'PERSON RESPONSIBLE',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            if (hasRosterForTeam)
              TextButton.icon(
                onPressed: () => setState(
                  () => entry.populateResponsiblePersonsFromTeam(_auditorTeams),
                ),
                icon: const Icon(
                  Icons.group_add,
                  size: 13,
                  color: primaryThemeColor,
                ),
                label: const Text(
                  'Fetch from Team',
                  style: TextStyle(fontSize: 10, color: primaryThemeColor),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        for (var i = 0; i < entry.responsiblePersonControllers.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('•  ', style: TextStyle(fontSize: 12)),
                Expanded(
                  child: TextFormField(
                    controller: entry.responsiblePersonControllers[i],
                    style: const TextStyle(fontSize: 12),
                    decoration: const InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintText: 'Name or role',
                      hintStyle: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(
                    Icons.close,
                    size: 14,
                    color: Colors.redAccent,
                  ),
                  onPressed: () =>
                      setState(() => entry.removeResponsiblePersonAt(i)),
                ),
              ],
            ),
          ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () => setState(() => entry.addResponsiblePerson()),
            icon: const Icon(Icons.add, size: 13, color: primaryThemeColor),
            label: const Text(
              'Add Person / Role',
              style: TextStyle(fontSize: 11, color: primaryThemeColor),
            ),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _card({required String title, required Widget child}) {
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
}