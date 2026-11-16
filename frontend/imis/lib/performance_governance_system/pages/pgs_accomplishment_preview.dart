import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:universal_html/html.dart' as html;

const String _logoAssetUrl = 'assets/assets/CRMC.png';

const List<String> _monthOrder = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

class PgsMonthAccomplishment {
  final int id;
  final String status;
  final double percentAccomplished;
  final String postingMonth;
  final String remarks;
  final String auditorRemarks;

  PgsMonthAccomplishment({
    required this.id,
    required this.status,
    required this.percentAccomplished,
    required this.postingMonth,
    this.remarks = '',
    this.auditorRemarks = '',
  });

  factory PgsMonthAccomplishment.fromJson(Map<String, dynamic> j) =>
      PgsMonthAccomplishment(
        id: (j['id'] as num?)?.toInt() ?? 0,
        status: (j['status'] ?? '').toString(),
        percentAccomplished:
            (j['percentAccomplished'] as num?)?.toDouble() ?? 0,
        postingMonth: (j['postingMonth'] ?? '').toString(),
        remarks: (j['remarks'] ?? '').toString(),
        auditorRemarks: (j['auditorRemarks'] ?? '').toString(),
      );
}

class PgsDeliverableItem {
  final int id;
  final String name;
  final List<PgsMonthAccomplishment> accomplishments;

  PgsDeliverableItem({
    required this.id,
    required this.name,
    required this.accomplishments,
  });

  factory PgsDeliverableItem.fromJson(Map<String, dynamic> j) =>
      PgsDeliverableItem(
        id: (j['pgsDeliverableId'] as num?)?.toInt() ?? 0,
        name: (j['deliverableName'] ?? '').toString(),
        accomplishments:
            ((j['accomplishments'] as List?) ?? [])
                .map(
                  (e) => PgsMonthAccomplishment.fromJson(
                    Map<String, dynamic>.from(e),
                  ),
                )
                .toList(),
      );

  List<PgsMonthAccomplishment> progressMonths({bool includeZero = false}) {
    final list =
        accomplishments
            .where((a) => includeZero || a.percentAccomplished > 0)
            .toList();
    list.sort(
      (a, b) =>
          _monthIndex(a.postingMonth).compareTo(_monthIndex(b.postingMonth)),
    );
    return list;
  }
}

class PgsOfficeReport {
  final String periodName;
  final String officeName;
  final List<PgsDeliverableItem> deliverables;

  PgsOfficeReport({
    required this.periodName,
    required this.officeName,
    required this.deliverables,
  });

  factory PgsOfficeReport.fromJson(Map<String, dynamic> j) => PgsOfficeReport(
    periodName: (j['periodName'] ?? '').toString(),
    officeName: (j['officeName'] ?? '').toString(),
    deliverables:
        ((j['pgsDeliverableAccomplishmenItem'] as List?) ?? [])
            .map(
              (e) => PgsDeliverableItem.fromJson(Map<String, dynamic>.from(e)),
            )
            .toList(),
  );
}

int _monthIndex(String m) {
  final i = _monthOrder.indexWhere(
    (x) => x.toLowerCase() == m.trim().toLowerCase(),
  );
  return i < 0 ? 999 : i;
}

Future<void> openPgsAccomplishmentPreviewTab(
  PgsOfficeReport report, {
  String roadmapName = '',
  String periodLabel = '',
  bool showEmptyDeliverables = true,
  bool includeZeroMonths = false,
}) async {
  final logo = Uri.base.resolve(_logoAssetUrl).toString();
  final blob = html.Blob([
    buildPgsAccomplishmentPreviewDocument(
      logo,
      report,
      roadmapName: roadmapName,
      periodLabel: periodLabel.isEmpty ? report.periodName : periodLabel,
      showEmptyDeliverables: showEmptyDeliverables,
      includeZeroMonths: includeZeroMonths,
    ),
  ], 'text/html');
  final url = html.Url.createObjectUrlFromBlob(blob);
  html.window.open(url, '_blank');
  Future.delayed(
    const Duration(minutes: 5),
    () => html.Url.revokeObjectUrl(url),
  );
}

String _esc(String s) => s
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;');

