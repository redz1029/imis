// lib/audit/audit_checklist/pages/audit_checklist_page.dart
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/audit/audit_checklist/models/audit_checklist.dart';
import 'package:imis/audit/audit_checklist/services/audit_checklist_service.dart';

class AuditChecklistPage extends StatefulWidget {
  /// Optional. When provided, the page loads this schedule's checklist
  /// directly. When null/0, the page shows the schedule (team) list.
  final int auditScheduleId;

  const AuditChecklistPage({super.key, this.auditScheduleId = 0});

  @override
  State<AuditChecklistPage> createState() => _AuditChecklistPageState();
}

class _AuditChecklistPageState extends State<AuditChecklistPage> {
  static const Color primaryThemeColor = Color(0xFF883942);

  final AuditChecklistService _service = AuditChecklistService(Dio());

  // List (schedule) mode state.
  bool _isLoadingSchedules = false;
  String? _listError;
  List<AuditChecklistSummary> _schedules = [];

  // Detail (checklist) mode state.
  int _currentAuditScheduleId = 0;
  AuditChecklistSummary? _summary;
  bool _isLoadingChecklist = false;
  String? _checklistError;
  bool _noClauses = false;
  List<AuditChecklist> _rows = [];
  final Map<int, TextEditingController> _remarksControllers = {};
  final TextEditingController _auditeeTextController = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _currentAuditScheduleId = widget.auditScheduleId;
    if (_currentAuditScheduleId > 0) {
      _loadChecklist(_currentAuditScheduleId);
    } else {
      _loadSchedules();
    }
  }

  @override
  void dispose() {
    for (final c in _remarksControllers.values) {
      c.dispose();
    }
    _auditeeTextController.dispose();
    super.dispose();
  }

  Future<void> _loadSchedules() async {
    setState(() {
      _isLoadingSchedules = true;
      _listError = null;
    });
    try {
      final schedules = await _service.getSchedulesWithChecklistData();
      if (mounted) setState(() => _schedules = schedules);
    } catch (e) {
      if (mounted) setState(() => _listError = 'Unable to load audit checklist. $e');
    } finally {
      if (mounted) setState(() => _isLoadingSchedules = false);
    }
  }

  Future<void> _loadChecklist(int auditScheduleId) async {
    setState(() {
      _isLoadingChecklist = true;
      _checklistError = null;
      _noClauses = false;
      _rows = [];
      _remarksControllers.clear();
    });
    try {
      final rows = await _service.getOrGenerateForAuditSchedule(auditScheduleId);
      if (!mounted) return;
      setState(() {
        _rows = rows;
        if (rows.isEmpty) {
          _noClauses = true;
        } else {
          _auditeeTextController.text = rows.first.auditees ?? rows.first.auditeeName ?? '';
        }
      });
      for (final r in rows) {
        _remarksControllers[r.id] =
            TextEditingController(text: r.findingAndRemarks ?? '');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _checklistError = 'Unable to load audit checklist. $e');
      }
    } finally {
      if (mounted) setState(() => _isLoadingChecklist = false);
    }
  }

  void _setConforming(int index, bool? value) {
    setState(() {
      _rows[index] = _rows[index].copyWithResponse(conforming: value);
    });
  }

  Future<void> _saveAll() async {
    setState(() => _saving = true);
    try {
      final auditeeText = _auditeeTextController.text.trim();
      for (var i = 0; i < _rows.length; i++) {
        final remarks = _remarksControllers[_rows[i].id]?.text;
        var updated = _rows[i].copyWithResponse(findingAndRemarks: remarks);
        // Multi-value auditee string — saved as the checklist's display
        // auditee name (backend keeps it as a string).
        updated = updated.copyWithAuditees(auditeeText.isEmpty ? null : auditeeText);
        _rows[i] = await _service.save(updated);
      }
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Checklist saved')));
        // Refresh so the list reflects "Saved" state.
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Save failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Detail mode: an AuditScheduleId is active.
    if (_currentAuditScheduleId > 0) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Audit Checklist'),
          leading: widget.auditScheduleId == 0
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  tooltip: 'Back to schedules',
                  onPressed: () {
                    setState(() {
                      _currentAuditScheduleId = 0;
                      _rows.clear();
                      _remarksControllers.clear();
                      _summary = null;
                      _loadSchedules();
                    });
                  },
                )
              : null,
        ),
        body: _buildChecklistBody(),
      );
    }

    // List mode.
    return Scaffold(
      appBar: AppBar(title: const Text('Audit Checklist')),
      body: _buildListBody(),
    );
  }

  // =========================================================================
  // LIST MODE — dynamically generated from Audit Schedules, not hardcoded.
  // =========================================================================
  Widget _buildListBody() {
    if (_isLoadingSchedules) {
      return const Center(child: CircularProgressIndicator(color: primaryThemeColor));
    }
    if (_listError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.redAccent, size: 40),
              const SizedBox(height: 12),
              Text(
                _listError!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: _loadSchedules, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }
    if (_schedules.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'No confirmed audit checklists found.\nConfirm an Audit Schedule that has ISO clauses assigned to generate its checklist.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: _schedules.length,
      itemBuilder: (context, index) {
        final s = _schedules[index];
        final process = (s.officeProcess?.isNotEmpty ?? false) ? s.officeProcess! : '';
        final teamName = (s.teamName?.isNotEmpty ?? false) ? s.teamName! : '';
        // The department/office is the human-friendly identity of a confirmed
        // checklist; fall back to the team, then the schedule id.
        final title = process.isNotEmpty
            ? process
            : (teamName.isNotEmpty ? teamName : 'Schedule #${s.auditScheduleId}');
        final status = (s.statusName?.isNotEmpty ?? false) ? s.statusName! : 'Confirmed';
        final isApproved = status == 'Confirmed' || status == 'Approved';

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: ListTile(
            title: Text(
              title,
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                [
                  if (teamName.isNotEmpty && teamName != title) teamName,
                  if (s.clauseCount > 0) '${s.clauseCount} clause(s)',
                ].join(' • '),
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: (isApproved ? Colors.green : Colors.orange)
                        .withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isApproved ? Colors.green.shade700 : Colors.orange.shade800,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_ios, size: 16, color: primaryThemeColor),
              ],
            ),
            onTap: () => setState(() {
              _summary = s;
              _currentAuditScheduleId = s.auditScheduleId;
              _loadChecklist(s.auditScheduleId);
            }),
          ),
        );
      },
    );
  }

  // =========================================================================
  // DETAIL MODE — the CRMC Audit Checklist form.
  // =========================================================================
  Widget _buildChecklistBody() {
    if (_isLoadingChecklist) {
      return const Center(child: CircularProgressIndicator(color: primaryThemeColor));
    }
    if (_checklistError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.redAccent, size: 40),
              const SizedBox(height: 12),
              Text(
                _checklistError!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => _loadChecklist(_currentAuditScheduleId),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
    if (_noClauses) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'No ISO clauses are assigned to this audit schedule.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    if (_rows.isEmpty) {
      return const Center(child: Text('Unable to load audit checklist.'));
    }

    final header = _rows.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(header),
        const Divider(height: 1),
        Expanded(child: _buildTable()),
        _buildFooter(),
      ],
    );
  }

  Widget _buildHeader(AuditChecklist header) {
    final officeProcess = (header.officeProcess?.isNotEmpty ?? false)
        ? header.officeProcess!
        : (_summary?.officeProcess ?? '—');
    final auditors = (header.auditorNames?.isNotEmpty ?? false)
        ? header.auditorNames!
        : (header.auditorNames ?? '—');
    final scope = (header.auditScope?.isNotEmpty ?? false)
        ? header.auditScope!
        : (_summary?.auditScope ?? '—');

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Republic of the Philippines',
              textAlign: TextAlign.center,
              style: TextStyle(fontStyle: FontStyle.italic)),
          const Text('Department of Health', textAlign: TextAlign.center),
          const Text('COTABATO REGIONAL AND MEDICAL CENTER',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('AUDIT CHECKLIST',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          _headerRow('OFFICE/PROCESS', officeProcess),
          _headerRow('AUDIT SCOPE', scope),
          _headerRow('AUDITOR/S', auditors),
          const SizedBox(height: 4),
          _headerTextForm(
            'AUDITEE/S',
            _auditeeTextController,
            hint: 'e.g. Chief of Hospital, Medical Records Officer, Section Head',
          ),
        ],
      ),
    );
  }

  Widget _headerRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: [
            TextSpan(text: '$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: value.isEmpty ? '—' : value),
          ],
        ),
      ),
    );
  }

  Widget _headerTextForm(String label, TextEditingController controller,
      {String? hint}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: TextFormField(
              controller: controller,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
                isDense: true,
                hintText: hint,
                hintStyle: const TextStyle(fontSize: 12),
                border: const UnderlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTable() {
    return SingleChildScrollView(
      child: Table(
        border: TableBorder.all(color: Colors.grey.shade400),
        columnWidths: const {
          0: FixedColumnWidth(70),
          1: FlexColumnWidth(3),
          2: FixedColumnWidth(80),
          3: FlexColumnWidth(2),
        },
        children: [
          const TableRow(
            decoration: BoxDecoration(color: Color(0xFFEFEFEF)),
            children: [
              _HeaderCell('CRITERIA/CLAUSE'),
              _HeaderCell('ITEMS/QUESTIONS'),
              _HeaderCell('CONFORMING\nY/N'),
              _HeaderCell('FINDINGS/REMARKS'),
            ],
          ),
          for (var i = 0; i < _rows.length; i++) _buildRow(i),
          // Blank rows purely for visual/print fidelity with the original
          // CRMC form — never carry checklist data.
          for (var i = 0; i < 3; i++)
            const TableRow(
              children: [
                Padding(padding: EdgeInsets.all(8), child: SizedBox(height: 24)),
                Padding(padding: EdgeInsets.all(8), child: SizedBox(height: 24)),
                Padding(padding: EdgeInsets.all(8), child: SizedBox(height: 24)),
                Padding(padding: EdgeInsets.all(8), child: SizedBox(height: 24)),
              ],
            ),
        ],
      ),
    );
  }

  TableRow _buildRow(int index) {
    final row = _rows[index];
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(row.criteria ?? '', style: const TextStyle(fontSize: 12)),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(row.itemsAndQuestions ?? '', style: const TextStyle(fontSize: 12)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: DropdownButton<bool?>(
            isExpanded: true,
            value: row.conforming,
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(value: null, child: Text('')),
              DropdownMenuItem(value: true, child: Text('Y')),
              DropdownMenuItem(value: false, child: Text('N')),
            ],
            onChanged: (value) => _setConforming(index, value),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4),
          child: TextField(
            controller: _remarksControllers[row.id],
            maxLines: null,
            style: const TextStyle(fontSize: 12),
            decoration: const InputDecoration(isDense: true, border: InputBorder.none),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          const Expanded(child: Text('PREPARED BY: _____________________\nAuditor')),
          ElevatedButton(
            onPressed: _saving ? null : _saveAll,
            child: _saving
                ? const SizedBox(
                    width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;
  const _HeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(text, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}