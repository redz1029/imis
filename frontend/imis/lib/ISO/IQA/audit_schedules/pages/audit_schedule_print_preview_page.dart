// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:imis/audit/audit_plan/models/audit_plan_entry.dart';
import 'package:imis/audit/audit_plan/services/AuditPlanService.dart';
import 'package:imis/audit/audit_programme/services/audit_programme_service.dart';
import 'package:imis/audit/audit_schedules/models/audit_schedules.dart';
import 'package:imis/audit/audit_schedules/services/audit_schedule_service.dart';
import 'package:imis/common_services/common_service.dart';
import 'package:imis/constant/constant.dart';

/// Opens the print preview for one Audit Plan's schedule.
/// Pass [officeName] to print a single office's schedule; leave it null to
/// print every office (one per page).
Future<void> openAuditSchedulePrintPreview(
  BuildContext context,
  int auditPlanId, {
  String? officeName,
}) {
  return Navigator.of(context).push<void>(
    MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (_) => AuditSchedulePrintPreviewPage(
        auditPlanId: auditPlanId,
        officeName: officeName,
      ),
    ),
  );
}

// =============================================================================
// Constants
// =============================================================================
const String _kLogoCrmc = 'assets/crmc_logo.png';
const String _kLogoIso = 'assets/iso_tuv_certified.jpg';

/// Form code printed at the bottom-right of the original form.
const String _kFormCode = 'QP-03-F-03 Rev. 1';

const String _kFixedPurposeText = 'Internal Quality Audit';
const String _kFixedActivityText =
    'Opening Activity\n'
    'Introduction of Auditors\n'
    'Audit Proper\n'
    '-Interview\n'
    '-Observation\n'
    '-Documented Information Review\n\n'
    'Closing Meeting\n'
    '-Audit findings';

const double _kML = 28, _kMR = 28, _kMT = 24, _kMB = 22;
const double _kBorderW = 0.8;
const double _kFont = 10.5;
const double _kSmall = 9.5;
const double _kLogoBox = 86.0;

const double _kHeaderRowMinH = 58.0;
const double _kPurposeMinH = 44.0;
const double _kDateMinH = 26.0;
const double _kSigH = 92.0;

// TIME | ACTIVITY | CRITERIA | PERSON RESPONSIBLE
const List<double> _kColFr = [0.13, 0.42, 0.21, 0.24];

// AUDITEE | office | AUDIT TEAM | members
const List<double> _kHdrFr = [0.131, 0.376, 0.152, 0.341];

// =============================================================================
// Data
// =============================================================================
class _Row {
  const _Row(this.time, this.criteria, this.persons);
  final DateTime time;
  final String criteria;
  final List<String> persons;
}

class _TeamBlock {
  const _TeamBlock(this.label, this.members);
  final String label;
  final List<String> members;
}

class _Sig {
  const _Sig(this.heading, this.name, this.role, this.date);
  final String heading;
  final String name;
  final String role;
  final DateTime? date;
}

class _OfficePage {
  _OfficePage({
    required this.office,
    required this.teams,
    required this.purpose,
    required this.activity,
    required this.auditDate,
    required this.rows,
    required this.signatories,
  });
  final String office;
  final List<_TeamBlock> teams;
  final String purpose;
  final String activity;
  final DateTime auditDate;
  final List<_Row> rows;
  final List<_Sig> signatories;
}

class _PdfAssets {
  const _PdfAssets({
    required this.regular,
    required this.bold,
    required this.italic,
    required this.boldItalic,
    required this.unicode,
    this.crmc,
    this.iso,
  });
  final pw.Font regular;
  final pw.Font bold;
  final pw.Font italic;
  final pw.Font boldItalic;
  final bool unicode;
  final pw.MemoryImage? crmc;
  final pw.MemoryImage? iso;
}

class _Group {
  _Group(this.office, this.entries);
  final String office;
  final List<AuditPlanEntry> entries;
}

DateTime _signedLocal(DateTime d) => d.isUtc
    ? d.toLocal()
    : DateTime.utc(d.year, d.month, d.day, d.hour, d.minute, d.second)
        .toLocal();

