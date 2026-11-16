import 'package:html_editor_enhanced/utils/utils.dart';

const String syncListScript = r'''
(function () {
  var ed = document.querySelector('.note-editable');
  if (!ed) return;

  // ---------- 1) LIST MARKERS ----------
  try {
    var props = ['fontFamily', 'fontSize', 'color', 'fontWeight', 'fontStyle'];
    ed.querySelectorAll('li').forEach(function (li) {
      var a = window.getComputedStyle(li).textAlign;
      var pos = (a === 'center' || a === 'right' || a === 'end') ? 'inside' : '';
      if (li.style.listStylePosition !== pos) li.style.listStylePosition = pos;

      var walker = document.createTreeWalker(li, NodeFilter.SHOW_TEXT, {
        acceptNode: function (n) {
          return n.nodeValue.trim()
            ? NodeFilter.FILTER_ACCEPT
            : NodeFilter.FILTER_REJECT;
        }
      });
      var t = walker.nextNode();
      if (!t || !t.parentElement) return;
      if (t.parentElement === li) {
        props.forEach(function (p) { li.style[p] = ''; });
        return;
      }
      var cs = window.getComputedStyle(t.parentElement);
      props.forEach(function (p) {
        if (li.style[p] !== cs[p]) li.style[p] = cs[p];
      });
    });
  } catch (e) {}

  // ---------- 2) TABLE BORDERS (inline, kasama sa saved HTML) ----------
  try {
    ed.querySelectorAll('table').forEach(function (tb) {
      if (!tb.style.borderCollapse) tb.style.borderCollapse = 'collapse';
      if (!tb.style.width) tb.style.width = '100%';
      tb.querySelectorAll('td, th').forEach(function (c) {
        // lagyan lang kung wala pang sariling inline border
        if (!c.style.borderTopWidth && !c.style.border) {
          c.style.border = '1px solid #000';
        }
        if (!c.style.padding) c.style.padding = '4px 6px';
        if (!c.style.verticalAlign) c.style.verticalAlign = 'top';
      });
    });
  } catch (e) {}

  // ---------- 3) WRAP + WORD-LIKE TABLE ----------
  try {
    var st = document.getElementById('wrap-style');
    if (!st) {
      st = document.createElement('style');
      st.id = 'wrap-style';
      document.head.appendChild(st);
    }
    st.textContent =
      '.note-editor .note-editing-area { overflow-x: hidden !important; }' +
      '.note-editor .note-editing-area .note-editable {' +
      '  box-sizing: border-box !important; max-width: 100% !important;' +
      '  overflow-x: hidden !important; padding: 16px 24px !important;' +
      '  white-space: normal !important;' +
      '  overflow-wrap: anywhere !important; word-break: break-word !important;' +
      '}' +
      '.note-editable p, .note-editable div, .note-editable li {' +
      '  overflow-wrap: anywhere !important; word-break: break-word !important;' +
      '}' +
      '.note-editable table {' +
      '  table-layout: auto !important; width: 100% !important;' +
      '  max-width: 100% !important; border-collapse: collapse !important;' +
      '}' +
      '.note-editable td, .note-editable th {' +
      '  overflow-wrap: anywhere !important; word-break: break-word !important;' +
      '  white-space: normal !important;' +
      '}' +
      '.note-editable img { max-width: 100% !important; height: auto !important; cursor: pointer; }' +
      '.note-editable pre { white-space: pre-wrap !important; }' +
      '.note-editor .note-placeholder {' +
      '  padding: 16px 24px !important; box-sizing: border-box !important;' +
      '}' +
      '.note-editable > p:first-child { margin-top: 0 !important; }';
  } catch (e) {}
})();
''';

