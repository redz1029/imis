import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:imis/ISO/IQA/audit_report/service/audit_report_service.dart';
import 'package:imis/ISO/IQA/audit_report/model/audit_report.dart';
import 'package:imis/ISO/IQA/audit_report/model/audit_report_clause_results.dart';
import 'package:imis/ISO/IQA/audit_report/model/audit_com_findings.dart';
import 'package:imis/constant/permissions.dart';
import 'package:imis/utils/permission_service.dart';

// =============================================================================
// UI-only row wrapper — holds a TextEditingController per editable field and
// converts to/from the real generated model on load/save. The generated model
// itself has no controllers, so this is not a duplicate model, just a thin
// adapter for the form.
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

// =============================================================================
// AuditReportPage
//
// An audit report is never created here: it is raised by saving the audit
// checklist and kept in step with it (office, date, auditors, auditees, the
// non-conforming findings and their NCARs). The auditor only writes what the
// checklist cannot supply — the purpose, the commendable findings and the
// conclusions.
// =============================================================================

class AuditReportPage extends StatefulWidget {
  final int reportId;
  const AuditReportPage({super.key, required this.reportId});

  @override
  State<AuditReportPage> createState() => _AuditReportPageState();
}

class _AuditReportPageState extends State<AuditReportPage> {
  static const Color primaryThemeColor = Color(0xFF883942);
  final _service = AuditReportService(Dio());

  final _auditPurposeController = TextEditingController();
  final _auditConclusionsController = TextEditingController();

  /// The report as the server holds it. The checklist-owned parts (schedule,
  /// plan entry, office, auditees, summary of findings) are sent back untouched
  /// and ignored by the server; only the hand-written parts are changed.
  AuditReport? _report;

  String? _officeAuditedName;
  String? _auditStandardISOName;
  String? _planDate;
  String? _planOfficeProcess;
  String? _planAuditTeamName;

  List<Map<String, dynamic>> _ncarStatuses = [];
  final List<_ComFindingUI> _comFindings = [];

  // Checklist results of the report's schedule (read-only): conforming clauses
  // are listed as such and each non-conforming clause shows its NCAR.
  AuditReportClauseResults? _clauseResults;
  bool _isLoadingResults = false;
  String? _resultsError;

  bool _isLoading = true;
  bool _isSaving = false;
  String? _error;

