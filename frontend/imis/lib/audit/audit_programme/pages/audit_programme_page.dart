import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';

import 'package:imis/audit/audit_programme/services/audit_programme_service.dart';
import 'package:imis/audit/audit_programme/models/audit_programme.dart';

// =============================================================================
// 1. DATA MODELS & DTO ADAPTERS MATCHING C# BACKEND
// =============================================================================

class AuditPlanEntryRow {
  int? id;
  int dayNumber;

  // "Organizational Unit and Processes" — editable combo box:
  // - selectedOfficeId is set when the typed text matches a known office
  //   exactly (or the user picked one from the suggestion list).
  // - officeText always holds whatever is currently in the box (free text
  //   allowed).
  int? selectedOfficeId;
  String officeText;

  // "Standard Chapter" — multi-select: a list of ISO standard IDs.
  List<int> selectedIsoStandardIds;

  // Time-of-day for this row, e.g. "9:00 AM" — the date component comes
  // from the day group's date, not from here.
  TimeOfDay time;

  int? selectedTeamId;

  final TextEditingController officeTextController;
  final FocusNode officeFocusNode;

  AuditPlanEntryRow({
    this.id,
    required this.dayNumber,
    this.selectedOfficeId,
    String? officeText,
    List<int>? selectedIsoStandardIds,
    TimeOfDay? time,
    this.selectedTeamId,
  })  : officeText = officeText ?? '',
        selectedIsoStandardIds = selectedIsoStandardIds ?? <int>[],
        time = time ?? const TimeOfDay(hour: 9, minute: 0),
        officeTextController = TextEditingController(text: officeText ?? ''),
        officeFocusNode = FocusNode();

  void dispose() {
    officeTextController.dispose();
    officeFocusNode.dispose();
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

    final List<int> standardIds = [];
    final standards = json['isoStandardAuditPlans'] ?? json['IsoStandardAuditPlans'];
    if (standards != null) {
      for (final item in (standards as List)) {
        final rawStdId = item['isoStandardId'] ?? item['IsoStandardId'] ?? item['isoStandard']?['id'];
        if (rawStdId != null) {
          final parsed = rawStdId is int ? rawStdId : int.tryParse(rawStdId.toString());
          if (parsed != null) standardIds.add(parsed);
        }
      }
    }

    int? teamId;
    final auditors = json['isoAuditors'] ?? json['IsoAuditors'];
    if (auditors != null && (auditors as List).isNotEmpty) {
      final item = auditors[0];
      teamId = (item['teamId'] ?? item['TeamId'] ?? item['team']?['id']) as int?;
    }

    TimeOfDay time = const TimeOfDay(hour: 9, minute: 0);
    final rawTime = json['time'] ?? json['Time'];
    if (rawTime != null) {
      final parsed = DateTime.tryParse(rawTime.toString());
      if (parsed != null) {
        time = TimeOfDay(hour: parsed.toLocal().hour, minute: parsed.toLocal().minute);
      }
    }

    return AuditPlanEntryRow(
      id: (json['id'] ?? json['Id']) as int?,
      dayNumber: (json['dayNumber'] ?? json['DayNumber'] ?? 1) as int,
      selectedOfficeId: officeId,
      officeText: officeName,
      selectedIsoStandardIds: standardIds,
      time: time,
      selectedTeamId: teamId,
    );
  }

  /// [dayDate] is the day group's date — combined with this row's [time] to
  /// produce the full timestamp the backend expects.
  Map<String, dynamic> toBackendDtoJson(int auditPlanId, {required DateTime dayDate}) {
    final trimmedOfficeText = officeText.trim();
    final combined = DateTime(dayDate.year, dayDate.month, dayDate.day, time.hour, time.minute);

    return {
      'id': id ?? 0,
      'auditPlanId': auditPlanId,
      'dayNumber': dayNumber,
      'time': combined.toIso8601String(),
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
      'isoStandardAuditPlans': selectedIsoStandardIds
          .map((sid) => {'id': 0, 'isoStandardId': sid})
          .toList(),
      'isoAuditors': selectedTeamId != null
          ? [
              {'id': 0, 'teamId': selectedTeamId}
            ]
          : [],
    };
  }
}

class OfficeDto {
  final int id;
  final String name;

  OfficeDto({required this.id, required this.name});

