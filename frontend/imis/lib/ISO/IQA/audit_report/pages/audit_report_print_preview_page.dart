// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:imis/ISO/IQA/audit_checklist/services/audit_checklist_service.dart';
import 'package:imis/ISO/IQA/audit_report/model/audit_report.dart';
import 'package:imis/ISO/IQA/audit_report/service/audit_report_service.dart';
import 'package:imis/constant/constant.dart';

/// Opens the native print preview of an Audit Report (QP-03-F-06): office,
/// date, purpose and standard; the auditors and auditees; the commendable
/// findings; the summary of findings (NC / OFI) and the conclusions.
Future<void> openAuditReportPrintPreview(BuildContext context, int reportId) {
  return Navigator.of(context).push<void>(
    MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (_) => AuditReportPrintPreviewPage(reportId: reportId),
    ),
  );
}

const String _kLogoCrmc = 'assets/crmc_logo.png';
const String _kFormCode = 'QP-03-F-06 Rev. 1';

const double _kMargin = 36;
const double _kBorderW = 0.8;
const double _kFont = 10.5;
const double _kSmall = 8.5;
const double _kPad = 4;
const double _kSealBox = 64;

class _Line {
  const _Line({required this.criteria, required this.findings, required this.status});

  final String criteria;
  final String findings;
  final String status;
}

class _Data {
  const _Data({
    required this.office,
    required this.date,
    required this.purpose,
    required this.standard,
    required this.team,
    required this.auditors,
    required this.auditees,
    required this.commendable,
    required this.findings,
    required this.conclusions,
  });

  final String office;
  final DateTime? date;
  final String purpose;
  final String standard;
  final String team;
  final List<String> auditors;
  final List<String> auditees;
  final List<({String finding, String area})> commendable;
  final List<_Line> findings;
  final String conclusions;
}

class _Loaded {
  const _Loaded({
    required this.data,
    required this.regular,
    required this.bold,
    required this.unicode,
    this.seal,
  });

  final _Data data;
  final pw.Font regular;
  final pw.Font bold;
  final bool unicode;
  final pw.MemoryImage? seal;
}

List<String> _names(String? raw) => (raw ?? '')
    .split(RegExp(r'[,;\n\r]'))
    .map((e) => e.trim())
    .where((e) => e.isNotEmpty)
    .toList();

/// A stored finding reads "8.5.1 - the standard requires ... (NCAR 26-002)":
/// the clause becomes the CRITERIA cell and the rest the FINDINGS cell.
({String criteria, String findings}) _splitFinding(String text) {
  final m = RegExp(r'^\s*(\S+)\s+-\s+([\s\S]*)$').firstMatch(text);
  if (m == null) return (criteria: '', findings: text.trim());
  return (criteria: m.group(1)!.trim(), findings: m.group(2)!.trim());
}

_Data _dataFrom(
  AuditReport r, {
  required Map<int, String> statusNames,
  required String auditors,
}) {
  final summary = [...(r.auditSummaryFindings ?? const [])]
    ..sort((a, b) => a.no.compareTo(b.no));

  return _Data(
    office: (r.officeAuditedName ?? r.planOfficeProcess ?? '').trim(),
    date: r.auditDate,
    purpose: r.auditPurpose.trim(),
    standard: (r.auditStandardISOName ?? '').trim(),
    team: (r.planAuditTeamName ?? '').trim(),
    auditors: _names(auditors),
    auditees: [
      for (final s in r.auditScope ?? const [])
        if (s.auditee.trim().isNotEmpty) s.auditee.trim(),
    ],
    commendable: [
      for (final c in r.auditComFindings ?? const [])
        if (c.commendableFindings.trim().isNotEmpty ||
            c.area.trim().isNotEmpty)
          (finding: c.commendableFindings.trim(), area: c.area.trim()),
    ],
    findings: [
      for (final f in summary)
        () {
          final parts = _splitFinding(f.findings);
          return _Line(
            criteria: parts.criteria,
            findings: parts.findings,
            status: statusNames[f.auditNcarStatusId] ?? '',
          );
        }(),
    ],
    conclusions: r.auditConclusions.trim(),
  );
}

Future<_Loaded> _loadAll(int reportId) async {
  final dio = Dio();
  final reports = AuditReportService(dio);

  final report = await reports.getById(reportId);
  if (report == null) throw Exception('Unable to load this audit report.');

  // The auditors live on the checklist's schedule summary.
  var auditors = '';
  try {
    final summaries = await AuditChecklistService(
      dio,
    ).getSchedulesWithChecklistData();
    for (final s in summaries) {
      if (s.auditScheduleId == report.auditScheduleId) {
        auditors = (s.auditorNames ?? '').trim();
        break;
      }
    }
  } catch (e) {
    debugPrint('Audit report print preview: could not load auditors: $e');
  }

  final statusNames = <int, String>{};
  try {
    for (final s in await reports.getNcarStatuses()) {
      final id = (s['id'] ?? s['Id']) as num?;
      final name = (s['ncarStatus'] ?? s['NcarStatus'] ?? '').toString();
      if (id != null && name.isNotEmpty) statusNames[id.toInt()] = name;
    }
  } catch (e) {
    debugPrint('Audit report print preview: could not load statuses: $e');
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
    debugPrint('Audit report print preview: cannot load "$_kLogoCrmc": $e');
  }

  return _Loaded(
    data: _dataFrom(report, statusNames: statusNames, auditors: auditors),
    regular: regular,
    bold: bold,
    unicode: unicode,
    seal: seal,
  );
}

