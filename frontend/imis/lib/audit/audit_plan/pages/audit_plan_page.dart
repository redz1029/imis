// lib/audit/audit_plan/pages/audit_plan_page.dart
// NOTE: unrelated to this file — if lib/utils/page_list.dart has a broken
// stub method `map(AuditorTeamDto Function(json) param0) {}`, delete it.
// PageList<T> is not Iterable, so callers should use `.items.map(...)`
// instead of calling `.map(...)` directly on the PageList instance.

// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/audit/audit_plan/services/AuditPlanService.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:imis/auditor_team/services/auditor_team_service.dart';
import 'package:imis/audit/audit_plan/models/audit_plan.dart';
import 'package:imis/audit/audit_programme/services/audit_programme_service.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/common_services/common_service.dart';
import 'package:imis/user/models/user.dart';

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

  // "STANDARD" column — per the printed form this is a plain typed field
  // (e.g. "4.1, 4.2, 4.3, 5.1, 6.2"), NOT a dropdown / multi-select.
  final TextEditingController standardTextController;

  int? selectedTeamId;
  List<TextEditingController> responsiblePersonControllers;

  // Set when this row was generated from an Audit Programme entry — used so
  // the UI can show "fetched from Audit Programme" affordances.
  final int? sourceProgrammeEntryId;

  AuditPlanEntryRow({
    this.id,
    required this.dayNumber,
    TimeOfDay? time,
    this.selectedOfficeId,
    String? officeText,
    String? standardText,
    this.selectedTeamId,
    List<String>? responsiblePersons,
    this.sourceProgrammeEntryId,
  })  : time = time ?? const TimeOfDay(hour: 9, minute: 0),
        officeTextController = TextEditingController(text: officeText ?? ''),
        officeFocusNode = FocusNode(),
        standardTextController = TextEditingController(text: standardText ?? ''),
        responsiblePersonControllers = (responsiblePersons ?? const <String>[])
            .map((n) => TextEditingController(text: n))
            .toList();

  void addResponsiblePerson([String text = '']) {
    responsiblePersonControllers.add(TextEditingController(text: text));
  }

  void removeResponsiblePersonAt(int index) {
    responsiblePersonControllers.removeAt(index).dispose();
  }

  /// "This data will be fetch from audit programme" — pulls the active
  /// roster for the currently selected Team and replaces the responsible
  /// person list with it.
  void populateResponsiblePersonsFromTeam(List<AuditorTeamDto> allAuditorTeams) {
    if (selectedTeamId == null) return;
    final roster = allAuditorTeams.where((a) => a.teamId == selectedTeamId && a.isActive).toList()
      ..sort((a, b) => a.auditorName.compareTo(b.auditorName));
    if (roster.isEmpty) return;

    for (final c in responsiblePersonControllers) {
      c.dispose();
    }
    responsiblePersonControllers = roster.map((a) => TextEditingController(text: a.auditorName)).toList();
  }

  void dispose() {
    officeTextController.dispose();
    officeFocusNode.dispose();
    standardTextController.dispose();
    for (final c in responsiblePersonControllers) {
      c.dispose();
    }
  }

  /// Builds a row straight from an Audit Programme entry. [allStandards] is
  /// the master ISO-standard list, used to turn the Programme entry's
  /// standard IDs into the plain "4.1, 4.2, ..." text this column now uses.
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
      selectedTeamId: pe.teamId,
      sourceProgrammeEntryId: pe.id,
    );
  }

  factory AuditPlanEntryRow.fromJson(Map<String, dynamic> json) {
    int? officeId;
    String officeName = '';
    final processes = json['auditPlanProcesses'] ?? json['AuditPlanProcesses'];
    if (processes != null && (processes as List).isNotEmpty) {
      final item = processes[0];
      officeId = (item['officeId'] ?? item['OfficeId'] ?? item['office']?['id']) as int?;
      final rawName = item['processName'] ?? item['ProcessName'] ?? item['office']?['name'];
      officeName = rawName?.toString() ?? '';
    }

    // Prefer the new free-typed 'standardText' field. Fall back to
    // reconstructing it from any legacy isoStandardAuditPlans payload so
    // older saved records still display something sensible.
    String standardText = (json['standardText'] ?? json['StandardText'] ?? '').toString();
    if (standardText.isEmpty) {
      final standards = json['isoStandardAuditPlans'] ?? json['IsoStandardAuditPlans'];
      if (standards != null) {
        final labels = <String>[];
        for (final item in (standards as List)) {
          final label = item['clauseRef'] ??
              item['ClauseRef'] ??
              item['isoStandard']?['clauseRef'] ??
              item['isoStandard']?['ClauseRef'];
          if (label != null) labels.add(label.toString());
        }
        standardText = labels.join(', ');
      }
    }

    int? teamId;
    final auditors = json['isoAuditors'] ?? json['IsoAuditors'];
    if (auditors != null && (auditors as List).isNotEmpty) {
      final item = auditors[0];
      teamId = (item['teamId'] ?? item['TeamId'] ?? item['team']?['id']) as int?;
    }

    final List<String> responsibleNames = [];
    final responsible = json['responsiblePersons'] ?? json['ResponsiblePersons'];
    if (responsible != null) {
      for (final item in (responsible as List)) {
        final name = (item is String) ? item : (item['name'] ?? item['Name'] ?? '').toString();
        if (name.isNotEmpty) responsibleNames.add(name);
      }
    }

    TimeOfDay time = const TimeOfDay(hour: 9, minute: 0);
    final rawTime = json['time'] ?? json['Time'];
    if (rawTime != null) {
      final parsed = DateTime.tryParse(rawTime.toString());
      if (parsed != null) time = TimeOfDay(hour: parsed.toLocal().hour, minute: parsed.toLocal().minute);
    }

    return AuditPlanEntryRow(
      id: (json['id'] ?? json['Id']) as int?,
      dayNumber: (json['dayNumber'] ?? json['DayNumber'] ?? 1) as int,
      time: time,
      selectedOfficeId: officeId,
      officeText: officeName,
      standardText: standardText,
      selectedTeamId: teamId,
      responsiblePersons: responsibleNames,
    );
  }

  Map<String, dynamic> toBackendDtoJson(int auditPlanId, {required DateTime dayDate}) {
    final trimmedOfficeText = officeTextController.text.trim();
    final combined = DateTime(dayDate.year, dayDate.month, dayDate.day, time.hour, time.minute);

    return {
      'id': id ?? 0,
      'auditPlanId': auditPlanId,
      'dayNumber': dayNumber,
      'time': combined.toIso8601String(),
      'standardText': standardTextController.text.trim(),
      'auditPlanProcesses': trimmedOfficeText.isNotEmpty
          ? [
              {
                'id': 0,
                'officeId': selectedOfficeId,
                'processName': trimmedOfficeText,
                'auditPlanEntryId': 0,
              }
            ]
          : [],
      'isoAuditors': selectedTeamId != null
          ? [
              {'id': 0, 'teamId': selectedTeamId}
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

  /// Parses one entry from the Audit Programme's own draft schedule
  /// (`auditPlan[].entries[]`), which is shaped exactly like an
  /// AuditPlanEntryRow's backend DTO: auditPlanProcesses / isoStandardAuditPlans
  /// / isoAuditors / dayNumber / time. This is where "fetched from audit
  /// programme" data actually lives — the Programme has no separate flat
  /// "entries" field.
  factory ProgrammeEntrySummary.fromJson(Map<String, dynamic> json) {
    int? officeId;
    String processText = '';
    final processes = json['auditPlanProcesses'] ?? json['AuditPlanProcesses'];
    if (processes != null && (processes as List).isNotEmpty) {
      final item = processes[0];
      officeId = (item['officeId'] ?? item['OfficeId']) as int?;
      processText = (item['processName'] ?? item['ProcessName'] ?? '').toString();
    }

    final List<int> standardIds = [];
    final standards = json['isoStandardAuditPlans'] ?? json['IsoStandardAuditPlans'];
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
      clause.isNotEmpty && name != null && name!.isNotEmpty ? '$clause - $name' : (clause.isNotEmpty ? clause : (name ?? ''));
  factory IsoStandardDto.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'] ?? json['Id'] ?? 0;
    return IsoStandardDto(
      id: rawId is int ? rawId : int.parse(rawId.toString()),
      clause: json['clauseRef'] ?? json['ClauseRef'] ?? json['clause'] ?? json['Clause'] ?? '',
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
  AuditorTeamDto({required this.teamId, this.auditorId, required this.auditorName, required this.isActive});
  factory AuditorTeamDto.fromJson(Map<String, dynamic> json) => AuditorTeamDto(
        teamId: (json['teamId'] ?? json['TeamId'] ?? 0) as int,
        auditorId: (json['auditorId'] ?? json['AuditorId']) as int?,
        auditorName: (json['auditorName'] ?? json['AuditorName'] ?? 'Unnamed Auditor').toString(),
        isActive: (json['isActive'] ?? json['IsActive'] ?? true) == true,
      );
}

// =============================================================================
// 2. AUDIT PLAN PAGE
// =============================================================================

class AuditPlanPage extends StatefulWidget {
  // Optional — when known (e.g. navigating in from a specific Audit
  // Programme's detail view), pass it directly and the picker is skipped.
  // When null (e.g. the sidebar's "Create Audit Plan" entry, which has no
  // programme context), the page shows a Programme picker first.
  final int? programmeId;
  final int? auditPlanId;

  const AuditPlanPage({super.key, this.programmeId, this.auditPlanId});

  @override
  State<AuditPlanPage> createState() => _AuditPlanPageState();
}

class _AuditPlanPageState extends State<AuditPlanPage> {
  static const Color primaryThemeColor = Color(0xFF883942);
  static const Color headerFillColor = Color(0xFFF3E9EA);

  // Column proportions for the schedule table: TIME | ORGANIZATIONAL UNIT
  // AND PROCESS | AUDIT TEAM / PERSON RESPONSIBLE | STANDARD.
  static const List<int> _colFlex = [2, 3, 4, 3];

  final AuditProgrammeService _service = AuditProgrammeService(Dio());
  final AuditPlanService _auditPlanService = AuditPlanService(Dio());

  bool _isLoading = true;
  String? _errorMessage;

  // Picker state — used only when widget.programmeId is null.
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
      // Assumes AuditProgrammeService exposes a list-all method, same
      // pattern as getOffices()/getTeams(). Add it if it doesn't exist yet.
      _allProgrammes = await _service.getAllAuditProgrammes();
    } catch (e) {
      _errorMessage = 'Failed to load Audit Programmes: $e';
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await Future.wait([
        _fetchMasterOffices(),
        _fetchMasterIsoStandards(),
        _fetchMasterTeams(),
        _fetchMasterAuditorTeams(),
      ]);

      final programme = await _service.getAuditProgrammeById(_resolvedProgrammeId!);
      if (programme == null) throw Exception('Audit Programme not found');

      final jsonMap = programme.toJson();
      _programmeTitle = (jsonMap['for'] ?? jsonMap['For'] ?? 'Audit Programme').toString();
      _programmeScope = (jsonMap['scopeOfAudit'] ?? jsonMap['ScopeOfAudit'] ?? '').toString();

      final loadedObjectives = jsonMap['objectives'] as List? ?? jsonMap['Objectives'] as List? ?? [];
      _programmeObjectives = loadedObjectives
          .map((o) => (o['description'] ?? o['Description'] ?? '').toString())
          .where((s) => s.isNotEmpty)
          .join('\n');

      final sourcePlans = (jsonMap['auditPlan'] as List? ?? jsonMap['AuditPlans'] as List? ?? []);

      // The Programme's own draft schedule is where "fetched from audit
      // programme" data actually lives — flatten every day's entries out of
      // it here.
      final List<ProgrammeEntrySummary> programmeEntries = [];
      for (final plan in sourcePlans) {
        final planMap = plan as Map<String, dynamic>;
        final entriesList = (planMap['entries'] as List? ?? planMap['Entries'] as List? ?? []);
        for (final e in entriesList) {
          programmeEntries.add(ProgrammeEntrySummary.fromJson(e as Map<String, dynamic>));
        }
      }

      if (widget.auditPlanId != null) {
        final plans = (jsonMap['auditPlan'] as List? ?? jsonMap['AuditPlans'] as List? ?? []);
        final match = plans.cast<Map<String, dynamic>>().where((p) => (p['id'] ?? p['Id']) == widget.auditPlanId);
        if (match.isNotEmpty) {
          final plan = match.first;
          final entriesList = (plan['entries'] as List? ?? plan['Entries'] as List? ?? []);
          for (final e in entriesList) {
            final row = AuditPlanEntryRow.fromJson(e as Map<String, dynamic>);
            _entries.add(row);
            _dayDates.putIfAbsent(row.dayNumber, () {
              final rawTime = e['time'] ?? e['Time'];
              final parsed = rawTime != null ? DateTime.tryParse(rawTime.toString()) : null;
              return parsed != null ? DateTime(parsed.year, parsed.month, parsed.day) : DateTime.now();
            });
          }
        }
      }

      if (_entries.isEmpty) {
        if (programmeEntries.isEmpty) {
          // No draft schedule saved on the source Programme — start blank.
          _dayDates[1] = DateTime.now();
          _entries.add(AuditPlanEntryRow(
            dayNumber: 1,
            time: const TimeOfDay(hour: 9, minute: 0),
            officeText: 'Opening Meeting',
            responsiblePersons: const [
              'Top Management',
              'ISO Core Team',
              'QMR',
              'DQMRs',
              'IQA Lead Auditor',
              'IQA Members',
              'Department / Section / Unit Heads Concerned',
              'Consultants Concerned',
              'Chief Residents Concerned',
            ],
          ));
        } else {
          final days = programmeEntries.map((e) => e.dayNumber).toSet().toList()..sort();

          for (final day in days) {
            final dayEntries = programmeEntries.where((e) => e.dayNumber == day).toList()
              ..sort((a, b) => (a.time.hour * 60 + a.time.minute).compareTo(b.time.hour * 60 + b.time.minute));

            // "THIS DAY 1 IS FETCH FROM AUDIT PROGRAMME" — each day's date
            // is pulled straight from the Programme's own saved schedule.
            _dayDates[day] = dayEntries.firstWhere((e) => e.date != null, orElse: () => dayEntries.first).date ??
                DateTime.now();

            if (day == 1) {
              _entries.add(AuditPlanEntryRow(
                dayNumber: 1,
                time: const TimeOfDay(hour: 9, minute: 0),
                officeText: 'Opening Meeting',
                responsiblePersons: const [
                  'Top Management',
                  'ISO Core Team',
                  'QMR',
                  'DQMRs',
                  'IQA Lead Auditor',
                  'IQA Members',
                  'Department / Section / Unit Heads Concerned',
                  'Consultants Concerned',
                  'Chief Residents Concerned',
                ],
              ));
            }

            // "This data will be fetch from audit programme" — Team is
            // pulled from the Programme entry, and Person Responsible is
            // filled from that Team's active roster immediately.
            for (final pe in dayEntries) {
              final row = AuditPlanEntryRow.fromProgrammeEntry(pe, allStandards: _standards);
              row.populateResponsiblePersonsFromTeam(_auditorTeams);
              _entries.add(row);
            }
          }
        }
      }
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
      _offices = offices.map((o) => OfficeDto.fromJson(o.toJson())).where((o) => seen.add(o.id)).toList();
    } catch (e) {
      debugPrint('Failed to load offices: $e');
    }
  }

  Future<void> _fetchMasterIsoStandards() async {
    try {
      final standards = await _service.getIsoStandards();
      final seen = <int>{};
      _standards = standards.map((s) => IsoStandardDto.fromJson(s.toJson())).where((s) => seen.add(s.id)).toList();
    } catch (e) {
      debugPrint('Failed to load ISO standards: $e');
    }
  }

  Future<void> _fetchMasterTeams() async {
    try {
      final teams = await _service.getTeams();
      final seen = <int>{};
      _teams = teams.map((t) => TeamDto.fromJson(t.toJson())).where((t) => seen.add(t.id)).toList();
    } catch (e) {
      debugPrint('Failed to load teams: $e');
    }
  }

  /// Fetches every AuditorTeam (each holding a list of Auditor records that
  /// only carry a userId, not a display name) plus the full User list, then
  /// flattens both into the {teamId, auditorId, auditorName, isActive} shape
  /// that AuditorTeamDto / populateResponsiblePersonsFromTeam expect.
  ///
  /// Mirrors the join AuditorTeamPage.getUserFullName() already does.
  Future<void> _fetchMasterAuditorTeams() async {
    try {
      final auditorTeamsService = AuditorTeamService(Dio());
      final commonService = CommonService(Dio());

      final teams = await auditorTeamsService.getAuditorTeams();
      final List<User> users = await commonService.fetchUsers();
      final Map<String, String> nameByUserId = {
        for (final u in users) u.id: u.fullName,
      };

      final List<AuditorTeamDto> flattened = [];
      for (final team in teams) {
        for (final auditor in team.auditors) {
          if (auditor.isDeleted) continue;
          flattened.add(AuditorTeamDto(
            teamId: team.teamId,
            auditorId: auditor.id,
            auditorName: (auditor.userId != null ? nameByUserId[auditor.userId] : null) ?? 'Unnamed Auditor',
            isActive: team.isActive && auditor.isActive,
          ));
        }
      }
      _auditorTeams = flattened;
    } catch (e) {
      debugPrint('Failed to load auditor teams: $e');
    }
  }

  int get _nextDayNumber => _dayDates.keys.isEmpty ? 1 : (_dayDates.keys.reduce((a, b) => a > b ? a : b) + 1);

  void _addDay() {
    setState(() {
      final day = _nextDayNumber;
      final lastDate =
          _dayDates.values.isEmpty ? DateTime.now() : _dayDates.values.reduce((a, b) => a.isAfter(b) ? a : b);
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
            colorScheme: const ColorScheme.light(primary: primaryThemeColor, onPrimary: Colors.white),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _dayDates[day] = picked);
  }

  Future<void> _pickTime(AuditPlanEntryRow entry) async {
    final picked = await showTimePicker(context: context, initialTime: entry.time);
    if (picked != null) setState(() => entry.time = picked);
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
      onSelected: (selection) => setState(() => entry.selectedOfficeId = selection.id),
      fieldViewBuilder: (context, textController, focusNode, onFieldSubmitted) {
        return TextFormField(
          controller: textController,
          focusNode: focusNode,
          style: const TextStyle(fontSize: 12),
          decoration: _decoration('ORGANIZATIONAL UNIT AND PROCESS').copyWith(
            hintText: 'Select an office, or type e.g. "Opening Meeting"',
            hintStyle: const TextStyle(fontSize: 11),
            suffixIcon: const Icon(Icons.arrow_drop_down, color: primaryThemeColor),
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
                      child: Text('No matches — your typed text will be saved as-is',
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
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
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            child: Text(option.name, style: const TextStyle(fontSize: 12)),
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
      labelStyle: const TextStyle(color: primaryThemeColor, fontSize: 11, fontWeight: FontWeight.w600),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: Colors.grey.shade300)),
      enabledBorder:
          OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: Colors.grey.shade300)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: primaryThemeColor, width: 1.5)),
    );
  }

  Future<void> _save() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Save'),
        content: const Text('Save this Audit Plan?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('No', style: TextStyle(color: primaryThemeColor))),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Yes', style: TextStyle(color: primaryThemeColor))),
        ],
      ),
    );
    if (confirm != true) return;
    if (_resolvedProgrammeId == null) return;

    final allDates = _dayDates.values.toList()..sort();
    final startDate = allDates.isNotEmpty ? allDates.first : DateTime.now();
    final endDate = allDates.isNotEmpty ? allDates.last : DateTime.now();

    final payload = {
      'id': widget.auditPlanId ?? 0,
      'auditProgrammeId': _resolvedProgrammeId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'planStatus': 'PendingApproval',
      'entries': _entries
          .map((e) => e.toBackendDtoJson(widget.auditPlanId ?? 0, dayDate: _dayDates[e.dayNumber] ?? DateTime.now()))
          .toList(),
    };

    try {
      final plan = AuditPlan.fromJson(payload);
      await _auditPlanService.saveAuditPlan(plan);
      if (!mounted) return;
      MotionToast.success(toastAlignment: Alignment.topCenter, description: const Text('Audit Plan saved')).show(context);
    } catch (e) {
      if (!mounted) return;
      MotionToast.error(toastAlignment: Alignment.topCenter, description: Text('Failed to save: $e')).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: Text(widget.auditPlanId == null ? 'Create Audit Plan' : 'Edit Audit Plan'),
        backgroundColor: mainBgColor,
        leading: (_resolvedProgrammeId != null && widget.programmeId == null)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                tooltip: 'Back to list',
                onPressed: () => setState(() {
                  _resolvedProgrammeId = null;
                  _errorMessage = null;
                  for (final e in _entries) {
                    e.dispose();
                  }
                  _entries.clear();
                  _dayDates.clear();
                }),
              )
            : null,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryThemeColor))
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)))
              : _resolvedProgrammeId == null
                  ? _buildProgrammePicker()
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildOverviewCard(),
                          const SizedBox(height: 16),
                          _buildScheduleCard(),
                          const SizedBox(height: 24),
                          SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryThemeColor,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                              ),
                              onPressed: _save,
                              child: const Text('SAVE AUDIT PLAN', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }

  /// Shown when no programmeId was passed in (e.g. from the sidebar) — lets
  /// the user pick which Audit Programme to build a Plan for.
  Widget _buildProgrammePicker() {
    if (_allProgrammes.isEmpty) {
      return const Center(child: Text('No Audit Programmes found.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: _allProgrammes.length,
      itemBuilder: (context, i) {
        final p = _allProgrammes[i];
        final json = p.toJson();
        final forText = (json['for'] ?? json['For'] ?? 'Untitled').toString();
        final year = (json['year'] ?? json['Year'] ?? '').toString();
        final id = (json['id'] ?? json['Id']) as int;

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))],
          ),
          child: ListTile(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('$forText — $year', style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text((json['purpose'] ?? json['Purpose'] ?? '').toString(), maxLines: 1, overflow: TextOverflow.ellipsis),
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

  // ---------------------------------------------------------------------
  // Objectives / Scope — rendered as a bordered two-column table, matching
  // the printed form's "Audit Objectives / Scope of Audit" block.
  // ---------------------------------------------------------------------
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
          border: TableBorder(horizontalInside: BorderSide(color: Colors.grey.shade400)),
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
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: primaryThemeColor)),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(value.isNotEmpty ? value : '—', style: const TextStyle(fontSize: 12)),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------
  // Schedule — a real bordered table with a "DAY N — DATE" banner row
  // spanning the full width above each day's group of entry rows.
  // ---------------------------------------------------------------------
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
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('SCHEDULE',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: primaryThemeColor, letterSpacing: 0.5)),
              ElevatedButton.icon(
                onPressed: _addDay,
                icon: const Icon(Icons.calendar_month, size: 16, color: Colors.white),
                label: const Text('Add Day', style: TextStyle(color: Colors.white, fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryThemeColor,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(4)),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTableHeaderRow(),
                for (final day in sortedDays) ...[
                  _buildDayBannerRow(day),
                  for (final i in dayToIndices[day]!) _buildTableEntryRow(i, dayToIndices[day]!.length),
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () => _addRowToDay(day),
                        icon: const Icon(Icons.add, size: 16, color: primaryThemeColor),
                        label: Text('Add Row to Day $day', style: const TextStyle(fontSize: 12, color: primaryThemeColor)),
                        style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 0)),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeaderRow() {
    return Container(
      decoration: BoxDecoration(
        color: headerFillColor,
        border: Border(bottom: BorderSide(color: Colors.grey.shade400)),
      ),
      child: Row(
        children: [
          _headerCell('TIME', _colFlex[0]),
          _vDivider(),
          _headerCell('ORGANIZATIONAL UNIT AND PROCESS', _colFlex[1]),
          _vDivider(),
          _headerCell('AUDIT TEAM / PERSON RESPONSIBLE', _colFlex[2]),
          _vDivider(),
          _headerCell('STANDARD', _colFlex[3]),
        ],
      ),
    );
  }

  Widget _headerCell(String label, int flex) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: primaryThemeColor, letterSpacing: 0.3),
        ),
      ),
    );
  }

  Widget _vDivider() => Container(width: 1, color: Colors.grey.shade400);

  /// "DAY N — DATE" banner spanning the full table width. For Day 1 on a
  /// freshly generated plan, the date was sourced from the Audit
  /// Programme's own schedule (see `_load`) — shown with a small caption.
  Widget _buildDayBannerRow(int day) {
    final date = _dayDates[day] ?? DateTime.now();
    final fromProgramme = day == 1 && _entries.any((e) => e.dayNumber == 1 && e.sourceProgrammeEntryId != null);

    return Container(
      width: double.infinity,
      color: const Color(0xFFE5E5E5),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
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
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.edit_calendar, size: 14, color: primaryThemeColor),
                    ],
                  ),
                  if (fromProgramme)
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Text(
                        'Date fetched from Audit Programme schedule',
                        style: TextStyle(fontSize: 10, color: Colors.grey, fontStyle: FontStyle.italic),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (_dayDates.length > 1)
            IconButton(
              icon: const Icon(Icons.close, size: 18, color: Colors.redAccent),
              tooltip: 'Remove Day',
              onPressed: () => _removeDay(day),
            ),
        ],
      ),
    );
  }

  Widget _buildTableEntryRow(int index, int rowsInThisDay) {
    final entry = _entries[index];
    final safeTeamValue = _teams.any((t) => t.id == entry.selectedTeamId) ? entry.selectedTeamId : null;
    final hasRosterForTeam = entry.selectedTeamId != null && _auditorTeams.any((a) => a.teamId == entry.selectedTeamId && a.isActive);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(flex: _colFlex[0], child: _cellPad(_timeCell(entry, rowsInThisDay))),
            _vDivider(),
            Expanded(flex: _colFlex[1], child: _cellPad(_buildOfficeCombo(entry))),
            _vDivider(),
            Expanded(flex: _colFlex[2], child: _cellPad(_teamAndResponsibleCell(entry, safeTeamValue, hasRosterForTeam))),
            _vDivider(),
            Expanded(flex: _colFlex[3], child: _cellPad(_standardCell(entry))),
          ],
        ),
      ),
    );
  }

  Widget _cellPad(Widget child) => Padding(padding: const EdgeInsets.all(8), child: child);

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
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 16),
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
                Text(entry.time.format(context), style: const TextStyle(fontSize: 12)),
                const Icon(Icons.access_time, size: 14, color: primaryThemeColor),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Free-typed "STANDARD" field — e.g. "4.1, 4.2, 4.3, 5.1, 6.2" — per the
  /// printed form. No dropdown / selection dialog.
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

  Widget _teamAndResponsibleCell(AuditPlanEntryRow entry, int? safeTeamValue, bool hasRosterForTeam) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<int>(
          value: safeTeamValue,
          isExpanded: true,
          hint: const Text('Select Team', style: TextStyle(fontSize: 12)),
          decoration: _decoration('AUDIT TEAM'),
          items: _teams.isEmpty
              ? [const DropdownMenuItem<int>(value: null, child: Text('No options available', style: TextStyle(fontSize: 12)))]
              : _teams
                  .map((t) => DropdownMenuItem<int>(value: t.id, child: Text(t.name, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12))))
                  .toList(),
          onChanged: _teams.isEmpty ? null : (val) => setState(() => entry.selectedTeamId = val),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('PERSON RESPONSIBLE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.grey.shade700)),
            if (hasRosterForTeam)
              TextButton.icon(
                onPressed: () => setState(() => entry.populateResponsiblePersonsFromTeam(_auditorTeams)),
                icon: const Icon(Icons.group_add, size: 13, color: primaryThemeColor),
                label: const Text('Fetch from Team', style: TextStyle(fontSize: 10, color: primaryThemeColor)),
                style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 0)),
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
                  icon: const Icon(Icons.close, size: 14, color: Colors.redAccent),
                  onPressed: () => setState(() => entry.removeResponsiblePersonAt(i)),
                ),
              ],
            ),
          ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () => setState(() => entry.addResponsiblePerson()),
            icon: const Icon(Icons.add, size: 13, color: primaryThemeColor),
            label: const Text('Add Person / Role', style: TextStyle(fontSize: 11, color: primaryThemeColor)),
            style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 0)),
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
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: primaryThemeColor)),
          const Divider(height: 20),
          child,
        ],
      ),
    );
  }
}