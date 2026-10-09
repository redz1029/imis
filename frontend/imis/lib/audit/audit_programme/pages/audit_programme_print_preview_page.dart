// lib/audit/audit_programme/pages/audit_programme_print_preview_page.dart
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

import 'package:imis/audit/audit_programme/models/audit_programme.dart';
import 'package:imis/audit/audit_programme/services/audit_programme_service.dart';
import 'package:imis/common_services/common_service.dart';
import 'package:imis/constant/constant.dart';

/// Opens the native (Flutter) print preview of an Audit Programme.
Future<void> openAuditProgrammePrintPreview(
  BuildContext context,
  int programmeId,
) {
  return Navigator.of(context).push<void>(
    MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (_) => AuditProgrammePrintPreviewPage(programmeId: programmeId),
    ),
  );
}

// =============================================================================
// Layout constants (points)
// =============================================================================
const String _kLogoCrmc = 'assets/images/crmc_logo.png';
const String _kLogoIso = 'assets/images/iso_tuv_certified.jpg';
const String _kFormCode = 'QP-03-F-04 Rev. 2';

/// The printed form closes every batch with "DAY n / REPORTING". The data has
/// no such entry, so it is appended after the last audit day of each batch.
/// Set to false to print only the days that actually have entries.
const bool _kAppendReportingDay = true;

const double _kML = 48, _kMR = 48, _kMT = 30, _kMB = 30;
const double _kBorderW = 0.8;
const double _kFont = 10.5;
const double _kTeamFont = 7.5;
const double _kBannerH = 19.0;
const double _kLogoBox = 64.0;
const double _kSideW = 104.0;
const double _kHeaderBlockH = 83.0;
const double _kLabelW = 122.0;
const double _kRomanW = 34.0;
const int _kClausesPerLine = 5;

// OFFICE | STANDARD | DATE | TEAM (measured from the scanned form).
const List<double> _kColFr = [0.32, 0.31, 0.15, 0.22];

// =============================================================================
// Data
// =============================================================================
class _Entry {
  _Entry({
    required this.dayNumber,
    required this.date,
    required this.minutes,
    required this.office,
    required this.teamId,
    required this.persons,
    required this.standards,
    required this.order,
  });

  final int dayNumber;
  final DateTime? date;
  final int minutes;
  final String office;
  final int? teamId;
  final List<String> persons;
  final String standards;
  final int order;

  bool get isReporting => office.trim().toLowerCase() == 'reporting';
}

class _Batch {
  _Batch({required this.number, required this.start, required this.entries});
  final int number;
  final DateTime? start;
  final List<_Entry> entries;
}

class _Sig {
  const _Sig(this.heading, this.name, this.role, this.date);
  final String heading;
  final String name;
  final String role;
  final DateTime? date;
}

class _Data {
  _Data({
    required this.forText,
    required this.fromText,
    required this.purpose,
    required this.objectives,
    required this.scopeFreq,
    required this.schedule,
    required this.planObjective,
    required this.scope,
    required this.criteria,
    required this.methodology,
    required this.selection,
    required this.reporting,
    required this.verification,
    required this.limitations,
    required this.batches,
    required this.teamNames,
    required this.rosters,
    required this.signatories,
  });

  final String forText;
  final String fromText;
  final String purpose;
  final List<String> objectives;
  final String scopeFreq;
  final String schedule;
  final String planObjective;
  final String scope;
  final String criteria;
  final String methodology;
  final String selection;
  final String reporting;
  final String verification;
  final String limitations;
  final List<_Batch> batches;
  final Map<int, String> teamNames;
  final Map<int, List<String>> rosters;
  final List<_Sig> signatories;
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

int? _intOrNull(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is num) return v.toInt();
  return int.tryParse(v.toString());
}

/// Reads [key] (camelCase) or its PascalCase twin from a JSON map.
String _pick(Map<String, dynamic> json, String key) {
  final pascal = key[0].toUpperCase() + key.substring(1);
  return (json[key] ?? json[pascal] ?? '').toString().trim();
}

int _compareClause(String a, String b) {
  final ap = a.split('.');
  final bp = b.split('.');
  final n = math.min(ap.length, bp.length);
  for (var i = 0; i < n; i++) {
    final ai = int.tryParse(ap[i].trim());
    final bi = int.tryParse(bp[i].trim());
    if (ai != null && bi != null) {
      if (ai != bi) return ai.compareTo(bi);
    } else {
      final c = ap[i].compareTo(bp[i]);
      if (c != 0) return c;
    }
  }
  return ap.length.compareTo(bp.length);
}

