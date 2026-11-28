import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:universal_html/html.dart' as html;

const String _logoAssetUrl = 'assets/assets/CRMC.png';

class HistoryLogPrintRow {
  final String code;
  final String page;
  final String revision;
  final DateTime? date;
  final String reasons;

  const HistoryLogPrintRow({
    this.code = '',
    this.page = '',
    this.revision = '',
    this.date,
    this.reasons = '',
  });
}

class HistoryLogPrintPreview {
  HistoryLogPrintPreview._();

  static const int rowsPerPage = 5;

  static void open({
    required String title,
    required DateTime? date,
    required List<HistoryLogPrintRow> rows,
  }) {
    final doc = buildHtml(title: title, date: date, rows: rows);
    final blob = html.Blob([doc], 'text/html');
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.window.open(url, '_blank');
    Future.delayed(
      const Duration(minutes: 5),
      () => html.Url.revokeObjectUrl(url),
    );
  }

  static const _esc = HtmlEscape(HtmlEscapeMode.element);
  static String _e(String s) => _esc.convert(s.trim()).replaceAll('\n', '<br>');

  static String _fmt(DateTime? d) {
    if (d == null || d.year < 2000) return '';
    return DateFormat('MMMM d, y').format(d.toLocal()).toUpperCase();
  }

  static String _pageHeader(String title, String dateText, String logo) => '''
<div class="top">
  <div class="logo-box"><img src="$logo" onerror="this.style.display='none'"></div>
  <div class="lines">
    <div style="font-size: 12pt;">Republic of the Philippines</div>
    <div style="font-size: 12pt;">Department of Health</div>
<div class="center" style="font-size: 12pt;">COTABATO REGIONAL AND MEDICAL CENTER</div>  </div>
</div>
<div class="ttl">REVISION HISTORY LOG</div>
<div class="meta">
  <span>Document Title: <u>${_e(title)}</u></span>
  <span>Date: <u>&nbsp;${_e(dateText)}&nbsp;&nbsp;</u></span>
</div>''';

  static String _row(HistoryLogPrintRow? r) {
    if (r == null) {
      return '<tr><td></td><td></td><td></td><td></td><td></td></tr>';
    }
    return '<tr>'
        '<td>${_e(r.code)}</td>'
        '<td class="c">${_e(r.page)}</td>'
        '<td class="c">${_e(r.revision)}</td>'
        '<td class="c">${_e(_fmt(r.date))}</td>'
        '<td>${_e(r.reasons)}</td>'
        '</tr>';
  }

  static String _table(List<HistoryLogPrintRow?> rows) => '''
<table class="log">
  <colgroup>
    <col style="width: 19%">
    <col style="width: 10%">
    <col style="width: 13%">
    <col style="width: 10%">
    <col style="width: 46%">
  </colgroup>
  <thead>
    <tr>
      <th>Document Code</th>
      <th>Page No.</th>
      <th>Revision No.</th>
      <th>Date</th>
      <th>Reasons/ Details of Revision</th>
    </tr>
  </thead>
  <tbody>${rows.map(_row).join()}</tbody>
</table>''';

  static String buildHtml({
    required String title,
    required DateTime? date,
    required List<HistoryLogPrintRow> rows,
  }) {
    final logo = Uri.base.resolve(_logoAssetUrl).toString();
    final dateText = _fmt(date);

    final pages = <List<HistoryLogPrintRow?>>[];
    for (var i = 0; i < rows.length; i += rowsPerPage) {
      pages.add(<HistoryLogPrintRow?>[...rows.skip(i).take(rowsPerPage)]);
    }
    if (pages.isEmpty) pages.add(<HistoryLogPrintRow?>[]);
    for (final p in pages) {
      while (p.length < rowsPerPage) {
        p.add(null);
      }
    }

    final sections = StringBuffer();
    for (final p in pages) {
      sections.write(
        '<section class="pg">${_pageHeader(title, dateText, logo)}${_table(p)}</section>',
      );
    }

    return '''<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Revision History Log</title>
<style>@page { size: 210mm 297mm; margin: 0; }</style>
<style>$_css</style>
<script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
</head>
<body>
  <div class="bar">
    <span>Print Preview - Revision History Log</span>
    <span class="sp"></span>
    <button id="btnPdf" onclick="downloadPdf()">Download PDF</button>
    <button onclick="window.print()">Print</button>
    <button class="alt" onclick="window.close()">Close</button>
  </div>
  <div class="wrap">$sections</div>
  <script>$_js</script>
</body>
</html>''';
  }

