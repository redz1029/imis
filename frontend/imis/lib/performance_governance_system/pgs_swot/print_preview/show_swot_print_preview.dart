import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:imis/constant/constant.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

const String kSwotFormCode = 'QP-01F-11 Rev. 0';
const String kSwotLogoAsset = 'assets/CRMC.png';

class SwotPrintEntry {
  final String label;
  final String left;
  final String right;
  const SwotPrintEntry({required this.label, this.left = '', this.right = ''});
}

class SwotPrintData {
  final String department;
  final String objective;
  final List<SwotPrintEntry> internal;
  final List<SwotPrintEntry> external;
  final String preparedBy;
  final String reviewedBy;
  final String validatedBy;
  final bool isServiceHead;

  const SwotPrintData({
    required this.department,
    required this.objective,
    required this.internal,
    required this.external,
    required this.preparedBy,
    this.reviewedBy = '',
    required this.validatedBy,
    this.isServiceHead = false,
  });
}

Future<void> showSwotPrintPreview(BuildContext context, SwotPrintData data) {
  return showDialog(
    context: context,
    builder:
        (_) => Dialog(
          insetPadding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                color: primaryColor,
                padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'PRINT PREVIEW - SWOT ANALYSIS',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white70),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PdfPreview(
                  build: (_) => buildSwotPdf(data),
                  initialPageFormat: PdfPageFormat.a4.landscape,
                  pdfFileName: 'SWOT_${data.department}.pdf',
                  canChangePageFormat: false,
                  canChangeOrientation: false,
                  canDebug: false,
                  maxPageWidth: 900,
                ),
              ),
            ],
          ),
        ),
  );
}

const _side = pw.BorderSide(width: 1.2);
const _thin = pw.BorderSide(width: 0.5, color: PdfColors.grey700);

final PdfPageFormat _format = PdfPageFormat.a4.landscape;
const _margin = pw.EdgeInsets.fromLTRB(40, 28, 40, 28);
const int _minLines = 2;
const double _lineH = 12.5;
const double _entryGap = 8;
const double _headerH = 132;
const double _footerH = 16;
const double _infoH = 48;
const double _introH = 72;
const double _plainH = 32;
const double _closeH = 6;
const double _sigH = 84;
const double _logoShift = 35;
pw.ThemeData? _cachedTheme;
pw.MemoryImage? _cachedLogo;
const int _maxChars = 54;
const double _logoW = 180;
const double _logoH = 180;
const double _headerTextW = 270;
double _fixedH(bool first, bool intro) =>
    _footerH +
    _headerH +
    (first ? _infoH : 0) +
    (intro ? _introH : _plainH) +
    _closeH +
    8;

class _Line {
  final String label;
  final String? left;
  final String? right;
  final bool lined;
  final bool entryStart;
  _Line(this.label, this.left, this.right, this.lined, this.entryStart);
}

class _Placed {
  final _Line line;
  final double h;
  final bool showLabel;
  _Placed(this.line, this.h, this.showLabel);
}

class _PageSpec {
  final bool internal;
  final bool first;
  final double avail;
  final bool sigOnly;
  final List<_Placed> rows = [];
  double used = 0;
  bool sig = false;
  _PageSpec({
    required this.internal,
    required this.first,
    required this.avail,
    this.sigOnly = false,
  });
}

List<String> _wrap(String text, int maxChars) {
  final out = <String>[];
  for (final raw in text.split(RegExp(r'\r?\n'))) {
    final t = raw.trim();
    if (t.isEmpty) continue;
    var cur = '';
    for (final w in t.split(RegExp(r'\s+'))) {
      if (cur.isEmpty) {
        cur = w;
      } else if (cur.length + 1 + w.length <= maxChars) {
        cur = '$cur $w';
      } else {
        out.add(cur);
        cur = w;
      }
    }
    if (cur.isNotEmpty) out.add(cur);
  }
  return out;
}

List<_Line> _linesFor(List<SwotPrintEntry> entries) {
  final rows = <_Line>[];
  for (final e in entries) {
    final l = _wrap(e.left, _maxChars);
    final r = _wrap(e.right, _maxChars);
    var count = l.length > r.length ? l.length : r.length;
    if (count < _minLines) count = _minLines;
    for (int i = 0; i < count; i++) {
      rows.add(
        _Line(
          e.label,
          i < l.length ? l[i] : null,
          i < r.length ? r[i] : null,
          true,
          i == 0,
        ),
      );
    }
  }
  if (rows.isEmpty) rows.add(_Line('', null, null, true, true));
  return rows;
}

