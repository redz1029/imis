// lib/audit/audit_checklist/pages/audit_checklist_print_preview_page.dart
// ignore_for_file: use_build_context_synchronously

import 'dart:math' as math;
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:imis/ISO/IQA/audit_checklist/models/audit_checklist.dart';
import 'package:imis/ISO/IQA/audit_checklist/services/audit_checklist_service.dart';
import 'package:imis/constant/constant.dart';

/// Opens the native (Flutter) print preview of an Audit Checklist.
///
/// [preparedByName] / [preparedByDate] fill the "PREPARED BY" block. The
/// checklist data carries no preparer, so they default to a blank signature
/// line, like the unsigned printed form.
Future<void> openAuditChecklistPrintPreview(
  BuildContext context,
  int auditScheduleId, {
  String? preparedByName,
  DateTime? preparedByDate,
}) {
  return Navigator.of(context).push<void>(
    MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (_) => AuditChecklistPrintPreviewPage(
        auditScheduleId: auditScheduleId,
        preparedByName: preparedByName,
        preparedByDate: preparedByDate,
      ),
    ),
  );
}

// =============================================================================
// Layout constants (points)
// =============================================================================
const String _kLogoCrmc = 'assets/crmc_logo.png';
const String _kLogoIso = 'assets/iso_tuv_certified.jpg';
const String _kFormCode = 'QP-03-F-05 Rev. 0';

/// The scanned checklist has no TÜV mark in the letterhead. Set to true to add
/// it on the right, as in your Audit Programme preview.
const bool _kShowIsoLogo = false;

const double _kML = 38, _kMR = 38, _kMT = 26, _kMB = 26;
const double _kBorderW = 0.8;
const double _kFont = 10;
const double _kHeadFont = 9;
const double _kSmall = 7;
const double _kLineH = 12.4;
const double _kSmallLineH = 8.8;
const double _kPadX = 5;
const double _kPadY = 3;

/// Square crop box for the CRMC seal (seal ~3/4 of it). Change only this
/// number to make the seal larger or smaller.
const double _kLogoBox = 94;
const double _kTitleH = 30;
const double _kTblHdrH = 32;
const double _kMinRowH = 22;
const double _kBlankRowH = 22;
const double _kBottomH = 92;

// CRITERIA/CLAUSE | ITEMS/QUESTIONS | CONFORMING Y/N | FINDINGS/ REMARKS
const List<double> _kColFr = [0.20, 0.40, 0.20, 0.20];

// =============================================================================
// Data
// =============================================================================
class _Clause {
  const _Clause({
    required this.criteria,
    required this.items,
    required this.conforming,
    required this.remarks,
  });

  final String criteria;
  final String items;
  final bool? conforming;
  final String remarks;
}

class _Data {
  const _Data({
    required this.office,
    required this.scope,
    required this.auditors,
    required this.auditees,
    required this.clauses,
  });

  final String office;
  final String scope;
  final String auditors;
  final String auditees;
  final List<_Clause> clauses;
}

class _PdfAssets {
  const _PdfAssets({
    required this.regular,
    required this.bold,
    required this.unicode,
    this.crmc,
    this.iso,
  });

  final pw.Font regular;
  final pw.Font bold;
  final bool unicode;
  final pw.MemoryImage? crmc;
  final pw.MemoryImage? iso;
}

String _firstNonEmpty(List<String?> values) {
  for (final v in values) {
    final t = v?.trim();
    if (t != null && t.isNotEmpty) return t;
  }
  return '';
}

