// ignore_for_file: use_build_context_synchronously

import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:imis/ISO/IQA/ncar/models/ncar_attachment.dart';
import 'package:imis/ISO/IQA/ncar/models/nonconforming_action_report.dart';
import 'package:imis/ISO/IQA/ncar/services/ncar_service.dart';
import 'package:imis/constant/constant.dart';

/// Opens the native print preview of a Nonconforming Action Report
/// (QP-03-F-08). Page 1 is the form; the pictures attached to the NCAR as proof
/// of resolution are laid out on the pages that follow.
Future<void> openNcarPrintPreview(BuildContext context, int ncarId) {
  return Navigator.of(context).push<void>(
    MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (_) => NcarPrintPreviewPage(ncarId: ncarId),
    ),
  );
}

const String _kLogoCrmc = 'assets/crmc_logo.png';

const double _kMargin = 36;
const double _kBorderW = 0.8;
const double _kFont = 10;
const double _kSmall = 8;
const double _kPad = 4;
const double _kSealBox = 64;

/// Height of one picture frame; two columns x two rows fill an attachment page.
const double _kPictureH = 300;

class _Loaded {
  const _Loaded({
    required this.ncar,
    required this.attachments,
    required this.regular,
    required this.bold,
    required this.unicode,
    this.seal,
  });

  final NonconformingActionReport ncar;
  final List<NcarAttachment> attachments;
  final pw.Font regular;
  final pw.Font bold;
  final bool unicode;
  final pw.MemoryImage? seal;
}

Future<_Loaded> _loadAll(int ncarId) async {
  final service = NcarService(Dio());

  final ncar = await service.getNcarById(ncarId);
  if (ncar == null) {
    throw Exception('Unable to load this NCAR.');
  }

  var attachments = <NcarAttachment>[];
  try {
    attachments = await service.getAttachments(ncarId);
  } catch (e) {
    // The form still prints; only the picture pages are missing.
    debugPrint('NCAR print preview: could not load pictures: $e');
  }

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

  pw.MemoryImage? seal;
  try {
    final data = await rootBundle.load(_kLogoCrmc);
    seal = pw.MemoryImage(data.buffer.asUint8List());
  } catch (e) {
    debugPrint('NCAR print preview: cannot load "$_kLogoCrmc": $e');
  }

  return _Loaded(
    ncar: ncar,
    attachments: attachments,
    regular: regular,
    bold: bold,
    unicode: unicode,
  );
}

class NcarPrintPreviewPage extends StatefulWidget {
  const NcarPrintPreviewPage({super.key, required this.ncarId});

  final int ncarId;

  @override
  State<NcarPrintPreviewPage> createState() => _NcarPrintPreviewPageState();
}

class _NcarPrintPreviewPageState extends State<NcarPrintPreviewPage> {
  _Loaded? _data;
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
      _data = await _loadAll(widget.ncarId);
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<Uint8List> _buildPdf(PdfPageFormat format) =>
      _NcarPdfBuilder(_data!, format).build();

