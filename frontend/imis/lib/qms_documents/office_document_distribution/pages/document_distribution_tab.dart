import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/qms_documents/office_document_distribution/models/office_document_distribution.dart';
import 'package:imis/qms_documents/office_document_distribution/models/policy_and_procedure_office_document.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';

/// Option sa Copy Holder dropdown. Kung walang laman ang `holders`,
/// text field (user id) ang lalabas.
class DistributionHolder {
  final String userId;
  final String name;
  final int? officeId;
  const DistributionHolder({
    required this.userId,
    required this.name,
    this.officeId,
  });
}

/// Option sa Office dropdown.
class DistributionOffice {
  final int id;
  final String name;
  const DistributionOffice({required this.id, required this.name});
}

class DocumentDistributionTab extends StatefulWidget {
  final int? procedureId;
  final String Function() documentCode;
  final String Function() documentTitle;
  final List<DistributionHolder> holders;
  final List<DistributionOffice> offices;
  final Future<PolicyAndProcedureOfficeDocument?> Function(int procedureId)
  onLoad;
  final Future<PolicyAndProcedureOfficeDocument> Function(
    PolicyAndProcedureOfficeDocument doc,
  )
  onSave;

  const DocumentDistributionTab({
    super.key,
    required this.procedureId,
    required this.documentCode,
    required this.documentTitle,
    required this.onLoad,
    required this.onSave,
    this.holders = const [],
    this.offices = const [],
  });

  @override
  State<DocumentDistributionTab> createState() =>
      DocumentDistributionTabState();
}

class DocumentDistributionTabState extends State<DocumentDistributionTab> {
  // flex per column (Copy No | Holder | Office | I-Date | I-Rev | I-Sig | R-Date | R-Rev | R-Sig)
  static const _fNo = 2;
  static const _fHolder = 7;
  static const _fOffice = 7;
  static const _fDate = 4;
  static const _fRev = 3;
  static const _fSig = 4;
  static const double _actionW = 44;
  static const double _minTableW = 1200;

  PolicyAndProcedureOfficeDocument? _doc;
  List<_DistRow> _rows = [];
  final List<_DistRow> _removed = [];
  DateTime? _postingDate;
  bool _controlled = true;
  bool _master = true;

  bool _loading = false;
  bool _saving = false;
  bool _dirty = false;
  String? _error;

  bool get dirty => _dirty;

  @override
  void initState() {
    super.initState();
    if (widget.procedureId != null) reload();
  }

  @override
  void didUpdateWidget(covariant DocumentDistributionTab old) {
    super.didUpdateWidget(old);
    if (old.procedureId != widget.procedureId && widget.procedureId != null) {
      reload();
    }
  }

  @override
  void dispose() {
    _disposeRows();
    super.dispose();
  }

  void _disposeRows() {
    for (final r in _rows) {
      r.dispose();
    }
    for (final r in _removed) {
      r.dispose();
    }
    _rows = [];
    _removed.clear();
  }

  DateTime? _validDate(DateTime? d) => (d == null || d.year < 2000) ? null : d;

