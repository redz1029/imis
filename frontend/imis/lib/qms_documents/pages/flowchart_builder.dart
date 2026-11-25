import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';

const double kFlowW = 602;
const double kFlowH = 640;
const double kFlowHeaderH = 46;
const double kFlowLeftW = 120;
const double kFlowMidW = 360;
const double kFlowRightW = kFlowW - kFlowLeftW - kFlowMidW;

const double _kPad = 8;

const double _kChar = 6.0;
const double _kLine = 13;
const double _kNoteChar = 6.2;
const double _kNoteLine = 16;

const List<String> _kSerifFallback = ['Times', 'serif'];

enum FlowShape { terminator, process, decision, io, connector }

enum NoteSide { left, right }

extension FlowShapeX on FlowShape {
  String get label => switch (this) {
    FlowShape.terminator => 'Start / End',
    FlowShape.process => 'Process',
    FlowShape.decision => 'Decision',
    FlowShape.io => 'Input / Output',
    FlowShape.connector => 'Connector',
  };

  Size get size => switch (this) {
    FlowShape.terminator => const Size(84, 32),
    FlowShape.process => const Size(100, 42),
    FlowShape.decision => const Size(108, 68),
    FlowShape.io => const Size(100, 42),
    FlowShape.connector => const Size(30, 30),
  };

  String get defaultText => switch (this) {
    FlowShape.terminator => 'Start',
    FlowShape.process => 'Process',
    FlowShape.decision => 'Condition?',
    FlowShape.io => 'Input',
    FlowShape.connector => 'A',
  };

  Color get color => switch (this) {
    FlowShape.terminator => const Color(0xFF2E7D32),
    FlowShape.process => const Color(0xFF1565C0),
    FlowShape.decision => const Color(0xFFEF6C00),
    FlowShape.io => const Color(0xFF6A1B9A),
    FlowShape.connector => const Color(0xFF455A64),
  };

  double get textWidth => switch (this) {
    FlowShape.decision => size.width * 0.58,
    FlowShape.io => size.width * 0.72,
    FlowShape.connector => size.width * 0.7,
    _ => size.width - 16,
  };

  int get maxLines {
    final usableH =
        this == FlowShape.decision ? size.height * 0.6 : size.height - 10;
    return math.max(1, (usableH / _kLine).floor());
  }

  List<String> wrap(String text) =>
      _wrapText(text, math.max(3, (textWidth / _kChar).floor()), maxLines);
}

extension NoteSideX on NoteSide {
  double get x =>
      this == NoteSide.left ? _kPad : kFlowLeftW + kFlowMidW + _kPad;
  double get width =>
      (this == NoteSide.left ? kFlowLeftW : kFlowRightW) - _kPad * 2;
  String get label =>
      this == NoteSide.left ? 'Responsible / TAT' : 'Description';
  String get defaultText =>
      this == NoteSide.left ? 'Responsible person\nTAT' : 'Description';
}

Offset _clampPos(Offset p, Size s) => Offset(
  p.dx.clamp(kFlowLeftW + 6, kFlowLeftW + kFlowMidW - 6 - s.width).toDouble(),
  p.dy.clamp(kFlowHeaderH + 6, kFlowH - 6 - s.height).toDouble(),
);

class FlowNode {
  final int id;
  final FlowShape type;
  Offset pos;
  String text;

  FlowNode(this.id, this.type, this.pos, this.text);

  Size get size => type.size;
  Offset get center => pos + Offset(size.width / 2, size.height / 2);
  List<String> get lines => type.wrap(text);

  void clamp() => pos = _clampPos(pos, size);

  Map<String, dynamic> toJson() => {
    'id': id,
    't': type.index,
    'x': pos.dx,
    'y': pos.dy,
    'text': text,
  };

  factory FlowNode.fromJson(Map<String, dynamic> j) => FlowNode(
    (j['id'] as num).toInt(),
    FlowShape.values[(j['t'] as num).toInt().clamp(
      0,
      FlowShape.values.length - 1,
    )],
    Offset((j['x'] as num).toDouble(), (j['y'] as num).toDouble()),
    (j['text'] ?? '').toString(),
  )..clamp();
}

class FlowNote {
  final int id;
  final NoteSide side;
  double y; // top
  String text;

  FlowNote(this.id, this.side, this.y, this.text);

  List<String> get lines =>
      _wrapText(text, math.max(4, (side.width / _kNoteChar).floor()), 14);
  double get height => math.max(1, lines.length) * _kNoteLine + 8;
  double get centerY => y + height / 2;

  double clampY(double v) =>
      v
          .clamp(
            kFlowHeaderH + 4,
            math.max(kFlowHeaderH + 4, kFlowH - 4 - height),
          )
          .toDouble();

  Map<String, dynamic> toJson() => {
    'id': id,
    's': side.index,
    'y': y,
    'text': text,
  };

  factory FlowNote.fromJson(Map<String, dynamic> j) {
    final n = FlowNote(
      (j['id'] as num).toInt(),
      NoteSide.values[(j['s'] as num).toInt().clamp(0, 1)],
      (j['y'] as num).toDouble(),
      (j['text'] ?? '').toString(),
    );
    n.y = n.clampY(n.y);
    return n;
  }
}