List<_PageSpec> _paginate(SwotPrintData d) {
  final pageH = _format.height - _margin.top - _margin.bottom;
  final pages = <_PageSpec>[];

  void addSection(List<SwotPrintEntry> entries, bool internal) {
    _PageSpec newPage() {
      final first = pages.isEmpty;
      return _PageSpec(
        internal: internal,
        first: first,
        avail: pageH - _fixedH(first, internal),
      );
    }

    var page = newPage();
    for (final line in _linesFor(entries)) {
      var h =
          _lineH + (line.entryStart && page.rows.isNotEmpty ? _entryGap : 0);
      if (page.rows.isNotEmpty && page.used + h > page.avail) {
        pages.add(page);
        page = newPage();
        h = _lineH;
      }
      page.rows.add(_Placed(line, h, line.entryStart));
      page.used += h;
    }
    pages.add(page);
  }

  addSection(d.internal, true);
  addSection(d.external, false);

  final last = pages.last;
  if (last.used + _sigH <= last.avail) {
    last.sig = true;
  } else {
    pages.add(
      _PageSpec(
        internal: false,
        first: false,
        avail: pageH - _headerH - _footerH,
        sigOnly: true,
      )..sig = true,
    );
  }
  return pages;
}

Future<pw.ThemeData> _loadTheme() async {
  return _cachedTheme ??= pw.ThemeData.withFont(
    base: pw.Font.times(),
    bold: pw.Font.timesBold(),
    italic: pw.Font.timesItalic(),
    boldItalic: pw.Font.timesBoldItalic(),
  );
}

Future<pw.MemoryImage?> _loadLogo() async {
  if (_cachedLogo != null) return _cachedLogo;
  try {
    final bytes = await rootBundle.load(kSwotLogoAsset);
    return _cachedLogo = pw.MemoryImage(bytes.buffer.asUint8List());
  } catch (_) {
    return null;
  }
}

Future<void> preloadSwotPdfAssets() async {
  await _loadTheme();
  await _loadLogo();
}

Future<Uint8List> buildSwotPdf(SwotPrintData d) async {
  final theme = await _loadTheme();
  final logo = await _loadLogo();
  final pages = _paginate(d);
  final doc = pw.Document(theme: theme, title: 'SWOT Analysis');

  for (int i = 0; i < pages.length; i++) {
    final spec = pages[i];
    doc.addPage(
      pw.Page(
        pageFormat: _format,
        margin: _margin,
        build:
            (_) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              children: [
                _header(logo),
                if (spec.first) ...[
                  _infoLine('Department/Section/Unit:', d.department),
                  _infoLine('Objective Statement:', d.objective, bold: false),
                  pw.SizedBox(height: 8),
                ],
                if (!spec.sigOnly) _box(spec),
                if (spec.sig) ...[pw.SizedBox(height: 14), _signatures(d)],
                pw.Spacer(),
                _footer(i + 1, pages.length),
              ],
            ),
      ),
    );
  }
  return doc.save();
}

pw.Widget _header(pw.MemoryImage? logo) {
  return pw.SizedBox(
    height: _headerH,
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Expanded(
          child: pw.Align(
            alignment: pw.Alignment.centerRight,
            child:
                logo == null
                    ? pw.SizedBox()
                    : pw.Transform.translate(
                      offset: const PdfPoint(_logoShift, 0),
                      child: pw.Image(
                        logo,
                        width: _logoW,
                        height: _logoH,
                        fit: pw.BoxFit.contain,
                      ),
                    ),
          ),
        ),

        pw.SizedBox(
          width: _headerTextW,
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(
                'Republic of the Philippines',
                style: pw.TextStyle(
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                'Department of Health',
                style: pw.TextStyle(
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                'COTABATO REGIONAL AND MEDICAL CENTER',
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 18),
              pw.Text(
                'SWOT ANALYSIS',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        pw.Expanded(child: pw.SizedBox()),
      ],
    ),
  );
}

pw.Widget _footer(int page, int total) {
  return pw.SizedBox(
    height: _footerH,
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Expanded(child: pw.SizedBox()),
        pw.Text(
          'Page $page of $total',
          style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
        ),
        pw.Expanded(
          child: pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
              kSwotFormCode,
              style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
            ),
          ),
        ),
      ],
    ),
  );
}