String _ordSuffix(int n) {
  final m100 = n % 100;
  if (m100 >= 11 && m100 <= 13) return 'TH';
  switch (n % 10) {
    case 1:
      return 'ST';
    case 2:
      return 'ND';
    case 3:
      return 'RD';
    default:
      return 'TH';
  }
}

/// The server stores UTC but serializes it without a "Z"; read it as UTC.
DateTime _signedLocal(DateTime d) => d.isUtc
    ? d.toLocal()
    : DateTime.utc(d.year, d.month, d.day, d.hour, d.minute, d.second)
        .toLocal();

String _roleFor(String label, String fallback) {
  final cleaned = label
      .replaceAll(
        RegExp(r'(prepared|noted|approved)\s*by\s*:?', caseSensitive: false),
        '',
      )
      .replaceAll(':', '')
      .trim();
  if (cleaned.isEmpty) return fallback;
  final up = cleaned.toUpperCase();
  if (up == 'QMR') return 'Quality Management Representative';
  if (up == 'QMS') return 'Chair, ISO – Quality Management System';
  return cleaned;
}

List<_Sig> _buildSignatories(AuditProgramme programme) {
  final prepared = <_Sig>[];
  final noted = <_Sig>[];
  final approved = <_Sig>[];

  for (final s in programme.signatories) {
    final label = (s.signatoryLabel ?? '').toString().trim();
    final up = label.toUpperCase();
    final name = (s.signatoryName ?? '').toString().trim();
    final signed = s.dateSigned;
    final date = signed == null ? null : _signedLocal(signed);

    if (up.contains('PREPAR')) {
      prepared.add(
        _Sig('Prepared by:', name, _roleFor(label, 'IQA Lead Auditor'), date),
      );
    } else if (up.contains('NOTE') || up.contains('QMS')) {
      noted.add(
        _Sig(
          'Noted by:',
          name,
          _roleFor(label, 'Chair, ISO – Quality Management System'),
          date,
        ),
      );
    } else if (up.contains('APPROV') || up.contains('QMR')) {
      approved.add(
        _Sig(
          'Approved by:',
          name,
          _roleFor(label, 'Quality Management Representative'),
          date,
        ),
      );
    }
  }

  if (prepared.isEmpty) {
    prepared.add(const _Sig('Prepared by:', '', 'IQA Lead Auditor', null));
  }
  if (noted.isEmpty) {
    noted.add(const _Sig(
      'Noted by:',
      '',
      'Chair, ISO – Quality Management System',
      null,
    ));
  }
  if (approved.isEmpty) {
    approved.add(const _Sig(
      'Approved by:',
      '',
      'Quality Management Representative',
      null,
    ));
  }
  return [...prepared, ...noted, ...approved];
}

