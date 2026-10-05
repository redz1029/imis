// lib/audit/audit_checklist/pages/audit_checklist_page.dart
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:imis/audit/audit_schedules/models/audit_schedules.dart';
import 'package:imis/audit/audit_schedules/services/audit_schedule_service.dart';
import '../models/audit_checklist.dart';
import '../models/auditee.dart';
import '../services/audit_checklist_service.dart';
import '../services/auditee_service.dart';

class AuditChecklistPage extends StatefulWidget {
  final int auditPlanEntryId;

  const AuditChecklistPage({super.key, required this.auditPlanEntryId});

  @override
  State<AuditChecklistPage> createState() => _AuditChecklistPageState();
}

class _AuditChecklistPageState extends State<AuditChecklistPage> {
  static const Color primaryThemeColor = Color(0xFF883942);

  final AuditChecklistService _service = AuditChecklistService(Dio());
  final AuditeeService _auditeeService = AuditeeService(Dio());
  final AuditSchedulesService _scheduleService = AuditSchedulesService(Dio());

  int _currentAuditPlanEntryId = 0;
  List<AuditSchedules> _confirmedSchedules = [];
  bool _isLoadingSchedules = false;

  Future<List<AuditChecklist>>? _future;
  List<AuditChecklist> _rows = [];
  List<Auditee> _auditeeSuggestions = [];
  final Map<int, TextEditingController> _remarksControllers = {};