const String imageFixScript = r'''
(function () {
  var ed = document.querySelector('.note-editable');
  if (!ed) return;

  var MAX_W = 1000, DEFAULT_W = 400, QUALITY = 0.82;
  window.__imgDone = window.__imgDone || new WeakSet();

  // tandaan kung aling image ang huling na-click
  if (!ed.__imgBound) {
    ed.__imgBound = true;
    ed.addEventListener('click', function (e) {
      window.__selImg = (e.target && e.target.tagName === 'IMG') ? e.target : null;
    });
  }

  ed.querySelectorAll('img').forEach(function (img) {
    if (window.__imgDone.has(img)) return;

    function run() {
      if (window.__imgDone.has(img)) return;
      window.__imgDone.add(img);
      var nw = img.naturalWidth, nh = img.naturalHeight;
      if (!nw) return;

      var src = img.getAttribute('src') || '';
      var isRaster = src.indexOf('data:image') === 0 &&
                     !/^data:image\/(svg|gif)/.test(src);

      // downscale + recompress (para gumaan ang base64)
      if (isRaster && (nw > MAX_W || src.length > 300000)) {
        try {
          var s = Math.min(1, MAX_W / nw);
          var c = document.createElement('canvas');
          c.width = Math.round(nw * s);
          c.height = Math.round(nh * s);
          var ctx = c.getContext('2d');
          ctx.fillStyle = '#fff';
          ctx.fillRect(0, 0, c.width, c.height);
          ctx.drawImage(img, 0, 0, c.width, c.height);
          img.src = c.toDataURL('image/jpeg', QUALITY);
        } catch (e) {}
      }

      // default size
      if (!img.style.width) img.style.width = Math.min(nw, DEFAULT_W) + 'px';
      img.style.height = 'auto';
      img.style.maxWidth = '100%';
    }

    if (img.complete && img.naturalWidth) run();
    else img.addEventListener('load', run, { once: true });
  });
})();
''';

String imageApplyScript(String apply) => '''
(function () {
  var img = window.__selImg;
  if (!img) return;
  $apply
})();
''';

final List<WebScript> imageScripts = [
  for (final p in const [25, 50, 75, 100])
    WebScript(
      name: 'imgW$p',
      script: imageApplyScript(
        "img.style.width = '$p%'; img.style.height = 'auto';",
      ),
    ),
  WebScript(
    name: 'imgLeft',
    script: imageApplyScript(
      "img.style.display = 'block'; img.style.margin = '6px auto 6px 0';",
    ),
  ),
  WebScript(
    name: 'imgCenter',
    script: imageApplyScript(
      "img.style.display = 'block'; img.style.margin = '6px auto';",
    ),
  ),
  WebScript(
    name: 'imgRight',
    script: imageApplyScript(
      "img.style.display = 'block'; img.style.margin = '6px 0 6px auto';",
    ),
  ),
];

// ───────────────────────── PARAGRAPH / BLOCK ─────────────────────────

String blockScript(String apply) => '''
(function () {
  var ed = document.querySelector('.note-editable');
  var sel = window.getSelection();
  if (!ed || !sel || !sel.rangeCount) return;
  var r = sel.getRangeAt(0);
  var q = 'p,div,li,h1,h2,h3,h4,h5,h6,blockquote,pre,td,th';
  var blocks = [];
  ed.querySelectorAll(q).forEach(function (b) {
    if (!b.querySelector(q) && r.intersectsNode(b)) blocks.push(b);
  });
  if (!blocks.length) {
    var n = r.startContainer;
    if (n.nodeType === 3) n = n.parentElement;
    var b = n && n.closest ? n.closest(q) : null;
    if (b && ed.contains(b)) blocks.push(b);
  }
  blocks.forEach(function (b) { $apply });
})();
''';

final List<WebScript> paragraphScripts = [
  for (final v in const ['1.0', '1.15', '1.5', '2.0', '2.5', '3.0'])
    WebScript(
      name: 'lsp${v.replaceAll('.', '')}',
      script: blockScript("b.style.lineHeight = '$v';"),
    ),
  WebScript(
    name: 'spaceRemove',
    script: blockScript("b.style.marginTop = '0'; b.style.marginBottom = '0';"),
  ),
  WebScript(
    name: 'spaceAdd',
    script: blockScript("b.style.marginBottom = '10pt';"),
  ),
];

// ───────────────────────── SANITIZE + PREVIEW ─────────────────────────