List<_Entry> _parseEntries(
  List<dynamic> rawEntries,
  Map<int, String> standardsById,
) {
  final entries = <_Entry>[];
  var order = 0;

  for (final raw in rawEntries) {
    if (raw is! Map) continue;
    final e = Map<String, dynamic>.from(raw);
    if (e['isDeleted'] == true) continue;

    var office = '';
    final processes = e['auditPlanProcesses'] ?? e['AuditPlanProcesses'];
    if (processes is List && processes.isNotEmpty && processes[0] is Map) {
      final item = processes[0] as Map;
      final officeObj = item['office'];
      final rawName = item['processName'] ??
          item['ProcessName'] ??
          (officeObj is Map ? officeObj['name'] : null);
      office = (rawName ?? '').toString().trim();
    }

    int? teamId;
    final auditors = e['isoAuditors'] ?? e['IsoAuditors'];
    if (auditors is List && auditors.isNotEmpty && auditors[0] is Map) {
      final item = auditors[0] as Map;
      final teamObj = item['team'];
      teamId = _intOrNull(
        item['teamId'] ??
            item['TeamId'] ??
            (teamObj is Map ? teamObj['id'] : null),
      );
    }

    final persons = <String>[];
    final responsible = e['responsiblePersons'] ?? e['ResponsiblePersons'];
    if (responsible is List) {
      for (final item in responsible) {
        final name = item is String
            ? item
            : (item is Map ? (item['name'] ?? item['Name'] ?? '') : '')
                .toString();
        if (name.trim().isNotEmpty) persons.add(name.trim());
      }
    }

    var standards =
        (e['standardText'] ?? e['StandardText'] ?? '').toString().trim();
    if (standards.isEmpty) {
      final list = e['isoStandardAuditPlans'] ?? e['IsoStandardAuditPlans'];
      if (list is List) {
        final labels = <String>[];
        for (final item in list) {
          if (item is! Map) continue;
          final id = _intOrNull(item['isoStandardId'] ?? item['IsoStandardId']);
          if (id == null) continue;
          final label = standardsById[id];
          if (label != null && label.isNotEmpty) labels.add(label);
        }
        standards = labels.join(', ');
      }
    }

    DateTime? date;
    var minutes = 9 * 60;
    final rawTime = e['time'] ?? e['Time'];
    if (rawTime != null) {
      final parsed = DateTime.tryParse(rawTime.toString());
      if (parsed != null) {
        date = DateTime(parsed.year, parsed.month, parsed.day);
        final local = parsed.toLocal();
        minutes = local.hour * 60 + local.minute;
      }
    }

    if (office.isEmpty && persons.isEmpty && standards.isEmpty && teamId == null) {
      continue;
    }

    entries.add(_Entry(
      dayNumber: _intOrNull(e['dayNumber'] ?? e['DayNumber']) ?? 1,
      date: date,
      minutes: minutes,
      office: office,
      teamId: teamId,
      persons: persons,
      standards: standards,
      order: order++,
    ));
  }
  return entries;
}