  final TextEditingController _auditeeTextController = TextEditingController();
  final FocusNode _auditeeFocusNode = FocusNode();
  int? _selectedAuditeeId;

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _currentAuditPlanEntryId = widget.auditPlanEntryId;
    if (_currentAuditPlanEntryId > 0) {
      _future = _load();
    } else {
      _loadConfirmedSchedules();
    }
    _loadAuditeeSuggestions();
  }

  Future<void> _loadConfirmedSchedules() async {
    setState(() => _isLoadingSchedules = true);
    try {
      final list = await _scheduleService.getConfirmedAuditSchedules();
      if (mounted) setState(() => _confirmedSchedules = list);
    } catch (_) {
      if (mounted) setState(() => _confirmedSchedules = []);
    } finally {
      if (mounted) setState(() => _isLoadingSchedules = false);
    }
  }

  Future<List<AuditChecklist>> _load() async {
    final rows = await _service.getOrGenerateForAuditPlanEntry(_currentAuditPlanEntryId);
    _rows = rows;
    if (rows.isNotEmpty) {
      _selectedAuditeeId = rows.first.auditeeId;
      _auditeeTextController.text = rows.first.auditeeName ?? '';
    }
    for (final r in rows) {
      _remarksControllers[r.id] = TextEditingController(text: r.findingAndRemarks ?? '');
    }
    return rows;
  }

  Future<void> _loadAuditeeSuggestions() async {
    try {
      final list = await _auditeeService.getAll();
      if (mounted) setState(() => _auditeeSuggestions = list);
    } catch (_) {
      if (mounted) setState(() => _auditeeSuggestions = []);
    }
  }

  @override
  void dispose() {
    for (final c in _remarksControllers.values) {
      c.dispose();
    }
    _auditeeTextController.dispose();
    _auditeeFocusNode.dispose();
    super.dispose();
  }

  void _setConforming(int index, bool? value) {
    setState(() {
      _rows[index] = _rows[index].copyWithResponse(conforming: value);
    });
  }

  Future<void> _saveAll() async {
    setState(() => _saving = true);
    try {
      final auditeeName = _auditeeTextController.text.trim().isEmpty
          ? null
          : _auditeeTextController.text.trim();
      for (var i = 0; i < _rows.length; i++) {
        final remarks = _remarksControllers[_rows[i].id]?.text;
        var updated = _rows[i].copyWithResponse(findingAndRemarks: remarks);
        updated = updated.copyWithAuditee(
          auditeeId: _selectedAuditeeId,
          auditeeName: auditeeName,
        );
        _rows[i] = await _service.save(updated);
      }
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Checklist saved')));
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
    if (_currentAuditPlanEntryId == 0) {
      return Scaffold(
        appBar: AppBar(title: const Text('Select Confirmed Audit Schedule')),
        body: _isLoadingSchedules
            ? const Center(child: CircularProgressIndicator(color: primaryThemeColor))
            : _confirmedSchedules.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'No Confirmed Audit Schedules found.\nAn Audit Schedule must be confirmed by the Department Head (or approved) before a checklist can be filled.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(fontSize: 14, color: Colors.grey.shade700),
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(24),
                    itemCount: _confirmedSchedules.length,
                    itemBuilder: (context, index) {
                      final sched = _confirmedSchedules[index];
                      final dateRange =
                          '${DateFormat('MMM d, yyyy').format(sched.startDate)} – ${DateFormat('MMM d, yyyy').format(sched.endDate)}';
                      final title = sched.officeName != null && sched.officeName!.isNotEmpty
                          ? sched.officeName!
                          : (sched.activity.isNotEmpty ? sched.activity : 'Schedule #${sched.id}');

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 1,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        child: ListTile(
                          title: Text(
                            title,
                            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Status: ${sched.effectiveStatusName} • $dateRange',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: primaryThemeColor),
                          onTap: () {
                            setState(() {
                              _currentAuditPlanEntryId = sched.auditPlanEntryId;
                              _future = _load();
                            });
                          },
                        ),
                      );
                    },
                  ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Audit Checklist'),
        leading: widget.auditPlanEntryId == 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                tooltip: 'Back to schedules',
                onPressed: () {
                  setState(() {
                    _currentAuditPlanEntryId = 0;
                    _rows.clear();
                    _remarksControllers.clear();
                    _loadConfirmedSchedules();
                  });
                },
              )
            : null,
      ),
      body: FutureBuilder<List<AuditChecklist>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (_rows.isEmpty) {
            return const Center(child: Text('No checklist items found.'));
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
        },
      ),
    );
  }

  Widget _buildAuditeeCombo() {
    return RawAutocomplete<Auditee>(
      textEditingController: _auditeeTextController,
      focusNode: _auditeeFocusNode,
      optionsBuilder: (TextEditingValue value) {
        if (value.text.trim().isEmpty) return _auditeeSuggestions;
        final query = value.text.trim().toLowerCase();
        return _auditeeSuggestions
            .where((a) => a.displayName.toLowerCase().contains(query));
      },
      displayStringForOption: (a) => a.displayName,
      onSelected: (Auditee selection) {
        setState(() {
          _selectedAuditeeId = selection.id;
          _auditeeTextController.text = selection.displayName;
        });
      },
      fieldViewBuilder: (context, textController, focusNode, onFieldSubmitted) {
        return TextFormField(
          controller: textController,
          focusNode: focusNode,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            labelText: 'AUDITEE',
            labelStyle: const TextStyle(
              color: primaryThemeColor,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
            isDense: true,
            hintText: 'Type or select the auditee',
            hintStyle: const TextStyle(fontSize: 12),
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
          ),
          onChanged: (val) {
            final match = _auditeeSuggestions.where((a) => a.displayName == val);
            _selectedAuditeeId = match.isNotEmpty ? match.first.id : null;
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
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, i) {
                  final option = options.elementAt(i);
                  return InkWell(
                    onTap: () => onSelected(option),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Text(option.displayName, style: const TextStyle(fontSize: 12)),
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

  Widget _buildHeader(AuditChecklist header) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Republic of the Philippines',
              textAlign: TextAlign.center, style: TextStyle(fontStyle: FontStyle.italic)),
          const Text('Department of Health', textAlign: TextAlign.center),
          const Text('COTABATO REGIONAL AND MEDICAL CENTER',
              textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('AUDIT CHECKLIST',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          _headerRow('OFFICE/PROCESS', header.officeProcess),
          _headerRow('AUDITOR/S', header.auditTeamName),
          const SizedBox(height: 8),
          _buildAuditeeCombo(),
        ],
      ),
    );
  }

  Widget _headerRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: [
            TextSpan(text: '$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: value ?? '—'),
          ],
        ),
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
          2: FixedColumnWidth(90),
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
        ],
      ),
    );
  }

  TableRow _buildRow(int index) {
    final row = _rows[index];
    return TableRow(
      children: [
        Padding(padding: const EdgeInsets.all(8), child: Text(row.criteria ?? '')),
        Padding(padding: const EdgeInsets.all(8), child: Text(row.itemsAndQuestions ?? '')),
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