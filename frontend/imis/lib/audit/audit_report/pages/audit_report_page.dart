import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:imis/audit/audit_plan/models/audit_plan.dart';
import 'package:imis/audit/audit_plan/models/audit_plan_entry.dart';
import 'package:imis/audit/audit_report/service/audit_report_service.dart';
import 'package:imis/audit/audit_report/model/audit_report.dart';
import 'package:imis/audit/audit_report/model/audit_com_findings.dart';
import 'package:imis/audit/audit_report/model/audit_scope.dart';
import 'package:imis/audit/audit_report/model/audit_summary_findings.dart';
import 'package:imis/audit/audit_schedules/models/audit_schedules.dart';

// =============================================================================
// UI-only row wrappers — hold a TextEditingController per editable field and
// convert to/from the real generated models on load/save. The generated
// models themselves have no controllers, so these are not a duplicate model,
// just a thin adapter for the form.
// =============================================================================

class _ComFindingUI {
  int? id;
  int? areasId;
  final TextEditingController findingController;
  final TextEditingController areaController;

  _ComFindingUI({this.id, this.areasId, String? finding, String? area})
    : findingController = TextEditingController(text: finding ?? ''),
      areaController = TextEditingController(text: area ?? '');

  factory _ComFindingUI.fromModel(AuditComFindings m) => _ComFindingUI(
    id: m.id,
    areasId: m.areasId,
    finding: m.commendableFindings,
    area: m.area,
  );

  AuditComFindings toModel() => AuditComFindings(
    id: id ?? 0,
    commendableFindings: findingController.text,
    area: areaController.text,
    areasId: areasId,
  );

  void dispose() {
    findingController.dispose();
    areaController.dispose();
  }
}

class _ScopeUI {
  int? id;
  final TextEditingController auditeeController;

  _ScopeUI({this.id, String? auditee})
    : auditeeController = TextEditingController(text: auditee ?? '');

  factory _ScopeUI.fromModel(AuditScope m) =>
      _ScopeUI(id: m.id, auditee: m.auditee);

  AuditScope toModel() =>
      AuditScope(id: id ?? 0, auditee: auditeeController.text);

  void dispose() => auditeeController.dispose();
}

class _SummaryUI {
  int? id;
  int no;
  final TextEditingController findingController;
  int? auditNcarStatusId;

  _SummaryUI({
    this.id,
    required this.no,
    String? finding,
    this.auditNcarStatusId,
  }) : findingController = TextEditingController(text: finding ?? '');

  factory _SummaryUI.fromModel(AuditSummaryFindings m) => _SummaryUI(
    id: m.id,
    no: m.no,
    finding: m.findings,
    auditNcarStatusId: m.auditNcarStatusId,
  );

  AuditSummaryFindings toModel() => AuditSummaryFindings(
    id: id ?? 0,
    no: no,
    findings: findingController.text,
    auditNcarStatusId: auditNcarStatusId,
  );

  void dispose() => findingController.dispose();
}

// =============================================================================
// AuditReportPage
// =============================================================================

class AuditReportPage extends StatefulWidget {
  final int? reportId;
  const AuditReportPage({super.key, this.reportId});

  @override
  State<AuditReportPage> createState() => _AuditReportPageState();
}

class _AuditReportPageState extends State<AuditReportPage> {
  static const Color primaryThemeColor = Color(0xFF883942);
  final _service = AuditReportService(Dio());

  final _auditPurposeController = TextEditingController();
  final _auditConclusionsController = TextEditingController();

  int? _existingId;
  String _rowVersion = '';
  bool _isDeleted = false;

  int? _officeAuditedId;
  String? _officeAuditedName;
  int? _auditStandardISOId;
  String? _auditStandardISOName;
  int?
  _selectedAuditeeId; // no picker endpoint yet — left null unless you add one
  String? _auditeeName;

  // Source selection: an AuditReport belongs to an AuditSchedule (required FK),
  // and schedules hang off an audit plan entry, which hangs off an audit plan.
  List<AuditPlan> _plans = [];
  int? _selectedPlanId;

  List<AuditPlanEntry> _entries = [];
  int? _selectedAuditPlanEntryId;

  List<AuditSchedules> _schedules = [];
  int? _selectedScheduleId;

  List<Map<String, dynamic>> _ncarStatuses = [];
  bool _isLoadingLookups = false;