Future<_Data> _loadPrintData(int programmeId) async {
  final programmeService = AuditProgrammeService(Dio());

  final AuditProgramme? programme =
      await programmeService.getAuditProgrammeById(programmeId);
  if (programme == null) throw Exception('Audit Programme not found');
  final json = programme.toJson();

  final standardsById = <int, String>{};
  try {
    for (final s in await programmeService.getIsoStandards()) {
      final j = s.toJson();
      final id = _intOrNull(j['id'] ?? j['Id']);
      if (id == null) continue;
      final clause =
          (j['clauseRef'] ?? j['ClauseRef'] ?? j['clause'] ?? j['Clause'] ?? '')
              .toString()
              .trim();
      final name = (j['name'] ?? j['Name'] ?? '').toString().trim();
      standardsById[id] = clause.isNotEmpty ? clause : name;
    }
  } catch (e) {
    debugPrint('Programme print preview: failed to load ISO standards: $e');
  }

  final teamNames = <int, String>{};
  try {
    for (final t in await programmeService.getTeams()) {
      final j = t.toJson();
      final id = _intOrNull(j['id'] ?? j['Id']);
      if (id == null) continue;
      teamNames[id] = (j['name'] ?? j['Name'] ?? '').toString().trim();
    }
  } catch (e) {
    debugPrint('Programme print preview: failed to load teams: $e');
  }

  // Roster order is kept as returned (the printed form is not alphabetical).
  final rosters = <int, List<String>>{};
  try {
    final commonService = CommonService(Dio());
    final auditorTeams = await commonService.fetchAuditorTeam();
    final users = await commonService.fetchUsers();
    final nameByUserId = <String, String>{
      for (final u in users) u.id: u.fullName,
    };
    for (final team in auditorTeams) {
      for (final auditor in team.auditors) {
        if (auditor.isDeleted) continue;
        if (!(team.isActive && auditor.isActive)) continue;
        final uid = auditor.userId;
        final name = uid == null ? null : nameByUserId[uid];
        final list = rosters.putIfAbsent(team.teamId, () => <String>[]);
        final display = name ?? 'Unnamed Auditor';
        if (!list.contains(display)) list.add(display);
      }
    }
  } catch (e) {
    debugPrint('Programme print preview: failed to load auditor teams: $e');
  }

  // Objectives: stored one per line, sorted by sortOrder.
  final rawObjectives =
      json['objectives'] as List? ?? json['Objectives'] as List? ?? [];
  final objectiveRows = <MapEntry<int, String>>[];
  for (var i = 0; i < rawObjectives.length; i++) {
    final o = rawObjectives[i];
    if (o is! Map) continue;
    final text = (o['description'] ?? o['Description'] ?? '').toString().trim();
    if (text.isEmpty) continue;
    objectiveRows.add(
      MapEntry(_intOrNull(o['sortOrder'] ?? o['SortOrder']) ?? i, text),
    );
  }
  objectiveRows.sort((a, b) => a.key.compareTo(b.key));

  // Batches: one per audit plan, in start-date order.
  final rawPlans =
      json['auditPlan'] as List? ?? json['AuditPlans'] as List? ?? [];
  final plans = <Map<String, dynamic>>[];
  for (final p in rawPlans) {
    if (p is! Map) continue;
    final m = Map<String, dynamic>.from(p);
    if (m['isDeleted'] == true) continue;
    plans.add(m);
  }
  DateTime? planStart(Map<String, dynamic> p) =>
      DateTime.tryParse((p['startDate'] ?? p['StartDate'] ?? '').toString());
  plans.sort((a, b) {
    final sa = planStart(a);
    final sb = planStart(b);
    if (sa == null && sb == null) return 0;
    if (sa == null) return 1;
    if (sb == null) return -1;
    return sa.compareTo(sb);
  });

  final batches = <_Batch>[];
  for (final plan in plans) {
    final rawEntries =
        (plan['entries'] as List? ?? plan['Entries'] as List? ?? []);
    final entries = _parseEntries(rawEntries, standardsById);
    if (entries.isEmpty) continue;
    final start = planStart(plan);
    batches.add(_Batch(
      number: batches.length + 1,
      start: start == null ? null : DateTime(start.year, start.month, start.day),
      entries: entries,
    ));
  }

  return _Data(
    forText: _pick(json, 'for'),
    fromText: _pick(json, 'from'),
    purpose: _pick(json, 'purpose'),
    objectives: objectiveRows.map((e) => e.value).toList(),
    scopeFreq: _pick(json, 'scopeAndFreqAudit'),
    schedule: _pick(json, 'internalAuditSched'),
    planObjective: _pick(json, 'auditPlanObjective'),
    scope: _pick(json, 'scopeOfAudit'),
    criteria: _pick(json, 'auditCriteria'),
    methodology: _pick(json, 'auditMethodology'),
    selection: _pick(json, 'selectionAndEvaluationOfAuditors'),
    reporting: _pick(json, 'reporting'),
    verification: _pick(json, 'verificationOfPreviousNonconformities'),
    limitations: _pick(json, 'auditLimitations'),
    batches: batches,
    teamNames: teamNames,
    rosters: rosters,
    signatories: _buildSignatories(programme),
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
    } catch (_) {
      return null;
    }
  }

  return _PdfAssets(
    regular: regular,
    bold: bold,
    unicode: unicode,
    crmc: await logo(_kLogoCrmc),
    iso: await logo(_kLogoIso),
  );
}

// =============================================================================
// Preview page
// =============================================================================
class AuditProgrammePrintPreviewPage extends StatefulWidget {
  const AuditProgrammePrintPreviewPage({super.key, required this.programmeId});

  final int programmeId;

  @override
  State<AuditProgrammePrintPreviewPage> createState() =>
      _AuditProgrammePrintPreviewPageState();
}

