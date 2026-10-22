import 'package:imis/performance_governance_system/pgs_strategy_review_report/models/strategy_review_office.dart';
import 'package:universal_html/html.dart' as html;

const String _logoAssetUrl = 'assets/assets/CRMC.png';

Future<void> openOfficesPreviewTab(
  List<StrategyReviewOffice> offices, {
  String roadmapName = '',
  String kraName = '',
  String periodLabel = '',
}) async {
  final logo = Uri.base.resolve(_logoAssetUrl).toString();
  final blob = html.Blob([
    buildOfficesPreviewDocument(
      logo,
      offices,
      roadmapName: roadmapName,
      kraName: kraName,
      periodLabel: periodLabel,
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

String _buildTitle(String roadmapName) {
  final name = roadmapName.trim().toUpperCase();
  return name.isEmpty
      ? 'ROADMAP CONTRIBUTION REPORT'
      : 'ROADMAP CONTRIBUTION REPORT ($name)';
}

const String _subtitle = 'Unit PGS Deliverables and Accomplishments';

String _percentCell(num? pct) {
  final value = (pct ?? 0).clamp(0, 100).toDouble();
  final label =
      value % 1 == 0 ? '${value.toInt()}%' : '${value.toStringAsFixed(1)}%';

  final color = value >= 100 ? '#16a34a' : (value > 0 ? '#f59e0b' : '#dc2626');

  final barWidth = value == 0 ? 100 : value;

  return '<div class="pct" style="color:$color">$label</div>'
      '<div class="bar-bg"><div class="bar-fg" style="width:$barWidth%;background:$color"></div></div>';
}

String _remarksCell(String? remarks) {
  final text = (remarks ?? '').replaceAll('\r', '').trim();
  if (text.isEmpty) return '<span class="na">&mdash;</span>';
  return _esc(text);
}

String _buildSummary(List<StrategyReviewOffice> offices) {
  final totalOffices = offices.length;
  var totalDeliverables = 0;
  var notStarted = 0;
  var onGoing = 0;
  var completed = 0;

  for (final o in offices) {
    for (final d in o.deliverables) {
      totalDeliverables++;
      final v = (d.accomplishment?.percentAccomplished ?? 0);
      if (v >= 100) {
        completed++;
      } else if (v > 0) {
        onGoing++;
      } else {
        notStarted++;
      }
    }
  }

  String pct(int n) {
    if (totalDeliverables == 0) return '0%';
    final p = n / totalDeliverables * 100;
    return p % 1 == 0 ? '${p.toInt()}%' : '${p.toStringAsFixed(1)}%';
  }

  String statItem(String label, int count, String color, String textColor) =>
      '<div class="stat-item" style="border-color:$color">'
      '<span class="stat-label"><i class="dot" style="background:$color"></i>$label</span>'
      '<span class="stat-val" style="color:$textColor">$count'
      '<span class="stat-pct"> (${pct(count)})</span></span></div>';

  return '<div class="summary">'
      '<div class="sum-item"><span class="sum-label">Total Offices</span>'
      '<span class="sum-val">$totalOffices</span></div>'
      '<div class="sum-item"><span class="sum-label">Total Deliverables</span>'
      '<span class="sum-val">$totalDeliverables</span></div>'
      '</div>'
      '<div class="stats">'
      '${statItem('Not Started', notStarted, '#dc2626', '#dc2626')}'
      '${statItem('On Going', onGoing, '#f59e0b', '#b45309')}'
      '${statItem('Completed', completed, '#16a34a', '#16a34a')}'
      '</div>';
}

String _buildRows(List<StrategyReviewOffice> offices) {
  if (offices.isEmpty) {
    return '<tr><td colspan="3" class="empty">No offices found.</td></tr>';
  }
  final b = StringBuffer();
  for (final o in offices) {
    b.write(
      '<tr class="office"><td colspan="3">${_esc(o.officeName.toUpperCase())}</td></tr>',
    );
    if (o.deliverables.isEmpty) {
      b.write('<tr><td colspan="3" class="empty">No deliverables</td></tr>');
      continue;
    }
    for (final d in o.deliverables) {
      b.write(
        '<tr><td class="dname">${_esc(d.deliverableName.replaceAll('\r', '').trim())}</td>'
        '<td class="pcell">${_percentCell(d.accomplishment?.percentAccomplished)}</td>'
        '<td class="rcell">${_remarksCell(d.accomplishment?.remarks)}</td></tr>',
      );
    }
  }
  return b.toString();
}

String buildOfficesPreviewDocument(
  String logoUrl,
  List<StrategyReviewOffice> offices, {
  String roadmapName = '',
  String kraName = '',
  String periodLabel = '',
}) => '''<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Print Preview - ${_esc(_buildTitle(roadmapName))}</title>
<!-- margin: 0 para mawala ang browser header/footer (date, title, URL) -->
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

  /* ---- One real page ---- */
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

  /* ---- Header ---- */
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

  .title { text-align: center; font-weight: bold; font-size: 14pt; margin: 28pt 0 0 0; }
  .subtitle { text-align: center; font-weight: bold; font-style: italic; font-size: 13pt; margin-top: 6pt; }
  .sub { text-align: center; font-size: 11pt; margin-top: 4pt; }
  .sub b { font-weight: bold; }

  /* ---- Summary ---- */
  .summary { display: flex; gap: 12px; margin-top: 14pt; }
  .sum-item {
    flex: 1; border: 1px solid #964459; border-radius: 4px;
    padding: 6px 10px; display: flex; justify-content: space-between;
    align-items: center; background: #F2D5D9;
    -webkit-print-color-adjust: exact; print-color-adjust: exact;
  }
  .sum-label { font-size: 10.5pt; color: #964459; font-weight: bold; }
  .sum-val { font-size: 13pt; font-weight: bold; color: #964459; }

  /* ---- Status statistics ---- */
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

  /* ---- Data table ---- */
  table.data { width: 100%; border-collapse: collapse; margin-top: 12pt; font-size: 10.5pt; }
  table.data th {
    background: #964459; color: #fff; padding: 6px 8px;
    border: 1px solid #964459; text-align: left; font-size: 10.5pt;
    -webkit-print-color-adjust: exact; print-color-adjust: exact;
  }
  table.data th.c { text-align: center; width: 17%; }
  table.data th.r { width: 26%; }
  table.data td { border: 1px solid #964459; padding: 5px 8px; vertical-align: middle; }
  tr.office td {
    background: #F2D5D9; color: #964459; font-weight: bold; font-size: 10.5pt;
    -webkit-print-color-adjust: exact; print-color-adjust: exact;
  }
  td.dname { white-space: pre-line; }
  td.pcell { text-align: center; }
  td.rcell { white-space: pre-line; font-size: 10pt; }
  .pct { font-weight: bold; font-size: 10.5pt; }
  .bar-bg {
    height: 6px; background: #e5e7eb; border-radius: 3px; margin-top: 3px;
    -webkit-print-color-adjust: exact; print-color-adjust: exact;
  }
  .bar-fg {
    height: 6px; border-radius: 3px;
    -webkit-print-color-adjust: exact; print-color-adjust: exact;
  }
  .na { color: #6B7280; }
  td.empty { text-align: center; font-style: italic; color: #6B7280; padding: 10px; }

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

  <!-- Source data (hindi nakikita) -->
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
    <div class="title">${_esc(_buildTitle(roadmapName))}</div>
    <div class="subtitle">${_esc(_subtitle)}</div>
    ${periodLabel.isEmpty ? '' : '<div class="sub">${_esc(periodLabel)}</div>'}
    ${_buildSummary(offices)}
  </template>
  <table id="src" style="display:none"><tbody>
    ${_buildRows(offices)}
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
      t.innerHTML = '<thead><tr><th>Deliverable</th><th class="c">% Accomplished</th><th class="r">Remarks</th></tr></thead><tbody></tbody>';
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
          // huwag iwan mag-isa ang office row sa dulo ng page
          var last = cur.tbody.lastElementChild;
          if (last && last.classList.contains('office') && cur.tbody.children.length > 1) {
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
      wrap.style.zoom = 1; // iwas distort sa capture

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
          // .pg height = (h - 1mm)
          pdf.addImage(canvas.toDataURL('image/jpeg', 0.95), 'JPEG', 0, 0, curW, curH - 1);
          btn.textContent = 'Generating ' + (i + 1) + '/' + pages.length + '...';
        }

        pdf.save('strategy-review-offices.pdf');
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
