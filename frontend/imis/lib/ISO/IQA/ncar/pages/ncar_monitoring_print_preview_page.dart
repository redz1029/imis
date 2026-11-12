// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:imis/ISO/IQA/ncar/models/ncar_monitoring_log.dart';
import 'package:imis/ISO/IQA/ncar/services/ncar_service.dart';
import 'package:imis/ISO/IQA/widgets/iqa_list_toolbar.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/utils/pdf_download.dart';

/// Opens the native print preview of the NCAR Monitoring Log (QP-03-F-09): one
/// landscape table listing every NCAR with who issued it, who it went to and
/// when it was verified and validated.
///
/// [period] limits the log to the NCARs issued in that period (the NCAR list's
/// period filter); null prints all of them.
Future<void> openNcarMonitoringPrintPreview(
  BuildContext context, {
  DateTimeRange? period,
}) {
  return Navigator.of(context).push<void>(
    MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (_) => NcarMonitoringPrintPreviewPage(period: period),
    ),
  );
}

const String _kLogoCrmc = 'assets/CRMCLogo.png';
const String _kLogoIso = 'assets/TR-Testmark.jpg';
const String _kFormCode = 'QP-03-F-09';

const double _kMargin = 36;
const double _kBorderW = 0.8;
const double _kFont = 9;
const double _kHead = 8.5;
const double _kSmall = 8;
const double _kSealBox = 86;

/// Rows a printed log has at least, so a short log still looks like the form
/// (the extra rows are left blank to write in by hand).
const int _kMinRows = 8;

/// Height of one row of the table.
const double _kRowH = 30;

class _Loaded {
  const _Loaded({
    required this.logs,
    required this.regular,
    required this.bold,
    required this.unicode,
    this.period,
    this.seal,
    this.iso,
  });

  final List<NcarMonitoringLog> logs;
  final DateTimeRange? period;
  final pw.Font regular;
  final pw.Font bold;
  final bool unicode;
  final pw.MemoryImage? seal;
  final pw.MemoryImage? iso;
}

/// The log is read page by page until the server has nothing new to give.
Future<List<NcarMonitoringLog>> _fetchAllLogs(NcarService service) async {
  const pageSize = 100;
  final byId = <int, NcarMonitoringLog>{};
  for (var page = 1; page <= 100; page++) {
    final batch = await service.getMonitoringLogs(
      page: page,
      pageSize: pageSize,
    );
    final before = byId.length;
    for (final l in batch) {
      byId[l.id] = l;
    }
    // Nothing new: the last page was already read (a server that ignores the
    // page number, or one that caps the page size, ends up here too).
    if (batch.isEmpty || byId.length == before) break;
  }
  return byId.values.toList();
}

/// The TUV mark is a 7170 px wide JPEG that is printed about 104 pt wide.
/// Viewers shrink an image that large badly (jagged, soft lettering), so it is
/// scaled down once here with a smooth filter and embedded at a sensible size.
/// If that is not possible the original is used unchanged.
Future<pw.MemoryImage> _scaledLogo(Uint8List bytes, int width) async {
  try {
    final codec = await ui.instantiateImageCodec(bytes, targetWidth: width);
    final frame = await codec.getNextFrame();
    final png = await frame.image.toByteData(format: ui.ImageByteFormat.png);
    frame.image.dispose();
    codec.dispose();
    if (png != null) return pw.MemoryImage(png.buffer.asUint8List());
  } catch (e) {
    debugPrint('NCAR monitoring print preview: cannot scale the logo: $e');
  }
  return pw.MemoryImage(bytes);
}

DateTime _local(DateTime v) => v.isUtc ? v.toLocal() : v;