  @override
  Widget build(BuildContext context) {
    final ref = _data?.ncar.referenceNumber ?? '';
    return Scaffold(
      appBar: AppBar(
        title: const Text('NCAR — Print Preview'),
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
                  pdfFileName: 'NCAR_${ref.isEmpty ? widget.ncarId : ref}.pdf',
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

/// Builds the NCAR PDF from already-loaded data (no network, no assets), so the
/// layout can be exercised in a unit test.
@visibleForTesting
Future<Uint8List> buildNcarPdfForTest(
  NonconformingActionReport ncar,
  List<NcarAttachment> attachments,
  PdfPageFormat format,
) {
  return _NcarPdfBuilder(
    _Loaded(
      ncar: ncar,
      attachments: attachments,
      regular: pw.Font.times(),
      bold: pw.Font.timesBold(),
      unicode: false,
    ),
    format,
  ).build();
}

// =============================================================================
// PDF builder
// =============================================================================
class _NcarPdfBuilder {
  _NcarPdfBuilder(this.d, this.format);

  final _Loaded d;
  final PdfPageFormat format;

  NonconformingActionReport get n => d.ncar;

  pw.BorderSide get _bs => const pw.BorderSide(width: _kBorderW);

  /// "Page 1 of N" needs the final page count, which only exists after layout:
  /// build, read the count, and rebuild once if the guess was wrong.
  Future<Uint8List> build() async {
    var total = 1;
    for (var pass = 0; pass < 3; pass++) {
      final doc = _compose(total);
      final count = doc.document.pdfPageList.pages.length;
      if (count == total || pass == 2) return doc.save();
      total = count;
    }
    throw StateError('unreachable');
  }

  // ---------------------------------------------------------------- text ---
  String _s(String v) {
    if (d.unicode) return v;
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

  pw.TextStyle _st({bool bold = false, double size = _kFont}) => pw.TextStyle(
        font: bold ? d.bold : d.regular,
        fontSize: size,
        color: PdfColors.black,
      );

  pw.Widget _t(
    String text, {
    bool bold = false,
    double size = _kFont,
    pw.TextAlign? align,
  }) =>
      pw.Text(_s(text), style: _st(bold: bold, size: size), textAlign: align);

  /// "Label: value" with a bold label, wrapping like a paragraph.
  pw.Widget _labelled(String label, String value, {double size = _kFont}) {
    return pw.RichText(
      text: pw.TextSpan(
        children: [
          pw.TextSpan(text: _s(label), style: _st(bold: true, size: size)),
          if (value.trim().isNotEmpty)
            pw.TextSpan(text: ' ${_s(value.trim())}', style: _st(size: size)),
        ],
      ),
    );
  }

  /// Sign-off dates are stored in UTC; the audit date is a wall-clock value.
  DateTime _local(DateTime v) => v.isUtc ? v.toLocal() : v;

  String _date(DateTime? v) =>
      v == null ? '' : DateFormat('MMMM d, yyyy').format(_local(v));

  String _name(String? v) => (v ?? '').trim();

  // -------------------------------------------------------------- layout ---
  /// One full-width row of the form. Left/right edges are always drawn; the top
  /// edge only on the first row, so stacked rows share one border.
  pw.Widget _row(pw.Widget child, {bool top = false, bool bottom = true}) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border(
          top: top ? _bs : pw.BorderSide.none,
          left: _bs,
          right: _bs,
          bottom: bottom ? _bs : pw.BorderSide.none,
        ),
      ),
      child: child,
    );
  }

  pw.Widget _pad(pw.Widget child, {double v = _kPad}) => pw.Padding(
        padding: pw.EdgeInsets.symmetric(horizontal: 5, vertical: v),
        child: child,
      );

  /// Cells separated by vertical rules; every cell is as tall as the tallest.
  pw.Widget _cells(List<int> flex, List<pw.Widget> cells, {double minH = 0}) {
    return pw.ConstrainedBox(
      constraints: pw.BoxConstraints(minHeight: minH),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < cells.length; i++)
            pw.Expanded(
              flex: flex[i],
              child: pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border(
                    right: i == cells.length - 1
                        ? pw.BorderSide.none
                        : _bs,
                  ),
                ),
                child: _pad(cells[i]),
              ),
            ),
        ],
      ),
    );
  }

  pw.Widget _check(bool on, String label, {double indent = 0}) {
    return pw.Padding(
      padding: pw.EdgeInsets.only(left: indent, bottom: 3),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Container(
            width: 9,
            height: 9,
            alignment: pw.Alignment.center,
            decoration: pw.BoxDecoration(border: pw.Border.all(width: 0.9)),
            child: on
                ? pw.Container(width: 5.4, height: 5.4, color: PdfColors.black)
                : null,
          ),
          pw.SizedBox(width: 4),
          pw.Expanded(child: _t(label, size: 9)),
        ],
      ),
    );
  }

  // --------------------------------------------------------- letterhead ----
  pw.Widget _letterhead() {
    final seal = d.seal;
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.center,
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        if (seal != null)
          pw.SizedBox(
            width: _kSealBox,
            height: _kSealBox,
            child: pw.ClipRect(child: pw.Image(seal, fit: pw.BoxFit.cover)),
          ),
        pw.SizedBox(width: 10),
        pw.Column(
          mainAxisSize: pw.MainAxisSize.min,
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            _t('Republic of the Philippines'),
            _t('Department of Health'),
            _t('COTABATO REGIONAL AND MEDICAL CENTER', bold: true, size: 11),
          ],
        ),
      ],
    );
  }

  pw.Widget _title() => pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 8),
        child: pw.Center(
          child: pw.Column(
            children: [
              _t('NONCONFORMING ACTION REPORT', bold: true, size: 12),
              _t('(NCAR)', bold: true, size: 12),
            ],
          ),
        ),
      );

  // ---------------------------------------------------------- form rows ----
  List<pw.Widget> _formRows(int total) {
    final rows = <pw.Widget>[];

    // Reference / Office / Page
    rows.add(_row(
      _cells(
        [22, 40, 18],
        [
          _labelled('Reference Number:', n.referenceNumber),
          _labelled('Office:', n.office),
          _t('Page 1 of $total', align: pw.TextAlign.center),
        ],
      ),
      top: true,
    ));

    // Nature / Relevant standard / Audit date
    rows.add(_row(
      _cells(
        [62, 19, 19],
        [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _t('Nature/Type of Report:', bold: true, size: 9),
              pw.SizedBox(height: 3),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    flex: 11,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        _check(
                          n.isInternalCustomer,
                          'Internal Customer/Interested Party',
                        ),
                        _check(
                          n.isExternalCustomer,
                          'External Customer/Interested Party',
                        ),
                        _check(n.isComplaint, 'Complaint', indent: 12),
                        _check(n.isResponseRate, 'Response Rate', indent: 12),
                        _check(n.isOperations, 'Operations', indent: 12),
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 6),
                  pw.Expanded(
                    flex: 8,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        _check(n.isInternalAudit, 'Internal Audit'),
                        _check(n.isExternalAudit, 'External Audit'),
                        _check(n.isNonconformity, 'Nonconformity', indent: 12),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _t('Relevant Standard:', bold: true, size: 9),
              pw.SizedBox(height: 10),
              pw.Center(child: _t(n.relevantStandard)),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _t('Audit Date:', bold: true, size: 9),
              pw.SizedBox(height: 10),
              pw.Center(child: _t(_date(n.auditDate), align: pw.TextAlign.center)),
            ],
          ),
        ],
        minH: 84,
      ),
    ));

    // Requirement / policy / findings, one paragraph per row so a long finding
    // can run onto the next page.
    final body = <String>[
      n.standardRequirement,
      n.legalOrPolicyReference,
      n.auditFindings,
    ].map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    if (body.isEmpty) body.add('');
    for (var i = 0; i < body.length; i++) {
      rows.add(_row(
        _pad(_t(body[i]), v: 5),
        bottom: i == body.length - 1,
      ));
    }

    // Issued / acknowledged
    const sign = [20, 30, 22, 28];
    rows.add(_row(
      _cells(sign, [
        _t('Issued by: Auditor', size: 9),
        _t(_name(n.issuedByAuditorName), align: pw.TextAlign.center),
        _t('Acknowledged by: Auditee', size: 9),
        _t(_name(n.acknowledgedByAuditeeName), align: pw.TextAlign.center),
      ]),
    ));
    rows.add(_row(
      _cells(sign, [
        _t('Date:', size: 9),
        _t(_date(n.issuedDate)),
        _t('Date:', size: 9),
        _t(_date(n.acknowledgedDate)),
      ]),
    ));

    // Root cause analysis
    rows.add(_row(
      _pad(_t('Root Cause Analysis:', bold: true)),
      bottom: false,
    ));
    rows.addAll(_numbered(n.rootCauses, minBlankH: 56));
    rows.add(_row(
      _cells(sign, [
        _t('Prepared by: Auditee', size: 9),
        _t(_name(n.proposedByAuditeeName), align: pw.TextAlign.center),
        _t('Date:', size: 9),
        _t(_date(n.proposedDate)),
      ]),
    ));

    // Proposed actions, one correction/corrective pair per row
    rows.add(_row(
      _pad(_t('Write details of proposed actions:', bold: true)),
    ));
    rows.add(_row(
      _cells(
        [50, 50],
        [
          _t('Correction:', bold: true, size: 9),
          _t('Corrective:', bold: true, size: 9),
        ],
      ),
      bottom: false,
    ));
    final pairs = math.max(n.corrections.length, n.correctiveActions.length);
    if (pairs == 0) {
      rows.add(_row(_cells([50, 50], [pw.SizedBox(height: 54), pw.SizedBox()])));
    } else {
      for (var i = 0; i < pairs; i++) {
        rows.add(_row(
          _cells(
            [50, 50],
            [
              _t(i < n.corrections.length ? '${i + 1}. ${n.corrections[i]}' : ''),
              _t(
                i < n.correctiveActions.length
                    ? '${i + 1}. ${n.correctiveActions[i]}'
                    : '',
              ),
            ],
          ),
          bottom: i == pairs - 1,
        ));
      }
    }

    // Prepared / approved
    const approve = [50, 50];
    rows.add(_row(
      _cells(approve, [
        _labelled('Prepared by: Auditee', _name(n.proposedByAuditeeName)),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _labelled('Approved by:', _name(n.approvedByHeadName)),
            _t('Department/Section Head', size: _kSmall),
          ],
        ),
      ]),
    ));
    rows.add(_row(
      _cells(approve, [
        _labelled('Date:', _date(n.proposedDate)),
        _labelled('Date:', _date(n.approvedDate)),
      ]),
    ));

    // Verification
    rows.add(_row(
      _cells(
        [72, 28],
        [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _t('Verified by:', bold: true),
              pw.SizedBox(height: 3),
              _t(_name(n.verificationDetails)),
              pw.SizedBox(height: 28),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.SizedBox(height: 14),
              _check(false, 'Risk Source ______'),
              _check(false, 'Date Identified ______'),
            ],
          ),
        ],
      ),
    ));
    rows.add(_row(
      _cells(
        [72, 28],
        [
          _labelled('Auditor:', _name(n.verifiedByAuditorName)),
          _labelled('Date:', _date(n.verifiedDate)),
        ],
      ),
    ));
    rows.add(_row(
      _cells(
        [50, 22, 28],
        [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _labelled('Validated by:', _name(n.validatedByLeadAuditorName)),
              _t('Lead Auditor', size: _kSmall),
            ],
          ),
          _labelled('Date:', _date(n.validatedDate)),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _check(n.isActive && !n.isClosed, 'Active'),
              _check(n.isClosed, 'Closed'),
            ],
          ),
        ],
      ),
    ));

    rows.add(
      pw.Padding(
        padding: const pw.EdgeInsets.only(top: 3),
        child: pw.Align(
          alignment: pw.Alignment.centerRight,
          child: _t(n.formRevision, bold: true, size: _kSmall),
        ),
      ),
    );
    return rows;
  }

  /// Numbered lines inside the form's side rules; blank space when empty so the
  /// auditee still has room to write by hand.
  List<pw.Widget> _numbered(List<String> items, {required double minBlankH}) {
    if (items.isEmpty) {
      return [
        _row(pw.SizedBox(height: minBlankH), bottom: true),
      ];
    }
    return [
      for (var i = 0; i < items.length; i++)
        _row(
          _pad(_t('${i + 1}. ${items[i]}'), v: 2),
          bottom: i == items.length - 1,
        ),
    ];
  }

  // ---------------------------------------------------------- attachments --
  pw.Widget _picture(NcarAttachment a, int number, double width) {
    pw.Widget image;
    try {
      image = pw.Image(pw.MemoryImage(a.bytes), fit: pw.BoxFit.contain);
    } catch (_) {
      image = pw.Center(child: _t('Picture could not be displayed', size: _kSmall));
    }
    final caption = a.caption ?? 'Picture $number';
    return pw.Container(
      width: width,
      padding: const pw.EdgeInsets.all(6),
      decoration: pw.BoxDecoration(border: pw.Border.all(width: _kBorderW)),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            height: _kPictureH,
            width: width - 12,
            child: pw.Center(child: image),
          ),
          pw.SizedBox(height: 4),
          _t(caption, size: 9),
        ],
      ),
    );
  }

  // -------------------------------------------------------------- compose --
  pw.Document _compose(int total) {
    final doc = pw.Document(
      title: 'NCAR ${n.referenceNumber}',
      author: 'Cotabato Regional and Medical Center',
    );

    final contentW = format.width - 2 * _kMargin;
    pw.Widget footer(pw.Context ctx) => ctx.pageNumber <= 1
        ? pw.SizedBox()
        : pw.Align(
            alignment: pw.Alignment.centerRight,
            child: _t('${n.referenceNumber}  -  Page ${ctx.pageNumber} of $total', size: _kSmall),
          );

    doc.addPage(
      pw.MultiPage(
        pageFormat: format,
        margin: const pw.EdgeInsets.all(_kMargin),
        footer: footer,
        build: (_) => [
          _letterhead(),
          _title(),
          ..._formRows(total),
        ],
      ),
    );

    if (d.attachments.isNotEmpty) {
      const gap = 10.0;
      final w = (contentW - gap) / 2;
      doc.addPage(
        pw.MultiPage(
          pageFormat: format,
          margin: const pw.EdgeInsets.all(_kMargin),
          footer: footer,
          build: (_) => [
            pw.Center(
              child: _t(
                'NONCONFORMING ACTION REPORT (NCAR) — ATTACHMENTS',
                bold: true,
                size: 11,
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Center(
              child: _t(
                'Evidence that the nonconformity was resolved',
                size: 9,
              ),
            ),
            pw.SizedBox(height: 6),
            _labelled('Reference Number:', n.referenceNumber),
            _labelled('Office:', n.office),
            pw.SizedBox(height: 10),
            pw.Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [
                for (var i = 0; i < d.attachments.length; i++)
                  _picture(d.attachments[i], i + 1, w),
              ],
            ),
          ],
        ),
      );
    }

    return doc;
  }
}