List<String> _periodMonths(String periodLabel, List<PgsDeliverableItem> items) {
  final lower = periodLabel.toLowerCase();
  final found = <MapEntry<int, int>>[];
  for (var i = 0; i < _monthOrder.length; i++) {
    final pos = lower.indexOf(_monthOrder[i].toLowerCase());
    if (pos >= 0) found.add(MapEntry(pos, i));
  }
  found.sort((a, b) => a.key.compareTo(b.key));

  if (found.isNotEmpty) {
    final start = found.first.value;
    final end = found.last.value;
    final out = <String>[];
    var i = start;
    while (true) {
      out.add(_monthOrder[i]);
      if (i == end) break;
      i = (i + 1) % 12;
    }
    return out;
  }

  final idx = <int>{};
  for (final d in items) {
    for (final a in d.accomplishments) {
      final i = _monthIndex(a.postingMonth);
      if (i < 999) idx.add(i);
    }
  }
  if (idx.isEmpty) return [];
  final sorted = idx.toList()..sort();
  return [for (var i = sorted.first; i <= sorted.last; i++) _monthOrder[i]];
}

String _percentCell(num? pct) {
  final value = (pct ?? 0).clamp(0, 100).toDouble();
  final label =
      value % 1 == 0 ? '${value.toInt()}%' : '${value.toStringAsFixed(1)}%';
  final color = value >= 100 ? '#16a34a' : (value > 0 ? '#f59e0b' : '#dc2626');
  final barWidth = value == 0 ? 100 : value;
  return '<div class="pct" style="color:$color">$label</div>'
      '<div class="bar-bg"><div class="bar-fg" style="width:$barWidth%;background:$color"></div></div>';
}

String _statusLabel(String s) {
  switch (s) {
    case 'completed':
      return 'Completed';
    case 'onGoing':
      return 'On Going';
    case 'notStarted':
      return 'Not Started';
    default:
      return s.isEmpty ? '—' : s;
  }
}

String _statusColor(String s) {
  switch (s) {
    case 'completed':
      return '#16a34a';
    case 'onGoing':
      return '#b45309';
    default:
      return '#dc2626';
  }
}

String _statusCell(String s) =>
    '<span class="badge" style="color:${_statusColor(s)};border-color:${_statusColor(s)}">'
    '${_esc(_statusLabel(s))}</span>';

String _progressStatusCell(num? pct, String status) =>
    '${_percentCell(pct)}${_statusCell(status)}';

String _remarksCell(String s) {
  final t = s.replaceAll('\r', '').trim();
  if (t.isEmpty) return '<span class="none">—</span>';
  return _esc(t);
}

String _buildSummary(List<PgsDeliverableItem> items, bool includeZero) {
  var withProgress = 0;
  var notStarted = 0;
  var onGoing = 0;
  var completed = 0;

  for (final d in items) {
    final months = d.progressMonths(includeZero: false);
    if (months.isEmpty) {
      notStarted++;
      continue;
    }
    withProgress++;
    final latest = months.last.percentAccomplished;
    if (latest >= 100) {
      completed++;
    } else {
      onGoing++;
    }
  }

  final total = items.length;
  String pct(int n) {
    if (total == 0) return '0%';
    final p = n / total * 100;
    return p % 1 == 0 ? '${p.toInt()}%' : '${p.toStringAsFixed(1)}%';
  }

  String statItem(String label, int count, String color, String textColor) =>
      '<div class="stat-item" style="border-color:$color">'
      '<span class="stat-label"><i class="dot" style="background:$color"></i>$label</span>'
      '<span class="stat-val" style="color:$textColor">$count'
      '<span class="stat-pct"> (${pct(count)})</span></span></div>';

  return '<div class="summary">'
      '<div class="sum-item"><span class="sum-label">Total Deliverables</span>'
      '<span class="sum-val">$total</span></div>'
      '<div class="sum-item"><span class="sum-label">With Progress</span>'
      '<span class="sum-val">$withProgress</span></div>'
      '</div>'
      '<div class="stats">'
      '${statItem('No Progress', notStarted, '#dc2626', '#dc2626')}'
      '${statItem('On Going', onGoing, '#f59e0b', '#b45309')}'
      '${statItem('Completed', completed, '#16a34a', '#16a34a')}'
      '</div>';
}