Future<_Loaded> _loadAll(DateTimeRange? period) async {
  final all = await _fetchAllLogs(NcarService(Dio()));

  // In the order the NCARs were issued, like the paper log.
  final logs =
      all
          .where(
            (l) =>
                period == null ||
                IqaPeriod.matches(period, _local(l.dateIssued)),
          )
          .toList()
        ..sort((a, b) {
          final c = a.dateIssued.compareTo(b.dateIssued);
          return c != 0 ? c : a.ncarNo.compareTo(b.ncarNo);
        });

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
    debugPrint('NCAR monitoring print preview: cannot load "$_kLogoCrmc": $e');
  }

  pw.MemoryImage? iso;
  try {
    final data = await rootBundle.load(_kLogoIso);
    iso = await _scaledLogo(data.buffer.asUint8List(), 960);
  } catch (e) {
    debugPrint('NCAR monitoring print preview: cannot load "$_kLogoIso": $e');
  }

  return _Loaded(
    logs: logs,
    period: period,
    regular: regular,
    bold: bold,
    unicode: unicode,
    seal: seal,
    iso: iso,
  );
}

class NcarMonitoringPrintPreviewPage extends StatefulWidget {
  const NcarMonitoringPrintPreviewPage({super.key, this.period});

  final DateTimeRange? period;

  @override
  State<NcarMonitoringPrintPreviewPage> createState() =>
      _NcarMonitoringPrintPreviewPageState();
}

