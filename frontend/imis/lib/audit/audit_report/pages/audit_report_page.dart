import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:imis/audit/audit_report/service/audit_report_service.dart';
import 'package:imis/audit/audit_report/model/audit_report.dart';
import 'package:imis/audit/audit_report/model/audit_com_findings.dart';
import 'package:imis/audit/audit_report/model/audit_scope.dart';
import 'package:imis/audit/audit_report/model/audit_summary_findings.dart';

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

  _ComFindingUI({this.id, this.areasId, String? finding})
      : findingController = TextEditingController(text: finding ?? '');

  factory _ComFindingUI.fromModel(AuditComFindings m) => _ComFindingUI(
        id: m.id,
        areasId: m.areasId,
        finding: m.commendableFindings,
      );

  AuditComFindings toModel() => AuditComFindings(
        id: id ?? 0,
        commendableFindings: findingController.text,
        // Area is `required string` on the backend DTO but there is no
        // Area/Process picker in this form yet — sent empty until one exists.
        area: '',
        areasId: areasId,
      );

  void dispose() => findingController.dispose();
}

class _ScopeUI {
  int? id;
  final TextEditingController auditeeController;

  _ScopeUI({this.id, String? auditee})
      : auditeeController = TextEditingController(text: auditee ?? '');

  factory _ScopeUI.fromModel(AuditScope m) =>
      _ScopeUI(id: m.id, auditee: m.auditee);

  AuditScope toModel() => AuditScope(
        id: id ?? 0,
        auditee: auditeeController.text,
      );

  void dispose() => auditeeController.dispose();
}

class _SummaryUI {
  int? id;
  int no;
  final TextEditingController findingController;

  _SummaryUI({this.id, required this.no, String? finding})
      : findingController = TextEditingController(text: finding ?? '');

  factory _SummaryUI.fromModel(AuditSummaryFindings m) =>
      _SummaryUI(id: m.id, no: m.no, finding: m.findings);