pw.Widget _infoLine(String label, String value, {bool bold = true}) {
  return pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 6),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.SizedBox(
          width: 150,
          child: pw.Text(label, style: pw.TextStyle(fontSize: 10)),
        ),
        pw.Expanded(
          child: pw.Container(
            padding: const pw.EdgeInsets.only(bottom: 2, left: 4),
            decoration: const pw.BoxDecoration(
              border: pw.Border(bottom: _side),
            ),
            child: pw.Text(
              value,
              style: pw.TextStyle(
                fontSize: 10,
                fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

pw.Widget _box(_PageSpec spec) {
  final title = spec.internal ? 'Internal Context' : 'External Context';
  final left = spec.internal ? 'Strengths' : 'Opportunities';
  final right = spec.internal ? 'Weaknesses' : 'Threats';

  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.stretch,
    children: [
      // heading (inuulit sa bawat page)
      pw.Container(
        height: spec.internal ? _introH : _plainH,
        padding: const pw.EdgeInsets.fromLTRB(12, 8, 12, 4),
        decoration: const pw.BoxDecoration(
          border: pw.Border(top: _side, left: _side, right: _side),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            if (spec.internal) ...[
              pw.Text(
                'The Context:',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 6),
              pw.Text(
                'Establish the context which might impact achieving pratice objectives, e.g. factors relating to:',
                style: const pw.TextStyle(fontSize: 9.5),
              ),
              pw.SizedBox(height: 6),
            ],
            pw.Row(
              children: [
                pw.Expanded(
                  flex: 2,
                  child: pw.Text(
                    title,
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.Expanded(
                  flex: 3,
                  child: pw.Center(
                    child: pw.Text(
                      left,
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                pw.SizedBox(width: 14),
                pw.Expanded(
                  flex: 3,
                  child: pw.Center(
                    child: pw.Text(
                      right,
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      for (final r in spec.rows) _row(r),
      // sarado ang box sa dulo ng bawat page
      pw.Container(
        height: _closeH,
        decoration: const pw.BoxDecoration(
          border: pw.Border(left: _side, right: _side, bottom: _side),
        ),
      ),
    ],
  );
}

pw.Widget _cell(String? text, bool lined) {
  return pw.Container(
    height: _lineH,
    alignment: pw.Alignment.bottomLeft,
    padding: const pw.EdgeInsets.only(bottom: 1.5),
    decoration: pw.BoxDecoration(
      border:
          (lined && text != null) || (lined && text == null)
              ? const pw.Border(bottom: _thin)
              : null,
    ),
    child:
        text == null
            ? null
            : pw.Text(text, style: const pw.TextStyle(fontSize: 9)),
  );
}

pw.Widget _row(_Placed p) {
  final gap = p.h - _lineH;
  return pw.Container(
    height: p.h,
    padding: pw.EdgeInsets.fromLTRB(12, gap, 12, 0),
    decoration: const pw.BoxDecoration(
      border: pw.Border(left: _side, right: _side),
    ),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          flex: 2,
          child: pw.Padding(
            padding: const pw.EdgeInsets.only(left: 6),
            child:
                p.showLabel
                    ? pw.Text(
                      p.line.label,
                      style: const pw.TextStyle(fontSize: 9.5),
                    )
                    : pw.SizedBox(),
          ),
        ),
        pw.Expanded(flex: 3, child: _cell(p.line.left, p.line.lined)),
        pw.SizedBox(width: 14),
        pw.Expanded(flex: 3, child: _cell(p.line.right, p.line.lined)),
      ],
    ),
  );
}

pw.Widget _signatures(SwotPrintData d) {
  pw.Widget block(String label, String name, String role) {
    return pw.Expanded(
      child: pw.Padding(
        padding: const pw.EdgeInsets.symmetric(horizontal: 8),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              label,
              style: pw.TextStyle(
                fontSize: 9.5,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 16),
            pw.Container(
              width: double.infinity,
              alignment: pw.Alignment.center,
              padding: const pw.EdgeInsets.only(bottom: 3),
              decoration: const pw.BoxDecoration(
                border: pw.Border(bottom: pw.BorderSide(width: 1.5)),
              ),
              child: pw.Text(
                name.toUpperCase(),
                style: const pw.TextStyle(fontSize: 9.5),
              ),
            ),
            pw.SizedBox(height: 3),
            pw.Center(
              child: pw.Text(
                role,
                style: pw.TextStyle(
                  fontSize: 9.5,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  return pw.SizedBox(
    height: _sigH,
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        block(
          'Prepared by:',
          d.preparedBy,
          d.isServiceHead ? 'Service Head' : 'Department Chair',
        ),
        if (!d.isServiceHead)
          block(
            'Review and Verified by:',
            d.reviewedBy,
            'Quality Management Representative',
          ),
        block(
          d.isServiceHead ? 'Approved by:' : 'Validated by:',
          d.validatedBy,
          d.isServiceHead ? 'MCC' : 'Service Head',
        ),
      ],
    ),
  );
}
