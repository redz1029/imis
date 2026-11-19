import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/qms_documents/dcrrf/models/pap_dcrrf_history.dart';
import 'package:imis/qms_documents/dcrrf/services/dcrrf_history_service.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';

enum DcrrfType { newDoc, revision, deletion }

enum DcrrfDecision { denied, approved }

class DcrrfAction {
  final String label;
  final DateTime? date;
  final String signature;
  const DcrrfAction({
    required this.label,
    required this.date,
    required this.signature,
  });

  Map<String, dynamic> toJson() => {
    'label': label,
    'date': date?.toIso8601String(),
    'signature': signature,
  };
}

class DcrrfData {
  final int? id;
  final int? procedureId;
  final String initiator;
  final DateTime date;
  final String referenceNo;
  final String manualTitle;
  final String documentTitle;
  final String documentCode;
  final String revisionNumber;
  final DcrrfType type;
  final String details;
  final String justification;
  final DcrrfDecision? decision;
  final String denialReason;
  final List<DcrrfAction> actions;

  const DcrrfData({
    this.id,
    this.procedureId,
    required this.initiator,
    required this.date,
    required this.referenceNo,
    required this.manualTitle,
    required this.documentTitle,
    required this.documentCode,
    required this.revisionNumber,
    required this.type,
    required this.details,
    required this.justification,
    required this.decision,
    required this.denialReason,
    required this.actions,
  });

  Map<String, dynamic> toJson() => {
    'id': id ?? 0,
    'policyAndProcedureId': procedureId,
    'initiator': initiator,
    'date': date.toIso8601String(),
    'referenceNo': referenceNo,
    'manualTitle': manualTitle,
    'documentTitle': documentTitle,
    'documentCode': documentCode,
    'revisionNumber': revisionNumber,
    'type': type.name,
    'details': details,
    'justification': justification,
    'decision': decision?.name,
    'denialReason': denialReason,
    'actions': [for (final a in actions) a.toJson()],
  };
}

class DcrrfTab extends StatefulWidget {
  final int? procedureId;

  /// Live header values ng document: title, docCode, revision, section...
  final Map<String, String> Function() header;
  final String initiatorName;
  final PapDcrrfService service;

  /// Existing DCRRF record. Null = unang DCRRF pa lang (walang existing record).
  final DcrrfData? existing;

  /// Save handler. Kapag null, magpapakita ng warning na hindi pa connected.
  final Future<void> Function(DcrrfData data)? onSave;

  const DcrrfTab({
    super.key,
    required this.procedureId,
    required this.header,
    required this.initiatorName,
    required this.service,
    this.existing,
    this.onSave,
  });

  @override
  State<DcrrfTab> createState() => DcrrfTabState();
}

class DcrrfTabState extends State<DcrrfTab> {
  static const _actionLabels = [
    'Document Amended/Prepared',
    'Revision History Log Updated',
    'Master list Updated',
    'Document Issued',
  ];

  final _formKey = GlobalKey<FormState>();
  final _initiator = TextEditingController();
  final _reference = TextEditingController();
  final _manualTitle = TextEditingController(text: 'QMS-DOCUMENTS');
  final _docTitle = TextEditingController();
  final _docCode = TextEditingController();
  final _revNo = TextEditingController();
  final _details = TextEditingController();
  final _justification = TextEditingController();
  final _denialReason = TextEditingController();
  final Map<String, TextEditingController> _sig = {
    for (final a in _actionLabels) a: TextEditingController(),
  };
  final Map<String, DateTime?> _actDate = {
    for (final a in _actionLabels) a: null,
  };

  DateTime _date = DateTime.now();
  DcrrfType? _type;
  DcrrfDecision? _decision;
  List<PapDcrrfHistoryLog> _history = [];

  bool _loading = true;
  bool _saving = false;
  bool _dirty = false;
  String? _error;