class _NcarMonitoringPrintPreviewPageState
    extends State<NcarMonitoringPrintPreviewPage> {
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
      _data = await _loadAll(widget.period);
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<Uint8List> _buildPdf(PdfPageFormat format) =>
      _NcarMonitoringPdfBuilder(_data!, format.landscape).build();

  @override
  Widget build(BuildContext context) {
    const fileName = 'NCAR_Monitoring_Log.pdf';
    return Scaffold(
      appBar: AppBar(
        title: const Text('NCAR Monitoring Log — Print Preview'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body:
          _loading
              ? const Center(
                child: CircularProgressIndicator(color: primaryColor),
              )
              : _error != null
              ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.redAccent,
                        size: 44,
                      ),
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
                initialPageFormat: PdfPageFormat.a4.landscape,
                pageFormats: const <String, PdfPageFormat>{
                  'A4': PdfPageFormat.a4,
                  'Letter': PdfPageFormat.letter,
                  'Legal': PdfPageFormat.legal,
                },
                canChangeOrientation: false,
                canChangePageFormat: true,
                canDebug: false,
                maxPageWidth: 1000,
                pdfFileName: fileName,
                allowSharing: false,
                actions: [downloadPdfAction(fileName)],
                onError:
                    (context, error) => Center(
                      child: Text(
                        'Unable to build the preview: $error',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
              ),
    );
  }
}

/// Builds the log PDF from already-loaded data (no network, no assets), so the
/// layout can be exercised in a unit test.
@visibleForTesting
Future<Uint8List> buildNcarMonitoringPdfForTest(
  List<NcarMonitoringLog> logs,
  PdfPageFormat format, {
  DateTimeRange? period,
}) {
  return _NcarMonitoringPdfBuilder(
    _Loaded(
      logs: logs,
      period: period,
      regular: pw.Font.times(),
      bold: pw.Font.timesBold(),
      unicode: false,
    ),
    format.landscape,
  ).build();
}

// =============================================================================
// PDF builder
// =============================================================================
class _NcarMonitoringPdfBuilder {
  _NcarMonitoringPdfBuilder(this.d, this.format);

  final _Loaded d;
  final PdfPageFormat format;

  Future<Uint8List> build() async => _compose().save();

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
  }) => pw.Text(_s(text), style: _st(bold: bold, size: size), textAlign: align);

  String _date(DateTime? v) =>
      v == null ? '' : DateFormat('MMM d, yyyy').format(_local(v));

  // --------------------------------------------------------- letterhead ----
  pw.Widget _letterhead() {
    final crmc = d.seal;
    final iso = d.iso;

    final seal =
        crmc == null
            ? null
            : pw.SizedBox(
              width: _kSealBox,
              height: _kSealBox,
              child: pw.ClipRect(child: pw.Image(crmc, fit: pw.BoxFit.cover)),
            );

    final tuv =
        iso == null
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

    // The same letterhead as the other IQA forms.
    return pw.SizedBox(
      height: _kSealBox,
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
              _t('COTABATO REGIONAL AND MEDICAL CENTER', bold: true, size: 11),
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
    final p = d.period;
    String? periodText;
    if (p != null) {
      final from = DateFormat('MMMM d, yyyy').format(p.start);
      final to = DateFormat('MMMM d, yyyy').format(p.end);
      periodText = from == to ? from : '$from - $to';
    }
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 8, bottom: 8),
      child: pw.Center(
        child: pw.Column(
          children: [
            _t('NCAR MONITORING LOG', bold: true, size: 12),
            if (periodText != null) ...[
              pw.SizedBox(height: 2),
              _t(periodText, size: 9),
            ],
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------------------- table ---
  // Column order and headings follow the paper log.
  static const _heads = <String>[
    'NCAR NO.',
    'DEPT/SECTION/UNIT',
    'DATE ISSUED',
    'NAME AND SIGNATURE',
    'ITEM NO.',
    'NAME OF AUDITEE',
    'DATE VERIFIED',
    'NAME AND SIGNATURE OF AUDITOR',
    'DATE VALIDATED',
    'REMARKS',
  ];

  static const _flex = <double>[9, 16, 9, 15, 6, 12, 9, 15, 9, 8];

  pw.Widget _cell(String text, {bool bold = false, double size = _kFont}) {
    return pw.Container(
      constraints: const pw.BoxConstraints(minHeight: _kRowH),
      alignment: pw.Alignment.centerLeft,
      padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: _t(text, bold: bold, size: size),
    );
  }

  pw.TableRow _head() => pw.TableRow(
    repeat: true,
    children: [for (final h in _heads) _cell(h, bold: true, size: _kHead)],
  );

  pw.TableRow _row(NcarMonitoringLog? l) {
    final cells =
        l == null
            ? List<String>.filled(_heads.length, '')
            : [
              l.ncarNo,
              l.deptSectionUnit,
              _date(l.dateIssued),
              l.issuedByName,
              l.itemNoRelevantStandard,
              l.auditeeName,
              _date(l.dateVerified),
              (l.verifiedByAuditorName ?? '').trim(),
              _date(l.dateValidated),
              l.remarks,
            ];
    return pw.TableRow(children: [for (final c in cells) _cell(c.trim())]);
  }

  pw.Widget _table() {
    // Blank rows only while every row is short: wrapped rows are taller, and a
    // blank row must never be what pushes the log onto a second page.
    final wrapped = d.logs.any(
      (l) => [
        l.deptSectionUnit,
        l.issuedByName,
        l.auditeeName,
        l.verifiedByAuditorName ?? '',
      ].any((t) => t.length > 28),
    );
    final blanks =
        (!wrapped && d.logs.length < _kMinRows) ? _kMinRows - d.logs.length : 0;
    return pw.Table(
      border: pw.TableBorder.all(width: _kBorderW),
      columnWidths: {
        for (var i = 0; i < _flex.length; i++) i: pw.FlexColumnWidth(_flex[i]),
      },
      children: [
        _head(),
        for (final l in d.logs) _row(l),
        for (var i = 0; i < blanks; i++) _row(null),
      ],
    );
  }

  // -------------------------------------------------------------- compose --
  pw.Document _compose() {
    final doc = pw.Document(
      title: 'NCAR Monitoring Log',
      author: 'Cotabato Regional and Medical Center',
    );

    doc.addPage(
      pw.MultiPage(
        pageFormat: format,
        margin: const pw.EdgeInsets.all(_kMargin),
        footer:
            (ctx) => pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                _t(
                  'Page ${ctx.pageNumber} of ${ctx.pagesCount}',
                  size: _kSmall,
                ),
                _t(_kFormCode, bold: true, size: _kSmall),
              ],
            ),
        build: (_) => [_letterhead(), _title(), _table()],
      ),
    );
    return doc;
  }
}