class _AuditProgrammePrintPreviewPageState
    extends State<AuditProgrammePrintPreviewPage> {
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
        _loadPrintData(widget.programmeId),
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
    return _ProgrammePdfBuilder(
      data: _data!,
      assets: _assets!,
      format: format,
    ).build();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audit Programme — Print Preview'),
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
                  pdfFileName: 'Audit_Programme_${widget.programmeId}.pdf',
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
// Page-top rule
// =============================================================================
/// The form's blocks only draw left / right / bottom edges (their top edge is
/// the previous block's bottom edge). When a block is pushed to the top of a
/// new page it therefore has no line above it. This wrapper paints exactly that
/// missing top edge, and only when the block is the first thing on the page,
/// so no line is ever drawn twice.
///
/// It extends [pw.SingleChildWidget], so a wrapped [pw.Table] still splits
/// across pages exactly as it did before.
class _PageTopRule extends pw.SingleChildWidget {
  _PageTopRule({
    required pw.Widget child,
    required this.pageTop,
    required this.side,
  }) : super(child: child);

  /// Y (from the bottom of the page) of the top edge of the content area.
  final double pageTop;
  final pw.BorderSide side;

  @override
  void paint(pw.Context context) {
    super.paint(context);
    paintChild(context);

    final b = box;
    if (b == null || (b.top - pageTop).abs() > 0.5) return;

    context.canvas
      ..saveContext()
      ..setLineCap(PdfLineCap.square)
      ..setStrokeColor(side.color)
      ..setLineWidth(side.width)
      ..drawLine(b.left, b.top, b.right, b.top)
      ..strokePath()
      ..restoreContext();
  }
}

// =============================================================================
// PDF builder
// =============================================================================
class _ProgrammePdfBuilder {
  _ProgrammePdfBuilder({
    required this.data,
    required this.assets,
    required this.format,
  });

  final _Data data;
  final _PdfAssets assets;
  final PdfPageFormat format;

  late final double _contentW = format.width - _kML - _kMR;

  late final List<double> _colW = () {
    final w = <double>[for (final f in _kColFr) (_contentW * f).floorToDouble()];
    w[3] = _contentW - w[0] - w[1] - w[2];
    return w;
  }();

  pw.BorderSide get _bs => const pw.BorderSide(width: _kBorderW);

  /// Y of the top edge of the page content area (page height minus top margin).
  late final double _pageTop = format.height - _kMT;

  /// Wraps a block so that it gets a top line when it lands at the top of a page.
  pw.Widget _ruled(pw.Widget child) =>
      _PageTopRule(child: child, pageTop: _pageTop, side: _bs);

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

  // ---------------------------------------------------------- paragraphs ---
  static final RegExp _numberedRe = RegExp(r'^(\d+)[\.\)]\s+(.*)$');

  pw.Widget _numbered(String marker, String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(left: 4, bottom: 2),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(width: 16, child: _t(marker)),
          pw.Expanded(child: _t(text)),
        ],
      ),
    );
  }

  /// One widget per line. Lines like "2. Quality Manual" get a hanging indent;
  /// blank lines become a small gap. With [renumber], every line is treated as
  /// a list item and numbered 1..n (stored objectives already carry "1. ").
  List<pw.Widget> _paragraphs(String text, {bool renumber = false}) {
    final out = <pw.Widget>[];
    var n = 0;
    for (final raw in text.trim().split('\n')) {
      final line = raw.trim();
      if (line.isEmpty) {
        out.add(pw.SizedBox(height: 6));
        continue;
      }
      final m = _numberedRe.firstMatch(line);
      if (renumber) {
        n++;
        out.add(_numbered('$n.', m != null ? m.group(2)! : line));
      } else if (m != null) {
        out.add(_numbered('${m.group(1)}.', m.group(2)!));
      } else {
        out.add(pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 2),
          child: _t(line),
        ));
      }
    }
    return out;
  }

  // --------------------------------------------------------------- boxes ---
  pw.Widget _box({
    required pw.Widget child,
    bool top = false,
    pw.EdgeInsets padding = const pw.EdgeInsets.fromLTRB(6, 5, 6, 6),
  }) {
    final block = pw.Container(
      width: _contentW,
      padding: padding,
      decoration: pw.BoxDecoration(
        border: pw.Border(
          top: top ? _bs : pw.BorderSide.none,
          left: _bs,
          right: _bs,
          bottom: _bs,
        ),
      ),
      child: child,
    );
    // Blocks with their own top edge never need the page-top line.
    return top ? block : _ruled(block);
  }

  pw.Widget _section(
    String roman,
    String heading,
    List<pw.Widget> body, {
    bool top = false,
  }) {
    return _box(
      top: top,
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(width: _kRomanW, child: _t(roman, bold: true)),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _t(heading, bold: true),
                pw.SizedBox(height: 3),
                ...body,
              ],
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _labelBox(String label, String value) {
    return _box(
      padding: const pw.EdgeInsets.fromLTRB(6, 9, 6, 11),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(width: _kLabelW, child: _t(label, bold: true)),
          pw.Expanded(child: _t(value)),
        ],
      ),
    );
  }

  pw.Widget _headerTable() {
    const fr = [0.10, 0.56, 0.11, 0.23];
    final w = <double>[for (final f in fr) (_contentW * f).floorToDouble()];
    w[3] = _contentW - w[0] - w[1] - w[2];

    pw.Widget cell(String text, pw.Alignment align, pw.TextAlign ta) {
      return pw.Container(
        alignment: align,
        padding: const pw.EdgeInsets.all(5),
        child: _t(text, bold: true, align: ta),
      );
    }

    return pw.Table(
      columnWidths: {
        for (var i = 0; i < 4; i++) i: pw.FixedColumnWidth(w[i]),
      },
      border: pw.TableBorder(
        top: _bs,
        left: _bs,
        right: _bs,
        bottom: _bs,
        verticalInside: _bs,
      ),
      defaultVerticalAlignment: pw.TableCellVerticalAlignment.full,
      children: [
        pw.TableRow(
          children: [
            cell('FOR:', pw.Alignment.centerLeft, pw.TextAlign.left),
            cell(data.forText, pw.Alignment.center, pw.TextAlign.center),
            cell('FROM:', pw.Alignment.centerLeft, pw.TextAlign.left),
            cell(data.fromText, pw.Alignment.center, pw.TextAlign.center),
          ],
        ),
      ],
    );
  }

  pw.Widget _purposeBox() {
    return _box(
      child: pw.RichText(
        text: pw.TextSpan(
          children: [
            pw.TextSpan(text: 'Purpose: ', style: _st(bold: true)),
            pw.TextSpan(text: _s(data.purpose), style: _st()),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------- banners ---
  pw.Widget _banner(
    pw.Widget child, {
    bool top = false,
    double height = _kBannerH,
  }) {
    return pw.Container(
      width: _contentW,
      height: height,
      alignment: pw.Alignment.center,
      decoration: pw.BoxDecoration(
        border: pw.Border(
          top: top ? _bs : pw.BorderSide.none,
          left: _bs,
          right: _bs,
          bottom: _bs,
        ),
      ),
      child: child,
    );
  }

  pw.Widget _batchBanner(int number, {required bool top}) {
    return _banner(
      top: top,
      height: 21,
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _t('$number', bold: true, size: 11),
          _t(_ordSuffix(number), bold: true, size: 7),
          _t(' BATCH', bold: true, size: 11),
        ],
      ),
    );
  }

  pw.Widget _dayBanner(int day, int total) {
    return _banner(_t('DAY $day OF DAY $total', bold: true, size: 11));
  }

  pw.Widget _reportingBanner() {
    return _banner(_t('REPORTING', bold: true, size: 11), height: 28);
  }

  // ---------------------------------------------------------------- rows ---
  List<String> _standardLines(String raw) {
    final tokens = raw
        .split(RegExp(r'[,;\n]+'))
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toSet()
        .toList()
      ..sort(_compareClause);
    final lines = <String>[];
    for (var i = 0; i < tokens.length; i += _kClausesPerLine) {
      final chunk = tokens.sublist(
        i,
        math.min(i + _kClausesPerLine, tokens.length),
      );
      lines.add(chunk.join(', ') + (i + _kClausesPerLine < tokens.length ? ',' : ''));
    }
    return lines;
  }

  pw.Widget _entryRow(_Entry e, _Batch batch) {
    final date = e.date ??
        (batch.start == null
            ? null
            : batch.start!.add(Duration(days: e.dayNumber - 1)));
    final dateText = date == null ? '' : DateFormat('MMMM d, yyyy').format(date);

    final persons = e.persons.isNotEmpty
        ? e.persons
        : (e.teamId != null
            ? (data.rosters[e.teamId] ?? const <String>[])
            : const <String>[]);

    pw.Widget cell(pw.Widget? child) => pw.Padding(
          padding: const pw.EdgeInsets.fromLTRB(4, 4, 4, 12),
          child: child,
        );

    final stdLines = _standardLines(e.standards);

    return pw.Table(
      columnWidths: {
        for (var i = 0; i < 4; i++) i: pw.FixedColumnWidth(_colW[i]),
      },
      border: pw.TableBorder(left: _bs, right: _bs, bottom: _bs, verticalInside: _bs),
      defaultVerticalAlignment: pw.TableCellVerticalAlignment.top,
      children: [
        pw.TableRow(
          children: [
            cell(e.office.isEmpty ? null : _t(e.office)),
            cell(stdLines.isEmpty ? null : _t(stdLines.join('\n'))),
            cell(dateText.isEmpty ? null : _t(dateText)),
            cell(
              (e.teamId == null && persons.isEmpty)
                  ? null
                  : pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        if (e.teamId != null) ...[
                          _t(
                            data.teamNames[e.teamId] ?? 'Team ${e.teamId}',
                            bold: true,
                            size: _kTeamFont,
                          ),
                          pw.SizedBox(height: 5),
                        ],
                        for (final p in persons) _t(p, size: _kTeamFont),
                      ],
                    ),
            ),
          ],
        ),
      ],
    );
  }

  // ------------------------------------------------------------- batches ---
  /// One unbreakable group: Container is not splittable in MultiPage, so a
  /// banner can never be stranded at the bottom of a page without its row.
  pw.Widget _group(List<pw.Widget> children) {
    return pw.Container(
      width: _contentW,
      child: pw.Column(
        mainAxisSize: pw.MainAxisSize.min,
        children: children,
      ),
    );
  }

  List<pw.Widget> _batchWidgets(_Batch b, {required bool first}) {
    final out = <pw.Widget>[];
    if (!first) out.add(pw.SizedBox(height: 14));

    final audit = b.entries.where((e) => !e.isReporting).toList();
    final reporting = b.entries.where((e) => e.isReporting).toList();

    final byDay = <int, List<_Entry>>{};
    for (final e in audit) {
      byDay.putIfAbsent(e.dayNumber, () => <_Entry>[]).add(e);
    }
    final days = byDay.keys.toList()..sort();

    int? reportingDay;
    if (reporting.isNotEmpty) {
      reportingDay = reporting.map((e) => e.dayNumber).reduce(math.min);
    } else if (_kAppendReportingDay) {
      reportingDay = (days.isEmpty ? 0 : days.last) + 1;
    }
    final total = reportingDay ?? (days.isEmpty ? 1 : days.last);

    var pendingBatchBanner = true;

    for (final day in days) {
      final list = byDay[day]!
        ..sort((a, c) {
          final m = a.minutes.compareTo(c.minutes);
          return m != 0 ? m : a.order.compareTo(c.order);
        });

      // A group that opens with a batch banner for a non-first batch already
      // draws its own top edge; every other group needs the page-top rule.
      final ownTop = pendingBatchBanner && !first;
      final head = <pw.Widget>[
        if (pendingBatchBanner) _batchBanner(b.number, top: !first),
        _dayBanner(day, total),
        _entryRow(list.first, b),
      ];
      pendingBatchBanner = false;
      out.add(ownTop ? _group(head) : _ruled(_group(head)));

      for (var i = 1; i < list.length; i++) {
        out.add(_ruled(_entryRow(list[i], b)));
      }
    }

    if (reportingDay != null) {
      final ownTop = pendingBatchBanner && !first;
      final tail = _group([
        if (pendingBatchBanner) _batchBanner(b.number, top: !first),
        _dayBanner(reportingDay, total),
        _reportingBanner(),
      ]);
      out.add(ownTop ? tail : _ruled(tail));
    }
    return out;
  }

  // ------------------------------------------------------------ letterhead ---
  pw.Widget _side(pw.Widget? child, pw.Alignment alignment) {
    return pw.SizedBox(
      width: _kSideW,
      child: pw.Align(alignment: alignment, child: child),
    );
  }

  pw.Widget _letterhead() {
    final iso = assets.iso;
    final crmc = assets.crmc;

    final left = iso == null ? null : pw.Image(iso, height: 40);
    final right = crmc == null
        ? null
        : pw.SizedBox(
            width: _kLogoBox,
            height: _kLogoBox,
            child: pw.ClipRect(
              child: pw.Image(crmc, fit: pw.BoxFit.cover),
            ),
          );

    return pw.SizedBox(
      height: _kHeaderBlockH,
      child: pw.Column(
        mainAxisSize: pw.MainAxisSize.min,
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
          pw.SizedBox(
            height: _kLogoBox,
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                _side(left, pw.Alignment.centerLeft),
                pw.Expanded(
                  child: pw.Column(
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
                ),
                _side(right, pw.Alignment.centerRight),
              ],
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Container(width: _contentW, height: 3, color: PdfColors.black),
          pw.SizedBox(height: 2),
          pw.Container(width: _contentW, height: 0.7, color: PdfColors.black),
        ],
      ),
    );
  }

  // ------------------------------------------------------------ signatures ---
  pw.Widget _sigColumn(_Sig s, double colW) {
    final dateText = s.date == null ? '' : DateFormat('M/d/yyyy').format(s.date!);
    return pw.Padding(
      padding: const pw.EdgeInsets.only(left: 22, right: 16),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          _t(s.heading.toUpperCase(), bold: true),
          pw.SizedBox(height: 36),
          if (s.name.trim().isEmpty)
            pw.Container(
              width: colW - 70,
              height: 12,
              decoration: pw.BoxDecoration(border: pw.Border(bottom: _bs)),
            )
          else
            _t(s.name.trim().toUpperCase(), bold: true),
          if (s.role.trim().isNotEmpty) _t(s.role.trim()),
          pw.SizedBox(height: 3),
          pw.Row(
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              _t('Date:'),
              pw.SizedBox(width: 4),
              pw.Container(
                width: 90,
                height: 13,
                alignment: pw.Alignment.bottomCenter,
                decoration: pw.BoxDecoration(border: pw.Border(bottom: _bs)),
                child: dateText.isEmpty ? null : _t(dateText),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _signatureBlock() {
    final sigs = data.signatories;
    final colW = _contentW / 2;
    final rows = <pw.Widget>[];
    for (var i = 0; i < sigs.length; i += 2) {
      rows.add(pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(width: colW, child: _sigColumn(sigs[i], colW)),
          pw.SizedBox(
            width: colW,
            child: i + 1 < sigs.length ? _sigColumn(sigs[i + 1], colW) : null,
          ),
        ],
      ));
      rows.add(pw.SizedBox(height: 22));
    }
    return pw.Container(
      width: _contentW,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: rows,
      ),
    );
  }

  // ---------------------------------------------------------------- footer ---
  pw.Widget _footer(pw.Context ctx) {
    final isLast = ctx.pageNumber == ctx.pagesCount;
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 8),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Expanded(child: pw.SizedBox()),
          pw.Expanded(
            child: pw.Center(child: _t('${ctx.pageNumber}', size: 9)),
          ),
          pw.Expanded(
            child: pw.Align(
              alignment: pw.Alignment.centerRight,
              child: isLast
                  ? _t(_kFormCode, bold: true, size: 8.5)
                  : pw.SizedBox(),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------------ body ---
  List<pw.Widget> _body() {
    final w = <pw.Widget>[
      _letterhead(),
      pw.SizedBox(height: 6),
      pw.Center(child: _t('AUDIT PROGRAMME', bold: true, size: 12)),
      pw.SizedBox(height: 10),
      _headerTable(),
      _purposeBox(),
      _section('I.', 'Objectives', _paragraphs(data.objectives.join('\n'), renumber: true)),
      _section('II.', 'Scope and Frequency of Audit', _paragraphs(data.scopeFreq)),
      _section('III.', 'Internal Audit Schedule', _paragraphs(data.schedule)),
      _labelBox('Audit Plan Objective:', data.planObjective),
      _labelBox('Scope of Audit:', data.scope),
    ];

    for (var i = 0; i < data.batches.length; i++) {
      w.addAll(_batchWidgets(data.batches[i], first: i == 0));
    }

    final hasBatches = data.batches.isNotEmpty;
    if (hasBatches) w.add(pw.SizedBox(height: 16));

    w.addAll([
      _section('IV.', 'Audit Criteria', _paragraphs(data.criteria), top: hasBatches),
      _section('V.', 'Audit Methodology', _paragraphs(data.methodology)),
      _section(
        'VI.',
        'Selection and Evaluation of Auditors',
        _paragraphs(data.selection),
      ),
      _section('VII.', 'Reporting', _paragraphs(data.reporting)),
      _section(
        'VIII.',
        'Verification of Previous Nonconformities/Follow Up Actions',
        _paragraphs(data.verification),
      ),
      _section('IX.', 'Audit Limitations', _paragraphs(data.limitations)),
      pw.SizedBox(height: 26),
      _signatureBlock(),
    ]);
    return w;
  }

  Future<Uint8List> build() async {
    final doc = pw.Document(
      title: 'Audit Programme',
      author: 'Cotabato Regional and Medical Center',
    );

    doc.addPage(
      pw.MultiPage(
        pageFormat: format,
        margin: const pw.EdgeInsets.fromLTRB(_kML, _kMT, _kMR, _kMB),
        theme: pw.ThemeData.withFont(base: assets.regular, bold: assets.bold),
        maxPages: 200,
        footer: _footer,
        build: (pw.Context ctx) => _body(),
      ),
    );
    return doc.save();
  }
}