String _monthRow(
  String month,
  num? pct,
  String status,
  String remarks,
  String auditorRemarks,
) =>
    '<tr class="mrow"><td class="mcell">${_esc(month)}</td>'
    '<td class="pcell">${_progressStatusCell(pct, status)}</td>'
    '<td class="rcell">${_remarksCell(remarks)}</td>'
    '<td class="rcell">${_remarksCell(auditorRemarks)}</td></tr>';

String _buildRows(
  List<PgsDeliverableItem> items, {
  required bool showEmpty,
  required bool includeZero,
  List<String> periodMonths = const [],
}) {
  final b = StringBuffer();
  var shown = 0;

  for (final d in items) {
    final months = d.progressMonths(includeZero: includeZero);
    if (months.isEmpty && !showEmpty) continue;
    shown++;

    b.write(
      '<tr class="deliv"><td colspan="4">${_esc(d.name.replaceAll('\r', '').trim())}</td></tr>',
    );

    if (periodMonths.isNotEmpty) {
      for (final pm in periodMonths) {
        final rec =
            d.accomplishments
                .where(
                  (a) =>
                      a.postingMonth.trim().toLowerCase() == pm.toLowerCase(),
                )
                .firstOrNull;
        final pct = rec?.percentAccomplished ?? 0;
        final status =
            (rec == null || (pct == 0 && rec.status.isEmpty))
                ? 'notStarted'
                : rec.status;

        b.write(
          _monthRow(
            pm,
            pct,
            status,
            rec?.remarks ?? '',
            rec?.auditorRemarks ?? '',
          ),
        );
      }
      continue;
    }

    if (months.isEmpty) {
      b.write('<tr><td colspan="4" class="empty">No progress posted</td></tr>');
      continue;
    }

    for (final m in months) {
      b.write(
        _monthRow(
          m.postingMonth,
          m.percentAccomplished,
          m.status,
          m.remarks,
          m.auditorRemarks,
        ),
      );
    }
  }

  if (shown == 0) {
    return '<tr><td colspan="4" class="empty">No deliverables found.</td></tr>';
  }
  return b.toString();
}