  factory OfficeDto.fromJson(Map<String, dynamic> json) {
    return OfficeDto(
      id: json['id'] ?? json['Id'] ?? 0,
      name: json['name'] ?? json['Name'] ?? 'Unnamed Office',
    );
  }
}

class IsoStandardDto {
  final int id;
  final String clause;
  final String? name;

  IsoStandardDto({required this.id, required this.clause, this.name});

  String get displayLabel {
    if (clause.isNotEmpty && name != null && name!.isNotEmpty) {
      return '$clause - $name';
    }
    return clause.isNotEmpty ? clause : (name ?? '');
  }

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

  factory TeamDto.fromJson(Map<String, dynamic> json) {
    return TeamDto(
      id: json['id'] ?? json['Id'] ?? 0,
      name: json['name'] ?? json['Name'] ?? 'Unnamed Team',
    );
  }
}

// =============================================================================
// 2. MAIN PROGRAMME PAGE
// =============================================================================

class AuditProgrammePage extends StatefulWidget {
  final int? programmeId;

  const AuditProgrammePage({super.key, this.programmeId});

  @override
  State<AuditProgrammePage> createState() => _AuditProgrammePageState();
}

class _AuditProgrammePageState extends State<AuditProgrammePage> {
  static const Color primaryThemeColor = Color(0xFF883942);

  final AuditProgrammeService _service = AuditProgrammeService(Dio());

  final TextEditingController _forController = TextEditingController(text: 'ISO-QMR');
  final TextEditingController _fromController = TextEditingController(text: 'Internal Quality Audit Committee');
  final TextEditingController _purposeController = TextEditingController(
    text: 'Preparation and submission for approval of the ISO Internal Quality Audit Programme.',
  );
  final TextEditingController _internalAuditSchedController = TextEditingController(
    text: 'Internal Quality Audit will be conducted on April 25 – 28, May 23 – 26, and July 4, 2023.\n\n'
          'Follow-up/Revisit Internal Audit will be conducted on October 3 – 5, October 24 – 26, and November 8, 2023.',
  );
  final TextEditingController _auditPlanObjectiveController = TextEditingController(
    text: 'To properly manage the implementation of the Internal Quality Audit activities as per scheduled audit plan.',
  );
  final TextEditingController _scopeOfAuditController = TextEditingController(
    text: 'Management Processes, all Core Processes, and Support Processes of all Departments/Sections/Units of the Organization.',
  );
  final TextEditingController _objectivesController = TextEditingController(
    text: '1. To determine the adequacy of the documented quality management system in conformance to the ISO 9001:2015 standards and other regulatory and statutory requirements;\n'
          '2. To verify legal compliance and adherence to the quality policy and achievement of its objectives and targets; and\n'
          '3. To determine areas for improvement on all processes including the status of active nonconformities and customer satisfaction surveys.',
  );
  final TextEditingController _scopeController = TextEditingController(
    text: 'All Departments/Sections/Units shall be audited twice a year. The first internal audit will be conducted on the second quarter and the follow-up audit will be conducted on the fourth quarter of the year.',
  );
  final TextEditingController _criteriaController = TextEditingController(
    text: 'Audit criteria is based on the data presented from the documents and records and are as follows:\n'
          '1. ISO 9001:2015\n2. Quality Manual\n3. Quality Objectives\n4. Standard Operating Procedure\n5. Statutory, regulatory laws and other applicable laws affecting the Organization',
  );
  final TextEditingController _methodologyController = TextEditingController(
    text: 'Auditors may use the following Audit Methodologies:\n'
          '1. IQA Procedure\n2. Using the P-D-C-A Approach/Checklist\n3. QOC - Questions-Observe-Check Method\n4. Others as applicable',
  );
  final TextEditingController _auditorSelectionController = TextEditingController(
    text: 'The QMR shall select and evaluate based on the IQA Procedure.',
  );
  final TextEditingController _reportingController = TextEditingController(
    text: 'Results of audits shall be presented during the closing meeting. Final audit reports shall be submitted 1 week after the conduct of each audit.',
  );
  final TextEditingController _verificationController = TextEditingController(
    text: 'All nonconformities still open shall be verified on the next audit.',
  );
  final TextEditingController _limitationsController = TextEditingController(
    text: 'In order to advocate independence as an audit principle, cross posting of auditors will be implemented. In no case will any auditor be assigned to audit his/her own work or his/her division.',
  );

  final List<AuditPlanEntryRow> _entries = [];