/// 10:00 A.M. / 1:30 P.M. (as printed on the original form)
String _fmtTime(DateTime t) {
  final h = t.hour % 12 == 0 ? 12 : t.hour % 12;
  final m = t.minute.toString().padLeft(2, '0');
  return '$h:$m ${t.hour < 12 ? 'A.M.' : 'P.M.'}';
}

List<_Group> _groupByOffice(List<AuditPlanEntry> entries) {
  final map = <String, _Group>{};
  final order = <String>[];
  for (final e in entries) {
    var office = 'Unspecified Office';
    final processes = e.auditPlanProcesses;
    if (processes != null && processes.isNotEmpty) {
      final n = processes.first.processName?.trim();
      if (n != null && n.isNotEmpty) office = n;
    }
    final key = office.toLowerCase();
    final existing = map[key];
    if (existing != null) {
      existing.entries.add(e);
    } else {
      map[key] = _Group(office, [e]);
      order.add(key);
    }
  }
  final list = order.map((k) => map[k]!).toList()
    ..sort((a, b) {
      final af = a.entries.first;
      final bf = b.entries.first;
      final d = af.dayNumber.compareTo(bf.dayNumber);
      return d != 0 ? d : af.time.compareTo(bf.time);
    });
  return list;
}

List<_Sig> _buildSignatories(AuditSchedules? schedule) {
  _Sig? prepared;
  _Sig? approved;

  for (final s in schedule?.signatories ?? const []) {
    final label = (s.signatoryLabel ?? '').toString().trim();
    final up = label.toUpperCase();
    final name = (s.signatoryName ?? '').toString().trim();
    final signed = s.dateSigned;
    final date = signed == null ? null : _signedLocal(signed);

    if (up.contains('PREPAR') || up.contains('LEAD') || up.contains('TEAM')) {
      prepared ??= _Sig('PREPARED BY:', name, 'Team Leader', date);
    } else {
      approved ??= _Sig(
        'REVIEWED AND APPROVED BY:',
        name,
        'Auditee/Head of Office',
        date,
      );
    }
  }

  return [
    prepared ?? const _Sig('PREPARED BY:', '', 'Team Leader', null),
    approved ??
        const _Sig(
          'REVIEWED AND APPROVED BY:',
          '',
          'Auditee/Head of Office',
          null,
        ),
  ];
}

