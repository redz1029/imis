import 'package:flutter/material.dart';
import '../models/audit_checklist.dart';
import '../services/audit_checklist_service.dart';

class AuditChecklistScreen extends StatefulWidget {
  final int auditPlanEntryId;
  final AuditChecklistService service;

  const AuditChecklistScreen({
    super.key,
    required this.auditPlanEntryId,
    required this.service,
  });

  @override
  State<AuditChecklistScreen> createState() => _AuditChecklistScreenState();
}

class _AuditChecklistScreenState extends State<AuditChecklistScreen> {
  late Future<List<AuditChecklist>> _future;
  List<AuditChecklist> _rows = [];
  final Map<int, TextEditingController> _remarksControllers = {};
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<AuditChecklist>> _load() async {
    final rows =
        await widget.service.getOrGenerateForAuditPlanEntry(widget.auditPlanEntryId);
    _rows = rows;
    for (final r in rows) {
      _remarksControllers[r.id] =
          TextEditingController(text: r.findingAndRemarks ?? '');
    }
    return rows;
  }

  @override
  void dispose() {
    for (final c in _remarksControllers.values) {
      c.dispose();
    }
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
      for (var i = 0; i < _rows.length; i++) {
        final remarks = _remarksControllers[_rows[i].id]?.text;
        final updated = _rows[i].copyWithResponse(findingAndRemarks: remarks);
        _rows[i] = await widget.service.save(updated);
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
    return Scaffold(
      appBar: AppBar(title: const Text('Audit Checklist')),
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

  Widget _buildHeader(AuditChecklist header) {
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
          _headerRow('OFFICE/PROCESS', header.officeProcess),
          _headerRow('AUDIT SCOPE', header.auditScope),
          _headerRow('AUDITOR/S', header.auditTeamName),
          _headerRow('AUDITEE/S', header.auditees),
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
            TextSpan(
                text: '$label: ',
                style: const TextStyle(fontWeight: FontWeight.bold)),
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
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(row.criteria ?? ''),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(row.itemsAndQuestions ?? ''),
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
            decoration: const InputDecoration(
              isDense: true,
              border: InputBorder.none,
            ),
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
          const Expanded(
            child: Text('PREPARED BY: _____________________\nAuditor'),
          ),
          ElevatedButton(
            onPressed: _saving ? null : _saveAll,
            child: _saving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2))
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
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}