Future<_Data> _loadPrintData(int auditScheduleId) async {
  final service = AuditChecklistService(Dio());

  final all = await service.getOrGenerateForAuditSchedule(auditScheduleId);
  final rows = all.where((r) => !r.isDeleted).toList();
  if (rows.isEmpty) {
    throw Exception('No ISO clauses are assigned to this audit schedule.');
  }

  // Same fallback the checklist page uses: the schedule summary resolves the
  // office / scope / team when the checklist rows come back without them.
  AuditChecklistSummary? summary;
  try {
    final list = await service.getSchedulesWithChecklistData();
    for (final s in list) {
      if (s.auditScheduleId == auditScheduleId) {
        summary = s;
        break;
      }
    }
  } catch (e) {
    debugPrint('Checklist print preview: could not load schedule summary: $e');
  }

  final head = rows.first;
  return _Data(
    office: _firstNonEmpty([head.officeProcess, summary?.officeProcess]),
    scope: _firstNonEmpty([head.auditScope, summary?.auditScope]),
    auditors: _firstNonEmpty([head.auditorNames, summary?.auditorNames]),
    auditees: _firstNonEmpty([
      head.auditees,
      head.auditeeName,
      summary?.auditees,
    ]),
    clauses: [
      for (final r in rows)
        _Clause(
          criteria: (r.criteria ?? '').trim(),
          items: (r.itemsAndQuestions ?? '').trim(),
          conforming: r.conforming,
          remarks: (r.findingAndRemarks ?? '').trim(),
        ),
    ],
  );
}

Future<_PdfAssets> _loadAssets() async {
  pw.Font regular;
  pw.Font bold;
  var unicode = true;
  try {
    regular = await PdfGoogleFonts.tinosRegular().timeout(
      const Duration(seconds: 10),
    );
    bold = await PdfGoogleFonts.tinosBold().timeout(
      const Duration(seconds: 10),
    );
  } catch (_) {
    regular = pw.Font.times();
    bold = pw.Font.timesBold();
    unicode = false;
  }

  Future<pw.MemoryImage?> logo(String path) async {
    try {
      final data = await rootBundle.load(path);
      return pw.MemoryImage(data.buffer.asUint8List());
    } catch (e) {
      debugPrint('Checklist print preview: cannot load asset "$path": $e');
      return null;
    }
  }

  return _PdfAssets(
    regular: regular,
    bold: bold,
    unicode: unicode,
    crmc: await logo(_kLogoCrmc),
    iso: _kShowIsoLogo ? await logo(_kLogoIso) : null,
  );
}

// =============================================================================
// Text measuring: real Times New Roman advance widths (Tinos is metric
// compatible), so wrapped lines are measured instead of guessed.
// =============================================================================
final Map<int, double> _kGlyphW = () {
  final m = <int, double>{};
  void set(String chars, double w) {
    for (final r in chars.runes) {
      m[r] = w;
    }
  }

  set(' ', 0.25);
  set('0123456789', 0.5);
  set('ijlt', 0.278);
  set('fr', 0.333);
  set('s', 0.389);
  set('acez', 0.444);
  set('bdghknopquvxy', 0.5);
  set('w', 0.722);
  set('m', 0.778);
  set('I', 0.333);
  set('J', 0.389);
  set('FPS', 0.556);
  set('ELTZ', 0.611);
  set('BCR', 0.667);
  set('ADGHKNOQUVXY', 0.722);
  set('M', 0.889);
  set('W', 0.944);
  set('.,', 0.25);
  set(':;/', 0.278);
  set('()-', 0.333);
  set("'", 0.2);
  set('"', 0.408);
  set('&', 0.778);
  set('%', 0.833);
  set('–', 0.5);
  set('—', 1.0);
  set('•', 0.35);
  return m;
}();

// =============================================================================
// Preview page
// =============================================================================
class AuditChecklistPrintPreviewPage extends StatefulWidget {
  const AuditChecklistPrintPreviewPage({
    super.key,
    required this.auditScheduleId,
    this.preparedByName,
    this.preparedByDate,
  });

  final int auditScheduleId;
  final String? preparedByName;
  final DateTime? preparedByDate;

  @override
  State<AuditChecklistPrintPreviewPage> createState() =>
      _AuditChecklistPrintPreviewPageState();
}