  Future<void> reload() async {
    final pid = widget.procedureId;
    if (pid == null) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final d = await widget.onLoad(pid);
      if (!mounted) return;
      _disposeRows();
      setState(() {
        _doc = d;
        _postingDate = _validDate(d?.postingDate);
        _controlled = d?.isControlledCopy ?? true;
        _master = d?.isMasterCopy ?? true;
        _rows = [
          for (final e
              in (d?.officeDocumentDistributionList ??
                  const <OfficeDocumentDistribution>[]))
            if (!e.isDeleted) _DistRow.fromModel(e, _validDate),
        ];
        _dirty = false;
      });
    } catch (e) {
      debugPrint('Distribution load failed: $e');
      if (mounted) {
        setState(() => _error = 'Failed to load distribution list');
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _markDirty() {
    if (!_dirty) setState(() => _dirty = true);
  }

  void _addRow() => setState(() {
    _rows.add(_DistRow());
    _dirty = true;
  });

  void _removeRow(int i) => setState(() {
    final r = _rows.removeAt(i);
    if (r.source != null) {
      _removed.add(r);
    } else {
      r.dispose();
    }
    _dirty = true;
  });

  Future<DateTime?> _pick(DateTime? current) {
    return showDatePicker(
      context: context,
      initialDate: current ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
  }

  String? _validate() {
    for (var i = 0; i < _rows.length; i++) {
      if ((_rows[i].userId ?? '').trim().isEmpty) {
        return 'Copy ${i + 1}: Copy Holder is required';
      }
    }
    return null;
  }

  Future<void> save() async {
    if (_saving || widget.procedureId == null) return;

    final err = _validate();
    if (err != null) {
      MotionToast.error(
        title: const Text('Incomplete Row'),
        description: Text(err),
        toastAlignment: Alignment.center,
      ).show(context);
      return;
    }

    setState(() => _saving = true);
    try {
      final parentId = _doc?.id ?? 0;
      final payload = PolicyAndProcedureOfficeDocument(
        id: parentId,
        isDeleted: false,
        rowVersion: _doc?.rowVersion,
        policyAndProcedureId: widget.procedureId,
        postingDate: _postingDate ?? DateTime.now(),
        isControlledCopy: _controlled,
        isMasterCopy: _master,
        officeDocumentDistributionList: [
          for (final r in _rows) r.toModel(parentId),
          for (final r in _removed) r.toModel(parentId, deleted: true),
        ],
      );

      await widget.onSave(payload);

      if (!mounted) return;
      MotionToast.success(
        title: const Text('Success'),
        description: const Text('Distribution list saved'),
        toastAlignment: Alignment.center,
      ).show(context);
      await reload();
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

  // ───────────────────────── UI ─────────────────────────

  OutlineInputBorder _outline(Color c) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: c),
  );

  InputDecoration _dec({String? hint, Widget? suffix}) => InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade500),
    isDense: true,
    suffixIcon: suffix,
    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
    border: _outline(Colors.grey.shade300),
    enabledBorder: _outline(Colors.grey.shade300),
    focusedBorder: _outline(primaryColor),
  );

  Widget _card({required Widget child}) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: child,
  );