  bool get _locked => widget.existing == null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => reload());
  }

  @override
  void dispose() {
    for (final c in [
      _initiator,
      _reference,
      _manualTitle,
      _docTitle,
      _docCode,
      _revNo,
      _details,
      _justification,
      _denialReason,
    ]) {
      c.dispose();
    }
    for (final c in _sig.values) {
      c.dispose();
    }
    super.dispose();
  }

  List<PapDcrrfHistoryLog> _sorted(List<PapDcrrfHistoryLog> rows) {
    final s = [...rows];
    s.sort((a, b) {
      final c = (a.date ?? DateTime(0)).compareTo(b.date ?? DateTime(0));
      return c != 0 ? c : (a.id ?? 0).compareTo(b.id ?? 0);
    });
    return s;
  }

  Future<void> reload() async {
    if (_dirty || !mounted) return;
    setState(() {
      _loading = true;
      _error = null;
    });

    List<PapDcrrfHistoryLog> rows = const [];
    String? error;
    final id = widget.procedureId;
    if (id != null) {
      try {
        final hist = await widget.service.getHistory(id);
        rows = _sorted([
          for (final r
              in hist.policyAndProcedureLogList ?? const <PapDcrrfHistoryLog>[])
            if (r.isDeleted != true) r,
        ]);
      } catch (e) {
        error = 'Failed to load history log';
      }
    }
    if (!mounted) return;

    final h = widget.header();
    final latest = rows.isEmpty ? null : rows.last;
    final e = widget.existing;

    setState(() {
      _history = rows.reversed.toList(); // newest first sa table
      _error = error;

      if (e != null) {
        _applyExisting(e);
      } else {
        _initiator.text = widget.initiatorName;
        _date = DateTime.now();
        _docTitle.text = h['title'] ?? '';
        final code = (h['docCode'] ?? '').trim();
        _docCode.text = code.isNotEmpty ? code : (latest?.documentCode ?? '');

        if (latest == null) {
          // Unang record pa lang: New document.
          _type = DcrrfType.newDoc;
          final rev = (h['revision'] ?? '').trim();
          _revNo.text = rev.isNotEmpty ? rev : '0';
        } else {
          // May history na, pero hayaan ang user na pumili ng type.
          final lastRev = (latest.revision ?? '').trim();
          final n = int.tryParse(lastRev);
          _revNo.text = n == null ? lastRev : '${n + 1}';
        }
      }
      _loading = false;
    });
  }

  void _applyExisting(DcrrfData e) {
    _initiator.text = e.initiator;
    _date = e.date;
    _reference.text = e.referenceNo;
    _manualTitle.text = e.manualTitle;
    _docTitle.text = e.documentTitle;
    _docCode.text = e.documentCode;
    _revNo.text = e.revisionNumber;
    _type = e.type;
    _details.text = e.details;
    _justification.text = e.justification;
    _decision = e.decision;
    _denialReason.text = e.denialReason;
    for (final a in e.actions) {
      if (_actDate.containsKey(a.label)) {
        _actDate[a.label] = a.date;
        _sig[a.label]?.text = a.signature;
      }
    }
  }

  DcrrfData _collect() => DcrrfData(
    id: widget.existing?.id,
    procedureId: widget.procedureId,
    initiator: _initiator.text.trim(),
    date: _date,
    referenceNo: _reference.text.trim(),
    manualTitle: _manualTitle.text.trim(),
    documentTitle: _docTitle.text.trim(),
    documentCode: _docCode.text.trim(),
    revisionNumber: _revNo.text.trim(),
    type: _type ?? DcrrfType.newDoc,
    details: _details.text.trim(),
    justification: _justification.text.trim(),
    decision: _decision,
    denialReason: _denialReason.text.trim(),
    actions: [
      for (final a in _actionLabels)
        DcrrfAction(
          label: a,
          date: _actDate[a],
          signature: _sig[a]!.text.trim(),
        ),
    ],
  );
  Future<void> _save() async {
    if (_saving) return;
    if (!_formKey.currentState!.validate()) return;

    if (_type == null) {
      MotionToast.warning(
        title: const Text('Required'),
        description: const Text('Please tick New, Revision, or Deletion.'),
        toastAlignment: Alignment.center,
      ).show(context);
      return;
    }

    final save = widget.onSave;
    if (save == null) {
      MotionToast.warning(
        title: const Text('Not connected'),
        description: const Text('DCRRF save endpoint is not connected yet.'),
        toastAlignment: Alignment.center,
      ).show(context);
      return;
    }

    setState(() => _saving = true);
    try {
      await save(_collect());
      if (!mounted) return;
      _dirty = false;
      MotionToast.success(
        title: const Text('Success'),
        description: const Text('DCRRF saved'),
        toastAlignment: Alignment.center,
      ).show(context);
    } catch (e) {
      if (!mounted) return;
      MotionToast.error(
        title: const Text('Failed to Save'),
        description: Text('$e', maxLines: 3, overflow: TextOverflow.ellipsis),
        toastAlignment: Alignment.center,
      ).show(context);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _pickActionDate(String label) async {
    final d = await showDatePicker(
      context: context,
      initialDate: _actDate[label] ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (d == null) return;
    setState(() {
      _actDate[label] = d;
      _dirty = true;
    });
  }

  // ---------------------------------------------------------------- UI

  OutlineInputBorder _outline(Color c) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: c),
  );

  InputDecoration _deco({String? hint}) => InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade500),
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    border: _outline(Colors.grey.shade300),
    enabledBorder: _outline(Colors.grey.shade300),
    focusedBorder: _outline(primaryColor),
    errorBorder: _outline(Colors.red.shade300),
    focusedErrorBorder: _outline(Colors.red.shade400),
    disabledBorder: _outline(Colors.grey.shade200),
  );

  Widget _label(String t, {bool required = false}) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      required ? '$t *' : t,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  Widget _text(
    TextEditingController c,
    String label, {
    String? hint,
    bool required = false,
    bool readOnly = false,
    int minLines = 1,
    int? maxLines = 1,
    bool Function()? requiredWhen,
  }) {
    final isRequired = required || requiredWhen != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label, required: isRequired),
        TextFormField(
          controller: c,
          readOnly: readOnly,
          minLines: minLines,
          maxLines: maxLines,
          keyboardType: TextInputType.multiline,
          onChanged: (_) => _dirty = true,
          style: GoogleFonts.plusJakartaSans(fontSize: 12),
          decoration: _deco(hint: hint),
          validator: (v) {
            final need = required || (requiredWhen?.call() ?? false);
            return need && (v == null || v.trim().isEmpty)
                ? '$label is required'
                : null;
          },
        ),
      ],
    );
  }

  Widget _cols(List<Widget> children) {
    return LayoutBuilder(
      builder: (context, c) {
        if (c.maxWidth < 700) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < children.length; i++) ...[
                children[i],
                if (i != children.length - 1) const SizedBox(height: 14),
              ],
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < children.length; i++) ...[
              Expanded(child: children[i]),
              if (i != children.length - 1) const SizedBox(width: 16),
            ],
          ],
        );
      },
    );
  }

  Widget _section(String title, {String? hint}) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: primaryColor,
          ),
        ),
        if (hint != null) ...[
          const SizedBox(width: 8),
          Text(
            hint,
            style: const TextStyle(
              fontSize: 11,
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
          ),
        ],
      ],
    ),
  );

  Widget _divider() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 18),
    child: Divider(height: 1, color: Colors.grey.shade200),
  );

  Widget _checkRow(String label, bool value, VoidCallback onTap) => InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: value,
              activeColor: primaryColor,
              onChanged: (_) => onTap(),
            ),
          ),
          const SizedBox(width: 8),
          Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 12)),
        ],
      ),
    ),
  );

  void _setType(DcrrfType t) => setState(() {
    _type = t;
    _dirty = true;
  });

  void _setDecision(DcrrfDecision d) => setState(() {
    _decision = d;
    _dirty = true;
  });

  Widget _typeBox() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _label('Tick appropriate box', required: true),
      _checkRow(
        'New',
        _type == DcrrfType.newDoc,
        () => _setType(DcrrfType.newDoc),
      ),
      _checkRow(
        'Revision',
        _type == DcrrfType.revision,
        () => _setType(DcrrfType.revision),
      ),
      _checkRow(
        'Deletion',
        _type == DcrrfType.deletion,
        () => _setType(DcrrfType.deletion),
      ),
    ],
  );

  Widget _dateBox(String text, VoidCallback? onTap) => InkWell(
    borderRadius: BorderRadius.circular(8),
    onTap: onTap,
    child: InputDecorator(
      decoration: _deco().copyWith(
        suffixIcon: const Icon(Icons.calendar_today_outlined, size: 16),
      ),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          color: text == 'Select date' ? Colors.grey.shade500 : Colors.black87,
        ),
      ),
    ),
  );

  Widget _historyTable() {
    TableRow row(List<String> cells, {bool header = false}) => TableRow(
      decoration:
          header ? BoxDecoration(color: primaryColor.withOpacity(0.1)) : null,
      children: [
        for (final c in cells)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Text(
              c.isEmpty ? '—' : c,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: header ? FontWeight.w700 : FontWeight.w500,
                color: header ? primaryColor : Colors.black87,
              ),
            ),
          ),
      ],
    );

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.hardEdge,
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(1),
          1: FlexColumnWidth(1.5),
          2: FlexColumnWidth(1.8),
          3: FlexColumnWidth(4),
        },
        border: TableBorder(
          horizontalInside: BorderSide(color: Colors.grey.shade200),
        ),
        children: [
          row(['Rev.', 'Date', 'Document Code', 'Reasons'], header: true),
          for (final h in _history)
            row([
              h.revision ?? '',
              h.date == null ? '' : DateFormat('MMM d, y').format(h.date!),
              h.documentCode ?? '',
              h.reasons ?? '',
            ]),
        ],
      ),
    );
  }

  Widget _approvalSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 40,
          children: [
            _checkRow(
              'Request Denied',
              _decision == DcrrfDecision.denied,
              () => _setDecision(DcrrfDecision.denied),
            ),
            _checkRow(
              'Request Approved',
              _decision == DcrrfDecision.approved,
              () => _setDecision(DcrrfDecision.approved),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _text(
          _denialReason,
          'If denied, state reason/s or suggestion/s for revision',
          minLines: 2,
          maxLines: null,
          requiredWhen: () => !_locked && _decision == DcrrfDecision.denied,
        ),
      ],
    );
  }

  Widget _actionRows() {
    return Column(
      children: [
        for (final a in _actionLabels)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: LayoutBuilder(
              builder: (context, c) {
                final date = _dateBox(
                  _actDate[a] == null
                      ? 'Select date'
                      : DateFormat('MMM d, y').format(_actDate[a]!),
                  () => _pickActionDate(a),
                );
                final sig = TextFormField(
                  controller: _sig[a],
                  onChanged: (_) => _dirty = true,
                  style: GoogleFonts.plusJakartaSans(fontSize: 12),
                  decoration: _deco(hint: 'Signature'),
                );
                final title = Text(
                  a,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                );
                if (c.maxWidth < 700) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      title,
                      const SizedBox(height: 6),
                      date,
                      const SizedBox(height: 6),
                      sig,
                    ],
                  );
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 3, child: title),
                    const SizedBox(width: 12),
                    Expanded(flex: 2, child: date),
                    const SizedBox(width: 12),
                    Expanded(flex: 3, child: sig),
                  ],
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _lockable(Widget child) =>
      _locked
          ? Opacity(opacity: 0.5, child: IgnorePointer(child: child))
          : child;

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: primaryColor),
        ),
      );
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Document Change Request / Revision Form (DCRRF)',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const Text(
                          'QP-01-F-01 Rev. 0',
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        _error!,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.red.shade400,
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    _cols([
                      _text(_initiator, 'Initiator', required: true),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _label('Date'),
                          _dateBox(DateFormat('MMMM d, y').format(_date), null),
                        ],
                      ),
                      _text(
                        _reference,
                        'Reference No.',
                        hint: 'Assigned by DCO',
                        readOnly: _locked,
                      ),
                    ]),
                    _divider(),
                    _section('1. DETAILS OF DOCUMENT TO BE PREPARED/REVISED'),
                    _cols([
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _text(_manualTitle, 'Manual Title', required: true),
                          const SizedBox(height: 14),
                          _text(
                            _docTitle,
                            'Document Title',
                            required: true,
                            minLines: 1,
                            maxLines: null,
                          ),
                          const SizedBox(height: 14),
                          _cols([
                            _text(_docCode, 'Document Code', required: true),
                            _text(_revNo, 'Revision Number', required: true),
                          ]),
                        ],
                      ),
                      _typeBox(),
                    ]),
                    if (_history.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _label('Previous revisions (from History Log)'),
                      _historyTable(),
                    ],
                    _divider(),
                    _section(
                      '2. DETAILS OF REQUEST',
                      hint: '(Provide additional sheet if necessary)',
                    ),
                    _text(
                      _details,
                      'Details',
                      hint: 'Describe the document to be prepared/revised',
                      required: true,
                      minLines: 4,
                      maxLines: null,
                    ),
                    _divider(),
                    _section('3. JUSTIFICATION'),
                    _text(
                      _justification,
                      'Justification',
                      hint: 'Why is this change needed?',
                      minLines: 4,
                      maxLines: null,
                      requiredWhen:
                          () => _type != null && _type != DcrrfType.newDoc,
                    ),
                    _divider(),
                    _section(
                      '4. APPROVAL',
                      hint: '(Tick/Fill appropriate box)',
                    ),
                    _lockable(_approvalSection()),
                    _divider(),
                    _section('5. ACTION BY THE DOCUMENTS CONTROL OFFICER'),
                    _lockable(_actionRows()),
                    if (_locked)
                      const Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(
                          'Sections 4 and 5 are for the approver and Documents '
                          'Control Officer. They unlock once this request is saved.',
                          style: TextStyle(
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: _saving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child:
                      _saving
                          ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : const Text('Save DCRRF'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
