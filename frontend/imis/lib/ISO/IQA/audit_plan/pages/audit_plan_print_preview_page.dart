// lib/audit/audit_plan/pages/audit_plan_print_preview_page.dart
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

import 'package:imis/ISO/IQA/audit_plan/models/audit_plan.dart';
import 'package:imis/ISO/IQA/audit_plan/services/AuditPlanService.dart';
import 'package:imis/ISO/IQA/audit_programme/services/audit_programme_service.dart';
import 'package:imis/common_services/common_service.dart';
import 'package:imis/constant/constant.dart';

/// Opens the native (Flutter) print preview of an Audit Plan.
Future<void> openAuditPlanPrintPreview(BuildContext context, int auditPlanId) {
  return Navigator.of(context).push<void>(
    MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (_) => AuditPlanPrintPreviewPage(auditPlanId: auditPlanId),
    ),
  );
}

// =============================================================================
// Opening Meeting (Day 1 of every Audit Plan, as on the original form).
// Public so the Audit Plan form uses exactly the same defaults.
// =============================================================================
const String kOpeningMeetingLabel = 'Opening Meeting';

const List<String> kOpeningMeetingPersons = <String>[
  'Top Management',
  'ISO Core Team',
  'QMR',
  'DQMRs',
  'IQA Lead Auditor',
  'IQA Members',
  'Department / Section / Unit Heads Concerned',
  'Consultants Concerned',
  'Chief Residents Concerned',
];

// =============================================================================
// Layout constants (points)
// =============================================================================
const String _kLogoCrmc = 'assets/CRMCLogo.png';
const String _kLogoIso = 'assets/TR-Testmark.jpg';
const String _kFormCode = 'QP-03-F-02 Rev.1';

const double _kML = 48, _kMR = 48, _kMT = 30, _kMB = 30;
const double _kLineH = 12.6;
const double _kSpacerH = 7.0;

/// Extra room above the first line of a new time slot (under its separator).
const double _kTopGap = 3.0;
const double _kBannerH = 17.0;
const double _kFooterH = 20.0;
const double _kBorderW = 0.8;
const double _kPadX = 4.0;
const double _kFont = 10.0;
const double _kLogoBox = 64.0;
const double _kSideW = 104.0;

/// Letterhead block: logo row + double rule + a clear gap before whatever
/// follows (the original form leaves a gap between the rule and the table).
const double _kHeaderBlockH = 92.0;
const double _kTitleH = 30.0;
const double _kObjGap = 8.0;
const double _kLabelW = 104.0;
const double _kSigGap = 16.0;
const double _kSigSpace = 26.0;
const List<double> _kColFr = [0.13, 0.29, 0.30, 0.28];