class FlowEdge {
  final int from;
  final int to;
  String label;

  int mode;

  FlowEdge(this.from, this.to, [this.label = '', this.mode = 0]);

  Map<String, dynamic> toJson() => {'f': from, 't': to, 'l': label, 'm': mode};

  factory FlowEdge.fromJson(Map<String, dynamic> j) => FlowEdge(
    (j['f'] as num).toInt(),
    (j['t'] as num).toInt(),
    (j['l'] ?? '').toString(),
    ((j['m'] as num?) ?? 0).toInt().clamp(0, 2),
  );
}

Offset flowAnchor(FlowNode n, Offset toward) {
  final c = n.center;
  final d = toward - c;
  final w = n.size.width, h = n.size.height;
  if (d.dx.abs() / w > d.dy.abs() / h) {
    return Offset(d.dx > 0 ? n.pos.dx + w : n.pos.dx, c.dy);
  }
  return Offset(c.dx, d.dy > 0 ? n.pos.dy + h : n.pos.dy);
}

List<Offset> flowPath(FlowNode a, FlowNode b, int mode) {
  final ac = a.center, bc = b.center;
  final aw = a.size.width, ah = a.size.height;
  final bw = b.size.width, bh = b.size.height;

  if (mode == 1) {
    final s = Offset(bc.dx >= ac.dx ? a.pos.dx + aw : a.pos.dx, ac.dy);
    final t = Offset(bc.dx, bc.dy >= ac.dy ? b.pos.dy : b.pos.dy + bh);
    return [s, Offset(bc.dx, ac.dy), t];
  }
  if (mode == 2) {
    final s = Offset(ac.dx, bc.dy >= ac.dy ? a.pos.dy + ah : a.pos.dy);
    final t = Offset(ac.dx <= bc.dx ? b.pos.dx : b.pos.dx + bw, bc.dy);
    return [s, Offset(ac.dx, bc.dy), t];
  }
  return [flowAnchor(a, bc), flowAnchor(b, ac)];
}

List<Offset> _arrowHead(Offset from, Offset to) {
  final ang = math.atan2(to.dy - from.dy, to.dx - from.dx);
  const len = 10.0;
  return [
    to,
    to - Offset(math.cos(ang - 0.42), math.sin(ang - 0.42)) * len,
    to - Offset(math.cos(ang + 0.42), math.sin(ang + 0.42)) * len,
  ];
}

Offset _labelCenter(List<Offset> p, double tw) {
  final a = p[0], b = p[1];
  final mid = Offset((a.dx + b.dx) / 2, (a.dy + b.dy) / 2);
  final horizontal = (b.dx - a.dx).abs() >= (b.dy - a.dy).abs();
  return mid + (horizontal ? const Offset(0, -10) : Offset(tw / 2 + 6, 0));
}

double _labelWidth(String s) => s.length * 6.6 + 8;

double _distToSegment(Offset p, Offset a, Offset b) {
  final ab = b - a;
  final len2 = ab.dx * ab.dx + ab.dy * ab.dy;
  if (len2 == 0) return (p - a).distance;
  final ap = p - a;
  final t = ((ap.dx * ab.dx + ap.dy * ab.dy) / len2).clamp(0.0, 1.0);
  return (p - (a + ab * t)).distance;
}

double _distToPath(Offset p, List<Offset> pts) {
  var best = double.infinity;
  for (var i = 0; i < pts.length - 1; i++) {
    best = math.min(best, _distToSegment(p, pts[i], pts[i + 1]));
  }
  return best;
}

List<String> _wrapText(String text, int maxChars, int maxLines) {
  final lines = <String>[];
  for (final para in text.split('\n')) {
    var cur = '';
    for (var word in para.split(RegExp(r'\s+'))) {
      if (word.isEmpty) continue;
      while (word.length > maxChars) {
        if (cur.isNotEmpty) {
          lines.add(cur);
          cur = '';
        }
        lines.add(word.substring(0, maxChars));
        word = word.substring(maxChars);
      }
      if (cur.isEmpty) {
        cur = word;
      } else if (cur.length + 1 + word.length <= maxChars) {
        cur = '$cur $word';
      } else {
        lines.add(cur);
        cur = word;
      }
    }
    if (cur.isNotEmpty) lines.add(cur);
  }
  if (lines.length > maxLines) {
    final cut = lines.sublist(0, maxLines);
    final last = cut.last;
    cut[maxLines - 1] =
        '${last.length > maxChars - 1 ? last.substring(0, maxChars - 1) : last}…';
    return cut;
  }
  return lines;
}

class FlowPage {
  final List<FlowNode> nodes;
  final List<FlowEdge> edges;
  final List<FlowNote> notes;
  int nextId;

  FlowPage({
    List<FlowNode>? nodes,
    List<FlowEdge>? edges,
    List<FlowNote>? notes,
    this.nextId = 1,
  }) : nodes = nodes ?? [],
       edges = edges ?? [],
       notes = notes ?? [];

  bool get isEmpty => nodes.isEmpty && notes.isEmpty;

  FlowNode? node(int id) {
    for (final n in nodes) {
      if (n.id == id) return n;
    }
    return null;
  }