  /// Only a role that may edit reports can save one. Read-only roles
  /// (QMR, QMS, Department Head) still see the report, just not the save.
  bool get _canEdit =>
      permissionService.hasPermission(AppPermissions.editAuditReport) ||
      permissionService.hasPermission(AppPermissions.addAuditReport);

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
    super.dispose();
  }

  String _formatDay(DateTime d) => '${d.month}/${d.day}/${d.year}';

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      try {
        _ncarStatuses = await _service.getNcarStatuses();
      } catch (_) {}

      final report = await _service.getById(widget.reportId);
      if (report == null) {
        _error = 'This audit report no longer exists.';
        return;
      }

      _report = report;
      _auditPurposeController.text =
          report.auditPurpose.isNotEmpty
              ? report.auditPurpose
              : 'INTERNAL QUALITY AUDIT';
      _auditConclusionsController.text = report.auditConclusions;

      _officeAuditedName = report.officeAuditedName;
      _auditStandardISOName = report.auditStandardISOName ?? 'ISO 9001:2015';
      _planOfficeProcess = report.planOfficeProcess;
      _planAuditTeamName = report.planAuditTeamName;
      _planDate =
          report.auditDate != null ? _formatDay(report.auditDate!) : null;

      for (final r in _comFindings) {
        r.dispose();
      }
      _comFindings
        ..clear()
        ..addAll(
          (report.auditComFindings ?? []).map(
            (m) => _ComFindingUI.fromModel(m),
          ),
        );
      if (_comFindings.isEmpty) {
        _comFindings.add(_ComFindingUI(area: _areaName));
      }

      await _loadClauseResults();
    } catch (e) {
      _error = 'Error loading: $e';
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String get _areaName => _officeAuditedName ?? _planOfficeProcess ?? '';

  Future<void> _loadClauseResults() async {
    final scheduleId = _report?.auditScheduleId ?? 0;
    if (scheduleId <= 0) {
      _clauseResults = null;
      return;
    }
    if (mounted) {
      setState(() {
        _isLoadingResults = true;
        _resultsError = null;
      });
    }
    try {
      final results = await _service.getClauseResults(scheduleId);
      if (!mounted) return;
      setState(() => _clauseResults = results);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _clauseResults = null;
        _resultsError = 'Could not load the checklist results.';
      });
    } finally {
      if (mounted) setState(() => _isLoadingResults = false);
    }
  }

  void _addComFinding() =>
      setState(() => _comFindings.add(_ComFindingUI(area: _areaName)));

  void _removeComFinding(_ComFindingUI r) => setState(() {
    r.dispose();
    _comFindings.remove(r);
  });

  Future<void> _save() async {
    final loaded = _report;
    if (loaded == null) return;

    if (_auditPurposeController.text.trim().isEmpty) {
      _showMessage('Audit purpose is required.');
      return;
    }

    // A commendable finding with no text is just an empty row.
    final commendable =
        _comFindings
            .where((r) => r.findingController.text.trim().isNotEmpty)
            .map((r) => r.toModel())
            .toList();

    final report = AuditReport(
      id: loaded.id,
      isDeleted: loaded.isDeleted,
      rowVersion: loaded.rowVersion,
      auditPurpose: _auditPurposeController.text.trim(),
      auditConclusions: _auditConclusionsController.text,
      officeAuditedId: loaded.officeAuditedId,
      officeAuditedName: loaded.officeAuditedName,
      auditStandardISOId: loaded.auditStandardISOId,
      auditStandardISOName: loaded.auditStandardISOName,
      auditeeId: loaded.auditeeId,
      auditeeName: loaded.auditeeName,
      auditPlanEntryId: loaded.auditPlanEntryId,
      auditScheduleId: loaded.auditScheduleId,
      planOfficeProcess: loaded.planOfficeProcess,
      planAuditTeamName: loaded.planAuditTeamName,
      auditComFindings: commendable,
      auditScope: loaded.auditScope,
      auditSummaryFindings: loaded.auditSummaryFindings,
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

  /// A label over a value the checklist supplies; shown, never edited.
  Widget _fact(String label, String? value) => Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value != null && value.trim().isNotEmpty ? value : '—',
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ],
    ),
  );

  Widget _factsPanel(List<Widget> children) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFFFBFBFB),
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: Row(children: children),
  );

  Widget _autoNote(String text) => Padding(
    padding: const EdgeInsets.only(top: 8),
    child: Row(
      children: [
        const Icon(Icons.sync_alt, size: 14, color: Colors.grey),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ),
      ],
    ),
  );

  Widget _headerCard() => _card(
    title: 'AUDIT REPORT HEADER',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _factsPanel([
          _fact('OFFICE AUDITED', _officeAuditedName ?? _planOfficeProcess),
          const SizedBox(width: 16),
          _fact('DATE OF AUDIT', _planDate),
          const SizedBox(width: 16),
          _fact('AUDIT STANDARD', _auditStandardISOName),
        ]),
        _autoNote(
          'Office, date and standard come from the audit plan and checklist.',
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _auditPurposeController,
          readOnly: !_canEdit,
          decoration: _decoration('AUDIT PURPOSE'),
        ),
      ],
    ),
  );

  Widget _scopeCard() {
    final auditees =
        (_report?.auditScope ?? [])
            .map((s) => s.auditee.trim())
            .where((a) => a.isNotEmpty)
            .toList();

    return _card(
      title: 'I. AUDIT SCOPE, AUDITORS AND AUDITEES',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _factsPanel([
            _fact(
              'AREA / PROCESS AUDITED',
              _officeAuditedName ?? _planOfficeProcess,
            ),
            const SizedBox(width: 16),
            _fact('AUDITORS (TEAM)', _planAuditTeamName),
          ]),
          const SizedBox(height: 12),
          const Text(
            'AUDITEES',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: primaryThemeColor,
            ),
          ),
          const SizedBox(height: 8),
          if (auditees.isEmpty)
            const Text(
              'No auditee has been named on the audit checklist yet.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                for (final name in auditees)
                  Chip(
                    label: Text(name, style: const TextStyle(fontSize: 12)),
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
          _autoNote('Auditors and auditees are taken from the audit checklist.'),
        ],
      ),
    );
  }

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
                    readOnly: !_canEdit,
                    decoration: _decoration('Commendable Finding'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: row.areaController,
                    readOnly: !_canEdit,
                    decoration: _decoration('Area'),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                  ),
                  onPressed:
                      _canEdit && _comFindings.length > 1
                          ? () => _removeComFinding(row)
                          : null,
                ),
              ],
            ),
          ),
        if (_canEdit)
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

  String _statusName(int? id) {
    for (final s in _ncarStatuses) {
      if ((s['id'] as num?)?.toInt() == id) {
        final name = (s['ncarStatus'] ?? s['NcarStatus'])?.toString().trim();
        if (name != null && name.isNotEmpty) return name;
      }
    }
    return 'NC';
  }

  Widget _summaryFindingsCard() {
    final findings = _report?.auditSummaryFindings ?? [];
    return _card(
      title: 'III. SUMMARY OF FINDINGS',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (findings.isEmpty)
            const Text(
              'No non-conforming clause on the audit checklist.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            )
          else
            for (final row in findings)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 32,
                      child: Text(
                        '${row.no}.',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        row.findings,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _resultCountChip(
                      _statusName(row.auditNcarStatusId),
                      null,
                      Colors.red.shade700,
                    ),
                  ],
                ),
              ),
          _autoNote(
            'One line per non-conforming clause, each with the NCAR already '
            'raised for it. It follows the audit checklist.',
          ),
        ],
      ),
    );
  }

  Widget _clauseResultsCard() {
    final results = _clauseResults;
    return _card(
      title: 'AUDIT CHECKLIST RESULTS',
      child:
          _isLoadingResults
              ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: CircularProgressIndicator(),
                ),
              )
              : _resultsError != null
              ? Text(
                _resultsError!,
                style: const TextStyle(color: Colors.redAccent),
              )
              : results == null || results.items.isEmpty
              ? const Text(
                'No checklist results yet for this audit schedule.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              )
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      _resultCountChip(
                        'Conforming',
                        results.conformingCount,
                        Colors.green.shade700,
                      ),
                      _resultCountChip(
                        'Non-conforming',
                        results.nonConformingCount,
                        Colors.red.shade700,
                      ),
                      _resultCountChip(
                        'Pending',
                        results.pendingCount,
                        Colors.grey.shade700,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  for (final result in results.items) _clauseResultRow(result),
                ],
              ),
    );
  }

  Widget _resultCountChip(String label, int? count, Color color) => Chip(
    label: Text(
      count == null ? label : '$label: $count',
      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color),
    ),
    backgroundColor: color.withValues(alpha: .1),
    side: BorderSide.none,
    visualDensity: VisualDensity.compact,
  );

  Widget _clauseResultRow(AuditReportClauseResult result) {
    final (label, color) = switch (result.conforming) {
      true => ('Conforming', Colors.green.shade700),
      false => ('Non-conforming', Colors.red.shade700),
      null => ('Pending', Colors.grey.shade700),
    };
    final remarks = (result.findingAndRemarks ?? '').trim();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 56,
            child: Text(
              result.clauseRef,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(result.question, style: const TextStyle(fontSize: 12)),
                if (remarks.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      'Remarks: $remarks',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                if (result.ncarId != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      'NCAR ${result.ncarReferenceNumber} • ${result.ncarStatus}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.red.shade800,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _conclusionsCard() => _card(
    title: 'IV. AUDIT CONCLUSIONS',
    child: TextFormField(
      controller: _auditConclusionsController,
      readOnly: !_canEdit,
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
                    const Expanded(
                      child: Text(
                        'AUDIT REPORT',
                        style: TextStyle(
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
                              _headerCard(),
                              _scopeCard(),
                              _commendableFindingsCard(),
                              _summaryFindingsCard(),
                              if ((_report?.auditScheduleId ?? 0) > 0)
                                _clauseResultsCard(),
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
                    if (_canEdit && _report != null)
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
