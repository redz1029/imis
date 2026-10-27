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

// ───────────────────────── IMAGE HANDLING ─────────────────────────

/// - Dina-downscale at nirere-compress ang mga naka-attach na image (base64)
///   para gumaan ang HTML na sine-save.
/// - Nilalagyan ng default na lapad (400px) para hindi full-width.
/// - Tine-track ang huling na-click na image para sa size/align buttons.
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

String buildPreviewDocument(String header, String body) => '''<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Print Preview</title>
<style>
  @page { size: A4; margin: 20mm; }
  html { background: #9aa0a6; }
  body { margin: 0; }

  .bar {
    position: sticky; top: 0; z-index: 10;
    display: flex; align-items: center; gap: 8px;
    padding: 8px 16px; background: #323639; color: #fff;
    font: 14px Arial, sans-serif;
  }
  .bar .sp { flex: 1; }
  .bar button {
    border: 0; border-radius: 4px; padding: 7px 14px; cursor: pointer;
    font: 13px Arial, sans-serif; background: #8c3a55; color: #fff;
  }
  .bar button.alt { background: #5f6368; }

  .wrap { padding: 24px 0; transform-origin: top center; }
  .sheet {
    box-sizing: border-box; width: 210mm; min-height: 297mm;
    margin: 0 auto; padding: 20mm; background: #fff;
    box-shadow: 0 2px 10px rgba(0,0,0,.4);
    font-family: "Times New Roman", Times, serif;
    font-size: 12pt; line-height: 1.3; color: #000;
  }
  .sheet p { margin: 0 0 6pt 0; }
  .sheet table { border-collapse: collapse; width: 100%; }
  .sheet td, .sheet th { border: 1px solid #000; padding: 4px 6px; vertical-align: top; }
  .sheet img { max-width: 100%; height: auto; page-break-inside: avoid; break-inside: avoid; }
  .sheet { overflow-wrap: anywhere; word-break: break-word; }
  .sheet table { table-layout: auto; }

  /* ---- Document header (imitates the official form) ---- */
  .hdr-top {
    text-align: center; line-height: 1.15;
    margin: 4mm 0 2pt 0; font-size: 12pt;
  }
  .hdr-top .hdr-center { font-weight: bold; text-transform: uppercase; }

  .sheet table.hdr {
    table-layout: fixed; width: 100%;
    margin: 0 0 16pt 0;
    font-size: 11pt; line-height: 1.15;
    border: 1px solid #000;
  }
  .sheet table.hdr td {
    border: 1px solid #000;
    vertical-align: top;
    padding: 2px 6px;
  }
  .sheet table.hdr b { text-transform: uppercase; }

  .sheet table.hdr td.logo {
    text-align: center; vertical-align: middle; padding: 4px;
  }
  .sheet table.hdr td.logo .logo-box {
    width: 84px; height: 84px; margin: 0 auto;
    overflow: hidden; position: relative;
  }
  .sheet table.hdr td.logo .logo-box img {
    position: absolute; top: 50%; left: 50%;
    width: 215px; max-width: none; height: auto;
    transform: translate(-50%, -50%);
  }

  @media print {
    html { background: #fff; }
    .bar { display: none; }
    .wrap { padding: 0; zoom: 1 !important; }
    .sheet { width: auto; min-height: 0; margin: 0; padding: 0; box-shadow: none; }
  }
</style>
</head>
<body>
  <div class="bar">
    <span>Print Preview &middot; A4</span>
    <span class="sp"></span>
    <button onclick="window.print()">Print / Save as PDF</button>
    <button class="alt" onclick="window.close()">Close</button>
  </div>
  <div class="wrap"><div class="sheet">$header$body</div></div>
  <script>
    function fit() {
      var wrap = document.querySelector('.wrap');
      var sheet = document.querySelector('.sheet');
      wrap.style.zoom = 1;
      var need = sheet.offsetWidth + 48;
      wrap.style.zoom = Math.min(1, window.innerWidth / need);
    }
    window.addEventListener('resize', fit);
    window.addEventListener('load', fit);
    fit();
  </script>
</body>
</html>''';