String sanitize(String s) => s
    .replaceAll(RegExp(r'<script[\s\S]*?</script>', caseSensitive: false), '')
    .replaceAll(
      RegExp(
        r'''\son\w+\s*=\s*("[^"]*"|'[^']*'|[^\s>]+)''',
        caseSensitive: false,
      ),
      '',
    )
    .replaceAll(RegExp(r'javascript:', caseSensitive: false), '');

const String _previewScript = r'''
var curW = 210, curH = 297;
var cur = null;
var runId = 0;

function fit() {
  var wrap = document.querySelector('.wrap');
  var pg = document.querySelector('.pg');
  if (!pg) return;
  wrap.style.zoom = 1;
  var need = pg.offsetWidth + 48;
  wrap.style.zoom = Math.min(1, window.innerWidth / need);
}

function fits(b) { return b.scrollHeight <= b.clientHeight + 1; }

function isBlank(n) {
  if (n.nodeType === 3) return !n.nodeValue.trim();
  if (n.nodeType !== 1) return true;
  return !n.textContent.trim() && !n.querySelector('img,table,hr');
}

var BLOCKS = ['P', 'DIV', 'TABLE', 'UL', 'OL', 'H1', 'H2', 'H3', 'H4', 'H5', 'H6', 'BLOCKQUOTE', 'PRE'];

function hasBlockChild(n) {
  for (var i = 0; i < n.children.length; i++) {
    if (BLOCKS.indexOf(n.children[i].tagName) !== -1) return true;
  }
  return false;
}

// i-unwrap ang plain wrapper div para maging hiwalay na blocks
function flatten(parent) {
  var out = [];
  Array.prototype.slice.call(parent.childNodes).forEach(function (n) {
    if (n.nodeType === 3) {
      if (!n.nodeValue.trim()) return;
      var p = document.createElement('p');
      p.appendChild(n);
      out.push(p);
      return;
    }
    if (n.nodeType !== 1) return;
    if (n.tagName === 'DIV' && !n.getAttribute('style') && !n.className && hasBlockChild(n)) {
      out = out.concat(flatten(n));
      return;
    }
    out.push(n);
  });
  return out;
}

function newPage(container) {
  var s = document.createElement('section');
  s.className = 'pg';
  var c = document.createElement('div');
  c.className = 'content';
  var h = document.createElement('div');
  h.className = 'hd';
  h.appendChild(document.getElementById('hdrTpl').content.cloneNode(true));
  var b = document.createElement('div');
  b.className = 'body';
  c.appendChild(h);
  c.appendChild(b);
  s.appendChild(c);
  container.appendChild(s);
  b.style.height = Math.max(50, c.clientHeight - h.offsetHeight) + 'px';
  return { body: b, section: s };
}

// table (by row, uulit ang thead) o list (by li)
// return: null = walang kasya, true = kasya lahat, Node = natirang bahagi
function splitRows(node) {
  var isT = node.tagName === 'TABLE';
  var head = null, cg = null, rows;
  if (isT) {
    head = node.tHead;
    cg = node.querySelector('colgroup');
    rows = Array.prototype.slice.call(node.rows).filter(function (r) {
      return !head || r.parentNode !== head;
    });
  } else {
    rows = Array.prototype.slice.call(node.children);
  }
  if (!rows.length) return null;

  function shell(startIdx) {
    var el = node.cloneNode(false);
    var host = el;
    if (isT) {
      if (cg) el.appendChild(cg.cloneNode(true));
      if (head) el.appendChild(head.cloneNode(true));
      host = document.createElement('tbody');
      el.appendChild(host);
    } else if (node.tagName === 'OL') {
      var st = parseInt(node.getAttribute('start') || '1', 10);
      el.setAttribute('start', String(st + startIdx));
    }
    return { el: el, host: host };
  }

  var sh = shell(0);
  cur.body.appendChild(sh.el);
  var i = 0;
  for (; i < rows.length; i++) {
    sh.host.appendChild(rows[i]);
    if (!fits(cur.body)) {
      sh.host.removeChild(rows[i]);
      break;
    }
  }
  if (i === 0) { cur.body.removeChild(sh.el); return null; }
  if (i >= rows.length) return true;

  var rest = shell(i);
  for (var j = i; j < rows.length; j++) rest.host.appendChild(rows[j]);
  return rest.el;
}

// hatiin ang mahabang paragraph by words
function splitText(node) {
  var tokens = node.innerHTML.match(/<[^>]+>|\s+|[^<\s]+/g) || [];
  if (tokens.length < 2) return null;

  function build(k) {
    var el = node.cloneNode(false);
    el.innerHTML = tokens.slice(0, k).join('');
    return el;
  }

  var lo = 1, hi = tokens.length - 1, best = 0;
  while (lo <= hi) {
    var mid = (lo + hi) >> 1;
    var el = build(mid);
    cur.body.appendChild(el);
    var ok = fits(cur.body);
    cur.body.removeChild(el);
    if (ok) { best = mid; lo = mid + 1; } else { hi = mid - 1; }
  }
  if (best === 0) return null;

  // mas maganda kung sa after ng space ang putol
  var b = best;
  while (b > 0 && !/^\s+$/.test(tokens[b - 1])) b--;
  if (b > 0) best = b;

  // alamin ang mga tag na bukas pa sa putol
  var stack = [];
  for (var i = 0; i < best; i++) {
    var t = tokens[i];
    if (t.charAt(0) !== '<' || t.charAt(1) === '!') continue;
    if (t.charAt(1) === '/') stack.pop();
    else if (t.charAt(t.length - 2) !== '/' && !/^<(br|img|hr|input|wbr)/i.test(t)) stack.push(t);
  }

  cur.body.appendChild(build(best));
  var rest = node.cloneNode(false);
  rest.innerHTML = stack.join('') + tokens.slice(best).join('');
  return rest;
}

function place(node, queue, container) {
  cur.body.appendChild(node);
  if (fits(cur.body)) return;
  cur.body.removeChild(node);

  var empty = cur.body.children.length === 0;
  var tag = node.tagName;
  var res = null;

  if (tag === 'TABLE' || tag === 'UL' || tag === 'OL') {
    res = splitRows(node);
  } else if (hasBlockChild(node)) {
    var kids = Array.prototype.slice.call(node.childNodes).filter(function (c) { return !isBlank(c); });
    if (kids.length === 1 && kids[0].nodeType === 1) {
      queue.unshift(kids[0]);
    } else {
      queue.unshift.apply(queue, kids.map(function (c) {
        var w = node.cloneNode(false);
        w.appendChild(c);
        return w;
      }));
    }
    return;
  } else if (!node.querySelector('img,table')) {
    res = splitText(node);
  }

  if (res === true) return;
  if (res) {
    cur = newPage(container);
    queue.unshift(res);
    return;
  }
  if (!empty) {
    cur = newPage(container);
    queue.unshift(node);
    return;
  }
  cur.body.appendChild(node); // sobrang laki talaga, i-force
}

function imagesReady(root) {
  var imgs = Array.prototype.slice.call(root.querySelectorAll('img'));
  var all = Promise.all(imgs.map(function (i) {
    return i.complete ? 1 : new Promise(function (r) { i.onload = i.onerror = r; });
  }));
  return Promise.race([all, new Promise(function (r) { setTimeout(r, 4000); })]);
}

async function paginate() {
  var my = ++runId;
  var wrap = document.querySelector('.wrap');
  wrap.style.zoom = 1;
  var container = document.getElementById('pages');
  var src = document.getElementById('src');
  src.innerHTML = '';
  src.appendChild(document.getElementById('bodyTpl').content.cloneNode(true));
  await imagesReady(src);
  if (my !== runId) return;

  container.innerHTML = '';
  try {
    var queue = flatten(src);
    while (queue.length && isBlank(queue[queue.length - 1])) queue.pop();

    cur = newPage(container);
    var guard = 0;
    while (queue.length && guard++ < 20000) {
      place(queue.shift(), queue, container);
    }
  } catch (e) {
    // fallback: isang tuloy-tuloy na page
    console.error(e);
    container.innerHTML = '';
    cur = newPage(container);
    cur.section.className = 'pg flow';
    cur.body.style.height = 'auto';
    cur.body.appendChild(document.getElementById('bodyTpl').content.cloneNode(true));
  }

   var pgs = container.querySelectorAll('.pg');
  for (var i = 0; i < pgs.length; i++) {
    var tds = pgs[i].querySelectorAll('table.hdr td');
    for (var k = 0; k < tds.length; k++) {
      if (/^\s*PAGES\s*:/i.test(tds[k].textContent)) {
        var pb = tds[k].querySelector('b');
        if (!pb) { pb = document.createElement('b'); tds[k].appendChild(pb); }
        pb.className = 'pgs';
        pb.textContent = (i + 1) + ' of ' + pgs.length;
      }
    }
  }
  fit();
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
    var pdf = new window.jspdf.jsPDF({ orientation: orient, unit: 'mm', format: [curW, curH] });
    var pages = document.querySelectorAll('.pg');

    for (var i = 0; i < pages.length; i++) {
      if (i > 0) pdf.addPage([curW, curH], orient);
      var canvas = await html2canvas(pages[i], {
        scale: 2, useCORS: true, backgroundColor: '#ffffff', logging: false
      });
      pdf.addImage(canvas.toDataURL('image/jpeg', 0.95), 'JPEG', 0, 0, curW, curH - 1);
      btn.textContent = 'Generating ' + (i + 1) + '/' + pages.length + '...';
    }
    pdf.save('procedure.pdf');
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
}

window.addEventListener('resize', fit);
window.addEventListener('load', applySize);
''';