Future<List<_OfficePage>> _loadPrintData(
  int auditPlanId,
  String? officeFilter,
) async {
  final planService = AuditPlanService(Dio());
  final programmeService = AuditProgrammeService(Dio());
  final scheduleService = AuditSchedulesService(Dio());

  final plans = await planService.getAllAuditPlans();
  final matchPlan = plans.where((p) => p.id == auditPlanId);
  if (matchPlan.isEmpty) throw Exception('Audit Plan not found');
  final plan = matchPlan.first;

  final programme =
      await programmeService.getAuditProgrammeById(plan.auditProgrammeId);
  if (programme == null) throw Exception('Parent Audit Programme not found');

  final json = programme.toJson();
  final plansJson =
      (json['auditPlan'] as List? ?? json['AuditPlans'] as List? ?? []);
  final planMatch = plansJson.cast<Map<String, dynamic>>().where(
        (p) => (p['id'] ?? p['Id']) == plan.id,
      );
  if (planMatch.isEmpty) {
    throw Exception('Audit Plan not found within its Programme');
  }
  final entriesJson = (planMatch.first['entries'] as List? ??
      planMatch.first['Entries'] as List? ??
      []);
  final entries = entriesJson
      .map((e) => AuditPlanEntry.fromJson(e as Map<String, dynamic>))
      .toList();

  // ISO clause lookup.
  final clauseById = <int, String>{};
  try {
    for (final s in await programmeService.getIsoStandards()) {
      final j = s.toJson();
      final rawId = j['id'] ?? j['Id'];
      final id = rawId is int ? rawId : int.tryParse('$rawId');
      if (id == null) continue;
      final clause =
          (j['clauseRef'] ?? j['ClauseRef'] ?? j['clause'] ?? j['Clause'] ?? '')
              .toString()
              .trim();
      clauseById[id] = clause;
    }
  } catch (e) {
    debugPrint('Schedule print: failed to load ISO standards: $e');
  }

  // Team names + rosters.
  final teamNames = <int, String>{};
  try {
    for (final t in await programmeService.getTeams()) {
      final j = t.toJson();
      final rawId = j['id'] ?? j['Id'];
      final id = rawId is int ? rawId : int.tryParse('$rawId');
      if (id == null) continue;
      teamNames[id] = (j['name'] ?? j['Name'] ?? '').toString().trim();
    }
  } catch (e) {
    debugPrint('Schedule print: failed to load teams: $e');
  }

  final rosters = <int, List<String>>{};
  try {
    final common = CommonService(Dio());
    final auditorTeams = await common.fetchAuditorTeam();
    final users = await common.fetchUsers();
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
    debugPrint('Schedule print: failed to load auditor teams: $e');
  }

  // Backing schedule rows (for signatories / purpose).
  List<AuditSchedules> schedules = const [];
  try {
    schedules = await scheduleService.getAuditSchedulesByPlanId(plan.id);
  } catch (e) {
    debugPrint('Schedule print: failed to load schedules: $e');
  }

  var groups = _groupByOffice(entries);
  if (officeFilter != null && officeFilter.trim().isNotEmpty) {
    final f = officeFilter.trim().toLowerCase();
    groups = groups.where((g) => g.office.trim().toLowerCase() == f).toList();
  }
  if (groups.isEmpty) throw Exception('No schedule entries to print.');

  String criteriaFor(AuditPlanEntry e) {
    final items = e.isoStandardAuditPlans ?? const [];
    final clauses = <String>[];
    for (final item in items) {
      final nested = item.isoStandard?.clauseRef;
      if (nested != null && nested.isNotEmpty) {
        clauses.add(nested);
        continue;
      }
      final resolved = clauseById[item.isoStandardId];
      if (resolved != null && resolved.isNotEmpty) clauses.add(resolved);
    }
    final unique = clauses.toSet().toList()..sort(_compareClause);
    return unique.join(', ');
  }

  List<String> personsFor(AuditPlanEntry e) {
    final auditors = e.isoAuditors ?? const [];
    if (auditors.isEmpty) return const [];
    final teamId = auditors.first.teamId;
    // ignore: unnecessary_null_comparison
    if (teamId == null) return const [];
    final roster = rosters[teamId];
    if (roster != null && roster.isNotEmpty) return roster;
    return [teamNames[teamId] ?? 'Team $teamId'];
  }

  final pages = <_OfficePage>[];
  for (final g in groups) {
    // Teams header block.
    final byTeam = <int, List<String>>{};
    for (final e in g.entries) {
      for (final a in (e.isoAuditors ?? const [])) {
        final id = a.teamId;
        if (id == null) continue;
        final members = byTeam.putIfAbsent(id, () => <String>[]);
        for (final n in (rosters[id] ?? const <String>[])) {
          if (!members.contains(n)) members.add(n);
        }
      }
    }
    final teamIds = byTeam.keys.toList()..sort();
    final teams = [
      for (final id in teamIds)
        _TeamBlock(teamNames[id] ?? 'Team $id', byTeam[id]!),
    ];

    final sortedEntries = List<AuditPlanEntry>.from(g.entries)
      ..sort((a, b) => a.time.compareTo(b.time));

    final first = sortedEntries.first;
    final start = plan.startDate;
    final auditDate = DateTime(start.year, start.month, start.day)
        .add(Duration(days: first.dayNumber - 1));

    // Match this office's backing schedule.
    AuditSchedules? sched;
    for (final s in schedules) {
      final nameMatch = s.officeName != null &&
          s.officeName!.trim().toLowerCase() == g.office.trim().toLowerCase();
      final entryMatch =
          g.entries.any((e) => e.id != 0 && s.auditPlanEntryId == e.id);
      if (nameMatch || entryMatch) {
        sched = s;
        break;
      }
    }

    pages.add(_OfficePage(
      office: g.office,
      teams: teams,
      purpose: (sched?.purpose.trim().isNotEmpty ?? false)
          ? sched!.purpose.trim()
          : _kFixedPurposeText,
      activity: _activityOf(sched),
      auditDate: auditDate,
      rows: [
        for (final e in sortedEntries)
          _Row(e.time, criteriaFor(e), personsFor(e)),
      ],
      signatories: _buildSignatories(sched),
    ));
  }
  return pages;
}