  Map<String, dynamic> toJson() => {
    'v': 2,
    'nextId': nextId,
    'nodes': [for (final n in nodes) n.toJson()],
    'edges': [for (final e in edges) e.toJson()],
    'notes': [for (final n in notes) n.toJson()],
  };

  factory FlowPage.fromJson(Map<String, dynamic> j) {
    final nodes = [
      for (final n in (j['nodes'] as List? ?? const []))
        FlowNode.fromJson(Map<String, dynamic>.from(n as Map)),
    ];
    final edges = [
      for (final e in (j['edges'] as List? ?? const []))
        FlowEdge.fromJson(Map<String, dynamic>.from(e as Map)),
    ];
    final notes = [
      for (final n in (j['notes'] as List? ?? const []))
        FlowNote.fromJson(Map<String, dynamic>.from(n as Map)),
    ];
    var maxId = 0;
    for (final n in nodes) {
      maxId = math.max(maxId, n.id);
    }
    for (final n in notes) {
      maxId = math.max(maxId, n.id);
    }
    final saved = (j['nextId'] as num?)?.toInt() ?? 1;
    return FlowPage(
      nodes: nodes,
      edges: edges,
      notes: notes,
      nextId: math.max(saved, maxId + 1),
    );
  }

  ({String svg, double width, double height})? toSvg() {
    if (isEmpty) return null;

    String f(double v) => v.toStringAsFixed(1);
    const esc = HtmlEscape(HtmlEscapeMode.element);
    const sans = 'Arial, Helvetica, sans-serif';
    const serif = "'Times New Roman', Times, serif";

    final b =
        StringBuffer()
          ..write(
            '<svg xmlns="http://www.w3.org/2000/svg" width="${f(kFlowW)}" height="${f(kFlowH)}" '
            'viewBox="0 0 ${f(kFlowW)} ${f(kFlowH)}">',
          )
          ..write('<rect width="100%" height="100%" fill="#ffffff"/>');

    void line(
      double x1,
      double y1,
      double x2,
      double y2, [
      double w = 1.5,
    ]) => b.write(
      '<line x1="${f(x1)}" y1="${f(y1)}" x2="${f(x2)}" y2="${f(y2)}" stroke="#000" stroke-width="$w"/>',
    );

    void text(
      String s,
      double x,
      double y, {
      String anchor = 'middle',
      double size = 11,
      String family = sans,
      String weight = '600',
    }) => b.write(
      '<text x="${f(x)}" y="${f(y)}" text-anchor="$anchor" font-size="$size" '
      'font-family="$family" font-weight="$weight" fill="#000">${esc.convert(s)}</text>',
    );

    // frame + columns + static header
    b.write(
      '<rect x="0.75" y="0.75" width="${f(kFlowW - 1.5)}" height="${f(kFlowH - 1.5)}" '
      'fill="none" stroke="#000" stroke-width="1.5"/>',
    );
    line(0, kFlowHeaderH, kFlowW, kFlowHeaderH);
    line(kFlowLeftW, 0, kFlowLeftW, kFlowH);
    line(kFlowLeftW + kFlowMidW, 0, kFlowLeftW + kFlowMidW, kFlowH);

    void header(List<String> ls, double cx) {
      final start = kFlowHeaderH / 2 - (ls.length - 1) * 16 / 2 + 5;
      for (var i = 0; i < ls.length; i++) {
        text(
          ls[i],
          cx,
          start + i * 16,
          size: 14,
          family: serif,
          weight: 'normal',
        );
      }
    }

    header(const ['Responsible', 'Person/TAT'], kFlowLeftW / 2);
    header(const ['Flowchart Diagram'], kFlowLeftW + kFlowMidW / 2);
    header(const ['Description'], kFlowLeftW + kFlowMidW + kFlowRightW / 2);

    // arrows
    for (final e in edges) {
      final a = node(e.from), c = node(e.to);
      if (a == null || c == null) continue;
      final pts = flowPath(a, c, e.mode);
      if ((pts.last - pts[pts.length - 2]).distance < 1) continue;

      b.write(
        '<polyline points="${pts.map((p) => '${f(p.dx)},${f(p.dy)}').join(' ')}" '
        'fill="none" stroke="#000" stroke-width="1.3" stroke-linejoin="round"/>',
      );
      final h = _arrowHead(pts[pts.length - 2], pts.last);
      b.write(
        '<polygon points="${h.map((p) => '${f(p.dx)},${f(p.dy)}').join(' ')}" fill="#000"/>',
      );

      if (e.label.trim().isNotEmpty) {
        final tw = _labelWidth(e.label);
        final mid = _labelCenter(pts, tw);
        text(e.label, mid.dx, mid.dy + 4, size: 11, weight: 'bold');
      }
    }

    // shapes
    for (final n in nodes) {
      final x = n.pos.dx, y = n.pos.dy;
      final sw = n.size.width, sh = n.size.height;
      final cx = x + sw / 2, cy = y + sh / 2;
      const style = 'fill="#ffffff" stroke="#000" stroke-width="1.5"';

      switch (n.type) {
        case FlowShape.terminator:
          b.write(
            '<rect x="${f(x)}" y="${f(y)}" width="${f(sw)}" height="${f(sh)}" rx="${f(sh / 2)}" $style/>',
          );
        case FlowShape.process:
          b.write(
            '<rect x="${f(x)}" y="${f(y)}" width="${f(sw)}" height="${f(sh)}" rx="4" $style/>',
          );
        case FlowShape.decision:
          b.write(
            '<polygon points="${f(cx)},${f(y)} ${f(x + sw)},${f(cy)} ${f(cx)},${f(y + sh)} ${f(x)},${f(cy)}" $style/>',
          );
        case FlowShape.io:
          final k = sw * 0.16;
          b.write(
            '<polygon points="${f(x + k)},${f(y)} ${f(x + sw)},${f(y)} ${f(x + sw - k)},${f(y + sh)} ${f(x)},${f(y + sh)}" $style/>',
          );
        case FlowShape.connector:
          b.write(
            '<ellipse cx="${f(cx)}" cy="${f(cy)}" rx="${f(sw / 2)}" ry="${f(sh / 2)}" $style/>',
          );
      }

      final ls = n.lines;
      final start = cy - (ls.length - 1) * _kLine / 2 + 4;
      for (var i = 0; i < ls.length; i++) {
        text(ls[i], cx, start + i * _kLine);
      }
    }

    for (final n in notes) {
      final ls = n.lines;
      for (var i = 0; i < ls.length; i++) {
        text(
          ls[i],
          n.side.x,
          n.y + 4 + 12 + i * _kNoteLine,
          anchor: 'start',
          size: 13,
          family: serif,
          weight: 'normal',
        );
      }
    }

    b.write('</svg>');
    return (svg: b.toString(), width: kFlowW, height: kFlowH);
  }
}