// =============================================================================
// Data
// =============================================================================
class _PlanEntry {
  _PlanEntry({
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

  bool get isOpening => office.trim().toLowerCase().startsWith('opening');

  _PlanEntry withMinutes(int m) => _PlanEntry(
        dayNumber: dayNumber,
        date: date,
        minutes: m,
        office: office,
        teamId: teamId,
        persons: persons,
        standards: standards,
        order: order,
      );
}

class _Sig {
  const _Sig(this.heading, this.name, this.role, this.date);
  final String heading;
  final String name;
  final String role;
  final DateTime? date;
}

class _PrintData {
  _PrintData({
    required this.objective,
    required this.scope,
    required this.entries,
    required this.teamNames,
    required this.rosters,
    required this.signatories,
  });

  final String objective;
  final String scope;
  final List<_PlanEntry> entries;
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

String _roleFor(String label, String fallback) {
  final cleaned = label
      .replaceAll(
        RegExp(r'(prepared|noted|approved)\s*by\s*:?', caseSensitive: false),
        '',
      )
      .replaceAll(':', '')
      .trim();
  if (cleaned.isEmpty) return fallback;
  if (cleaned.toUpperCase() == 'QMR') return 'Quality Management Representative';
  return cleaned;
}

List<_Sig> _buildSignatories(AuditPlan plan) {
  final prepared = <_Sig>[];
  final noted = <_Sig>[];
  final approved = <_Sig>[];

  for (final s in plan.signatories) {
    final label = (s.signatoryLabel ?? '').toString().trim();
    final up = label.toUpperCase();
    final name = (s.signatoryName ?? '').toString().trim();
    final signed = s.dateSigned;
    final date = signed?.toLocal();

    if (up.contains('PREPAR')) {
      prepared.add(_Sig('Prepared by:', name, _roleFor(label, 'IQA Lead Auditor'), date));
    } else if (up.contains('NOTE') || up.contains('QMS')) {
      noted.add(_Sig('Noted by:', name, _roleFor(label, ''), date));
    } else if (up.contains('APPROV') || up.contains('QMR')) {
      approved.add(_Sig(
        'Approved by:',
        name,
        _roleFor(label, 'Quality Management Representative'),
        date,
      ));
    }
  }

  if (prepared.isEmpty) {
    prepared.add(const _Sig('Prepared by:', '', 'IQA Lead Auditor', null));
  }
  if (noted.isEmpty) {
    noted.add(const _Sig('Noted by:', '', '', null));
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

/// Day 1 always opens with the Opening Meeting (as on the original form).
/// If the saved plan has none yet, it is added here with the standard list.
List<_PlanEntry> _withOpeningMeeting(List<_PlanEntry> entries) {
  final day1 = entries.where((e) => e.dayNumber == 1).toList();
  if (day1.isEmpty || day1.any((e) => e.isOpening)) return entries;

  final date =
      day1.map((e) => e.date).firstWhere((d) => d != null, orElse: () => null);

  return [
    _PlanEntry(
      dayNumber: 1,
      date: date,
      minutes: 9 * 60,
      office: kOpeningMeetingLabel,
      teamId: null,
      persons: List<String>.from(kOpeningMeetingPersons),
      standards: '',
      order: -1,
    ),
    ...entries,
  ];
}

/// Rows saved without a time of day (00:00) get sensible times instead of
/// "12:00 AM": the Opening Meeting at 9:00 AM, then one row per hour starting
/// 10:00 AM on Day 1 (9:00 AM on the other days). Rows with a real time keep it.
List<_PlanEntry> _withDefaultTimes(List<_PlanEntry> entries) {
  final byDay = <int, List<_PlanEntry>>{};
  for (final e in entries) {
    byDay.putIfAbsent(e.dayNumber, () => <_PlanEntry>[]).add(e);
  }

  final minutesOf = <_PlanEntry, int>{};
  for (final day in byDay.keys) {
    final list = [...byDay[day]!]..sort((a, b) => a.order.compareTo(b.order));
    var cursor = day == 1 ? 10 * 60 : 9 * 60;
    for (final e in list) {
      if (e.minutes != 0) {
        minutesOf[e] = e.minutes;
        if (e.minutes + 60 > cursor) cursor = e.minutes + 60;
        continue;
      }
      if (e.isOpening) {
        minutesOf[e] = 9 * 60;
        continue;
      }
      minutesOf[e] = cursor;
      cursor += 60;
    }
  }

  return [for (final e in entries) e.withMinutes(minutesOf[e] ?? e.minutes)];
}

/// The typed text of an entry that holds only typed text: no office from the
/// list, no clause, no team and no persons (e.g. the programme's "Reporting"
/// day). Returns null for any other entry.
String? _textOnlyEntryText(Map<String, dynamic> e) {
  if (e['isDeleted'] == true) return null;

  var office = '';
  int? officeId;
  final processes = e['auditPlanProcesses'] ?? e['AuditPlanProcesses'];
  if (processes is List && processes.isNotEmpty && processes[0] is Map) {
    final item = processes[0] as Map;
    final officeObj = item['office'];
    final rawName = item['processName'] ??
        item['ProcessName'] ??
        (officeObj is Map ? officeObj['name'] : null);
    office = (rawName ?? '').toString().trim();
    officeId = _intOrNull(
      item['officeId'] ??
          item['OfficeId'] ??
          (officeObj is Map ? officeObj['id'] : null),
    );
  }
  if (office.isEmpty) return null;
  if (officeId != null && officeId != 0) return null;

  final standardList = e['isoStandardAuditPlans'] ?? e['IsoStandardAuditPlans'];
  if (standardList is List && standardList.isNotEmpty) return null;

  final standardText =
      (e['standardText'] ?? e['StandardText'] ?? '').toString().trim();
  if (standardText.isNotEmpty) return null;

  final auditors = e['isoAuditors'] ?? e['IsoAuditors'];
  if (auditors is List && auditors.isNotEmpty) return null;

  final responsible = e['responsiblePersons'] ?? e['ResponsiblePersons'];
  if (responsible is List && responsible.isNotEmpty) return null;

  return office;
}

String _textOnlyKey(int dayNumber, String text) =>
    '$dayNumber|${text.trim().toLowerCase()}';

Future<_PrintData> _loadPrintData(int planId) async {
  final planService = AuditPlanService(Dio());
  final programmeService = AuditProgrammeService(Dio());

  final AuditPlan? plan = await planService.getAuditPlanById(planId);
  if (plan == null) throw Exception('Audit Plan not found');

  final programme =
      await programmeService.getAuditProgrammeById(plan.auditProgrammeId);
  if (programme == null) throw Exception('Audit Programme not found');
  final jsonMap = programme.toJson();

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
    debugPrint('Print preview: failed to load ISO standards: $e');
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
    debugPrint('Print preview: failed to load teams: $e');
  }

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
        rosters
            .putIfAbsent(team.teamId, () => <String>[])
            .add(name ?? 'Unnamed Auditor');
      }
    }
    for (final list in rosters.values) {
      list.sort();
    }
  } catch (e) {
    debugPrint('Print preview: failed to load auditor teams: $e');
  }

  var objective =
      (jsonMap['auditPlanObjective'] ?? jsonMap['AuditPlanObjective'] ?? '')
          .toString()
          .trim();
  if (objective.isEmpty) {
    final loaded =
        jsonMap['objectives'] as List? ?? jsonMap['Objectives'] as List? ?? [];
    objective = loaded
        .map((o) => (o['description'] ?? o['Description'] ?? '').toString())
        .where((s) => s.isNotEmpty)
        .join('\n');
  }
  final scope =
      (jsonMap['scopeOfAudit'] ?? jsonMap['ScopeOfAudit'] ?? '').toString().trim();

  final plans =
      (jsonMap['auditPlan'] as List? ?? jsonMap['AuditPlans'] as List? ?? []);
  Map<String, dynamic>? planJson;
  for (final p in plans) {
    if (p is Map && _intOrNull(p['id'] ?? p['Id']) == planId) {
      planJson = Map<String, dynamic>.from(p);
      break;
    }
  }
  if (planJson == null) {
    throw Exception('The entries of this Audit Plan were not found.');
  }
  final rawEntries =
      (planJson['entries'] as List? ?? planJson['Entries'] as List? ?? []);

  // Typed-text rows of the Audit Programme (e.g. "Reporting") are not part of
  // the Audit Plan, so they are never printed on it.
  final programmeTextOnlyKeys = <String>{};
  for (final p in plans) {
    if (p is! Map) continue;
    final list = p['entries'] as List? ?? p['Entries'] as List? ?? [];
    for (final raw in list) {
      if (raw is! Map) continue;
      final m = Map<String, dynamic>.from(raw);
      final text = _textOnlyEntryText(m);
      if (text == null) continue;
      programmeTextOnlyKeys.add(
        _textOnlyKey(_intOrNull(m['dayNumber'] ?? m['DayNumber']) ?? 1, text),
      );
    }
  }

  final entries = <_PlanEntry>[];
  var order = 0;
  for (final raw in rawEntries) {
    if (raw is! Map) continue;
    final e = Map<String, dynamic>.from(raw);

    // Skip a row that came from a programme typed-text row (e.g. "Reporting").
    final textOnly = _textOnlyEntryText(e);
    if (textOnly != null &&
        programmeTextOnlyKeys.contains(
          _textOnlyKey(_intOrNull(e['dayNumber'] ?? e['DayNumber']) ?? 1, textOnly),
        )) {
      continue;
    }

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
            : (item is Map ? (item['name'] ?? item['Name'] ?? '') : '').toString();
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

    entries.add(_PlanEntry(
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

  final finalEntries = _withDefaultTimes(_withOpeningMeeting(entries));

  return _PrintData(
    objective: objective,
    scope: scope,
    entries: finalEntries,
    teamNames: teamNames,
    rosters: rosters,
    signatories: _buildSignatories(plan),
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
      // Usually: the file is missing or not listed under `assets:` in pubspec.yaml.
      debugPrint('Audit Plan print preview: cannot load asset "$path": $e');
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
class AuditPlanPrintPreviewPage extends StatefulWidget {
  const AuditPlanPrintPreviewPage({super.key, required this.auditPlanId});

  final int auditPlanId;

  @override
  State<AuditPlanPrintPreviewPage> createState() =>
      _AuditPlanPrintPreviewPageState();
}

class _AuditPlanPrintPreviewPageState extends State<AuditPlanPrintPreviewPage> {
  _PrintData? _data;
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
        _loadPrintData(widget.auditPlanId),
        _loadAssets(),
      ]);
      _data = results[0] as _PrintData;
      _assets = results[1] as _PdfAssets;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<Uint8List> _buildPdf(PdfPageFormat format) {
    return _PlanPdfBuilder(
      data: _data!,
      assets: _assets!,
      format: format,
    ).build();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audit Plan — Print Preview'),
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
                  pdfFileName: 'Audit_Plan_${widget.auditPlanId}.pdf',
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
abstract class _Item {
  const _Item();
  double get h;
}

class _SpacerItem extends _Item {
  const _SpacerItem();
  @override
  double get h => _kSpacerH;
}

class _BannerItem extends _Item {
  const _BannerItem(this.text);
  final String text;
  @override
  double get h => _kBannerH;
}

class _CellLine {
  const _CellLine(
    this.text, {
    this.bold = false,
    this.bullet = false,
    this.indent = false,
  });
  final String text;
  final bool bold;
  final bool bullet;
  final bool indent;
}

class _LineItem extends _Item {
  const _LineItem({
    required this.time,
    this.topLine = false,
    this.office,
    this.team,
    this.std,
  });
  final String time;

  /// First line of a new time slot on the same day: a separator line is drawn
  /// above it (entries that share a time slot are not separated).
  final bool topLine;
  final _CellLine? office;
  final _CellLine? team;
  final _CellLine? std;
  @override
  double get h => _kLineH + (topLine ? _kTopGap : 0);
}

class _PageSpec {
  _PageSpec(this.items);
  final List<_Item> items;
  bool showBox = true;
  bool showSig = false;
}

class _PlanPdfBuilder {
  _PlanPdfBuilder({
    required this.data,
    required this.assets,
    required this.format,
  });

  final _PrintData data;
  final _PdfAssets assets;
  final PdfPageFormat format;

  late final double _contentW = format.width - _kML - _kMR;
  late final List<double> _colW = () {
    final w = <double>[for (final f in _kColFr) (_contentW * f).floorToDouble()];
    w[3] = _contentW - w[0] - w[1] - w[2];
    return w;
  }();

  late List<_PageSpec> _pages;
  late List<List<String>> _hdrLines;
  late double _hdrH;
  late List<String> _objLines;
  late List<String> _scopeLines;
  late double _objH;
  late double _scopeH;
  late double _sigH;

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

  pw.TextStyle _st({bool bold = false, double size = _kFont, bool underline = false}) {
    return pw.TextStyle(
      font: bold ? assets.bold : assets.regular,
      fontSize: size,
      color: PdfColors.black,
      decoration: underline ? pw.TextDecoration.underline : null,
    );
  }

  /// Approximate text width in points (0.55 is the average character
  /// width ratio of the Times/Tinos family).
  double _w(String s, {bool bold = false, double size = _kFont}) {
    return s.length * size * 0.55;
  }

  List<String> _wrap(String text, double maxW,
      {bool bold = false, double size = _kFont}) {
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

  double _inner(int col) => _colW[col] - 2 * _kPadX - 2;

  pw.BorderSide get _bs => const pw.BorderSide(width: _kBorderW);

  List<String> _standardLines(String raw) {
    final tokens = raw
        .split(RegExp(r'[,;\n]+'))
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toSet()
        .toList()
      ..sort(_compareClause);
    final lines = <String>[];
    for (var i = 0; i < tokens.length; i += 4) {
      final chunk = tokens.sublist(i, math.min(i + 4, tokens.length));
      final line = chunk.join(', ') + (i + 4 < tokens.length ? ',' : '');
      lines.addAll(_wrap(line, _inner(3)));
    }
    return lines;
  }

  /// Person-responsible lines. A team prints its name in bold followed by its
  /// members; free-text persons/roles (e.g. the Opening Meeting list) print as
  /// bullets, with a hanging indent for wrapped lines.
  List<_CellLine> _teamLines(_PlanEntry e) {
    final w = _inner(2);
    final lines = <_CellLine>[];
    final persons = e.persons.isNotEmpty
        ? e.persons
        : (e.teamId != null ? (data.rosters[e.teamId] ?? <String>[]) : <String>[]);

    if (e.teamId != null) {
      final name = data.teamNames[e.teamId] ?? 'Team';
      for (final l in _wrap(name, w, bold: true)) {
        lines.add(_CellLine(l, bold: true));
      }
      for (final p in persons) {
        for (final l in _wrap(p, w)) {
          lines.add(_CellLine(l));
        }
      }
    } else {
      for (final p in persons) {
        final wrapped = _wrap(p, w - 8.2);
        for (var i = 0; i < wrapped.length; i++) {
          lines.add(_CellLine(wrapped[i], bullet: i == 0, indent: i > 0));
        }
      }
    }
    return lines;
  }

  void _prepare() {
    final dash = assets.unicode ? '–' : '-';

    final titles = <String>[
      'Time',
      'Organizational Unit and Process',
      'Audit Team/Person Responsible',
      'Standard',
    ];
    _hdrLines = [
      for (var i = 0; i < 4; i++) _wrap(titles[i], _inner(i), bold: true),
    ];
    final hdrMax = _hdrLines.map((l) => l.length).reduce(math.max);
    _hdrH = hdrMax * _kLineH + 8;

    final textW = _contentW - _kLabelW - 12 - 2;
    _objLines = _wrap(data.objective, textW);
    _scopeLines = _wrap(data.scope, textW);
    _objH = math.max(1, _objLines.length) * _kLineH + 10;
    _scopeH = math.max(1, _scopeLines.length) * _kLineH + 10;

    _sigH = _computeSigHeight();

    final sorted = [...data.entries]..sort((a, b) {
        final d = a.dayNumber.compareTo(b.dayNumber);
        if (d != 0) return d;
        final m = a.minutes.compareTo(b.minutes);
        if (m != 0) return m;
        return a.order.compareTo(b.order);
      });

    final byDay = <int, List<_PlanEntry>>{};
    for (final e in sorted) {
      byDay.putIfAbsent(e.dayNumber, () => <_PlanEntry>[]).add(e);
    }
    final days = byDay.keys.toList()..sort();

    final items = <_Item>[];
    for (final day in days) {
      final list = byDay[day]!;
      final date = list
          .map((e) => e.date)
          .firstWhere((d) => d != null, orElse: () => null);
      final banner = date == null
          ? 'DAY $day'
          : 'DAY $day $dash ${DateFormat('MMMM d, yyyy').format(date).toUpperCase()}';
      items.add(_BannerItem(_s(banner)));

      String? prevTime;
      for (final e in list) {
        final timeText = DateFormat('h:mm a')
            .format(DateTime(2000, 1, 1, e.minutes ~/ 60, e.minutes % 60));
        final showTime = timeText != prevTime;
        // A separator line only where the time changes within the same day.
        // The first entry of a day sits right under the day banner (which has
        // its own bottom border), and entries sharing a time stay together.
        final startsNewTimeSlot = showTime && prevTime != null;
        prevTime = timeText;

        final officeLines = e.office.isEmpty
            ? <String>[]
            : _wrap(e.office, _inner(1));
        final teamLines = _teamLines(e);
        final stdLines = _standardLines(e.standards);

        final n = math.max(
          1,
          math.max(officeLines.length, math.max(teamLines.length, stdLines.length)),
        );
        for (var i = 0; i < n; i++) {
          items.add(_LineItem(
            time: (i == 0 && showTime) ? timeText : '',
            topLine: i == 0 && startsNewTimeSlot,
            office: i < officeLines.length ? _CellLine(officeLines[i]) : null,
            team: i < teamLines.length ? teamLines[i] : null,
            std: i < stdLines.length ? _CellLine(stdLines[i]) : null,
          ));
        }
        items.add(const _SpacerItem());
      }
    }

    final bodyAvail = format.height - _kMT - _kMB - _kHeaderBlockH - _kFooterH;
    final firstExtra = _kTitleH + _objH + _scopeH + 1.6 + _kObjGap + _hdrH;
    double cap(int idx) =>
        bodyAvail - (idx == 0 ? firstExtra : 0) - 2 * _kBorderW - 6;

    final pages = <List<_Item>>[];
    var cur = <_Item>[];
    var used = 0.0;

    void trimTail(List<_Item> list) {
      while (list.isNotEmpty && list.last is _SpacerItem) {
        list.removeLast();
      }
    }

    for (final it in items) {
      if (cur.isEmpty && it is _SpacerItem) continue;
      if (cur.isNotEmpty && used + it.h > cap(pages.length)) {
        final carry = <_Item>[];
        trimTail(cur);
        if (cur.isNotEmpty && cur.last is _BannerItem) {
          carry.add(cur.removeLast());
          trimTail(cur);
        }
        pages.add(cur);
        cur = carry;
        used = carry.fold<double>(0, (s, e) => s + e.h);
        if (cur.isEmpty && it is _SpacerItem) continue;
      }
      cur.add(it);
      used += it.h;
    }
    trimTail(cur);
    pages.add(cur);

    final specs = pages.map((p) => _PageSpec(p)).toList();

    final lastIdx = specs.length - 1;
    final lastUsed = specs[lastIdx].items.fold<double>(0, (s, e) => s + e.h);
    final room = cap(lastIdx) - lastUsed;
    if (room >= _sigH + _kSigGap) {
      specs[lastIdx].showSig = true;
    } else {
      final sigPage = _PageSpec(<_Item>[])
        ..showBox = false
        ..showSig = true;
      specs.add(sigPage);
    }
    _pages = specs;
  }

  Future<Uint8List> build() async {
    _prepare();

    final doc = pw.Document(
      title: 'Audit Plan',
      author: 'Cotabato Regional and Medical Center',
    );

    for (var i = 0; i < _pages.length; i++) {
      doc.addPage(
        pw.Page(
          pageFormat: format,
          margin: const pw.EdgeInsets.fromLTRB(_kML, _kMT, _kMR, _kMB),
          theme: pw.ThemeData.withFont(
            base: assets.regular,
            bold: assets.bold,
          ),
          build: (pw.Context ctx) => _pageWidget(i),
        ),
      );
    }
    return doc.save();
  }

  pw.Widget _pageWidget(int idx) {
    final spec = _pages[idx];
    final isLast = idx == _pages.length - 1;

    final kids = <pw.Widget>[_letterhead()];

    if (idx == 0) {
      kids.add(pw.SizedBox(
        height: _kTitleH,
        child: pw.Center(
          child: pw.Text('AUDIT PLAN', style: _st(bold: true, size: 13)),
        ),
      ));
      kids.add(_objectivesBox());
      kids.add(pw.SizedBox(height: _kObjGap));
    }

    if (spec.showBox) kids.add(_tableBox(spec, idx));

    if (spec.showSig) {
      kids.add(pw.SizedBox(height: spec.showBox ? _kSigGap : 10));
      kids.add(_signatureBlock());
    }

    kids.add(pw.Spacer());
    kids.add(_footer(idx, isLast));

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: kids,
    );
  }

  // ignore: unused_element
  pw.Widget _side(pw.Widget? child, pw.Alignment alignment) {
    return pw.SizedBox(
      width: _kSideW,
      child: pw.Align(alignment: alignment, child: child),
    );
  }

  /// Same letterhead as the original form: the CRMC seal sits against the
  /// left of the centred three-line heading, the TÜV certification mark on the
  /// right, and the double rule (thick over thin) closes the block. The block
  /// is taller than its content so a clear gap separates the rule from the
  /// table that follows on continuation pages.
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
            width: _kSideW,
            height: 50,
            child: pw.Image(
              iso,
              fit: pw.BoxFit.contain,
              alignment: pw.Alignment.centerRight,
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
                pw.Expanded(
                  child: pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: seal,
                  ),
                ),
                pw.SizedBox(width: 4),
                pw.Column(
                  mainAxisSize: pw.MainAxisSize.min,
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text('Republic of the Philippines', style: _st(size: 10)),
                    pw.Text('Department of Health', style: _st(size: 10)),
                    pw.Text(
                      'COTABATO REGIONAL AND MEDICAL CENTER',
                      style: _st(bold: true, size: 11),
                    ),
                  ],
                ),
                pw.SizedBox(width: 8),
                pw.Expanded(
                  child: pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: tuv,
                  ),
                ),
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

  pw.Widget _objectivesBox() {
    pw.Widget row(String label, List<String> lines, double h, bool bottom) {
      return pw.Container(
        width: _contentW,
        height: h,
        padding: const pw.EdgeInsets.fromLTRB(6, 5, 6, 5),
        decoration: pw.BoxDecoration(
          border: pw.Border(
            bottom: bottom ? _bs : pw.BorderSide.none,
          ),
        ),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.SizedBox(
              width: _kLabelW,
              child: pw.Text(label, style: _st(bold: true)),
            ),
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  for (final l in lines)
                    pw.SizedBox(
                      height: _kLineH,
                      child: pw.Text(l, style: _st(), softWrap: false),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return pw.Container(
      width: _contentW,
      decoration: pw.BoxDecoration(border: pw.Border.all(width: _kBorderW)),
      child: pw.Column(
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          row('Audit Objectives:', _objLines, _objH, true),
          row('Scope of Audit:', _scopeLines, _scopeH, false),
        ],
      ),
    );
  }

  pw.Widget _tableBox(_PageSpec spec, int pageIdx) {
    final rows = <pw.Widget>[];
    if (pageIdx == 0) rows.add(_headerRow());
    for (var i = 0; i < spec.items.length; i++) {
      rows.add(_itemWidget(spec.items[i], isFirst: i == 0));
    }
    return pw.Container(
      width: _contentW,
      decoration: pw.BoxDecoration(
        border: pw.Border(top: _bs, bottom: _bs),
      ),
      child: pw.Column(
        mainAxisSize: pw.MainAxisSize.min,
        children: rows,
      ),
    );
  }

  pw.Widget _headerRow() {
    return pw.Row(
      children: [
        for (var i = 0; i < 4; i++)
          pw.Container(
            width: _colW[i],
            height: _hdrH,
            padding: const pw.EdgeInsets.symmetric(horizontal: _kPadX),
            alignment: pw.Alignment.center,
            decoration: pw.BoxDecoration(
              border: pw.Border(
                left: _bs,
                right: i == 3 ? _bs : pw.BorderSide.none,
                bottom: _bs,
              ),
            ),
            child: pw.Column(
              mainAxisSize: pw.MainAxisSize.min,
              children: [
                for (final l in _hdrLines[i])
                  pw.SizedBox(
                    height: _kLineH,
                    child: pw.Text(
                      l,
                      style: _st(bold: true),
                      textAlign: pw.TextAlign.center,
                      softWrap: false,
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  pw.Widget _itemWidget(_Item it, {required bool isFirst}) {
    if (it is _BannerItem) return _banner(it, suppressTop: isFirst);
    if (it is _LineItem) {
      // The table box already draws a top edge, so a separator is not drawn
      // for the first item on a page (that would double the line).
      return _rowOf(
        it.h,
        (col) => _lineCell(it, col),
        topBorder: it.topLine && !isFirst,
        topPad: it.topLine ? _kTopGap : 0,
      );
    }
    return _rowOf(_kSpacerH, (col) => null);
  }

  pw.Widget _rowOf(
    double h,
    pw.Widget? Function(int col) content, {
    bool topBorder = false,
    double topPad = 0,
  }) {
    return pw.Row(
      children: [
        for (var i = 0; i < 4; i++)
          pw.Container(
            width: _colW[i],
            height: h,
            padding: pw.EdgeInsets.fromLTRB(_kPadX, topPad, _kPadX, 0),
            alignment: pw.Alignment.centerLeft,
            decoration: pw.BoxDecoration(
              border: pw.Border(
                top: topBorder ? _bs : pw.BorderSide.none,
                left: _bs,
                right: i == 3 ? _bs : pw.BorderSide.none,
              ),
            ),
            child: content(i),
          ),
      ],
    );
  }

  pw.Widget? _lineCell(_LineItem l, int col) {
    switch (col) {
      case 0:
        return l.time.isEmpty
            ? null
            : pw.Text(l.time, style: _st(), softWrap: false);
      case 1:
        return _textCell(l.office);
      case 2:
        return _textCell(l.team);
      default:
        return _textCell(l.std);
    }
  }

  pw.Widget? _textCell(_CellLine? c) {
    if (c == null || c.text.isEmpty) return null;
    final text = pw.Text(c.text, style: _st(bold: c.bold), softWrap: false);
    if (c.bullet) {
      return pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Container(
            width: 3.2,
            height: 3.2,
            decoration: const pw.BoxDecoration(
              color: PdfColors.black,
              shape: pw.BoxShape.circle,
            ),
          ),
          pw.SizedBox(width: 5),
          text,
        ],
      );
    }
    if (c.indent) {
      return pw.Padding(
        padding: const pw.EdgeInsets.only(left: 8.2),
        child: text,
      );
    }
    return text;
  }

  pw.Widget _banner(_BannerItem b, {required bool suppressTop}) {
    return pw.Container(
      width: _contentW,
      height: _kBannerH,
      alignment: pw.Alignment.center,
      decoration: pw.BoxDecoration(
        border: pw.Border(
          top: suppressTop ? pw.BorderSide.none : _bs,
          bottom: _bs,
          left: _bs,
          right: _bs,
        ),
      ),
      child: pw.Text(
        b.text,
        style: _st(bold: true, size: 10.5),
        softWrap: false,
      ),
    );
  }

  double _computeSigHeight() {
    final sigs = data.signatories;
    final colW = _contentW / sigs.length;
    final innerW = colW - 18;
    var maxH = 0.0;
    for (final s in sigs) {
      final nameLines =
          s.name.trim().isEmpty ? 0 : _wrap(s.name.trim(), innerW, bold: true).length;
      final roleLines =
          s.role.trim().isEmpty ? 0 : _wrap(s.role.trim(), innerW).length;
      final h = _kLineH +
          _kSigSpace +
          math.max(1, nameLines) * _kLineH +
          roleLines * _kLineH +
          4 +
          _kLineH;
      maxH = math.max(maxH, h);
    }
    return maxH;
  }

  pw.Widget _signatureBlock() {
    final sigs = data.signatories;
    final colW = _contentW / sigs.length;
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        for (final s in sigs)
          pw.SizedBox(width: colW, child: _sigColumn(s, colW)),
      ],
    );
  }

  pw.Widget _sigColumn(_Sig s, double colW) {
    final innerW = colW - 18;
    final nameLines =
        s.name.trim().isEmpty ? <String>[] : _wrap(s.name.trim(), innerW, bold: true);
    final roleLines =
        s.role.trim().isEmpty ? <String>[] : _wrap(s.role.trim(), innerW);
    final dateText =
        s.date == null ? '' : DateFormat('M/d/yyyy').format(s.date!);

    return pw.Padding(
      padding: const pw.EdgeInsets.only(right: 18),
      child: pw.Column(
        mainAxisSize: pw.MainAxisSize.min,
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
          pw.SizedBox(
            height: _kLineH,
            child: pw.Text(_s(s.heading), style: _st()),
          ),
          pw.SizedBox(height: _kSigSpace),
          if (nameLines.isEmpty)
            pw.Container(
              height: _kLineH,
              decoration: pw.BoxDecoration(border: pw.Border(bottom: _bs)),
            )
          else
            for (final l in nameLines)
              pw.SizedBox(
                height: _kLineH,
                child: pw.Center(
                  child: pw.Text(
                    l,
                    style: _st(bold: true, underline: true),
                    softWrap: false,
                  ),
                ),
              ),
          for (final l in roleLines)
            pw.SizedBox(
              height: _kLineH,
              child: pw.Center(
                child: pw.Text(l, style: _st(), softWrap: false),
              ),
            ),
          pw.SizedBox(height: 4),
          pw.SizedBox(
            height: _kLineH,
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text('Date:', style: _st()),
                pw.SizedBox(width: 4),
                pw.Expanded(
                  child: pw.Container(
                    height: _kLineH - 2,
                    alignment: pw.Alignment.bottomCenter,
                    decoration:
                        pw.BoxDecoration(border: pw.Border(bottom: _bs)),
                    child: dateText.isEmpty
                        ? null
                        : pw.Text(dateText, style: _st()),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _footer(int idx, bool isLast) {
    return pw.SizedBox(
      height: _kFooterH,
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Expanded(child: pw.SizedBox()),
          pw.Expanded(
            child: pw.Center(
              child: pw.Text('${idx + 1}', style: _st(bold: true)),
            ),
          ),
          pw.Expanded(
            child: pw.Align(
              alignment: pw.Alignment.centerRight,
              child: isLast
                  ? pw.Text(_kFormCode, style: _st(bold: true, size: 8.5))
                  : pw.SizedBox(),
            ),
          ),
        ],
      ),
    );
  }
}