/// The activity text saved on the office's schedule (editable on the
/// Audit Schedule page); falls back to the standard boilerplate.
String _activityOf(AuditSchedules? s) {
  final json = s?.toJson();
  if (json != null) {
    for (final e in json.entries) {
      if (e.key.toLowerCase() == 'activity') {
        final v = e.value?.toString().trim() ?? '';
        if (v.isNotEmpty) return e.value.toString();
      }
    }
  }
  return _kFixedActivityText;
}

int _compareClause(String a, String b) {
  final ap = a.split('.');
  final bp = b.split('.');
  final n = ap.length < bp.length ? ap.length : bp.length;
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

Future<_PdfAssets> _loadAssets() async {
  pw.Font regular;
  pw.Font bold;
  pw.Font italic;
  pw.Font boldItalic;
  var unicode = true;
  try {
    const t = Duration(seconds: 10);
    regular = await PdfGoogleFonts.tinosRegular().timeout(t);
    bold = await PdfGoogleFonts.tinosBold().timeout(t);
    italic = await PdfGoogleFonts.tinosItalic().timeout(t);
    boldItalic = await PdfGoogleFonts.tinosBoldItalic().timeout(t);
  } catch (_) {
    regular = pw.Font.times();
    bold = pw.Font.timesBold();
    italic = pw.Font.timesItalic();
    boldItalic = pw.Font.timesBoldItalic();
    unicode = false;
  }

  Future<pw.MemoryImage?> logo(String path) async {
    try {
      final data = await rootBundle.load(path);
      return pw.MemoryImage(data.buffer.asUint8List());
    } catch (e) {
      debugPrint('Schedule print: cannot load asset "$path": $e');
      return null;
    }
  }

  return _PdfAssets(
    regular: regular,
    bold: bold,
    italic: italic,
    boldItalic: boldItalic,
    unicode: unicode,
    crmc: await logo(_kLogoCrmc),
    iso: await logo(_kLogoIso),
  );
}

// =============================================================================
// Preview page
// =============================================================================
class AuditSchedulePrintPreviewPage extends StatefulWidget {
  const AuditSchedulePrintPreviewPage({
    super.key,
    required this.auditPlanId,
    this.officeName,
  });

  final int auditPlanId;
  final String? officeName;

  @override
  State<AuditSchedulePrintPreviewPage> createState() =>
      _AuditSchedulePrintPreviewPageState();
}

class _AuditSchedulePrintPreviewPageState
    extends State<AuditSchedulePrintPreviewPage> {
  List<_OfficePage>? _pages;
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
        _loadPrintData(widget.auditPlanId, widget.officeName),
        _loadAssets(),
      ]);
      _pages = results[0] as List<_OfficePage>;
      _assets = results[1] as _PdfAssets;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<Uint8List> _buildPdf(PdfPageFormat format) {
    return _SchedulePdfBuilder(
      pages: _pages!,
      assets: _assets!,
      format: format,
    ).build();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audit Schedule — Print Preview'),
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
                  pdfFileName: 'Audit_Schedule_${widget.auditPlanId}.pdf',
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
class _SchedulePdfBuilder {
  _SchedulePdfBuilder({
    required this.pages,
    required this.assets,
    required this.format,
  });

  final List<_OfficePage> pages;
  final _PdfAssets assets;
  final PdfPageFormat format;

  late final double _contentW = format.width - _kML - _kMR;

  late final List<double> _colW = () {
    final w = <double>[for (final f in _kColFr) (_contentW * f).floorToDouble()];
    w[3] = _contentW - w[0] - w[1] - w[2];
    return w;
  }();

  late final List<double> _hdrW = () {
    final w = <double>[for (final f in _kHdrFr) (_contentW * f).floorToDouble()];
    w[3] = _contentW - w[0] - w[1] - w[2];
    return w;
  }();

  pw.BorderSide get _bs => const pw.BorderSide(width: _kBorderW);
  pw.BorderSide get _none => pw.BorderSide.none;

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

  pw.TextStyle _st({
    bool bold = false,
    bool italic = false,
    double size = _kFont,
  }) {
    final pw.Font font = bold && italic
        ? assets.boldItalic
        : bold
            ? assets.bold
            : italic
                ? assets.italic
                : assets.regular;
    return pw.TextStyle(font: font, fontSize: size, color: PdfColors.black);
  }

  pw.Widget _t(
    String text, {
    bool bold = false,
    bool italic = false,
    double size = _kFont,
    pw.TextAlign? align,
  }) {
    return pw.Text(
      _s(text),
      style: _st(bold: bold, italic: italic, size: size),
      textAlign: align,
    );
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
            child: pw.ClipRect(child: pw.Image(crmc, fit: pw.BoxFit.cover)),
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

    return pw.SizedBox(
      height: _kLogoBox,
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Expanded(
            child: pw.Align(alignment: pw.Alignment.centerRight, child: seal),
          ),
          pw.SizedBox(width: 12),
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
          pw.SizedBox(width: 12),
          pw.Expanded(
            child: pw.Align(alignment: pw.Alignment.centerRight, child: tuv),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------- header block ---
  pw.Widget _headerBlock(_OfficePage p) {
    final members = <String>[];
    for (final t in p.teams) {
      for (final m in t.members) {
        if (!members.contains(m)) members.add(m);
      }
    }
    final w = _hdrW;
    final halfW = ((w[3] - 12) / 2).floorToDouble();

    pw.Widget cell(pw.Widget child, {pw.EdgeInsets? pad}) => pw.Container(
          constraints: const pw.BoxConstraints(minHeight: _kHeaderRowMinH),
          padding: pad ?? const pw.EdgeInsets.fromLTRB(5, 4, 5, 4),
          child: child,
        );

    final row1 = pw.Table(
      columnWidths: {
        for (var i = 0; i < 4; i++) i: pw.FixedColumnWidth(w[i]),
      },
      border: pw.TableBorder(
        left: _bs,
        top: _bs,
        right: _bs,
        bottom: _bs,
        horizontalInside: _none,
        verticalInside: _bs,
      ),
      defaultVerticalAlignment: pw.TableCellVerticalAlignment.top,
      children: [
        pw.TableRow(
          children: [
            // AUDITEE
            cell(_t('AUDITEE', bold: true, italic: true, size: _kSmall)),
            // Office name
            cell(
              _t(p.office),
              pad: const pw.EdgeInsets.fromLTRB(8, 10, 5, 4),
            ),
            // AUDIT TEAM + team label(s)
            cell(
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _t('AUDIT TEAM', bold: true, italic: true, size: _kSmall),
                  pw.SizedBox(height: 8),
                  pw.SizedBox(
                    width: w[2] - 10,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        for (final t in p.teams)
                          _t(t.label, align: pw.TextAlign.center),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Members, two per line
            cell(
              pw.Wrap(
                runSpacing: 1,
                children: [
                  for (final m in members)
                    pw.SizedBox(width: halfW, child: _t(m, size: _kSmall)),
                ],
              ),
              pad: const pw.EdgeInsets.fromLTRB(6, 4, 6, 4),
            ),
          ],
        ),
      ],
    );

    pw.Widget labelled(
      String label,
      String value, {
      required double minH,
    }) {
      return pw.Container(
        width: _contentW,
        constraints: pw.BoxConstraints(minHeight: minH),
        padding: const pw.EdgeInsets.fromLTRB(5, 5, 5, 5),
        decoration: pw.BoxDecoration(
          border: pw.Border(
            top: _none,
            left: _bs,
            right: _bs,
            bottom: _bs,
          ),
        ),
        child: pw.RichText(
          text: pw.TextSpan(
            children: [
              pw.TextSpan(
                text: _s('$label '),
                style: _st(bold: true, size: _kSmall),
              ),
              pw.TextSpan(text: _s(value), style: _st()),
            ],
          ),
        ),
      );
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        row1,
        labelled('Purpose:', p.purpose, minH: _kPurposeMinH),
        labelled(
          'Audit Date:',
          DateFormat('MMMM d, yyyy').format(p.auditDate),
          minH: _kDateMinH,
        ),
      ],
    );
  }

  // ----------------------------------------------------------------- table ---
  pw.Widget _cell(pw.Widget child) {
    return pw.Container(
      alignment: pw.Alignment.topLeft,
      padding: const pw.EdgeInsets.fromLTRB(6, 6, 6, 8),
      child: child,
    );
  }

  /// [fill] = true: no bottom border, so the last row visually continues into
  /// the filler that stretches down to the signature box (as on the original).
  pw.Widget _scheduleTable(_OfficePage p, {required bool fill}) {
    pw.Widget head(String text) => pw.Container(
          alignment: pw.Alignment.center,
          padding: const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 4),
          child: _t(
            text,
            bold: true,
            italic: true,
            size: 10,
            align: pw.TextAlign.center,
          ),
        );

    return pw.Table(
      columnWidths: {
        for (var i = 0; i < 4; i++) i: pw.FixedColumnWidth(_colW[i]),
      },
      border: pw.TableBorder(
        left: _bs,
        top: _none,
        right: _bs,
        bottom: fill ? _none : _bs,
        horizontalInside: _bs,
        verticalInside: _bs,
      ),
      defaultVerticalAlignment: pw.TableCellVerticalAlignment.top,
      children: [
        pw.TableRow(
          repeat: true,
          children: [
            head('TIME'),
            head('ACTIVITY'),
            head('CRITERIA'),
            head('PERSON RESPONSIBLE'),
          ],
        ),
        for (final r in p.rows)
          pw.TableRow(
            children: [
              _cell(_t(_fmtTime(r.time))),
              _cell(_t(p.activity)),
              _cell(_t(r.criteria)),
              _cell(
                r.persons.isEmpty
                    ? _t('')
                    : pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          for (final name in r.persons) _t(name),
                        ],
                      ),
              ),
            ],
          ),
      ],
    );
  }

  /// Empty body area that continues the column lines down to the signatures.
  pw.Widget _filler() {
    return pw.Row(
      children: [
        for (var i = 0; i < 4; i++)
          pw.Container(
            width: _colW[i],
            decoration: pw.BoxDecoration(
              border: pw.Border(
                top: _none,
                bottom: _none,
                left: i == 0 ? _bs : _none,
                right: _bs,
              ),
            ),
          ),
      ],
    );
  }

  // ------------------------------------------------------------ signatures ---
  pw.Widget _sigColumn(_Sig s, double colW, {required bool longDate}) {
    String dateText = '';
    if (s.date != null) {
      dateText = longDate
          ? DateFormat('MMMM d, yyyy').format(s.date!).toUpperCase()
          : DateFormat('M/d/yyyy').format(s.date!);
    }
    return pw.Padding(
      padding: const pw.EdgeInsets.fromLTRB(5, 4, 5, 4),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          _t(s.heading, size: 9),
          pw.SizedBox(height: 16),
          pw.Padding(
            padding: const pw.EdgeInsets.only(left: 13),
            child: s.name.trim().isEmpty
                ? pw.SizedBox(height: 13)
                : _t(s.name.trim().toUpperCase(), size: 11),
          ),
          pw.Container(
            margin: const pw.EdgeInsets.only(left: 13),
            width: colW - 60,
            height: 1,
            decoration: pw.BoxDecoration(border: pw.Border(bottom: _bs)),
          ),
          pw.SizedBox(height: 1),
          if (s.role.trim().isNotEmpty)
            _t(s.role.trim(), italic: true, size: 8.5),
          pw.SizedBox(height: 4),
          pw.Row(
            mainAxisSize: pw.MainAxisSize.min,
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              _t('Date:', size: 8.5),
              pw.SizedBox(width: 8),
              _t(dateText, size: 11),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _signatureBlock(_OfficePage p) {
    final colW = (_contentW / 2).floorToDouble();
    final sigs = p.signatories;
    return pw.Container(
      width: _contentW,
      height: _kSigH,
      decoration: pw.BoxDecoration(
        border: pw.Border(top: _bs, left: _bs, right: _bs, bottom: _bs),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            width: colW,
            height: _kSigH,
            decoration: pw.BoxDecoration(
              border: pw.Border(
                top: _none,
                bottom: _none,
                left: _none,
                right: _bs,
              ),
            ),
            child: _sigColumn(sigs[0], colW, longDate: true),
          ),
          pw.SizedBox(
            width: _contentW - colW - 2 * _kBorderW,
            child: sigs.length > 1
                ? _sigColumn(sigs[1], colW, longDate: false)
                : null,
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------- form code ---
  pw.Widget _formCode() {
    return pw.Container(
      width: _contentW,
      alignment: pw.Alignment.centerRight,
      padding: const pw.EdgeInsets.only(top: 6),
      child: _t(_kFormCode, bold: true, size: 8),
    );
  }

  pw.Widget _footer(pw.Context ctx) {
    final isLast = ctx.pageNumber == ctx.pagesCount;
    return isLast ? _formCode() : pw.SizedBox();
  }

  // ------------------------------------------------------------------ body ---
  pw.Widget _title() => pw.Center(
        child: _t('AUDIT SCHEDULE', bold: true, size: 11.5),
      );

  /// True when this office fits on one page with the table stretched down to
  /// the signature box (the normal case: one or two schedule rows).
  bool _fitsOnePage(_OfficePage p) {
    final members = <String>{};
    for (final t in p.teams) {
      members.addAll(t.members);
    }
    if (members.length > 16) return false;
    if (p.rows.length > 2) return false;
    for (final r in p.rows) {
      if (r.persons.length > 10) return false;
      if (r.criteria.length > 260) return false;
    }
    return true;
  }

  /// Single page laid out like the original form: the table runs from the
  /// header block all the way down to the signature box.
  pw.Widget _fillPage(_OfficePage p) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _letterhead(),
        pw.SizedBox(height: 14),
        _title(),
        pw.SizedBox(height: 10),
        _headerBlock(p),
        _scheduleTable(p, fill: true),
        pw.Expanded(child: _filler()),
        _signatureBlock(p),
        _formCode(),
      ],
    );
  }

  /// Fallback for unusually long schedules: flows across pages normally.
  List<pw.Widget> _flowBody(_OfficePage p) {
    return [
      _letterhead(),
      pw.SizedBox(height: 14),
      _title(),
      pw.SizedBox(height: 10),
      _headerBlock(p),
      _scheduleTable(p, fill: false),
      pw.SizedBox(height: 14),
      _signatureBlock(p),
    ];
  }

  Future<Uint8List> build() async {
    final doc = pw.Document(
      title: 'Audit Schedule',
      author: 'Cotabato Regional and Medical Center',
    );

    final theme = pw.ThemeData.withFont(
      base: assets.regular,
      bold: assets.bold,
      italic: assets.italic,
      boldItalic: assets.boldItalic,
    );
    const margin = pw.EdgeInsets.fromLTRB(_kML, _kMT, _kMR, _kMB);

    for (final p in pages) {
      if (_fitsOnePage(p)) {
        doc.addPage(
          pw.Page(
            pageFormat: format,
            margin: margin,
            theme: theme,
            build: (pw.Context ctx) => _fillPage(p),
          ),
        );
      } else {
        doc.addPage(
          pw.MultiPage(
            pageFormat: format,
            margin: margin,
            theme: theme,
            maxPages: 50,
            footer: _footer,
            build: (pw.Context ctx) => _flowBody(p),
          ),
        );
      }
    }
    return doc.save();
  }
}