  static const String _css = r'''
  html { background: #9aa0a6; }
  body { margin: 0; }

  .bar {
    position: sticky; top: 0; z-index: 10;
    display: flex; align-items: center; gap: 8px; flex-wrap: wrap;
    padding: 8px 16px; background: #323639; color: #fff;
    font: 14px Arial, sans-serif;
  }
  .bar .sp { flex: 1; }
  .bar button {
    border: 0; border-radius: 4px; padding: 7px 14px; cursor: pointer;
    font: 13px Arial, sans-serif; background: #8c3a55; color: #fff;
  }
  .bar button.alt { background: #5f6368; }
  .bar button:disabled { opacity: .6; cursor: wait; }

  .wrap { padding: 24px 0; transform-origin: top center; }

  .pg {
    box-sizing: border-box; position: relative; overflow: hidden;
    width: 210mm; height: 296mm;
    margin: 0 auto 16px; padding: 14mm 14mm 0 14mm; background: #fff;
    box-shadow: 0 2px 10px rgba(0,0,0,.4);
    font-family: "Times New Roman", Times, serif;
    font-size: 11pt; line-height: 1.2; color: #000;
  }

  /* ---- header ---- */
  .top { position: relative; min-height: 22mm; }
  .top .lines { text-align: center; line-height: 1.15; padding-top: 2mm; font-size: 10pt; }
  .top .lines .center { font-weight: bold; text-transform: uppercase; }
  .logo-box {
    position: absolute; left: 6mm; top: 0;
    width: 22mm; height: 22mm; overflow: hidden;
  }
  .logo-box img {
    position: absolute; top: 50%; left: 50%;
    width: 56mm; max-width: none; height: auto;
    transform: translate(-50%, -50%);
  }
  .ttl {
    text-align: center; font-weight: bold; font-size: 12pt;
    margin: 4mm 0 3mm 0;
  }
 .meta {
  display: flex; justify-content: space-between; align-items: flex-start;
  gap: 12px; font-size: 12pt; margin-bottom: 2mm;
}
.meta span:first-child { flex: 1 1 auto; min-width: 0; }
.meta span:last-child { flex: 0 0 auto; white-space: nowrap; }
  .meta u { text-decoration: underline; }

  /* ---- table ---- */
  table.log {
    width: 100%; table-layout: fixed; border-collapse: collapse;
    font-size: 12pt;
  }
  table.log th, table.log td {
    border: 1px solid #333; padding: 2px 5px; vertical-align: top;
    overflow-wrap: anywhere; word-break: break-word;
  }
  table.log th { font-weight: normal; text-align: center; height: 7mm; vertical-align: middle; }
  table.log tbody tr { height: 38mm; }
  table.log td.c { text-align: center; }

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
''';

  static const String _js = r'''
function fit() {
  var wrap = document.querySelector('.wrap');
  var pg = document.querySelector('.pg');
  if (!pg) return;
  wrap.style.zoom = 1;
  var need = pg.offsetWidth + 48;
  wrap.style.zoom = Math.min(1, window.innerWidth / need);
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
    var pdf = new window.jspdf.jsPDF({ orientation: 'p', unit: 'mm', format: [210, 297] });
    var pages = document.querySelectorAll('.pg');
    for (var i = 0; i < pages.length; i++) {
      if (i > 0) pdf.addPage([210, 297], 'p');
      var canvas = await html2canvas(pages[i], {
        scale: 2, useCORS: true, backgroundColor: '#ffffff', logging: false
      });
      pdf.addImage(canvas.toDataURL('image/jpeg', 0.95), 'JPEG', 0, 0, 210, 296);
      btn.textContent = 'Generating ' + (i + 1) + '/' + pages.length + '...';
    }
    pdf.save('revision-history-log.pdf');
  } catch (e) {
    console.error(e);
    alert('Hindi na-generate ang PDF. Subukan ang Print at piliin ang Save as PDF.');
  } finally {
    wrap.style.zoom = oldZoom;
    btn.disabled = false;
    btn.textContent = label;
  }
}

window.addEventListener('resize', fit);
window.addEventListener('load', fit);
''';
}