  // Derived read-only display strings, computed from the loaded
  // AuditPlanEntry (mirrors AuditReportDto's constructor on the backend).
  String? _planDate;
  String? _planOfficeProcess;
  String? _planAuditTeamName;

  final List<_ComFindingUI> _comFindings = [];
  final List<_ScopeUI> _scopeRows = [];
  final List<_SummaryUI> _summaryRows = [];

  bool _isLoading = true;
  bool _isSaving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _auditPurposeController.dispose();
    _auditConclusionsController.dispose();
    for (final r in _comFindings) {
      r.dispose();
    }
    for (final r in _scopeRows) {
      r.dispose();
    }
    for (final r in _summaryRows) {
      r.dispose();
    }
    super.dispose();
  }

  String _formatDay(DateTime d) => '${d.month}/${d.day}/${d.year}';

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      await _loadPlans();
      try {
        _ncarStatuses = await _service.getNcarStatuses();
      } catch (_) {}

      if (widget.reportId != null) {
        final report = await _service.getById(widget.reportId!);
        if (report != null) {
          _existingId = report.id;
          _rowVersion = report.rowVersion ?? '';
          _isDeleted = report.isDeleted ?? false;
          _auditPurposeController.text =
              report.auditPurpose.isNotEmpty
                  ? report.auditPurpose
                  : 'INTERNAL QUALITY AUDIT';
          _auditConclusionsController.text = report.auditConclusions;

          _officeAuditedId = report.officeAuditedId;
          _officeAuditedName = report.officeAuditedName;
          _auditStandardISOId = report.auditStandardISOId;
          _auditStandardISOName =
              report.auditStandardISOName ?? 'ISO 9001:2015';
          _selectedAuditeeId = report.auditeeId;
          _auditeeName = report.auditeeName;
          _selectedAuditPlanEntryId = report.auditPlanEntryId;
          _selectedScheduleId =
              report.auditScheduleId > 0 ? report.auditScheduleId : null;

          final entry = report.auditPlanEntry;

          // The server already assembled the header fields off the plan entry;
          // prefer those and fall back to deriving them from the nested entry
          // (used when the entry is not eagerly loaded).
          _planOfficeProcess = report.planOfficeProcess;
          _planAuditTeamName = report.planAuditTeamName;
          _planDate =
              report.auditDate != null ? _formatDay(report.auditDate!) : null;

          if (entry != null) {
            _planDate ??= _formatDay(entry.time);

            final processes = entry.auditPlanProcesses;
            if (_planOfficeProcess == null &&
                processes != null &&
                processes.isNotEmpty) {
              _planOfficeProcess = processes
                  .map((p) => p.office?.name ?? p.processName)
                  .where((n) => n != null && n.isNotEmpty)
                  .join(', ');
            }
            if (_officeAuditedName == null && _planOfficeProcess != null) {
              _officeAuditedName = _planOfficeProcess;
            }

            final auditors = entry.isoAuditors;
            if (_planAuditTeamName == null &&
                auditors != null &&
                auditors.isNotEmpty) {
              final withTeam = auditors.where((a) => a.team != null).toList();
              if (withTeam.isNotEmpty) {
                _planAuditTeamName = withTeam.first.team?.name;
              }
            }

            _selectedPlanId = entry.auditPlanId > 0 ? entry.auditPlanId : null;
          }

          // The list page's picker data is loaded from the plan the report was
          // generated from; without it the dropdowns would come up empty and
          // silently overwrite the saved schedule on save.
          if (_selectedPlanId != null) {
            await _loadEntries(_selectedPlanId!);
          }
          if (_selectedAuditPlanEntryId != null) {
            await _loadSchedules(_selectedAuditPlanEntryId!);
          }

          _comFindings.addAll(
            (report.auditComFindings ?? []).map(
              (m) => _ComFindingUI.fromModel(m),
            ),
          );
          _scopeRows.addAll(
            (report.auditScope ?? []).map((m) => _ScopeUI.fromModel(m)),
          );
          _summaryRows.addAll(
            (report.auditSummaryFindings ?? []).map(
              (m) => _SummaryUI.fromModel(m),
            ),
          );
        }
      } else {
        _auditPurposeController.text = 'INTERNAL QUALITY AUDIT';
        _auditStandardISOName = 'ISO 9001:2015';
      }

      if (_comFindings.isEmpty) {
        _comFindings.add(
          _ComFindingUI(area: _officeAuditedName ?? _planOfficeProcess ?? ''),
        );
      }
      if (_scopeRows.isEmpty) _scopeRows.add(_ScopeUI());
      if (_summaryRows.isEmpty) _summaryRows.add(_SummaryUI(no: 1));
    } catch (e) {
      _error = 'Error loading: $e';
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loadPlans() async {
    final plans = await _service.getAllAuditPlans();
    if (!mounted) return;
    setState(() => _plans = plans);
  }

  Future<void> _loadEntries(int planId) async {
    setState(() => _isLoadingLookups = true);
    try {
      final entries = await _service.getPlanEntries(planId);
      if (!mounted) return;
      setState(() {
        _entries = entries;
        _schedules = [];
      });
    } finally {
      if (mounted) setState(() => _isLoadingLookups = false);
    }
  }

  Future<void> _loadSchedules(int planEntryId) async {
    setState(() => _isLoadingLookups = true);
    try {
      final schedules = await _service.getSchedulesForPlanEntry(planEntryId);
      if (!mounted) return;
      setState(() => _schedules = schedules);
    } finally {
      if (mounted) setState(() => _isLoadingLookups = false);
    }
  }

  void _onPlanChanged(int? planId) {
    setState(() {
      _selectedPlanId = planId;
      _selectedAuditPlanEntryId = null;
      _selectedScheduleId = null;
      _entries = [];
      _schedules = [];
    });
    if (planId != null) {
      _loadEntries(planId).then((_) {
        if (!mounted) return;
        setState(() {
          _planOfficeProcess = null;
          _planAuditTeamName = null;
          _planDate = null;
        });
      });
    }
  }

  void _onEntryChanged(int? entryId) {
    setState(() {
      _selectedAuditPlanEntryId = entryId;
      _selectedScheduleId = null;
      _schedules = [];
    });
    if (entryId != null) {
      _loadSchedules(entryId).then((_) {
        if (!mounted) return;
        setState(() {
          AuditPlanEntry? entry;
          for (final e in _entries) {
            if (e.id == entryId) {
              entry = e;
              break;
            }
          }
          if (entry == null) return;
          _planDate = _formatDay(entry.time);

          final processes = entry.auditPlanProcesses;
          _planOfficeProcess =
              (processes != null && processes.isNotEmpty)
                  ? processes
                      .map((p) => p.office?.name ?? p.processName)
                      .where((n) => n != null && n.isNotEmpty)
                      .join(', ')
                  : null;

          if (processes != null && processes.isNotEmpty) {
            _officeAuditedId = processes.first.officeId ?? processes.first.id;
            _officeAuditedName =
                processes.first.office?.name ??
                processes.first.processName ??
                _planOfficeProcess;
          }

          final auditors = entry.isoAuditors;
          if (auditors != null && auditors.isNotEmpty) {
            final withTeam = auditors.where((a) => a.team != null).toList();
            _planAuditTeamName =
                withTeam.isNotEmpty ? withTeam.first.team?.name : null;
          }

          if (entry.standardText != null &&
              entry.standardText!.trim().isNotEmpty) {
            _auditStandardISOName = entry.standardText;
          } else if (entry.isoStandardAuditPlans != null &&
              entry.isoStandardAuditPlans!.isNotEmpty) {
            final firstStandard = entry.isoStandardAuditPlans!.first;
            _auditStandardISOId = firstStandard.isoStandardId;
            _auditStandardISOName =
                firstStandard.isoStandard?.particulars ??
                firstStandard.isoStandard?.clauseRef ??
                'ISO 9001:2015';
          } else if (_auditStandardISOName == null ||
              _auditStandardISOName!.isEmpty) {
            _auditStandardISOName = 'ISO 9001:2015';
          }

          if (_auditPurposeController.text.trim().isEmpty) {
            _auditPurposeController.text = 'INTERNAL QUALITY AUDIT';
          }

          // Populate auditees from entry responsiblePersons
          final responsible = entry.responsiblePersons;
          if (responsible != null && responsible.isNotEmpty) {
            final bool hasCustomScope = _scopeRows.any(
              (s) => s.auditeeController.text.trim().isNotEmpty,
            );
            if (!hasCustomScope || _existingId == null) {
              for (final r in _scopeRows) {
                r.dispose();
              }
              _scopeRows.clear();
              for (final p in responsible) {
                if (p.name.trim().isNotEmpty) {
                  _scopeRows.add(_ScopeUI(auditee: p.name.trim()));
                }
              }
              if (_scopeRows.isEmpty) _scopeRows.add(_ScopeUI());
            }
            _auditeeName = _scopeRows
                .map((s) => s.auditeeController.text.trim())
                .where((t) => t.isNotEmpty)
                .join(', ');
          }

          // Default area for commendable findings
          final areaName = _officeAuditedName ?? _planOfficeProcess ?? '';
          for (final com in _comFindings) {
            if (com.areaController.text.trim().isEmpty) {
              com.areaController.text = areaName;
            }
          }
        });
      });
    }
  }

  void _addComFinding() => setState(
    () => _comFindings.add(
      _ComFindingUI(area: _officeAuditedName ?? _planOfficeProcess ?? ''),
    ),
  );
  void _removeComFinding(_ComFindingUI r) => setState(() {
    r.dispose();
    _comFindings.remove(r);
  });

  void _addScopeRow() => setState(() => _scopeRows.add(_ScopeUI()));
  void _removeScopeRow(_ScopeUI r) => setState(() {
    r.dispose();
    _scopeRows.remove(r);
  });

  void _addSummaryRow() => setState(() {
    final nextNo = _summaryRows.isEmpty ? 1 : _summaryRows.last.no + 1;
    _summaryRows.add(_SummaryUI(no: nextNo));
  });
  void _removeSummaryRow(_SummaryUI r) => setState(() {
    r.dispose();
    _summaryRows.remove(r);
  });

  Future<void> _save() async {
    // AuditScheduleId is a required, non-nullable FK on AuditReportDto and on
    // the AuditReports table, so a report cannot be saved without a real
    // schedule — the DB rejects both a missing value and an id that doesn't
    // resolve. Validate here rather than letting the save fail server-side.
    if (_selectedAuditPlanEntryId == null) {
      _showMessage('Please select an audit plan entry.');
      return;
    }
    if (_selectedScheduleId == null) {
      _showMessage('Please select an audit schedule.');
      return;
    }
    if (_auditPurposeController.text.trim().isEmpty) {
      _showMessage('Audit purpose is required.');
      return;
    }

    final auditees =
        _scopeRows
            .map((r) => r.auditeeController.text.trim())
            .where((t) => t.isNotEmpty)
            .toList();
    final effectiveAuditeeName =
        auditees.isNotEmpty ? auditees.join(', ') : _auditeeName;

    final report = AuditReport(
      id: _existingId ?? 0,
      isDeleted: _isDeleted,
      rowVersion: _rowVersion,
      auditPurpose:
          _auditPurposeController.text.trim().isNotEmpty
              ? _auditPurposeController.text.trim()
              : 'INTERNAL QUALITY AUDIT',
      auditConclusions: _auditConclusionsController.text,
      officeAuditedId: _officeAuditedId,
      officeAuditedName: _officeAuditedName ?? _planOfficeProcess,
      auditStandardISOId: _auditStandardISOId,
      auditStandardISOName: _auditStandardISOName ?? 'ISO 9001:2015',
      auditeeId: _selectedAuditeeId,
      auditeeName: effectiveAuditeeName,
      auditPlanEntryId: _selectedAuditPlanEntryId,
      auditScheduleId: _selectedScheduleId!,
      planOfficeProcess: _planOfficeProcess,
      planAuditTeamName: _planAuditTeamName,
      auditComFindings: _comFindings.map((r) => r.toModel()).toList(),
      auditScope: _scopeRows.map((r) => r.toModel()).toList(),
      auditSummaryFindings: _summaryRows.map((r) => r.toModel()).toList(),
    );

    setState(() => _isSaving = true);
    try {
      await _service.addOrUpdate(report);
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      _showMessage('Save failed: $e');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  InputDecoration _decoration(String label) => InputDecoration(
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
  );

  InputDecoration _dropdownDecoration(String label) => _decoration(label);

  /// DropdownButtonFormField asserts that exactly one item matches its value, so
  /// a selection that isn't present in the freshly-loaded option list would throw
  /// rather than render. The lookup lists are loaded per-selection (and can come
  /// back empty if a plan/entry/schedule was removed or is filtered by
  /// permission), so the current selection is only fed back once it is known to
  /// be a valid option.
  int? _safeSelection(int? value, Iterable<int?> availableIds) {
    if (value == null) return null;
    for (final id in availableIds) {
      if (id == value) return value;
    }
    return null;
  }

  String _entryLabel(AuditPlanEntry e) {
    final parts = <String>['Day ${e.dayNumber}', _formatDay(e.time)];
    final process = e.auditPlanProcesses
        ?.map((p) => p.office?.name ?? p.processName)
        .where((n) => n != null && n.isNotEmpty)
        .join(', ');
    if (process != null && process.isNotEmpty) parts.add(process);
    return parts.join(' — ');
  }

  String _scheduleLabel(AuditSchedules s) {
    final activity = s.activity.isNotEmpty ? s.activity : 'Schedule ${s.id}';
    return '$activity — ${_formatDay(s.startDate)} to ${_formatDay(s.endDate)}';
  }

  Widget _sourceCard() => _card(
    title: 'AUDIT REPORT SOURCE',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<int>(
                initialValue: _safeSelection(
                  _selectedPlanId,
                  _plans.map((p) => p.id),
                ),
                isExpanded: true,
                hint: const Text(
                  'Select Audit Plan',
                  style: TextStyle(fontSize: 12),
                ),
                decoration: _dropdownDecoration('AUDIT PLAN'),
                items:
                    _plans.isEmpty
                        ? const [
                          DropdownMenuItem<int>(
                            value: null,
                            child: Text(
                              'No options available',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ]
                        : _plans
                            .map(
                              (p) => DropdownMenuItem<int>(
                                value: p.id,
                                child: Text(
                                  p.planName.isNotEmpty
                                      ? p.planName
                                      : 'Plan ${p.id}',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            )
                            .toList(),
                onChanged:
                    _plans.isEmpty || _isLoadingLookups ? null : _onPlanChanged,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<int>(
                initialValue: _safeSelection(
                  _selectedAuditPlanEntryId,
                  _entries.map((e) => e.id),
                ),
                isExpanded: true,
                hint: const Text(
                  'Select Plan Entry',
                  style: TextStyle(fontSize: 12),
                ),
                decoration: _dropdownDecoration('AUDIT PLAN ENTRY'),
                items:
                    _entries.isEmpty
                        ? const [
                          DropdownMenuItem<int>(
                            value: null,
                            child: Text(
                              'Select a plan first',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ]
                        : _entries
                            .map(
                              (e) => DropdownMenuItem<int>(
                                value: e.id,
                                child: Text(
                                  _entryLabel(e),
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            )
                            .toList(),
                onChanged:
                    _entries.isEmpty || _isLoadingLookups
                        ? null
                        : _onEntryChanged,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<int>(
          initialValue: _safeSelection(
            _selectedScheduleId,
            _schedules.map((s) => s.id),
          ),
          isExpanded: true,
          hint: const Text(
            'Select Audit Schedule',
            style: TextStyle(fontSize: 12),
          ),
          decoration: _dropdownDecoration('AUDIT SCHEDULE'),
          items:
              _schedules.isEmpty
                  ? const [
                    DropdownMenuItem<int>(
                      value: null,
                      child: Text(
                        'No schedules for this entry',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ]
                  : _schedules
                      .map(
                        (s) => DropdownMenuItem<int>(
                          value: s.id,
                          child: Text(
                            _scheduleLabel(s),
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      )
                      .toList(),
          onChanged:
              _schedules.isEmpty || _isLoadingLookups
                  ? null
                  : (val) => setState(() => _selectedScheduleId = val),
        ),
        const SizedBox(height: 8),
        const Text(
          'A report must belong to an audit schedule.',
          style: TextStyle(fontSize: 11, color: Colors.grey),
        ),
      ],
    ),
  );

  Widget _card({required String title, required Widget child}) => Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(color: Colors.black.withValues(alpha: .04), blurRadius: 6),
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
          ),
        ),
        const Divider(height: 20),
        child,
      ],
    ),
  );

  Widget _headerCard() => _card(
    title: 'AUDIT REPORT HEADER',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFBFBFB),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'OFFICE AUDITED',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _officeAuditedName ??
                          _planOfficeProcess ??
                          'Select an audit plan entry above',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color:
                            (_officeAuditedName != null ||
                                    _planOfficeProcess != null)
                                ? Colors.black87
                                : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'DATE OF AUDIT',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _planDate ?? 'Select an audit plan entry above',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _planDate != null ? Colors.black87 : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _auditPurposeController,
                decoration: _decoration('AUDIT PURPOSE'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                initialValue: _auditStandardISOName ?? 'ISO 9001:2015',
                decoration: _decoration('AUDIT STANDARD'),
                onChanged: (val) => _auditStandardISOName = val,
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _scopeCard() => _card(
    title: 'I. AUDIT SCOPE, AUDITORS AND AUDITEES',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFFBFBFB),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'AREA / PROCESS AUDITED',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _officeAuditedName ?? _planOfficeProcess ?? '—',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'AUDITORS (TEAM)',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _planAuditTeamName ?? '—',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Text(
          'AUDITEES',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: primaryThemeColor,
          ),
        ),
        const SizedBox(height: 8),
        for (final row in _scopeRows)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: row.auditeeController,
                    decoration: _decoration('Auditee Name'),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                  ),
                  onPressed:
                      _scopeRows.length > 1 ? () => _removeScopeRow(row) : null,
                ),
              ],
            ),
          ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: _addScopeRow,
            icon: const Icon(Icons.add, color: primaryThemeColor),
            label: const Text('Add Auditee'),
          ),
        ),
      ],
    ),
  );

  Widget _commendableFindingsCard() => _card(
    title: 'II. COMMENDABLE FINDINGS',
    child: Column(
      children: [
        for (final row in _comFindings)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: row.findingController,
                    decoration: _decoration('Commendable Finding'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: row.areaController,
                    decoration: _decoration('Area'),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                  ),
                  onPressed:
                      _comFindings.length > 1
                          ? () => _removeComFinding(row)
                          : null,
                ),
              ],
            ),
          ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: _addComFinding,
            icon: const Icon(Icons.add, color: primaryThemeColor),
            label: const Text('Add Finding'),
          ),
        ),
      ],
    ),
  );

  Widget _summaryFindingsCard() => _card(
    title: 'III. SUMMARY OF FINDINGS',
    child: Column(
      children: [
        for (final row in _summaryRows)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  padding: const EdgeInsets.only(top: 14),
                  child: Text(
                    '${row.no}.',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: row.findingController,
                    maxLines: 2,
                    decoration: _decoration('Finding'),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 140,
                  child: DropdownButtonFormField<int?>(
                    value: row.auditNcarStatusId,
                    decoration: _dropdownDecoration('STATUS'),
                    isExpanded: true,
                    hint: const Text('Status', style: TextStyle(fontSize: 12)),
                    items: [
                      const DropdownMenuItem<int?>(
                        value: null,
                        child: Text('None', style: TextStyle(fontSize: 12)),
                      ),
                      ..._ncarStatuses.map(
                        (s) => DropdownMenuItem<int?>(
                          value: (s['id'] as num?)?.toInt(),
                          child: Text(
                            (s['ncarStatus'] ??
                                    s['NcarStatus'] ??
                                    'Status ${s['id']}')
                                .toString(),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                    onChanged: (val) {
                      setState(() => row.auditNcarStatusId = val);
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                  ),
                  onPressed:
                      _summaryRows.length > 1
                          ? () => _removeSummaryRow(row)
                          : null,
                ),
              ],
            ),
          ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: _addSummaryRow,
            icon: const Icon(Icons.add, color: primaryThemeColor),
            label: const Text('Add Finding Row'),
          ),
        ),
      ],
    ),
  );

  Widget _conclusionsCard() => _card(
    title: 'IV. AUDIT CONCLUSIONS',
    child: TextFormField(
      controller: _auditConclusionsController,
      maxLines: 4,
      decoration: _decoration('AUDIT CONCLUSIONS'),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 960,
          maxHeight: MediaQuery.of(context).size.height * .9,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF4F6F8),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: const BoxDecoration(
                  color: primaryThemeColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.reportId == null
                            ? 'CREATE AUDIT REPORT'
                            : 'EDIT AUDIT REPORT',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Expanded(
                child:
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _error != null
                        ? Center(child: Text(_error!))
                        : SingleChildScrollView(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _sourceCard(),
                              _headerCard(),
                              _scopeCard(),
                              _commendableFindingsCard(),
                              _summaryFindingsCard(),
                              _conclusionsCard(),
                            ],
                          ),
                        ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Colors.grey.shade200)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed:
                          _isSaving ? null : () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _isSaving ? null : _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryThemeColor,
                      ),
                      child: const Text(
                        'SAVE',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