String buildPgsAccomplishmentPreviewDocument(
  String logoUrl,
  PgsOfficeReport report, {
  String roadmapName = '',
  String periodLabel = '',
  bool showEmptyDeliverables = true,
  bool includeZeroMonths = false,
}) {
  final visible =
      showEmptyDeliverables
          ? report.deliverables
          : report.deliverables
              .where(
                (d) =>
                    d.progressMonths(includeZero: includeZeroMonths).isNotEmpty,
              )
              .toList();

  final months = _periodMonths(
    periodLabel.isNotEmpty ? periodLabel : report.periodName,
    visible,
  );

  return '''<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Print Preview - Monthly Accomplishment Report</title>
<style id="pg">@page { size: 210mm 297mm; margin: 0; }</style>
<style>
  :root { --w: 210mm; --h: 297mm; }
  html { background: #9aa0a6; }
  body { margin: 0; }

  .bar {
    position: sticky; top: 0; z-index: 10;
    display: flex; align-items: center; gap: 8px; flex-wrap: wrap;
    padding: 8px 16px; background: #323639; color: #fff;
    font: 14px Arial, sans-serif;
  }
  .bar .sp { flex: 1; }
  .bar select {
    border: 0; border-radius: 4px; padding: 6px 8px;
    font: 13px Arial, sans-serif; background: #5f6368; color: #fff;
  }
  .bar button {
    border: 0; border-radius: 4px; padding: 7px 14px; cursor: pointer;
    font: 13px Arial, sans-serif; background: #8c3a55; color: #fff;
  }
  .bar button.alt { background: #5f6368; }
  .bar button:disabled { opacity: .6; cursor: wait; }

  .wrap { padding: 24px 0; transform-origin: top center; }

  .pg {
    box-sizing: border-box; position: relative; overflow: hidden;
    width: var(--w); height: calc(var(--h) - 1mm);
    margin: 0 auto 16px; padding: 20mm 20mm 0 20mm; background: #fff;
    box-shadow: 0 2px 10px rgba(0,0,0,.4);
    font-family: "Times New Roman", Times, serif;
    font-size: 12pt; line-height: 1.3; color: #000;
    overflow-wrap: anywhere; word-break: break-word;
  }
  .pg .body { height: calc(var(--h) - 41mm); overflow: hidden; }
  .pg .num {
    position: absolute; left: 0; right: 0; bottom: 9mm;
    text-align: center; font: 9pt Arial, sans-serif; color: #555;
  }

  .hdr {
    display: grid; grid-template-columns: 1fr auto 1fr;
    align-items: center; min-height: 100px;
  }
  .hdr .logo-cell { display: flex; justify-content: flex-end; padding-right: 4px; }
  .hdr .logo-box { width: 100px; height: 100px; overflow: hidden; position: relative; }
  .hdr .logo-box img {
    position: absolute; top: 50%; left: 50%;
    width: 255px; max-width: none; height: auto;
    transform: translate(-50%, -50%);
  }
  .hdr .txt { text-align: center; line-height: 1.25; padding: 0 12px; }
  .hdr .txt .l1 { font-size: 11pt; }
  .hdr .txt .l2 { font-size: 13pt; text-transform: uppercase; }
  .hdr .txt .l3 { font-size: 10.5pt; }

  .title { text-align: center; font-weight: bold; font-size: 15pt; margin: 28pt 0 0 0; }
  .office-name { text-align: center; font-weight: bold; font-size: 12pt; margin-top: 4pt; text-transform: uppercase; }
  .sub { text-align: center; font-size: 11pt; margin-top: 4pt; }

  .summary { display: flex; gap: 12px; margin-top: 14pt; }
  .sum-item {
    flex: 1; border: 1px solid #964459; border-radius: 4px;
    padding: 6px 10px; display: flex; justify-content: space-between;
    align-items: center; background: #F2D5D9;
    -webkit-print-color-adjust: exact; print-color-adjust: exact;
  }
  .sum-label { font-size: 10.5pt; color: #964459; font-weight: bold; }
  .sum-val { font-size: 13pt; font-weight: bold; color: #964459; }

  .stats { display: flex; gap: 12px; margin-top: 8pt; }
  .stat-item {
    flex: 1; border: 1px solid #000; border-left-width: 4px; border-radius: 4px;
    padding: 5px 10px; display: flex; justify-content: space-between;
    align-items: center; background: #fff;
    -webkit-print-color-adjust: exact; print-color-adjust: exact;
  }
  .stat-label { font-size: 10.5pt; font-weight: bold; color: #333; display: flex; align-items: center; }
  .stat-val { font-size: 13pt; font-weight: bold; }
  .stat-pct { font-size: 10pt; font-weight: normal; }
  .dot {
    display: inline-block; width: 8px; height: 8px; border-radius: 50%; margin-right: 6px;
    -webkit-print-color-adjust: exact; print-color-adjust: exact;
  }

  table.data { width: 100%; border-collapse: collapse; margin-top: 12pt; font-size: 10.5pt; table-layout: fixed; }
  table.data th {
    background: #964459; color: #fff; padding: 6px 8px;
    border: 1px solid #964459; text-align: left; font-size: 10pt;
    -webkit-print-color-adjust: exact; print-color-adjust: exact;
  }
  table.data th.m { width: 14%; }
  table.data th.c { text-align: center; width: 22%; }
  table.data th.r { width: 32%; }
  table.data td { border: 1px solid #964459; padding: 5px 8px; vertical-align: middle; }
  tr.deliv td {
    background: #F2D5D9; color: #964459; font-weight: bold; font-size: 10.5pt;
    white-space: pre-line;
    -webkit-print-color-adjust: exact; print-color-adjust: exact;
  }
  td.mcell { font-weight: bold; }
  td.pcell { text-align: center; }
  td.pcell .badge { margin-top: 5px; }
  td.rcell {
    font-size: 9pt; line-height: 1.3; vertical-align: top;
    white-space: pre-line; text-align: left;
  }
  td.rcell .none { color: #9ca3af; }
  .badge {
    display: inline-block; border: 1px solid; border-radius: 10px;
    padding: 1px 10px; font: bold 9pt Arial, sans-serif;
    -webkit-print-color-adjust: exact; print-color-adjust: exact;
  }
  .pct { font-weight: bold; font-size: 10.5pt; }
  .bar-bg {
    height: 6px; background: #e5e7eb; border-radius: 3px; margin-top: 3px;
    -webkit-print-color-adjust: exact; print-color-adjust: exact;
  }
  .bar-fg {
    height: 6px; border-radius: 3px;
    -webkit-print-color-adjust: exact; print-color-adjust: exact;
  }
  td.empty { text-align: center; font-style: italic; color: #6B7280; padding: 8px; }

  @media print {
    html { background: #fff; }
    .bar { display: none; }
    .wrap { padding: 0; zoom: 1 !important; }
    .pg {
      margin: 0; box-shadow: none;
      break-after: page; page-break-after: always;
    }
    .pg:last-child { break-after: auto; page-break-after: auto; }
  }
</style>
<script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
</head>
<body>
  <div class="bar">
    <span>Print Preview</span>
    <select id="size" onchange="applySize()">
      <option value="210,297">A4</option>
      <option value="297,420">A3</option>
      <option value="148,210">A5</option>
      <option value="215.9,279.4">Letter</option>
      <option value="215.9,355.6">Legal</option>
      <option value="215.9,330.2">Long (8.5 x 13)</option>
    </select>
    <select id="orient" onchange="applySize()">
      <option value="p">Portrait</option>
      <option value="l">Landscape</option>
    </select>
    <span class="sp"></span>
    <button id="btnPdf" onclick="downloadPdf()">Download PDF</button>
    <button onclick="window.print()">Print</button>
    <button class="alt" onclick="window.close()">Close</button>
  </div>

  <div class="wrap"><div id="pages"></div></div>

  <template id="firstHead">
    <div class="hdr">
      <div class="logo-cell">
        <div class="logo-box"><img src="$logoUrl" crossorigin="anonymous" onerror="this.style.display='none'"></div>
      </div>
      <div class="txt">
        <div class="l1">Department of Health</div>
        <div class="l2">Cotabato Regional and Medical Center</div>
        <div class="l3">Sinsuat Avenue, Rosary Heights X, Cotabato City</div>
      </div>
      <div></div>
    </div>
    <div class="title">PGS DELIVERABLES MONTHLY ACCOMPLISHMENT REPORT</div>
    ${report.officeName.isEmpty ? '' : '<div class="office-name">${_esc(report.officeName)}</div>'}
    ${periodLabel.isEmpty ? '' : '<div class="sub">${_esc(periodLabel)}</div>'}
    ${_buildSummary(visible, includeZeroMonths)}
  </template>
  <table id="src" style="display:none"><tbody>
    ${_buildRows(visible, showEmpty: showEmptyDeliverables, includeZero: includeZeroMonths, periodMonths: months)}
  </tbody></table>

  <script>
    var curW = 210, curH = 297;

    function fit() {
      var wrap = document.querySelector('.wrap');
      var pg = document.querySelector('.pg');
      if (!pg) return;
      wrap.style.zoom = 1;
      var need = pg.offsetWidth + 48;
      wrap.style.zoom = Math.min(1, window.innerWidth / need);
    }

    function newPage(container, first) {
      var s = document.createElement('section');
      s.className = 'pg';
      var b = document.createElement('div');
      b.className = 'body';
      if (first) {
        b.appendChild(document.getElementById('firstHead').content.cloneNode(true));
      }
      var t = document.createElement('table');
      t.className = 'data';
      t.innerHTML = '<thead><tr>'
        + '<th class="m">Month</th>'
        + '<th class="c">% Accomplished &amp; Status</th>'
        + '<th class="r">Department Remarks</th>'
        + '<th class="r">Auditor Remarks</th>'
        + '</tr></thead><tbody></tbody>';
      b.appendChild(t);
      var n = document.createElement('div');
      n.className = 'num';
      s.appendChild(b);
      s.appendChild(n);
      container.appendChild(s);
      return { body: b, tbody: t.tBodies[0] };
    }

    function paginate() {
      var container = document.getElementById('pages');
      container.innerHTML = '';
      var rows = Array.prototype.slice.call(document.querySelectorAll('#src tr'));
      var cur = newPage(container, true);

      rows.forEach(function (r) {
        var c = r.cloneNode(true);
        cur.tbody.appendChild(c);
        if (cur.body.scrollHeight > cur.body.clientHeight + 1 && cur.tbody.children.length > 1) {
          cur.tbody.removeChild(c);
          var carry = [c];
          // huwag iwan mag-isa ang deliverable title row sa dulo ng page
          var last = cur.tbody.lastElementChild;
          if (last && last.classList.contains('deliv') && cur.tbody.children.length > 1) {
            cur.tbody.removeChild(last);
            carry.unshift(last);
          }
          cur = newPage(container, false);
          carry.forEach(function (x) { cur.tbody.appendChild(x); });
        }
      });

      var nums = container.querySelectorAll('.num');
      for (var i = 0; i < nums.length; i++) {
        nums[i].textContent = 'Page ' + (i + 1) + ' of ' + nums.length;
      }
    }

    async function downloadPdf() {
      var btn = document.getElementById('btnPdf');
      var label = btn.textContent;
      var wrap = document.querySelector('.wrap');
      var oldZoom = wrap.style.zoom;

      if (!window.jspdf || !window.html2canvas) {
        alert('Hindi ma-load ang PDF library. I-check ang internet, o gamitin ang Print.');
        return;
      }

      btn.disabled = true;
      btn.textContent = 'Generating PDF...';
      wrap.style.zoom = 1;

      try {
        var orient = curW > curH ? 'l' : 'p';
        var pdf = new window.jspdf.jsPDF({
          orientation: orient,
          unit: 'mm',
          format: [curW, curH]
        });
        var pages = document.querySelectorAll('.pg');

        for (var i = 0; i < pages.length; i++) {
          if (i > 0) pdf.addPage([curW, curH], orient);
          var canvas = await html2canvas(pages[i], {
            scale: 2,
            useCORS: true,
            backgroundColor: '#ffffff',
            logging: false
          });
          pdf.addImage(canvas.toDataURL('image/jpeg', 0.95), 'JPEG', 0, 0, curW, curH - 1);
          btn.textContent = 'Generating ' + (i + 1) + '/' + pages.length + '...';
        }

        pdf.save('pgs-accomplishment-report.pdf');
      } catch (e) {
        console.error(e);
        alert('Hindi na-generate ang PDF. Subukan ang Print at piliin ang Save as PDF.');
      } finally {
        wrap.style.zoom = oldZoom;
        btn.disabled = false;
        btn.textContent = label;
      }
    }

    function applySize() {
      var d = document.getElementById('size').value.split(',');
      var w = parseFloat(d[0]), h = parseFloat(d[1]);
      if (document.getElementById('orient').value === 'l') { var t = w; w = h; h = t; }
      curW = w;
      curH = h;
      var root = document.documentElement.style;
      root.setProperty('--w', w + 'mm');
      root.setProperty('--h', h + 'mm');
      document.getElementById('pg').textContent =
        '@page { size: ' + w + 'mm ' + h + 'mm; margin: 0; }';
      paginate();
      fit();
    }

    window.addEventListener('resize', fit);
    window.addEventListener('load', applySize);
    applySize();
  </script>
</body>
</html>''';
}

Future<void> openPgsDeliverableAccomplishmentReport({
  required int periodId,
  required int officeId,
  required int pgsId,
  required BuildContext context,
}) async {
  try {
    final dio = Dio();

    final url =
        '${ApiEndpoint().filterAccomplishmentReport}?periodId=$periodId&officeId=$officeId&pgsId=$pgsId';

    final response = await AuthenticatedRequest.get(dio, url);

    if (response.statusCode == 200 && response.data is Map) {
      final report = PgsOfficeReport.fromJson(
        Map<String, dynamic>.from(response.data),
      );

      await openPgsAccomplishmentPreviewTab(
        report,
        periodLabel: report.periodName,
      );
    } else {
      if (context.mounted) {
        MotionToast.error(
          description: const Text('Failed to load accomplishment report'),
          toastAlignment: Alignment.topCenter,
        ).show(context);
      }
    }
  } catch (e) {
    if (context.mounted) {
      MotionToast.error(
        description: const Text('Failed to load accomplishment report'),
        toastAlignment: Alignment.topCenter,
      ).show(context);
    }
  }
}