  Widget _locked() => _card(
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.lock_outline, size: 40, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(
            'Document Distribution List is locked',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "You can't use this form yet. Save the document first to unlock it.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    ),
  );

  Widget _info(String label, String value) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      const SizedBox(height: 4),
      Text(
        value.trim().isEmpty ? '—' : value.trim(),
        style: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );

  Widget _postingDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Posting Date',
          style: TextStyle(fontSize: 11, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () async {
            final d = await _pick(_postingDate);
            if (d == null) return;
            setState(() {
              _postingDate = d;
              _dirty = true;
            });
          },
          child: InputDecorator(
            decoration: _dec(
              suffix: const Icon(Icons.calendar_today_outlined, size: 16),
            ),
            child: Text(
              _postingDate == null
                  ? 'Select date'
                  : DateFormat('MMM d, y').format(_postingDate!),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color:
                    _postingDate == null
                        ? Colors.grey.shade500
                        : Colors.black87,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _check(String label, bool value, ValueChanged<bool> onChanged) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: value,
          activeColor: primaryColor,
          visualDensity: VisualDensity.compact,
          onChanged: (v) {
            onChanged(v ?? false);
            _markDirty();
          },
        ),
        Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 12)),
      ],
    );
  }

  Widget _hCell(String t, int flex, {bool blank = false}) => Expanded(
    flex: flex,
    child: Container(
      height: 34,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border.all(color: Colors.grey.shade300, width: 0.6),
      ),
      child:
          blank
              ? null
              : Text(
                t,
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
    ),
  );

  Widget _tableHeader() {
    return Column(
      children: [
        Row(
          children: [
            _hCell('Copy No.', _fNo),
            _hCell('Copy Holder', _fHolder),
            _hCell('Office', _fOffice),
            _hCell('Issuance', _fDate + _fRev + _fSig),
            _hCell('Retrieval', _fDate + _fRev + _fSig),
            const SizedBox(width: _actionW),
          ],
        ),
        Row(
          children: [
            _hCell('', _fNo, blank: true),
            _hCell('', _fHolder, blank: true),
            _hCell('', _fOffice, blank: true),
            _hCell('Date', _fDate),
            _hCell('Revision', _fRev),
            _hCell('Signature', _fSig),
            _hCell('Date', _fDate),
            _hCell('Revision', _fRev),
            _hCell('Signature', _fSig),
            const SizedBox(width: _actionW),
          ],
        ),
      ],
    );
  }

  Widget _dateCell(DateTime? value, ValueChanged<DateTime> onPicked) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () async {
        final d = await _pick(value);
        if (d == null) return;
        onPicked(d);
        setState(() => _dirty = true);
      },
      child: InputDecorator(
        decoration: _dec(),
        child: Text(
          value == null ? 'Select' : DateFormat('MMM d, y').format(value),
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            color: value == null ? Colors.grey.shade500 : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _revCell(TextEditingController c) => TextField(
    controller: c,
    onChanged: (_) => _markDirty(),
    style: GoogleFonts.plusJakartaSans(fontSize: 12),
    decoration: _dec(hint: 'e.g. 00'),
  );

  // Signature ay pinipirmahan sa printed copy, kaya blank box lang dito.
  Widget _sigCell() => Container(
    height: 40,
    decoration: BoxDecoration(
      color: Colors.grey.shade50,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey.shade300),
    ),
  );

  Widget _holderCell(_DistRow r) {
    if (widget.holders.isEmpty) {
      return TextField(
        controller: r.holderText,
        onChanged: (v) {
          r.userId = v.trim();
          _markDirty();
        },
        style: GoogleFonts.plusJakartaSans(fontSize: 12),
        decoration: _dec(hint: 'Copy holder (user id)'),
      );
    }

    final items = <DropdownMenuItem<String>>[
      for (final h in widget.holders)
        DropdownMenuItem<String>(
          value: h.userId,
          child: Text(h.name, overflow: TextOverflow.ellipsis),
        ),
    ];
    final cur = r.userId;
    final hasCur = cur != null && cur.isNotEmpty;
    if (hasCur && !widget.holders.any((h) => h.userId == cur)) {
      items.insert(
        0,
        DropdownMenuItem<String>(
          value: cur,
          child: Text(cur, overflow: TextOverflow.ellipsis),
        ),
      );
    }

    return DropdownButtonFormField<String>(
      key: ValueKey('${identityHashCode(r)}-$cur'),
      value: hasCur ? cur : null,
      isExpanded: true,
      dropdownColor: Colors.white,
      style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.black87),
      hint: Text(
        'Select holder…',
        style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
      ),
      decoration: _dec(),
      items: items,
      onChanged: (v) {
        if (v == null) return;
        setState(() {
          r.userId = v;
          final match = widget.holders.where((h) => h.userId == v);
          if (match.isNotEmpty && match.first.officeId != null) {
            r.officeId = match.first.officeId;
          }
          _dirty = true;
        });
      },
    );
  }

  Widget _officeCell(_DistRow r) {
    if (widget.offices.isEmpty) {
      return InputDecorator(
        decoration: _dec(),
        child: Text(
          r.officeId == null ? '—' : 'Office #${r.officeId}',
          style: GoogleFonts.plusJakartaSans(fontSize: 12),
        ),
      );
    }

    final items = <DropdownMenuItem<int>>[
      for (final o in widget.offices)
        DropdownMenuItem<int>(
          value: o.id,
          child: Text(o.name, overflow: TextOverflow.ellipsis),
        ),
    ];
    final cur = r.officeId;
    if (cur != null && !widget.offices.any((o) => o.id == cur)) {
      items.insert(
        0,
        DropdownMenuItem<int>(value: cur, child: Text('Office #$cur')),
      );
    }

    return DropdownButtonFormField<int>(
      key: ValueKey('off-${identityHashCode(r)}-$cur'),
      value: cur,
      isExpanded: true,
      dropdownColor: Colors.white,
      style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.black87),
      hint: Text(
        'Select office…',
        style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
      ),
      decoration: _dec(),
      items: items,
      onChanged: (v) {
        if (v == null) return;
        setState(() {
          r.officeId = v;
          _dirty = true;
        });
      },
    );
  }

  Widget _dataRow(int i) {
    final r = _rows[i];
    const gap = SizedBox(width: 6);
    return Row(
      key: ObjectKey(r),
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: _fNo,
          child: Center(
            child: Text(
              '${i + 1}',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Expanded(flex: _fHolder, child: _holderCell(r)),
        gap,
        Expanded(flex: _fOffice, child: _officeCell(r)),
        gap,
        Expanded(
          flex: _fDate,
          child: _dateCell(r.issuanceDate, (d) => r.issuanceDate = d),
        ),
        gap,
        Expanded(flex: _fRev, child: _revCell(r.issuanceRev)),
        gap,
        Expanded(flex: _fSig, child: _sigCell()),
        gap,
        Expanded(
          flex: _fDate,
          child: _dateCell(r.retrievalDate, (d) => r.retrievalDate = d),
        ),
        gap,
        Expanded(flex: _fRev, child: _revCell(r.retrievalRev)),
        gap,
        Expanded(flex: _fSig, child: _sigCell()),
        SizedBox(
          width: _actionW,
          child: IconButton(
            tooltip: 'Remove row',
            icon: Icon(
              Icons.delete_outline,
              size: 20,
              color: Colors.red.shade400,
            ),
            onPressed: () => _removeRow(i),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.procedureId == null) return _locked();

    if (_loading) {
      return _card(
        child: const Center(
          child: CircularProgressIndicator(color: primaryColor),
        ),
      );
    }

    if (_error != null) {
      return _card(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_error!, style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 8),
              OutlinedButton(onPressed: reload, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Document Distribution List',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              OutlinedButton.icon(
                onPressed: _addRow,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Copy', style: TextStyle(fontSize: 12)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryColor,
                  side: BorderSide(color: primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _saving ? null : save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
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
                        : const Text('Save', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 32,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: [
              SizedBox(width: 160, child: _info('Code', widget.documentCode())),
              SizedBox(
                width: 320,
                child: _info('Document Title', widget.documentTitle()),
              ),
              SizedBox(width: 170, child: _postingDateField()),
              _check('Controlled Copy', _controlled, (v) {
                setState(() => _controlled = v);
              }),
              _check('Master Copy', _master, (v) {
                setState(() => _master = v);
              }),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1, color: Colors.grey.shade200),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, c) {
                final w = math.max(c.maxWidth, _minTableW);
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _tableHeader(),
                        const SizedBox(height: 10),
                        Expanded(
                          child:
                              _rows.isEmpty
                                  ? Center(
                                    child: Text(
                                      'No copies yet. Click "Add Copy" to start.',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  )
                                  : ListView.separated(
                                    itemCount: _rows.length,
                                    separatorBuilder:
                                        (_, __) => const SizedBox(height: 10),
                                    itemBuilder: (_, i) => _dataRow(i),
                                  ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DistRow {
  final OfficeDocumentDistribution? source;
  String? userId;
  int? officeId;
  DateTime? issuanceDate;
  DateTime? retrievalDate;
  final TextEditingController holderText;
  final TextEditingController issuanceRev;
  final TextEditingController retrievalRev;

  _DistRow({
    this.source,
    this.userId,
    this.officeId,
    this.issuanceDate,
    this.retrievalDate,
  }) : holderText = TextEditingController(text: userId ?? ''),
       issuanceRev = TextEditingController(
         text: source?.issuanceRevision ?? '',
       ),
       retrievalRev = TextEditingController(
         text: source?.retrievalRevision ?? '',
       );

  factory _DistRow.fromModel(
    OfficeDocumentDistribution m,
    DateTime? Function(DateTime?) validDate,
  ) => _DistRow(
    source: m,
    userId: m.copyHolderUserId,
    officeId: m.officeId,
    issuanceDate: validDate(m.issuanceDate),
    retrievalDate: validDate(m.retrievalDate),
  );

  OfficeDocumentDistribution toModel(int parentId, {bool deleted = false}) =>
      OfficeDocumentDistribution(
        id: source?.id ?? 0,
        isDeleted: deleted,
        rowVersion: source?.rowVersion,
        policyAndProcedureOfficeDocumentDistributionId:
            source?.policyAndProcedureOfficeDocumentDistributionId ?? parentId,
        copyHolderUserId: userId,
        officeId: officeId,
        issuanceDate: issuanceDate,
        issuanceRevision: issuanceRev.text.trim(),
        retrievalDate: retrievalDate,
        retrievalRevision: retrievalRev.text.trim(),
      );

  void dispose() {
    holderText.dispose();
    issuanceRev.dispose();
    retrievalRev.dispose();
  }
}