class FlowchartData {
  final List<FlowPage> pages;

  FlowchartData({List<FlowPage>? pages})
    : pages = (pages == null || pages.isEmpty) ? [FlowPage()] : pages;

  bool get isEmpty => pages.every((p) => p.isEmpty);
}

class FlowchartCodec {
  static String toHtml(FlowchartData d) {
    final out = StringBuffer();
    var first = true;
    for (final p in d.pages) {
      final r = p.toSvg();
      if (r == null) continue;
      final img = base64Encode(utf8.encode(r.svg));
      final json = base64Encode(utf8.encode(jsonEncode(p.toJson())));
      final brk = first ? '' : 'page-break-before:always;break-before:page;';
      out.write(
        '<div data-flowchart="$json" style="text-align:center;$brk">'
        '<img src="data:image/svg+xml;base64,$img" width="${r.width.round()}" '
        'style="max-width:100%;height:auto;"></div>',
      );
      first = false;
    }
    return out.toString();
  }

  static FlowchartData? fromHtml(String html) {
    final pages = <FlowPage>[];
    for (final m in RegExp(r'data-flowchart="([^"]+)"').allMatches(html)) {
      try {
        final j = jsonDecode(utf8.decode(base64Decode(m.group(1)!)));
        pages.add(FlowPage.fromJson(Map<String, dynamic>.from(j as Map)));
      } catch (_) {}
    }
    if (pages.isEmpty) return null;
    return FlowchartData(pages: pages);
  }
}

const Size _kChip = Size(120, 30);

class FlowchartBuilder extends StatefulWidget {
  final FlowchartData initial;

  final ValueChanged<FlowchartData> onChanged;

  const FlowchartBuilder({
    super.key,
    required this.initial,
    required this.onChanged,
  });

  @override
  State<FlowchartBuilder> createState() => _FlowchartBuilderState();
}

class _FlowchartBuilderState extends State<FlowchartBuilder> {
  final _boxKey = GlobalKey();
  late final FlowchartData _d = widget.initial;

  int _cur = 0;
  FlowPage get _p => _d.pages[_cur.clamp(0, _d.pages.length - 1)];

  int? _selectedNode;
  int? _selectedNote;
  FlowEdge? _selectedEdge;
  bool _connectMode = false;
  int? _connectFrom;

  Offset _rawPos = Offset.zero;
  double _rawY = 0;

  void _commit() => widget.onChanged(_d);

  void _select({int? node, int? note, FlowEdge? edge}) {
    _selectedNode = node;
    _selectedNote = note;
    _selectedEdge = edge;
  }

  FlowNode? get _node => _selectedNode == null ? null : _p.node(_selectedNode!);

  FlowNote? get _note {
    if (_selectedNote == null) return null;
    for (final n in _p.notes) {
      if (n.id == _selectedNote) return n;
    }
    return null;
  }

  void _goPage(int i) {
    if (i == _cur) return;
    setState(() {
      _cur = i;
      _select();
      _connectFrom = null;
    });
  }

  void _addPage() {
    setState(() {
      _d.pages.add(FlowPage());
      _cur = _d.pages.length - 1;
      _select();
      _connectFrom = null;
    });
    _commit();
  }