  AuditSummaryFindings toModel() => AuditSummaryFindings(
        id: id ?? 0,
        no: no,
        findings: findingController.text,
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
  int? _selectedAuditeeId; // no picker endpoint yet — left null unless you add one
  String? _auditeeName;
  int? _selectedAuditPlanEntryId;

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
    for (final r in _comFindings) r.dispose();
    for (final r in _scopeRows) r.dispose();
    for (final r in _summaryRows) r.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    try {
      if (widget.reportId != null) {
        final report = await _service.getById(widget.reportId!);
        if (report != null) {
          _existingId = report.id;
          _rowVersion = report.rowVersion ?? '';
          _isDeleted = report.isDeleted ?? false;
          _auditPurposeController.text = report.auditPurpose;
          _auditConclusionsController.text = report.auditConclusions;

          _officeAuditedId = report.officeAuditedId;
          _officeAuditedName = report.officeAuditedName;
          _auditStandardISOId = report.auditStandardISOId;
          _auditStandardISOName = report.auditStandardISOName;
          _selectedAuditeeId = report.auditeeId;
          _auditeeName = report.auditeeName;
          _selectedAuditPlanEntryId = report.auditPlanEntryId;

          final entry = report.auditPlanEntry;
          if (entry != null) {
            _planDate =
                '${entry.time.month}/${entry.time.day}/${entry.time.year}';

            final processes = entry.auditPlanProcesses;
            if (processes != null && processes.isNotEmpty) {
              _planOfficeProcess = processes
                  .map((p) => p.office?.name ?? p.processName)
                  .where((n) => n != null && n.isNotEmpty)
                  .join(', ');
            }

            final auditors = entry.isoAuditors;
            if (auditors != null && auditors.isNotEmpty) {
              final withTeam =
                  auditors.where((a) => a.team != null).toList();
              if (withTeam.isNotEmpty) {
                _planAuditTeamName = withTeam.first.team?.name;
              }
            }
          }

          _comFindings.addAll(
            (report.auditComFindings ?? [])
                .map((m) => _ComFindingUI.fromModel(m)),
          );
          _scopeRows.addAll(
            (report.auditScope ?? []).map((m) => _ScopeUI.fromModel(m)),
          );
          _summaryRows.addAll(
            (report.auditSummaryFindings ?? [])
                .map((m) => _SummaryUI.fromModel(m)),
          );
        }
      }

      if (_comFindings.isEmpty) _comFindings.add(_ComFindingUI());
      if (_scopeRows.isEmpty) _scopeRows.add(_ScopeUI());
      if (_summaryRows.isEmpty) _summaryRows.add(_SummaryUI(no: 1));
    } catch (e) {
      _error = 'Error loading: $e';
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _addComFinding() => setState(() => _comFindings.add(_ComFindingUI()));
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
    final report = AuditReport(
      id: _existingId ?? 0,
      isDeleted: _isDeleted,
      rowVersion: _rowVersion,
      auditPurpose: _auditPurposeController.text,
      auditConclusions: _auditConclusionsController.text,
      officeAuditedId: _officeAuditedId,
      officeAuditedName: _officeAuditedName,
      auditStandardISOId: _auditStandardISOId,
      auditStandardISOName: _auditStandardISOName,
      auditeeId: _selectedAuditeeId,
      auditeeName: _auditeeName,
      auditPlanEntryId: _selectedAuditPlanEntryId,
      auditComFindings: _comFindings.map((r) => r.toModel()).toList(),
      auditScope: _scopeRows.map((r) => r.toModel()).toList(),
      auditSummaryFindings: _summaryRows.map((r) => r.toModel()).toList(),
    );

    setState(() => _isSaving = true);
    try {
      await _service.addOrUpdate(report as Map<String, dynamic>);
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Save failed: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
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
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      );

  Widget _card({required String title, required Widget child}) => Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: .04), blurRadius: 6)
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: primaryThemeColor)),
            const Divider(height: 20),
            child,
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxWidth: 960, maxHeight: MediaQuery.of(context).size.height * .9),
        child: Container(
          decoration: BoxDecoration(
              color: const Color(0xFFF4F6F8),
              borderRadius: BorderRadius.circular(8)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                            fontSize: 16),
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
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _error != null
                        ? Center(child: Text(_error!))
                        : SingleChildScrollView(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _card(
                                  title: 'AUDIT REPORT HEADER',
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (_officeAuditedName != null)
                                        Text(
                                            'Office Audited: $_officeAuditedName'),
                                      if (_auditStandardISOName != null)
                                        Text(
                                            'Audit Standard: $_auditStandardISOName'),
                                      if (_planOfficeProcess != null)
                                        Text(
                                            'Plan Office/Process: $_planOfficeProcess'),
                                      if (_planDate != null)
                                        Text('Date of Audit: $_planDate'),
                                      if (_planAuditTeamName != null)
                                        Text(
                                            'Auditors (Team): $_planAuditTeamName'),
                                      const SizedBox(height: 12),
                                      TextFormField(
                                        controller: _auditPurposeController,
                                        decoration:
                                            _decoration('AUDIT PURPOSE'),
                                      ),
                                    ],
                                  ),
                                ),

                                // II. Commendable Findings
                                _card(
                                  title: 'II. COMMENDABLE FINDINGS',
                                  child: Column(
                                    children: [
                                      for (final row in _comFindings)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 8),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: TextFormField(
                                                  controller:
                                                      row.findingController,
                                                  decoration: _decoration(
                                                      'Commendable Finding'),
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                    Icons.delete_outline,
                                                    color: Colors.redAccent),
                                                onPressed: _comFindings.length >
                                                        1
                                                    ? () =>
                                                        _removeComFinding(row)
                                                    : null,
                                              ),
                                            ],
                                          ),
                                        ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: TextButton.icon(
                                          onPressed: _addComFinding,
                                          icon: const Icon(Icons.add,
                                              color: primaryThemeColor),
                                          label: const Text('Add Finding'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // I. Auditees (AuditScope) — DTO only exposes
                                // free-text Auditee per row.
                                _card(
                                  title: 'I. AUDITEES',
                                  child: Column(
                                    children: [
                                      for (final row in _scopeRows)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 8),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: TextFormField(
                                                  controller:
                                                      row.auditeeController,
                                                  decoration:
                                                      _decoration('Auditee'),
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                    Icons.delete_outline,
                                                    color: Colors.redAccent),
                                                onPressed: _scopeRows.length > 1
                                                    ? () => _removeScopeRow(row)
                                                    : null,
                                              ),
                                            ],
                                          ),
                                        ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: TextButton.icon(
                                          onPressed: _addScopeRow,
                                          icon: const Icon(Icons.add,
                                              color: primaryThemeColor),
                                          label: const Text('Add Auditee'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // III. Summary of Findings — DTO only has
                                // No + Findings; Criteria/Status(NC/OFI) from
                                // the printed form have no field yet.
                                _card(
                                  title: 'III. SUMMARY OF FINDINGS',
                                  child: Column(
                                    children: [
                                      for (final row in _summaryRows)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 8),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                  width: 40,
                                                  child: Text('${row.no}')),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: TextFormField(
                                                  controller:
                                                      row.findingController,
                                                  maxLines: 2,
                                                  decoration:
                                                      _decoration('Finding'),
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                    Icons.delete_outline,
                                                    color: Colors.redAccent),
                                                onPressed:
                                                    _summaryRows.length > 1
                                                        ? () =>
                                                            _removeSummaryRow(
                                                                row)
                                                        : null,
                                              ),
                                            ],
                                          ),
                                        ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: TextButton.icon(
                                          onPressed: _addSummaryRow,
                                          icon: const Icon(Icons.add,
                                              color: primaryThemeColor),
                                          label: const Text('Add Finding Row'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // IV. Audit Conclusions
                                _card(
                                  title: 'IV. AUDIT CONCLUSIONS',
                                  child: TextFormField(
                                    controller: _auditConclusionsController,
                                    maxLines: 4,
                                    decoration:
                                        _decoration('AUDIT CONCLUSIONS'),
                                  ),
                                ),
                              ],
                            ),
                          ),
              ),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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
                          backgroundColor: primaryThemeColor),
                      child: const Text('SAVE',
                          style: TextStyle(color: Colors.white)),
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