class _AuditChecklistPrintPreviewPageState
    extends State<AuditChecklistPrintPreviewPage> {
  _Data? _data;
  _PdfAssets? _assets;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await Future.wait<Object>([
        _loadPrintData(widget.auditScheduleId),
        _loadAssets(),
      ]);
      _data = results[0] as _Data;
      _assets = results[1] as _PdfAssets;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<Uint8List> _buildPdf(PdfPageFormat format) {
    return _ChecklistPdfBuilder(
      data: _data!,
      assets: _assets!,
      format: format,
      preparedByName: widget.preparedByName,
      preparedByDate: widget.preparedByDate,
    ).build();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audit Checklist — Print Preview'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline,
                            color: Colors.redAccent, size: 44),
                        const SizedBox(height: 12),
                        Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _load,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                          ),
                          child: const Text(
                            'RETRY',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : PdfPreview(
                  build: _buildPdf,
                  initialPageFormat: PdfPageFormat.a4,
                  pageFormats: const <String, PdfPageFormat>{
                    'A4': PdfPageFormat.a4,
                    'Letter': PdfPageFormat.letter,
                    'Legal': PdfPageFormat.legal,
                  },
                  canChangeOrientation: false,
                  canChangePageFormat: true,
                  canDebug: false,
                  maxPageWidth: 760,
                  pdfFileName: 'Audit_Checklist_${widget.auditScheduleId}.pdf',
                  onError: (context, error) => Center(
                    child: Text(
                      'Unable to build the preview: $error',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
    );
  }
}

// =============================================================================
// PDF builder
// =============================================================================
class _RowSpec {
  const _RowSpec({
    required this.criteria,
    required this.items,
    required this.yn,
    required this.remarks,
    required this.h,
  });

  final List<String> criteria;
  final List<String> items;
  final String yn;
  final List<String> remarks;
  final double h;
}

class _ChecklistPdfBuilder {
  _ChecklistPdfBuilder({
    required this.data,
    required this.assets,
    required this.format,
    this.preparedByName,
    this.preparedByDate,
  });

  final _Data data;
  final _PdfAssets assets;
  final PdfPageFormat format;
  final String? preparedByName;
  final DateTime? preparedByDate;

  late final double _contentW = format.width - _kML - _kMR;

  late final List<double> _colW = () {
    final w = <double>[for (final f in _kColFr) (_contentW * f).floorToDouble()];
    w[3] = _contentW - w[0] - w[1] - w[2];
    return w;
  }();

  pw.BorderSide get _bs => const pw.BorderSide(width: _kBorderW);

  // Computed once in _prepare().
  late List<double> _hdrW;
  late List<String> _officeLines;
  late List<String> _scopeLines;
  late List<String> _auditorLines;
  late List<String> _auditeeLines;
  late double _row1H;
  late double _row2H;
  late double _capacity;
  late List<_RowSpec> _rows;

  // ---------------------------------------------------------------- text ---
  String _s(String v) {
    if (assets.unicode) return v;
    final sb = StringBuffer();
    for (final r in v.runes) {
      if (r <= 0xFF) {
        sb.writeCharCode(r);
        continue;
      }
      switch (r) {
        case 0x2013:
        case 0x2014:
          sb.write('-');
          break;
        case 0x2018:
        case 0x2019:
          sb.write("'");
          break;
        case 0x201C:
        case 0x201D:
          sb.write('"');
          break;
        case 0x2026:
          sb.write('...');
          break;
        default:
          sb.write('?');
      }
    }
    return sb.toString();
  }

  pw.TextStyle _st({bool bold = false, double size = _kFont}) {
    return pw.TextStyle(
      font: bold ? assets.bold : assets.regular,
      fontSize: size,
      color: PdfColors.black,
    );
  }

  pw.Widget _t(
    String text, {
    bool bold = false,
    double size = _kFont,
    pw.TextAlign? align,
  }) {
    return pw.Text(
      _s(text),
      style: _st(bold: bold, size: size),
      textAlign: align,
    );
  }

  /// Width of [text] in points, with a small safety margin so a measured line
  /// never touches the cell border.
  double _w(String text, {bool bold = false, double size = _kFont}) {
    var em = 0.0;
    for (final r in text.runes) {
      em += _kGlyphW[r] ?? 0.5;
    }
    return em * size * (bold ? 1.10 : 1.03);
  }

  List<String> _wrap(
    String text,
    double maxW, {
    bool bold = false,
    double size = _kFont,
  }) {
    final out = <String>[];
    for (final para in _s(text).split('\n')) {
      final words =
          para.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
      if (words.isEmpty) {
        out.add('');
        continue;
      }
      var cur = '';
      for (var word in words) {
        while (word.length > 1 && _w(word, bold: bold, size: size) > maxW) {
          var cut = word.length - 1;
          while (cut > 1 &&
              _w(word.substring(0, cut), bold: bold, size: size) > maxW) {
            cut--;
          }
          if (cur.isNotEmpty) {
            out.add(cur);
            cur = '';
          }
          out.add(word.substring(0, cut));
          word = word.substring(cut);
        }
        final candidate = cur.isEmpty ? word : '$cur $word';
        if (cur.isEmpty || _w(candidate, bold: bold, size: size) <= maxW) {
          cur = candidate;
        } else {
          out.add(cur);
          cur = word;
        }
      }
      if (cur.isNotEmpty) out.add(cur);
    }
    return out;
  }

  double _inner(int col) => _colW[col] - 2 * _kPadX - 1;

  /// Explicit lines, one fixed-height box each, so a row is exactly as tall as
  /// it was measured.
  pw.Widget _lines(
    List<String> lines, {
    bool bold = false,
    double size = _kFont,
    double lineH = _kLineH,
    pw.TextAlign align = pw.TextAlign.left,
  }) {
    return pw.Column(
      mainAxisSize: pw.MainAxisSize.min,
      crossAxisAlignment: align == pw.TextAlign.center
          ? pw.CrossAxisAlignment.center
          : pw.CrossAxisAlignment.start,
      children: [
        for (final l in lines)
          pw.SizedBox(
            height: lineH,
            child: pw.Text(
              _s(l),
              style: _st(bold: bold, size: size),
              textAlign: align,
              softWrap: false,
            ),
          ),
      ],
    );
  }

  // ------------------------------------------------------------- prepare ---
  void _prepare() {
    final wl = (_contentW * 0.485).floorToDouble();
    final wr = _contentW - wl;
    _hdrW = [wl, wr];
    final inL = wl - 2 * _kPadX - 1;
    final inR = wr - 2 * _kPadX - 1;

    _officeLines = _wrap(data.office, inL);
    _scopeLines = _wrap(data.scope, inR);
    _auditorLines = _wrap(data.auditors, inL, size: _kSmall);
    _auditeeLines = _wrap(data.auditees, inR);

    _row1H =
        (1 + math.max(_officeLines.length, _scopeLines.length)) * _kLineH +
            2 * _kPadY;
    _row2H = math.max(
          _kLineH + _auditorLines.length * _kSmallLineH,
          _kLineH + _auditeeLines.length * _kLineH,
        ) +
        2 * _kPadY;

    _rows = [
      for (final c in data.clauses)
        () {
          final crit = c.criteria.isEmpty
              ? <String>[]
              : _wrap(c.criteria, _inner(0));
          final items =
              c.items.isEmpty ? <String>[] : _wrap(c.items, _inner(1));
          final rem =
              c.remarks.isEmpty ? <String>[] : _wrap(c.remarks, _inner(3));
          final n = math.max(
            1,
            math.max(crit.length, math.max(items.length, rem.length)),
          );
          return _RowSpec(
            criteria: crit,
            items: items,
            yn: c.conforming == null ? '' : (c.conforming! ? 'Y' : 'N'),
            remarks: rem,
            h: math.max(_kMinRowH, n * _kLineH + 8),
          );
        }(),
    ];

    final bodyH = format.height - _kMT - _kMB;
    final fixed = _kLogoBox +
        _kTitleH +
        _row1H +
        _row2H +
        _kTblHdrH +
        _kBottomH +
        2; // slack
    _capacity = math.max(80.0, bodyH - fixed);
  }

  List<List<_RowSpec>> _paginate() {
    final pages = <List<_RowSpec>>[];
    var cur = <_RowSpec>[];
    var used = 0.0;
    for (final r in _rows) {
      if (cur.isNotEmpty && used + r.h > _capacity) {
        pages.add(cur);
        cur = <_RowSpec>[];
        used = 0;
      }
      cur.add(r);
      used += r.h;
    }
    pages.add(cur); // always at least one page, even with no rows
    return pages;
  }

  // ------------------------------------------------------------ letterhead ---
  pw.Widget _letterhead() {
    final crmc = assets.crmc;
    final iso = assets.iso;

    final seal = crmc == null
        ? null
        : pw.SizedBox(
            width: _kLogoBox,
            height: _kLogoBox,
            child: pw.ClipRect(
              child: pw.Image(crmc, fit: pw.BoxFit.cover),
            ),
          );

    final tuv = iso == null
        ? null
        : pw.SizedBox(
            width: 104,
            height: 56,
            child: pw.Image(
              iso,
              fit: pw.BoxFit.contain,
              alignment: pw.Alignment.centerRight,
            ),
          );

    // The text stays centred (both Expanded sides are equal) and the seal sits
    // right against the left of it, as on the scanned form.
    return pw.SizedBox(
      height: _kLogoBox,
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Expanded(
            child: pw.Align(alignment: pw.Alignment.centerRight, child: seal),
          ),
          pw.SizedBox(width: 2),
          pw.Column(
            mainAxisSize: pw.MainAxisSize.min,
            mainAxisAlignment: pw.MainAxisAlignment.center,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              _t('Republic of the Philippines', size: 10),
              _t('Department of Health', size: 10),
              _t(
                'COTABATO REGIONAL AND MEDICAL CENTER',
                bold: true,
                size: 11,
              ),
            ],
          ),
          pw.SizedBox(width: 8),
          pw.Expanded(
            child: pw.Align(alignment: pw.Alignment.centerRight, child: tuv),
          ),
        ],
      ),
    );
  }

  pw.Widget _title() {
    return pw.SizedBox(
      height: _kTitleH,
      child: pw.Center(
        child: _t('AUDIT CHECKLIST', bold: true, size: 10.5),
      ),
    );
  }

  // ------------------------------------------------------------ header box ---
  pw.Widget _hdrCell(
    double w,
    double h,
    List<pw.Widget> kids, {
    bool top = false,
    bool right = false,
  }) {
    return pw.Container(
      width: w,
      height: h,
      padding: const pw.EdgeInsets.symmetric(
        horizontal: _kPadX,
        vertical: _kPadY,
      ),
      decoration: pw.BoxDecoration(
        border: pw.Border(
          top: top ? _bs : pw.BorderSide.none,
          left: _bs,
          right: right ? _bs : pw.BorderSide.none,
          bottom: _bs,
        ),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        mainAxisAlignment: pw.MainAxisAlignment.start,
        children: kids,
      ),
    );
  }

  pw.Widget _headerBox() {
    return pw.Column(
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        pw.Row(
          children: [
            _hdrCell(
              _hdrW[0],
              _row1H,
              [_lines(['OFFICE/PROCESS:']), _lines(_officeLines)],
              top: true,
            ),
            _hdrCell(
              _hdrW[1],
              _row1H,
              [_lines(['AUDIT SCOPE:']), _lines(_scopeLines)],
              top: true,
              right: true,
            ),
          ],
        ),
        pw.Row(
          children: [
            _hdrCell(_hdrW[0], _row2H, [
              _lines(['AUDITOR/S']),
              _lines(_auditorLines, size: _kSmall, lineH: _kSmallLineH),
            ]),
            _hdrCell(
              _hdrW[1],
              _row2H,
              [_lines(['AUDITEE/S:']), _lines(_auditeeLines)],
              right: true,
            ),
          ],
        ),
      ],
    );
  }

  // ----------------------------------------------------------------- table ---
  pw.Widget _gridRow(
    double h,
    List<pw.Widget?> cells,
    List<pw.Alignment> aligns,
  ) {
    return pw.Row(
      children: [
        for (var i = 0; i < 4; i++)
          pw.Container(
            width: _colW[i],
            height: h,
            alignment: aligns[i],
            padding: const pw.EdgeInsets.symmetric(horizontal: _kPadX),
            decoration: pw.BoxDecoration(
              border: pw.Border(
                left: _bs,
                right: i == 3 ? _bs : pw.BorderSide.none,
                bottom: _bs,
              ),
            ),
            child: cells[i],
          ),
      ],
    );
  }

  pw.Widget _tableHeader() {
    pw.Widget h(List<String> lines) => _lines(
          lines,
          bold: true,
          size: _kHeadFont,
          align: pw.TextAlign.center,
        );
    return _gridRow(
      _kTblHdrH,
      [
        h(['CRITERIA/CLAUSE']),
        h(['ITEMS/QUESTIONS']),
        h(['CONFORMING', 'Y/N']),
        h(['FINDINGS/', 'REMARKS']),
      ],
      [
        pw.Alignment.center,
        pw.Alignment.center,
        pw.Alignment.center,
        pw.Alignment.center,
      ],
    );
  }

  pw.Widget _dataRow(_RowSpec r) {
    return _gridRow(
      r.h,
      [
        r.criteria.isEmpty
            ? null
            : _lines(r.criteria, align: pw.TextAlign.center),
        r.items.isEmpty ? null : _lines(r.items),
        r.yn.isEmpty
            ? null
            : _lines([r.yn], bold: true, align: pw.TextAlign.center),
        r.remarks.isEmpty ? null : _lines(r.remarks),
      ],
      [
        pw.Alignment.center,
        pw.Alignment.centerLeft,
        pw.Alignment.center,
        pw.Alignment.centerLeft,
      ],
    );
  }

  pw.Widget _blankRow() {
    return _gridRow(
      _kBlankRowH,
      [null, null, null, null],
      [
        pw.Alignment.center,
        pw.Alignment.center,
        pw.Alignment.center,
        pw.Alignment.center,
      ],
    );
  }

  // ----------------------------------------------------- bottom (per page) ---
  pw.Widget _bottomBlock() {
    final name = (preparedByName ?? '').trim();
    final dateText = preparedByDate == null
        ? ''
        : DateFormat('M/d/yyyy').format(preparedByDate!);
    const w = 190.0;

    return pw.SizedBox(
      height: _kBottomH,
      child: pw.Padding(
        padding: const pw.EdgeInsets.only(top: 6),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisSize: pw.MainAxisSize.min,
              children: [
                _t('PREPARED BY:', size: 9),
                pw.SizedBox(height: 22),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(left: 12),
                  child: pw.Column(
                    mainAxisSize: pw.MainAxisSize.min,
                    children: [
                      pw.Container(
                        width: w,
                        height: 14,
                        alignment: pw.Alignment.center,
                        decoration:
                            pw.BoxDecoration(border: pw.Border(bottom: _bs)),
                        child: name.isEmpty
                            ? null
                            : _t(name.toUpperCase(), size: 10),
                      ),
                      pw.SizedBox(
                        width: w,
                        height: _kLineH,
                        child: pw.Center(child: _t('Auditor')),
                      ),
                      pw.SizedBox(height: 4),
                      pw.SizedBox(
                        width: w,
                        height: 14,
                        child: pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            _t('Date:'),
                            pw.SizedBox(width: 4),
                            pw.Container(
                              width: 90,
                              height: 13,
                              alignment: pw.Alignment.bottomCenter,
                              decoration: pw.BoxDecoration(
                                border: pw.Border(bottom: _bs),
                              ),
                              child: dateText.isEmpty ? null : _t(dateText),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            pw.Expanded(
              child: pw.Align(
                alignment: pw.Alignment.topRight,
                child: _t(_kFormCode, bold: true, size: 8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------------ page ---
  pw.Widget _pageWidget(List<_RowSpec> rows) {
    final used = rows.fold<double>(0, (sum, r) => sum + r.h);
    final blanks = math.max(0, ((_capacity - used) / _kBlankRowH).floor());

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        _letterhead(),
        _title(),
        _headerBox(),
        _tableHeader(),
        for (final r in rows) _dataRow(r),
        for (var i = 0; i < blanks; i++) _blankRow(),
        pw.Spacer(),
        _bottomBlock(),
      ],
    );
  }

  Future<Uint8List> build() async {
    _prepare();

    final doc = pw.Document(
      title: 'Audit Checklist',
      author: 'Cotabato Regional and Medical Center',
    );

    for (final page in _paginate()) {
      doc.addPage(
        pw.Page(
          pageFormat: format,
          margin: const pw.EdgeInsets.fromLTRB(_kML, _kMT, _kMR, _kMB),
          theme: pw.ThemeData.withFont(
            base: assets.regular,
            bold: assets.bold,
          ),
          build: (pw.Context ctx) => _pageWidget(page),
        ),
      );
    }
    return doc.save();
  }
}