  Future<void> _deletePage() async {
    if (_d.pages.length <= 1) return;
    final ok = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text(
              'Remove Flowchart ${_cur + 1}',
              style: const TextStyle(fontSize: 15),
            ),
            content: const Text(
              'This will remove this whole flowchart box. Continue?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('No'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Yes'),
              ),
            ],
          ),
    );
    if (ok != true) return;
    setState(() {
      _d.pages.removeAt(_cur);
      _cur = math.min(_cur, _d.pages.length - 1);
      _select();
      _connectFrom = null;
    });
    _commit();
  }

  void _onDrop(DragTargetDetails<Object> d) {
    final box = _boxKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    final data = d.data;

    if (data is FlowShape) {
      final sz = data.size;
      final c = box.globalToLocal(
        d.offset + Offset(sz.width / 2, sz.height / 2),
      );
      _addNode(data, c - Offset(sz.width / 2, sz.height / 2));
    } else if (data is NoteSide) {
      final c = box.globalToLocal(
        d.offset + Offset(_kChip.width / 2, _kChip.height / 2),
      );
      _addNote(data, c.dy);
    }
  }

  void _addNode(FlowShape t, Offset topLeft) {
    setState(() {
      final n = FlowNode(_p.nextId++, t, topLeft, t.defaultText)..clamp();
      _snapNode(n);
      n.clamp();
      _p.nodes.add(n);
      _select(node: n.id);
    });
    _commit();
  }

  void _addNote(NoteSide side, double centerY) {
    setState(() {
      final n = FlowNote(_p.nextId++, side, 0, side.defaultText);
      n.y = _snapNoteY(n, centerY - n.height / 2);
      _p.notes.add(n);
      _select(note: n.id);
    });
    _commit();
  }

  void _snapNode(FlowNode n) {
    const th = 6.0;
    for (final o in _p.nodes) {
      if (o.id == n.id) continue;
      if ((o.center.dx - n.center.dx).abs() < th) {
        n.pos = Offset(o.center.dx - n.size.width / 2, n.pos.dy);
      }
      if ((o.center.dy - n.center.dy).abs() < th) {
        n.pos = Offset(n.pos.dx, o.center.dy - n.size.height / 2);
      }
    }
  }

  double _snapNoteY(FlowNote n, double rawY) {
    var y = n.clampY(rawY);
    final cy = y + n.height / 2;
    for (final o in _p.nodes) {
      if ((o.center.dy - cy).abs() < 8) {
        y = o.center.dy - n.height / 2;
        break;
      }
    }
    return n.clampY(y);
  }

  void _onNodeTap(FlowNode n) {
    var changed = false;
    setState(() {
      if (_connectMode) {
        if (_connectFrom == null) {
          _connectFrom = n.id;
        } else if (_connectFrom != n.id) {
          final exists = _p.edges.any(
            (e) => e.from == _connectFrom && e.to == n.id,
          );
          if (!exists) {
            _p.edges.add(FlowEdge(_connectFrom!, n.id));
            changed = true;
          }
          _connectFrom = null;
        }
      }
      _select(node: n.id);
    });
    if (changed) _commit();
  }

  Future<String?> _askText(String title, String initial, {int maxLines = 4}) {
    final c = TextEditingController(text: initial);
    return showDialog<String>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text(title, style: const TextStyle(fontSize: 15)),
            content: TextField(
              controller: c,
              autofocus: true,
              minLines: 1,
              maxLines: maxLines,
              keyboardType: TextInputType.multiline,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, c.text),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  Future<void> _editNode(FlowNode n) async {
    final r = await _askText('Edit text', n.text);
    if (r == null) return;
    setState(() => n.text = r);
    _commit();
  }

  Future<void> _editNote(FlowNote n) async {
    final r = await _askText(n.side.label, n.text, maxLines: 6);
    if (r == null) return;
    setState(() {
      n.text = r;
      n.y = n.clampY(n.y);
    });
    _commit();
  }

  Future<void> _editSelected() async {
    final n = _node;
    final t = _note;
    if (n != null) return _editNode(n);
    if (t != null) return _editNote(t);
  }

  Future<void> _editEdgeLabel() async {
    final e = _selectedEdge;
    if (e == null) return;
    final r = await _askText(
      'Arrow label (e.g. YES / NO)',
      e.label,
      maxLines: 1,
    );
    if (r == null) return;
    setState(() => e.label = r);
    _commit();
  }

  void _cycleLineStyle() {
    final e = _selectedEdge;
    if (e == null) return;
    setState(() => e.mode = (e.mode + 1) % 3);
    _commit();
  }

  void _deleteSelected() {
    setState(() {
      if (_selectedNode != null) {
        final id = _selectedNode!;
        _p.nodes.removeWhere((n) => n.id == id);
        _p.edges.removeWhere((e) => e.from == id || e.to == id);
        _connectFrom = null;
      } else if (_selectedNote != null) {
        _p.notes.removeWhere((n) => n.id == _selectedNote);
      } else if (_selectedEdge != null) {
        _p.edges.remove(_selectedEdge);
      }
      _select();
    });
    _commit();
  }

  Future<void> _confirmClear() async {
    final ok = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text(
              'Clear Flowchart ${_cur + 1}',
              style: const TextStyle(fontSize: 15),
            ),
            content: const Text('Remove all shapes, arrows and text here?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('No'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Yes'),
              ),
            ],
          ),
    );
    if (ok != true) return;
    setState(() {
      _p.nodes.clear();
      _p.edges.clear();
      _p.notes.clear();
      _select();
      _connectFrom = null;
    });
    _commit();
  }

  void _onBackgroundTap(Offset p) {
    FlowEdge? hit;
    var best = 10.0;
    for (final e in _p.edges) {
      final a = _p.node(e.from), b = _p.node(e.to);
      if (a == null || b == null) continue;
      final dist = _distToPath(p, flowPath(a, b, e.mode));
      if (dist < best) {
        best = dist;
        hit = e;
      }
    }
    setState(() {
      _select(edge: hit);
      if (!_connectMode) _connectFrom = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: LayoutBuilder(
        builder: (context, c) {
          final wide = c.maxWidth >= 700;
          final right = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _pageBar(),
              const Divider(height: 1),
              _toolbar(),
              const Divider(height: 1),
              Expanded(child: _canvas()),
            ],
          );

          if (wide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(width: 150, child: _palette(horizontal: false)),
                const VerticalDivider(width: 1),
                Expanded(child: right),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 92, child: _palette(horizontal: true)),
              const Divider(height: 1),
              Expanded(child: right),
            ],
          );
        },
      ),
    );
  }

  Widget _pageBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          for (var i = 0; i < _d.pages.length; i++)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: ChoiceChip(
                label: Text(
                  'Flowchart ${i + 1}',
                  style: const TextStyle(fontSize: 11),
                ),
                selected: i == _cur,
                onSelected: (_) => _goPage(i),
              ),
            ),
          TextButton.icon(
            onPressed: _addPage,
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Add flowchart', style: TextStyle(fontSize: 12)),
            style: TextButton.styleFrom(foregroundColor: primaryColor),
          ),
          TextButton.icon(
            onPressed: _d.pages.length > 1 ? _deletePage : null,
            icon: const Icon(Icons.delete_outline, size: 16),
            label: const Text(
              'Remove this flowchart',
              style: TextStyle(fontSize: 12),
            ),
            style: TextButton.styleFrom(foregroundColor: Colors.red.shade400),
          ),
        ],
      ),
    );
  }

  Widget _toolbar() {
    final hasSel =
        _selectedNode != null || _selectedNote != null || _selectedEdge != null;
    final canEditText = _selectedNode != null || _selectedNote != null;
    const modeNames = ['Straight', 'Elbow H', 'Elbow V'];

    Widget btn(IconData i, String l, VoidCallback? t, {Color? color}) {
      return TextButton.icon(
        onPressed: t,
        icon: Icon(i, size: 16),
        label: Text(l, style: const TextStyle(fontSize: 12)),
        style: TextButton.styleFrom(
          foregroundColor: color ?? Colors.black87,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          OutlinedButton.icon(
            onPressed:
                () => setState(() {
                  _connectMode = !_connectMode;
                  _connectFrom = null;
                }),
            icon: Icon(
              Icons.timeline,
              size: 16,
              color: _connectMode ? Colors.white : primaryColor,
            ),
            label: Text(
              _connectMode ? 'Connect: ON' : 'Connect: OFF',
              style: TextStyle(
                fontSize: 12,
                color: _connectMode ? Colors.white : primaryColor,
              ),
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: _connectMode ? primaryColor : Colors.transparent,
              side: BorderSide(color: primaryColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(width: 4),
          btn(
            Icons.edit_outlined,
            'Edit text',
            canEditText ? _editSelected : null,
          ),
          btn(
            Icons.label_outline,
            'Arrow label',
            _selectedEdge != null ? _editEdgeLabel : null,
          ),
          btn(
            Icons.turn_right,
            _selectedEdge != null
                ? 'Line: ${modeNames[_selectedEdge!.mode]}'
                : 'Line style',
            _selectedEdge != null ? _cycleLineStyle : null,
          ),
          btn(
            Icons.delete_outline,
            'Delete',
            hasSel ? _deleteSelected : null,
            color: Colors.red.shade400,
          ),
          btn(
            Icons.layers_clear_outlined,
            'Clear all',
            _p.isEmpty ? null : _confirmClear,
          ),
          if (_connectMode)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                _connectFrom == null
                    ? 'Tap the source shape'
                    : 'Now tap the target shape',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              ),
            ),
        ],
      ),
    );
  }

  Widget _palette({required bool horizontal}) {
    final items = <Widget>[
      for (final t in FlowShape.values) _shapeItem(t, horizontal),
      _noteItem(NoteSide.left, horizontal),
      _noteItem(NoteSide.right, horizontal),
    ];

    if (horizontal) {
      return ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(8),
        children: [
          for (final i in items)
            Padding(padding: const EdgeInsets.only(right: 12), child: i),
        ],
      );
    }
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        const Text(
          'Shapes',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        const SizedBox(height: 2),
        Text(
          'Drag to the box',
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 12),
        for (final i in items) ...[i, const SizedBox(height: 12)],
        const Divider(),
        Text(
          '• Add flowchart = another box (new page)\n'
          '• Shapes stay inside the middle column\n'
          '• Left/right text: drag up/down only\n'
          '• Double-tap = edit text\n'
          '• Connect: ON → tap 2 shapes\n'
          '• Tap arrow = label / line style',
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade700,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _dragItem({
    required Object data,
    required Size feedbackSize,
    required Widget feedback,
    required Widget tile,
    required bool horizontal,
  }) {
    Offset anchor(Draggable<Object> d, BuildContext c, Offset p) =>
        Offset(feedbackSize.width / 2, feedbackSize.height / 2);
    final ghost = Opacity(opacity: 0.35, child: tile);
    final fb = Material(
      color: Colors.transparent,
      child: Opacity(opacity: 0.85, child: feedback),
    );

    if (horizontal) {
      return LongPressDraggable<Object>(
        data: data,
        dragAnchorStrategy: anchor,
        feedback: fb,
        childWhenDragging: ghost,
        child: tile,
      );
    }
    return Draggable<Object>(
      data: data,
      dragAnchorStrategy: anchor,
      feedback: fb,
      childWhenDragging: ghost,
      child: tile,
    );
  }

  Widget _shapeItem(FlowShape t, bool horizontal) {
    return _dragItem(
      data: t,
      feedbackSize: t.size,
      horizontal: horizontal,
      feedback: _ShapeView(
        type: t,
        lines: t.wrap(t.defaultText),
        selected: false,
        highlighted: false,
      ),
      tile: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 90,
            height: 44,
            child: FittedBox(
              child: _ShapeView(
                type: t,
                lines: const [],
                selected: false,
                highlighted: false,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(t.label, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }

  Widget _noteItem(NoteSide s, bool horizontal) {
    Widget chip() => Container(
      width: _kChip.width,
      height: _kChip.height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: primaryColor),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        s.label,
        style: const TextStyle(
          fontSize: 11,
          color: Colors.black87,
          decoration: TextDecoration.none,
          fontWeight: FontWeight.w500,
        ),
      ),
    );

    return _dragItem(
      data: s,
      feedbackSize: _kChip,
      horizontal: horizontal,
      feedback: chip(),
      tile: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 90,
            height: 44,
            child: Center(
              child: Icon(
                s == NoteSide.left ? Icons.format_align_left : Icons.notes,
                size: 26,
                color: primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            s == NoteSide.left ? 'Left text' : 'Right text',
            style: const TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _canvas() {
    return Container(
      color: Colors.grey.shade200,
      padding: const EdgeInsets.all(12),
      child: Center(
        child: DragTarget<Object>(
          onAcceptWithDetails: _onDrop,
          builder:
              (context, _, __) => FittedBox(
                fit: BoxFit.scaleDown,
                child: SizedBox(
                  key: _boxKey,
                  width: kFlowW,
                  height: kFlowH,
                  child: _box(),
                ),
              ),
        ),
      ),
    );
  }

  Widget _box() {
    final p = _p;
    return ClipRect(
      key: ValueKey('page-$_cur'),
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: (d) => _onBackgroundTap(d.localPosition),
              child: CustomPaint(
                painter: _BoxPainter(data: p, selectedEdge: _selectedEdge),
              ),
            ),
          ),
          for (final n in p.notes) _noteWidget(n),
          for (final n in p.nodes)
            Positioned(
              left: n.pos.dx,
              top: n.pos.dy,
              child: GestureDetector(
                onTap: () => _onNodeTap(n),
                onDoubleTap: () => _editNode(n),
                onPanStart:
                    (_) => setState(() {
                      _select(node: n.id);
                      _rawPos = n.pos;
                    }),
                onPanUpdate:
                    (d) => setState(() {
                      _rawPos = _clampPos(_rawPos + d.delta, n.size);
                      n.pos = _rawPos;
                      _snapNode(n);
                      n.clamp();
                    }),
                onPanEnd: (_) => _commit(),
                child: _ShapeView(
                  type: n.type,
                  lines: n.lines,
                  selected: _selectedNode == n.id,
                  highlighted: _connectFrom == n.id,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _noteWidget(FlowNote n) {
    final selected = _selectedNote == n.id;
    return Positioned(
      left: n.side.x,
      top: n.y,
      width: n.side.width,
      height: n.height,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => setState(() => _select(note: n.id)),
        onDoubleTap: () => _editNote(n),
        onPanStart:
            (_) => setState(() {
              _select(note: n.id);
              _rawY = n.y;
            }),
        onPanUpdate:
            (d) => setState(() {
              _rawY = n.clampY(_rawY + d.delta.dy);
              n.y = _snapNoteY(n, _rawY);
            }),
        onPanEnd: (_) => _commit(),
        child: Container(
          decoration: BoxDecoration(
            color:
                selected
                    ? primaryColor.withValues(alpha: 0.10)
                    : Colors.grey.withValues(alpha: 0.10),
            border: selected ? Border.all(color: primaryColor) : null,
          ),
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            n.lines.join('\n'),
            softWrap: false,
            overflow: TextOverflow.visible,
            style: const TextStyle(
              fontFamily: 'Times New Roman',
              fontFamilyFallback: _kSerifFallback,
              fontSize: 13,
              height: _kNoteLine / 13,
              color: Colors.black,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  }
}

class _ShapeView extends StatelessWidget {
  final FlowShape type;
  final List<String> lines;
  final bool selected;
  final bool highlighted;

  const _ShapeView({
    required this.type,
    required this.lines,
    required this.selected,
    required this.highlighted,
  });

  @override
  Widget build(BuildContext context) {
    final s = type.size;
    return SizedBox(
      width: s.width,
      height: s.height,
      child: CustomPaint(
        painter: _ShapePainter(type, selected, highlighted),
        child: Center(
          child: Text(
            lines.join('\n'),
            textAlign: TextAlign.center,
            softWrap: false,
            overflow: TextOverflow.visible,
            style: const TextStyle(
              fontSize: 11,
              height: _kLine / 11,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  }
}

class _ShapePainter extends CustomPainter {
  final FlowShape type;
  final bool selected;
  final bool highlighted;

  _ShapePainter(this.type, this.selected, this.highlighted);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final path = Path();
    switch (type) {
      case FlowShape.terminator:
        path.addRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(0, 0, w, h),
            Radius.circular(h / 2),
          ),
        );
      case FlowShape.process:
        path.addRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(0, 0, w, h),
            const Radius.circular(4),
          ),
        );
      case FlowShape.decision:
        path
          ..moveTo(w / 2, 0)
          ..lineTo(w, h / 2)
          ..lineTo(w / 2, h)
          ..lineTo(0, h / 2)
          ..close();
      case FlowShape.io:
        final k = w * 0.16;
        path
          ..moveTo(k, 0)
          ..lineTo(w, 0)
          ..lineTo(w - k, h)
          ..lineTo(0, h)
          ..close();
      case FlowShape.connector:
        path.addOval(Rect.fromLTWH(0, 0, w, h));
    }

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.fill
        ..color = type.color.withValues(alpha: 0.10),
    );
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = selected || highlighted ? 3 : 1.6
        ..color =
            highlighted
                ? Colors.amber.shade700
                : selected
                ? primaryColor
                : Colors.black87,
    );
  }

  @override
  bool shouldRepaint(covariant _ShapePainter old) =>
      old.type != type ||
      old.selected != selected ||
      old.highlighted != highlighted;
}

class _BoxPainter extends CustomPainter {
  final FlowPage data;
  final FlowEdge? selectedEdge;

  _BoxPainter({required this.data, required this.selectedEdge});

  static const _serif = TextStyle(
    fontFamily: 'Times New Roman',
    fontFamilyFallback: _kSerifFallback,
    fontSize: 14,
    color: Colors.black,
  );

  void _headerText(Canvas canvas, List<String> lines, double cx) {
    final start = kFlowHeaderH / 2 - lines.length * 16 / 2;
    for (var i = 0; i < lines.length; i++) {
      final tp = TextPainter(
        text: TextSpan(text: lines[i], style: _serif),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
        canvas,
        Offset(cx - tp.width / 2, start + i * 16 + (16 - tp.height) / 2),
      );
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = Colors.white);

    final dot = Paint()..color = Colors.grey.shade300;
    for (double x = kFlowLeftW + 10; x < kFlowLeftW + kFlowMidW; x += 20) {
      for (double y = kFlowHeaderH + 10; y < kFlowH; y += 20) {
        canvas.drawCircle(Offset(x, y), 0.8, dot);
      }
    }

    final ink =
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;
    canvas.drawRect(Rect.fromLTWH(0.75, 0.75, kFlowW - 1.5, kFlowH - 1.5), ink);
    canvas.drawLine(
      const Offset(0, kFlowHeaderH),
      const Offset(kFlowW, kFlowHeaderH),
      ink,
    );
    canvas.drawLine(
      const Offset(kFlowLeftW, 0),
      const Offset(kFlowLeftW, kFlowH),
      ink,
    );
    canvas.drawLine(
      const Offset(kFlowLeftW + kFlowMidW, 0),
      const Offset(kFlowLeftW + kFlowMidW, kFlowH),
      ink,
    );

    _headerText(canvas, const ['Responsible', 'Person/TAT'], kFlowLeftW / 2);
    _headerText(canvas, const [
      'Flowchart Diagram',
    ], kFlowLeftW + kFlowMidW / 2);
    _headerText(canvas, const [
      'Description',
    ], kFlowLeftW + kFlowMidW + kFlowRightW / 2);

    // arrows
    for (final e in data.edges) {
      final a = data.node(e.from), b = data.node(e.to);
      if (a == null || b == null) continue;
      final pts = flowPath(a, b, e.mode);
      if ((pts.last - pts[pts.length - 2]).distance < 1) continue;

      final sel = identical(e, selectedEdge);
      final color = sel ? Colors.redAccent : Colors.black;

      final path = Path()..moveTo(pts.first.dx, pts.first.dy);
      for (final p in pts.skip(1)) {
        path.lineTo(p.dx, p.dy);
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = color
          ..strokeWidth = sel ? 2.6 : 1.4
          ..strokeJoin = StrokeJoin.round
          ..style = PaintingStyle.stroke,
      );

      final h = _arrowHead(pts[pts.length - 2], pts.last);
      canvas.drawPath(
        Path()
          ..moveTo(h[0].dx, h[0].dy)
          ..lineTo(h[1].dx, h[1].dy)
          ..lineTo(h[2].dx, h[2].dy)
          ..close(),
        Paint()..color = color,
      );

      if (e.label.trim().isNotEmpty) {
        final tw = _labelWidth(e.label);
        final mid = _labelCenter(pts, tw);
        final tp = TextPainter(
          text: TextSpan(
            text: e.label,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, mid - Offset(tp.width / 2, tp.height / 2));
      }
    }
  }

  @override
  bool shouldRepaint(covariant _BoxPainter old) => true;
}