String buildPreviewDocument(String header, String body) => '''<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Print Preview</title>
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

  /* hidden na pinagkukunan ng laman */
  #src { position: absolute; left: -99999px; top: 0; width: 170mm; visibility: hidden; }

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
  .pg .content { height: calc(var(--h) - 41mm); overflow: hidden; }
  .pg .hd { display: flow-root; }
  .pg .body { overflow: hidden; display: flow-root; }

  /* fallback kapag pumalpak ang pagination */
  .pg.flow { height: auto; min-height: calc(var(--h) - 1mm); overflow: visible; }
  .pg.flow .content { height: auto; overflow: visible; }
  .pg.flow .body { overflow: visible; }

  /* ---- Body content ---- */
  .pg .body p { margin: 0 0 6pt 0; }
  .pg .body table { border-collapse: collapse; width: 100%; table-layout: auto; }
  .pg .body td, .pg .body th { border: 1px solid #000; padding: 4px 6px; vertical-align: top; }
  .pg .body img { max-width: 100%; height: auto; }

  /* ---- Document header (imitates the official form) ---- */
  .hdr-top {
    text-align: center; line-height: 1.15;
    margin: 4mm 0 2pt 0; font-size: 12pt;
  }
  .hdr-top .hdr-center { font-weight: bold; text-transform: uppercase; }

  .pg table.hdr {
    table-layout: fixed; width: 100%;
    margin: 0 0 16pt 0;
    font-size: 11pt; line-height: 1.15;
    border: 1px solid #000; border-collapse: collapse;
  }
  .pg table.hdr td {
    border: 1px solid #000;
    vertical-align: top;
    padding: 2px 6px;
  }
  .pg table.hdr b { text-transform: uppercase; }
  .pg table.hdr b.pgs { text-transform: none; }
  .pg table.hdr td.logo {
    text-align: center; vertical-align: middle; padding: 4px;
  }
  .pg table.hdr td.logo .logo-box {
    width: 84px; height: 84px; margin: 0 auto;
    overflow: hidden; position: relative;
  }
  .pg table.hdr td.logo .logo-box img {
    position: absolute; top: 50%; left: 50%;
    width: 215px; max-width: none; height: auto;
    transform: translate(-50%, -50%);
  }

  @media print {
    html { background: #fff; }
    .bar, #src { display: none; }
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

  <div id="src"></div>
  <template id="hdrTpl">$header</template>
  <template id="bodyTpl">$body</template>

  <script>$_previewScript</script>
</body>
</html>''';