class AuditReportPrintPreviewPage extends StatefulWidget {
  const AuditReportPrintPreviewPage({super.key, required this.reportId});

  final int reportId;

  @override
  State<AuditReportPrintPreviewPage> createState() =>
      _AuditReportPrintPreviewPageState();
}

class _AuditReportPrintPreviewPageState
    extends State<AuditReportPrintPreviewPage> {
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
      _data = await _loadAll(widget.reportId);
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<Uint8List> _buildPdf(PdfPageFormat format) =>
      _ReportPdfBuilder(_data!, format).build();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audit Report — Print Preview'),
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
                  pdfFileName: 'Audit_Report_${widget.reportId}.pdf',
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

/// Builds the report PDF from already-loaded data (no network, no assets), so
/// the layout can be exercised in a unit test.
@visibleForTesting
Future<Uint8List> buildAuditReportPdfForTest(
  AuditReport report, {
  Map<int, String> statusNames = const {},
  String auditors = '',
  PdfPageFormat format = PdfPageFormat.a4,
}) {
  return _ReportPdfBuilder(
    _Loaded(
      data: _dataFrom(report, statusNames: statusNames, auditors: auditors),
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
class _ReportPdfBuilder {
  _ReportPdfBuilder(this.l, this.format);

  final _Loaded l;
  final PdfPageFormat format;

  _Data get d => l.data;

  pw.BorderSide get _bs => const pw.BorderSide(width: _kBorderW);

  Future<Uint8List> build() => _compose().save();

  // ---------------------------------------------------------------- text ---
  String _s(String v) {
    if (l.unicode) return v;
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
        font: bold ? l.bold : l.regular,
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

  pw.Widget _cell(
    pw.Widget child, {
    pw.Alignment align = pw.Alignment.centerLeft,
  }) =>
      pw.Container(
        alignment: align,
        padding: const pw.EdgeInsets.all(_kPad),
        child: child,
      );

  pw.Widget _head(String text) => _cell(
        _t(text, bold: true, size: 9.5, align: pw.TextAlign.center),
        align: pw.Alignment.center,
      );

  String _date(DateTime? v) =>
      v == null ? '' : DateFormat('MMMM d, yyyy').format(v).toUpperCase();

  pw.Widget _section(String number, String title) => pw.Padding(
        padding: const pw.EdgeInsets.only(top: 14, bottom: 4),
        child: pw.Row(
          children: [
            pw.SizedBox(width: 26, child: _t(number, bold: true, size: 9.5)),
            _t(title, bold: true, size: 9.5),
          ],
        ),
      );

  // ----------------------------------------------------------- page header --
  pw.Widget _header(pw.Context ctx) {
    final seal = l.seal;
    final box = pw.Table(
      border: pw.TableBorder.all(width: _kBorderW),
      columnWidths: const {
        0: pw.FlexColumnWidth(1),
        1: pw.FlexColumnWidth(1),
      },
      children: [
        pw.TableRow(
          children: [
            _cell(_t('OFFICE AUDITED: ${d.office.toUpperCase()}', bold: true, size: 9.5)),
            _cell(_t('DATE OF AUDIT: ${_date(d.date)}', bold: true, size: 9.5)),
          ],
        ),
        pw.TableRow(
          children: [
            pw.ConstrainedBox(
              constraints: const pw.BoxConstraints(minHeight: 40),
              child: _cell(
                _t('AUDIT PURPOSE: ${d.purpose.toUpperCase()}', bold: true, size: 9.5),
              ),
            ),
            pw.ConstrainedBox(
              constraints: const pw.BoxConstraints(minHeight: 40),
              child: _cell(
                _t('AUDIT STANDARD : ${d.standard.toUpperCase()}', bold: true, size: 9.5),
              ),
            ),
          ],
        ),
      ],
    );

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pw.Row(
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
                _t('Republic of the Philippines', size: 10),
                _t('Department of Health', size: 10),
                _t('COTABATO REGIONAL AND MEDICAL CENTER', bold: true, size: 11),
              ],
            ),
          ],
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 8),
          child: pw.Center(child: _t('AUDIT REPORT', bold: true, size: 12)),
        ),
        box,
        pw.SizedBox(height: 4),
      ],
    );
  }

  pw.Widget _footer(pw.Context ctx) => pw.Stack(
        children: [
          pw.Center(child: _t('${ctx.pageNumber}', bold: true, size: _kSmall)),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: _t(_kFormCode, bold: true, size: _kSmall),
          ),
        ],
      );

  // ------------------------------------------------------------- sections ---
  pw.Widget _scopeTable() {
    final rows = [
      d.auditors.length,
      d.auditees.length,
      1,
    ].reduce((a, b) => a > b ? a : b);

    return pw.Table(
      border: pw.TableBorder.all(width: _kBorderW),
      columnWidths: const {
        0: pw.FlexColumnWidth(30),
        1: pw.FlexColumnWidth(35),
        2: pw.FlexColumnWidth(35),
      },
      children: [
        pw.TableRow(
          children: [
            _head('AREA/PROCESS AUDITED'),
            _head(
              d.team.isEmpty ? 'AUDITORS' : 'AUDITORS (${d.team})',
            ),
            _head('AUDITEE'),
          ],
        ),
        for (var i = 0; i < rows; i++)
          pw.TableRow(
            children: [
              _cell(_t(i == 0 ? d.office : '')),
              _cell(_t(i < d.auditors.length ? d.auditors[i] : '')),
              _cell(_t(i < d.auditees.length ? d.auditees[i] : '')),
            ],
          ),
      ],
    );
  }

  pw.Widget _commendableTable() {
    final items = d.commendable.isEmpty
        ? <({String finding, String area})>[(finding: '', area: '')]
        : d.commendable;
    return pw.Table(
      border: pw.TableBorder.all(width: _kBorderW),
      columnWidths: const {
        0: pw.FlexColumnWidth(70),
        1: pw.FlexColumnWidth(30),
      },
      children: [
        pw.TableRow(
          children: [_head('COMMENDABLE FINDINGS'), _head('AREA')],
        ),
        for (var i = 0; i < items.length; i++)
          pw.TableRow(
            children: [
              _cell(_t(items[i].finding.isEmpty ? '' : '${i + 1}. ${items[i].finding}')),
              _cell(_t(items[i].area)),
            ],
          ),
      ],
    );
  }

  pw.Widget _findingsTable() {
    final items = d.findings;
    return pw.Table(
      border: pw.TableBorder.all(width: _kBorderW),
      columnWidths: const {
        0: pw.FixedColumnWidth(34),
        1: pw.FixedColumnWidth(78),
        2: pw.FlexColumnWidth(1),
        3: pw.FixedColumnWidth(58),
      },
      children: [
        pw.TableRow(
          children: [
            _head('No.'),
            _head('CRITERIA'),
            _head('FINDINGS'),
            pw.Container(
              alignment: pw.Alignment.center,
              padding: const pw.EdgeInsets.all(_kPad),
              child: pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  _t('Status', bold: true, size: 9.5),
                  _t('(NC, OFI)', bold: true, size: 9.5),
                ],
              ),
            ),
          ],
        ),
        if (items.isEmpty)
          pw.TableRow(
            children: [
              _cell(_t('')),
              _cell(_t('')),
              _cell(_t('')),
              _cell(_t('')),
            ],
          ),
        for (var i = 0; i < items.length; i++)
          pw.TableRow(
            children: [
              _cell(_t('${i + 1}'), align: pw.Alignment.center),
              _cell(_t(items[i].criteria)),
              _cell(_t(items[i].findings)),
              _cell(_t(items[i].status), align: pw.Alignment.center),
            ],
          ),
      ],
    );
  }

  pw.Widget _signature(String label, String role) => pw.Expanded(
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _t(label, size: 9.5),
            pw.SizedBox(height: 30),
            pw.Container(
              width: 170,
              decoration: pw.BoxDecoration(
                border: pw.Border(top: _bs),
              ),
              padding: const pw.EdgeInsets.only(top: 2),
              child: _t(role, size: _kSmall),
            ),
            _t('Date:', size: _kSmall),
          ],
        ),
      );

  pw.Document _compose() {
    final doc = pw.Document(
      title: 'Audit Report - ${d.office}',
      author: 'Cotabato Regional and Medical Center',
    );

    doc.addPage(
      pw.MultiPage(
        pageFormat: format,
        margin: const pw.EdgeInsets.all(_kMargin),
        header: _header,
        footer: _footer,
        build: (_) => [
          _section('I.', 'Audit Scope, Auditors and Auditees'),
          _scopeTable(),
          _section('II.', 'Commendable Findings'),
          _commendableTable(),
          _section('III.', 'Summary of Findings'),
          _findingsTable(),
          _section('IV.', 'Audit Conclusions'),
          pw.Padding(
            padding: const pw.EdgeInsets.only(left: 10, right: 10, top: 4),
            child: _t(d.conclusions),
          ),
          pw.SizedBox(height: 34),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _signature('PREPARED BY:', 'Audit Team Leader'),
              _signature('ACKNOWLEDGED BY:', 'Auditee/Head of Office'),
            ],
          ),
        ],
      ),
    );

    return doc;
  }
}