  // One date per day number, e.g. {1: May 20 2025, 2: May 21 2025} — this is
  // what renders in each "DAY N — <date>" banner.
  final Map<int, DateTime> _dayDates = {};

  List<OfficeDto> _offices = [];
  List<IsoStandardDto> _standards = [];
  List<TeamDto> _teams = [];

  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadAllFormData();
  }

  @override
  void dispose() {
    _forController.dispose();
    _fromController.dispose();
    _purposeController.dispose();
    _internalAuditSchedController.dispose();
    _auditPlanObjectiveController.dispose();
    _scopeOfAuditController.dispose();
    _objectivesController.dispose();
    _scopeController.dispose();
    _criteriaController.dispose();
    _methodologyController.dispose();
    _auditorSelectionController.dispose();
    _reportingController.dispose();
    _verificationController.dispose();
    _limitationsController.dispose();
    for (final entry in _entries) {
      entry.dispose();
    }
    super.dispose();
  }

  Future<void> _loadAllFormData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await Future.wait([
        _fetchMasterOffices(),
        _fetchMasterIsoStandards(),
        _fetchMasterTeams(),
      ]);

      if (widget.programmeId != null) {
        final programme = await _service.getAuditProgrammeById(widget.programmeId!);

        if (programme != null) {
          final jsonMap = programme.toJson();

          _forController.text = jsonMap['for'] ?? jsonMap['For'] ?? '';
          _fromController.text = jsonMap['from'] ?? jsonMap['From'] ?? '';
          _purposeController.text = jsonMap['purpose'] ?? jsonMap['Purpose'] ?? '';
          _internalAuditSchedController.text =
              jsonMap['internalAuditSched'] ?? jsonMap['InternalAuditSched'] ?? '';
          _scopeController.text = jsonMap['scopeAndFreqAudit'] ?? jsonMap['ScopeAndFreqAudit'] ?? '';

          final loadedObjectives = jsonMap['objectives'] as List? ?? jsonMap['Objectives'] as List? ?? [];
          if (loadedObjectives.isNotEmpty) {
            _objectivesController.text = loadedObjectives
                .map((o) => (o['description'] ?? o['Description'] ?? '').toString())
                .where((line) => line.isNotEmpty)
                .join('\n');
          }

          _auditPlanObjectiveController.text = jsonMap['auditPlanObjective'] ?? jsonMap['AuditPlanObjective'] ?? '';
          _scopeOfAuditController.text = jsonMap['scopeOfAudit'] ?? jsonMap['ScopeOfAudit'] ?? '';

          _criteriaController.text = jsonMap['auditCriteria'] ?? jsonMap['AuditCriteria'] ?? '';
          _methodologyController.text = jsonMap['auditMethodology'] ?? jsonMap['AuditMethodology'] ?? '';
          _auditorSelectionController.text = jsonMap['selectionAndEvaluationOfAuditors'] ?? jsonMap['SelectionAndEvaluationOfAuditors'] ?? '';
          _reportingController.text = jsonMap['reporting'] ?? jsonMap['Reporting'] ?? '';
          _verificationController.text = jsonMap['verificationOfPreviousNonconformities'] ?? jsonMap['VerificationOfPreviousNonconformities'] ?? '';
          _limitationsController.text = jsonMap['auditLimitations'] ?? jsonMap['AuditLimitations'] ?? '';

          final auditPlans = jsonMap['auditPlan'] as List? ?? jsonMap['AuditPlans'] as List? ?? [];

          for (var plan in auditPlans) {
            final entriesList = plan['entries'] as List? ?? plan['Entries'] as List? ?? [];
            for (var entryJson in entriesList) {
              final row = AuditPlanEntryRow.fromJson(entryJson);
              _entries.add(row);

              // Derive this day's banner date from the first entry seen for
              // that day (its 'time' field carries the full date+time).
              if (!_dayDates.containsKey(row.dayNumber)) {
                final rawTime = entryJson['time'] ?? entryJson['Time'];
                final parsed = rawTime != null ? DateTime.tryParse(rawTime.toString()) : null;
                _dayDates[row.dayNumber] = parsed != null
                    ? DateTime(parsed.year, parsed.month, parsed.day)
                    : DateTime.now();
              }
            }
          }
        }
      }

      if (_entries.isEmpty) {
        _dayDates[1] = DateTime.now();
        _entries.add(AuditPlanEntryRow(dayNumber: 1));
      }
    } catch (e) {
      _errorMessage = 'Error loading form data: $e';
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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

  int get _nextDayNumber =>
      _dayDates.keys.isEmpty ? 1 : (_dayDates.keys.reduce((a, b) => a > b ? a : b) + 1);

  /// Adds a brand-new day banner (defaults to the day after the latest
  /// existing day) with one blank entry row under it.
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

  /// Adds another entry row under an existing day.
  void _addRowToDay(int day) {
    setState(() {
      _entries.add(AuditPlanEntryRow(dayNumber: day));
    });
  }

  void _removeEntry(AuditPlanEntryRow entry) {
    setState(() {
      entry.dispose();
      _entries.remove(entry);
    });
  }

  /// Removes an entire day and every entry under it. Disabled when it's the
  /// only remaining day.
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
    if (picked != null) {
      setState(() => _dayDates[day] = picked);
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: primaryThemeColor, fontSize: 13, fontWeight: FontWeight.bold),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: primaryThemeColor))
            : _errorMessage != null
                ? Center(child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)))
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          widget.programmeId == null ? 'Create Audit Programme' : 'Edit Audit Programme',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black87),
                        ),
                        const SizedBox(height: 20),

                        _buildCard(
                          title: 'PROGRAMME HEADER',
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _forController,
                                      decoration: _inputDecoration('FOR'),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _fromController,
                                      decoration: _inputDecoration('FROM'),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _purposeController,
                                maxLines: 2,
                                decoration: _inputDecoration('PURPOSE'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        _buildCard(
                          title: 'I. OBJECTIVES & II. SCOPE AND FREQUENCY OF AUDIT',
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _objectivesController,
                                maxLines: 4,
                                decoration: _inputDecoration('I. OBJECTIVES'),
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _scopeController,
                                maxLines: 3,
                                decoration: _inputDecoration('II. SCOPE AND FREQUENCY OF AUDIT'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // III. Internal Audit Schedule (narrative) + day-grouped entries
                        AuditPlanEntriesSection(
                          internalAuditSchedController: _internalAuditSchedController,
                          auditPlanObjectiveController: _auditPlanObjectiveController,
                          scopeOfAuditController: _scopeOfAuditController,
                          entries: _entries,
                          dayDates: _dayDates,
                          offices: _offices,
                          standards: _standards,
                          teams: _teams,
                          onAddDay: _addDay,
                          onAddRowToDay: _addRowToDay,
                          onRemoveEntry: _removeEntry,
                          onRemoveDay: _removeDay,
                          onPickDayDate: _pickDayDate,
                        ),
                        const SizedBox(height: 16),

                        _buildCard(
                          title: 'IV - IX. AUDIT SPECIFICATIONS & PROCEDURES',
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _criteriaController,
                                maxLines: 4,
                                decoration: _inputDecoration('IV. AUDIT CRITERIA'),
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _methodologyController,
                                maxLines: 4,
                                decoration: _inputDecoration('V. AUDIT METHODOLOGY'),
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _auditorSelectionController,
                                maxLines: 2,
                                decoration: _inputDecoration('VI. SELECTION AND EVALUATION OF AUDITORS'),
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _reportingController,
                                maxLines: 2,
                                decoration: _inputDecoration('VII. REPORTING'),
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _verificationController,
                                maxLines: 2,
                                decoration: _inputDecoration('VIII. VERIFICATION OF PREVIOUS NONCONFORMITIES / FOLLOW UP ACTIONS'),
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _limitationsController,
                                maxLines: 3,
                                decoration: _inputDecoration('IX. AUDIT LIMITATIONS'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryThemeColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                              elevation: 2,
                            ),
                            onPressed: () async {
                              bool? confirmAction = await showDialog<bool>(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(
                                      widget.programmeId == null ? "Confirm Save" : "Confirm Update",
                                    ),
                                    content: Text(
                                      widget.programmeId == null
                                          ? "Are you sure you want to save this record?"
                                          : "Are you sure you want to update this record?",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, false),
                                        child: Text("No", style: TextStyle(color: primaryThemeColor)),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, true),
                                        child: Text("Yes", style: TextStyle(color: primaryThemeColor)),
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (confirmAction != true) return;

                              // Overall plan StartDate/EndDate span every day
                              // that currently has entries.
                              final allDates = _dayDates.values.toList()..sort();
                              final startDate = allDates.isNotEmpty ? allDates.first : DateTime.now();
                              final endDate = allDates.isNotEmpty ? allDates.last : DateTime.now().add(const Duration(days: 30));

                              final payload = {
                                'id': widget.programmeId ?? 0,
                                'year': DateTime.now().year,
                                'for': _forController.text,
                                'from': _fromController.text,
                                'purpose': _purposeController.text,
                                'scopeAndFreqAudit': _scopeController.text,
                                'internalAuditSched': _internalAuditSchedController.text,
                                'auditPlanObjective': _auditPlanObjectiveController.text,
                                'scopeOfAudit': _scopeOfAuditController.text,
                                'objectives': _objectivesController.text
                                    .split('\n')
                                    .map((line) => line.trim())
                                    .where((line) => line.isNotEmpty)
                                    .toList()
                                    .asMap()
                                    .entries
                                    .map((e) => {
                                          'id': 0,
                                          'sortOrder': e.key,
                                          'description': e.value,
                                        })
                                    .toList(),
                                'auditCriteria': _criteriaController.text,
                                'auditMethodology': _methodologyController.text,
                                'selectionAndEvaluationOfAuditors': _auditorSelectionController.text,
                                'reporting': _reportingController.text,
                                'verificationOfPreviousNonconformities': _verificationController.text,
                                'auditLimitations': _limitationsController.text,
                                'auditPlan': [
                                  {
                                    'id': 0,
                                    'startDate': startDate.toIso8601String(),
                                    'endDate': endDate.toIso8601String(),
                                    'planStatus': 'Draft',
                                    'entries': _entries
                                        .map((e) => e.toBackendDtoJson(0, dayDate: _dayDates[e.dayNumber] ?? DateTime.now()))
                                        .toList(),
                                  }
                                ]
                              };

                              try {
                                final programme = AuditProgramme.fromJson(payload);
                                await _service.addOrUpdateAuditProgramme(programme);

                                if (!mounted) return;
                                MotionToast.success(
                                  toastAlignment: Alignment.topCenter,
                                  description: const Text('Saved successfully'),
                                ).show(context);
                              } catch (e) {
                                if (!mounted) return;
                                MotionToast.error(
                                  toastAlignment: Alignment.topCenter,
                                  description: Text('Failed to save: $e'),
                                ).show(context);
                              }
                            },
                            child: const Text(
                              'SAVE AUDIT PROGRAMME',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
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
          BoxShadow(color: const Color.fromARGB(255, 226, 114, 114).withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2)),
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

// =============================================================================
// 3. AUDIT PLAN ENTRIES SECTION — grouped by Day, each with its own banner
//    date (matching the printed "DAY 1 — MAY 20, 2025" layout) and its own
//    Add Row button.
// =============================================================================

class AuditPlanEntriesSection extends StatefulWidget {
  final TextEditingController internalAuditSchedController;
  final TextEditingController auditPlanObjectiveController;
  final TextEditingController scopeOfAuditController;
  final List<AuditPlanEntryRow> entries;
  final Map<int, DateTime> dayDates;
  final List<OfficeDto> offices;
  final List<IsoStandardDto> standards;
  final List<TeamDto> teams;
  final VoidCallback onAddDay;
  final void Function(int day) onAddRowToDay;
  final void Function(AuditPlanEntryRow entry) onRemoveEntry;
  final void Function(int day) onRemoveDay;
  final Future<void> Function(int day) onPickDayDate;

  const AuditPlanEntriesSection({
    super.key,
    required this.internalAuditSchedController,
    required this.auditPlanObjectiveController,
    required this.scopeOfAuditController,
    required this.entries,
    required this.dayDates,
    required this.offices,
    required this.standards,
    required this.teams,
    required this.onAddDay,
    required this.onAddRowToDay,
    required this.onRemoveEntry,
    required this.onRemoveDay,
    required this.onPickDayDate,
  });

  @override
  State<AuditPlanEntriesSection> createState() => _AuditPlanEntriesSectionState();
}

class _AuditPlanEntriesSectionState extends State<AuditPlanEntriesSection> {
  static const Color primaryThemeColor = Color(0xFF883942);

  InputDecoration _dropdownDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey.shade700, fontSize: 12, fontWeight: FontWeight.w600),
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
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: primaryThemeColor, width: 1.5),
      ),
    );
  }

  Future<void> _pickTime(AuditPlanEntryRow entry) async {
    final picked = await showTimePicker(context: context, initialTime: entry.time);
    if (picked != null) {
      setState(() => entry.time = picked);
    }
  }

  Future<void> _selectStandards(BuildContext context, AuditPlanEntryRow entry) async {
    final List<int> tempSelected = List<int>.from(entry.selectedIsoStandardIds);

    final result = await showDialog<List<int>>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              title: const Text(
                'Select Standard Chapters',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: primaryThemeColor),
              ),
              content: SizedBox(
                width: 360,
                child: widget.standards.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text('No standards available', style: TextStyle(fontSize: 12)),
                      )
                    : ListView(
                        shrinkWrap: true,
                        children: widget.standards.map((std) {
                          final checked = tempSelected.contains(std.id);
                          return CheckboxListTile(
                            dense: true,
                            activeColor: primaryThemeColor,
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text(std.displayLabel, style: const TextStyle(fontSize: 13)),
                            value: checked,
                            onChanged: (val) {
                              setDialogState(() {
                                if (val == true) {
                                  if (!tempSelected.contains(std.id)) tempSelected.add(std.id);
                                } else {
                                  tempSelected.remove(std.id);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, null),
                  child: Text('Cancel', style: TextStyle(color: Colors.grey.shade600)),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, tempSelected),
                  child: const Text('Done', style: TextStyle(color: primaryThemeColor, fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() => entry.selectedIsoStandardIds = result);
    }
  }

  Widget _buildOfficeCombo(AuditPlanEntryRow entry) {
    return RawAutocomplete<OfficeDto>(
      textEditingController: entry.officeTextController,
      focusNode: entry.officeFocusNode,
      optionsBuilder: (TextEditingValue value) {
        if (value.text.trim().isEmpty) return widget.offices;
        final query = value.text.trim().toLowerCase();
        return widget.offices.where((o) => o.name.toLowerCase().contains(query));
      },
      displayStringForOption: (o) => o.name,
      onSelected: (OfficeDto selection) {
        setState(() {
          entry.selectedOfficeId = selection.id;
          entry.officeText = selection.name;
        });
      },
      fieldViewBuilder: (context, textController, focusNode, onFieldSubmitted) {
        return TextFormField(
          controller: textController,
          focusNode: focusNode,
          style: const TextStyle(fontSize: 12),
          decoration: _dropdownDecoration('ORGANIZATIONAL UNIT AND PROCESSES').copyWith(
            hintText: 'Select or type office/process',
            hintStyle: const TextStyle(fontSize: 12),
            suffixIcon: const Icon(Icons.arrow_drop_down, color: primaryThemeColor),
          ),
          onChanged: (val) {
            entry.officeText = val;
            final match = widget.offices.where((o) => o.name == val);
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
                        'No matches — your typed text will be saved as a new process name',
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

  @override
  Widget build(BuildContext context) {
    // Group entries by dayNumber, preserving/sorting day order.
    final Map<int, List<AuditPlanEntryRow>> grouped = {};
    for (final e in widget.entries) {
      grouped.putIfAbsent(e.dayNumber, () => []).add(e);
    }
    final sortedDays = grouped.keys.toList()..sort();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'III. INTERNAL AUDIT SCHEDULE',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: primaryThemeColor, letterSpacing: 0.5),
          ),
          const Divider(height: 20),
          TextFormField(
            controller: widget.internalAuditSchedController,
            maxLines: 3,
            style: const TextStyle(fontSize: 13),
            decoration: _dropdownDecoration('INTERNAL AUDIT SCHEDULE').copyWith(
              hintText: 'e.g. Internal Quality Audit will be conducted on April 25–28, '
                  'May 23–26, and July 4. Follow-up audit will be conducted on '
                  'October 3–5, October 24–26, and November 8.',
              hintStyle: const TextStyle(fontSize: 12),
              hintMaxLines: 4,
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: widget.auditPlanObjectiveController,
            maxLines: 2,
            style: const TextStyle(fontSize: 13),
            decoration: _dropdownDecoration('AUDIT PLAN OBJECTIVE'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: widget.scopeOfAuditController,
            maxLines: 2,
            style: const TextStyle(fontSize: 13),
            decoration: _dropdownDecoration('SCOPE OF AUDIT'),
          ),
          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SCHEDULE',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: const Color.fromARGB(255, 228, 100, 100), letterSpacing: 0.5),
              ),
              ElevatedButton.icon(
                onPressed: widget.onAddDay,
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
          const Divider(height: 20),

          for (final day in sortedDays) _buildDayGroup(day, grouped[day]!),
        ],
      ),
    );
  }

  /// One "DAY N — DATE" banner (tap the date to change it) followed by that
  /// day's entry rows and its own "Add Row" button — matches the printed
  /// document's DAY 1 / DAY 2 / DAY 3 grouping.
  Widget _buildDayGroup(int day, List<AuditPlanEntryRow> dayEntries) {
    final date = widget.dayDates[day] ?? DateTime.now();

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Day banner — mirrors "DAY 1 – MAY 20, 2025" from the printed doc.
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
                    onTap: () => widget.onPickDayDate(day),
                    child: Row(
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
                  ),
                ),
                if (widget.dayDates.length > 1)
                  IconButton(
                    icon: const Icon(Icons.close, size: 18, color: Colors.redAccent),
                    tooltip: 'Remove Day',
                    onPressed: () => widget.onRemoveDay(day),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: dayEntries.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) => _buildEntryRow(dayEntries[i], dayEntries.length),
          ),

          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => widget.onAddRowToDay(day),
              icon: const Icon(Icons.add, size: 16, color: primaryThemeColor),
              label: Text('Add Row to Day $day', style: const TextStyle(fontSize: 12, color: primaryThemeColor)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntryRow(AuditPlanEntryRow entry, int rowsInThisDay) {
    final safeTeamValue = widget.teams.any((t) => t.id == entry.selectedTeamId) ? entry.selectedTeamId : null;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isWide = constraints.maxWidth > 800;

          Widget timePicker = InkWell(
            onTap: () => _pickTime(entry),
            child: InputDecorator(
              decoration: _dropdownDecoration('TIME'),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(entry.time.format(context), style: const TextStyle(fontSize: 12)),
                  const Icon(Icons.access_time, size: 14, color: primaryThemeColor),
                ],
              ),
            ),
          );

          Widget officeCombo = _buildOfficeCombo(entry);

          Widget standardMultiSelect = InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: () => _selectStandards(context, entry),
            child: InputDecorator(
              decoration: _dropdownDecoration('STANDARD CHAPTER').copyWith(
                suffixIcon: const Icon(Icons.arrow_drop_down, color: primaryThemeColor),
              ),
              child: entry.selectedIsoStandardIds.isEmpty
                  ? Text('Select Clause(s)', style: TextStyle(fontSize: 12, color: Colors.grey.shade600))
                  : Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: entry.selectedIsoStandardIds.map((id) {
                        final match = widget.standards.where((s) => s.id == id);
                        final label = match.isNotEmpty ? match.first.displayLabel : 'Clause #$id';
                        return Chip(
                          label: Text(label, style: const TextStyle(fontSize: 10)),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          backgroundColor: primaryThemeColor.withOpacity(0.08),
                          labelStyle: const TextStyle(color: primaryThemeColor),
                        );
                      }).toList(),
                    ),
            ),
          );

          Widget teamDropdown = DropdownButtonFormField<int>(
            value: safeTeamValue,
            isExpanded: true,
            hint: const Text('Select Team', style: TextStyle(fontSize: 12)),
            decoration: _dropdownDecoration('AUDITORS'),
            items: widget.teams.isEmpty
                ? [const DropdownMenuItem<int>(value: null, child: Text('No options available', style: TextStyle(fontSize: 12)))]
                : widget.teams
                    .map((team) => DropdownMenuItem<int>(
                          value: team.id,
                          child: Text(team.name, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)),
                        ))
                    .toList(),
            onChanged: widget.teams.isEmpty ? null : (val) => setState(() => entry.selectedTeamId = val),
          );

          Widget removeButton = IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
            onPressed: rowsInThisDay > 1 ? () => widget.onRemoveEntry(entry) : null,
            tooltip: 'Remove Row',
          );

          if (isWide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 2, child: timePicker),
                const SizedBox(width: 8),
                Expanded(flex: 3, child: officeCombo),
                const SizedBox(width: 8),
                Expanded(flex: 3, child: standardMultiSelect),
                const SizedBox(width: 8),
                Expanded(flex: 3, child: teamDropdown),
                const SizedBox(width: 4),
                removeButton,
              ],
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [removeButton],
                ),
                timePicker,
                const SizedBox(height: 8),
                officeCombo,
                const SizedBox(height: 8),
                standardMultiSelect,
                const SizedBox(height: 8),
                teamDropdown,
              ],
            );
          }
        },
      ),
    );
  }
}