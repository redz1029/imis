// import 'dart:math' as math;

// import 'package:flutter/material.dart';

// class RichTextSamplePage extends StatefulWidget {
//   const RichTextSamplePage({super.key});

//   @override
//   State<RichTextSamplePage> createState() => _RichTextSamplePageState();
// }

// class _RichTextSamplePageState extends State<RichTextSamplePage> {
//   final RichTextController _controller = RichTextController();
//   TextSpan? _preview;

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _save() {
//     FocusScope.of(context).unfocus();
//     setState(() {
//       _preview = _controller.toTextSpan(
//         const TextStyle(fontSize: 16, height: 1.4, color: Colors.black87),
//       );
//     });
//   }

//   void _clear() {
//     _controller.clear();
//     setState(() => _preview = null);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Rich Text Editor')),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               RichTextEditor(
//                 controller: _controller,
//                 hintText: 'Type your notes here...',
//               ),
//               const SizedBox(height: 12),
//               Row(
//                 children: [
//                   Expanded(
//                     child: FilledButton.icon(
//                       onPressed: _save,
//                       icon: const Icon(Icons.visibility),
//                       label: const Text('Preview'),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: OutlinedButton.icon(
//                       onPressed: _clear,
//                       icon: const Icon(Icons.clear),
//                       label: const Text('Clear'),
//                     ),
//                   ),
//                 ],
//               ),
//               if (_preview != null) ...[
//                 const SizedBox(height: 16),
//                 const Text(
//                   'Preview',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 8),
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey.shade400),
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                   child: Text.rich(_preview!, textAlign: TextAlign.left),
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// /// Style ng bawat character.
// class CharStyle {
//   final bool bold;
//   final bool italic;
//   final bool underline;

//   const CharStyle({
//     this.bold = false,
//     this.italic = false,
//     this.underline = false,
//   });

//   CharStyle copyWith({bool? bold, bool? italic, bool? underline}) => CharStyle(
//     bold: bold ?? this.bold,
//     italic: italic ?? this.italic,
//     underline: underline ?? this.underline,
//   );

//   @override
//   bool operator ==(Object other) =>
//       other is CharStyle &&
//       other.bold == bold &&
//       other.italic == italic &&
//       other.underline == underline;

//   @override
//   int get hashCode => Object.hash(bold, italic, underline);
// }

// /// Controller na nagta-track ng style per character.
// class RichTextController extends TextEditingController {
//   List<CharStyle> _styles = [];
//   CharStyle typingStyle = const CharStyle();
//   String _prevText = '';
//   TextSelection _prevSelection = const TextSelection.collapsed(offset: -1);

//   RichTextController({String? text}) : super(text: text) {
//     _styles = List.filled(this.text.length, const CharStyle(), growable: true);
//     _prevText = this.text;
//     addListener(_onChanged);
//   }

//   void _onChanged() {
//     final newText = text;

//     // Text changed -> i-sync ang styles
//     if (newText != _prevText) {
//       int start = 0;
//       final minLen = math.min(_prevText.length, newText.length);
//       while (start < minLen && _prevText[start] == newText[start]) {
//         start++;
//       }
//       int endOld = _prevText.length;
//       int endNew = newText.length;
//       while (endOld > start &&
//           endNew > start &&
//           _prevText[endOld - 1] == newText[endNew - 1]) {
//         endOld--;
//         endNew--;
//       }

//       if (_styles.length != _prevText.length) {
//         _styles = List.filled(
//           _prevText.length,
//           const CharStyle(),
//           growable: true,
//         );
//       }
//       _styles.replaceRange(
//         start,
//         endOld,
//         List.filled(endNew - start, typingStyle),
//       );
//       _prevText = newText;
//       _prevSelection = selection;
//       return;
//     }

//     if (selection != _prevSelection) {
//       _prevSelection = selection;
//       if (selection.isValid && selection.isCollapsed && _styles.isNotEmpty) {
//         final i = selection.baseOffset;
//         if (i > 0) {
//           typingStyle = _styles[math.min(i, _styles.length) - 1];
//         } else {
//           typingStyle = _styles.first;
//         }
//       }
//     }
//   }

//   bool get _hasRange =>
//       selection.isValid && !selection.isCollapsed && _styles.isNotEmpty;

//   bool _isOn(bool Function(CharStyle) get) {
//     if (_hasRange) {
//       final s = math.min(selection.start, _styles.length);
//       final e = math.min(selection.end, _styles.length);
//       if (e > s) return _styles.sublist(s, e).every(get);
//     }
//     return get(typingStyle);
//   }

//   void _toggle(
//     bool Function(CharStyle) get,
//     CharStyle Function(CharStyle, bool) set,
//   ) {
//     final newValue = !_isOn(get);
//     if (_hasRange) {
//       final s = math.min(selection.start, _styles.length);
//       final e = math.min(selection.end, _styles.length);
//       for (int i = s; i < e; i++) {
//         _styles[i] = set(_styles[i], newValue);
//       }
//     }
//     typingStyle = set(typingStyle, newValue);
//     notifyListeners();
//   }

//   bool get isBold => _isOn((s) => s.bold);
//   bool get isItalic => _isOn((s) => s.italic);
//   bool get isUnderline => _isOn((s) => s.underline);

//   void toggleBold() => _toggle((s) => s.bold, (s, v) => s.copyWith(bold: v));
//   void toggleItalic() =>
//       _toggle((s) => s.italic, (s, v) => s.copyWith(italic: v));
//   void toggleUnderline() =>
//       _toggle((s) => s.underline, (s, v) => s.copyWith(underline: v));

//   TextStyle _toTextStyle(CharStyle c) => TextStyle(
//     fontWeight: c.bold ? FontWeight.bold : FontWeight.normal,
//     fontStyle: c.italic ? FontStyle.italic : FontStyle.normal,
//     decoration: c.underline ? TextDecoration.underline : TextDecoration.none,
//   );

//   /// Gamitin ito kung gusto mong i-display (read-only) ang laman ng editor.
//   TextSpan toTextSpan([TextStyle? base]) {
//     final t = text;
//     if (t.isEmpty) return TextSpan(style: base, text: '');
//     if (_styles.length != t.length) {
//       _styles = List.filled(t.length, const CharStyle(), growable: true);
//     }
//     final children = <TextSpan>[];
//     int s = 0;
//     for (int i = 1; i <= t.length; i++) {
//       if (i == t.length || _styles[i] != _styles[s]) {
//         children.add(
//           TextSpan(text: t.substring(s, i), style: _toTextStyle(_styles[s])),
//         );
//         s = i;
//       }
//     }
//     return TextSpan(style: base, children: children);
//   }

//   @override
//   TextSpan buildTextSpan({
//     required BuildContext context,
//     TextStyle? style,
//     required bool withComposing,
//   }) => toTextSpan(style);

//   @override
//   void dispose() {
//     removeListener(_onChanged);
//     super.dispose();
//   }
// }

// /// Rich text editor widget: Bold, Italic, Underline, Left/Center/Right/Justify.
// class RichTextEditor extends StatefulWidget {
//   final RichTextController? controller;
//   final String hintText;
//   final TextStyle? textStyle;
//   final int? minLines;

//   const RichTextEditor({
//     super.key,
//     this.controller,
//     this.hintText = 'Type here...',
//     this.textStyle,
//     this.minLines = 10,
//   });

//   @override
//   State<RichTextEditor> createState() => _RichTextEditorState();
// }

// class _RichTextEditorState extends State<RichTextEditor> {
//   late final RichTextController _controller;
//   late final bool _ownsController;
//   TextAlign _align = TextAlign.left;

//   @override
//   void initState() {
//     super.initState();
//     _ownsController = widget.controller == null;
//     _controller = widget.controller ?? RichTextController();
//   }

//   @override
//   void dispose() {
//     if (_ownsController) _controller.dispose();
//     super.dispose();
//   }

//   Widget _toolButton({
//     required IconData icon,
//     required bool active,
//     required VoidCallback onPressed,
//     required String tooltip,
//   }) {
//     final cs = Theme.of(context).colorScheme;
//     return IconButton(
//       tooltip: tooltip,
//       icon: Icon(icon, size: 20),
//       onPressed: onPressed,
//       style: IconButton.styleFrom(
//         backgroundColor: active ? cs.primaryContainer : null,
//         foregroundColor: active ? cs.onPrimaryContainer : null,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         // ExcludeFocus para hindi mawala ang focus/selection sa TextField
//         ExcludeFocus(
//           child: ListenableBuilder(
//             listenable: _controller,
//             builder:
//                 (context, _) => Wrap(
//                   spacing: 2,
//                   runSpacing: 2,
//                   crossAxisAlignment: WrapCrossAlignment.center,
//                   children: [
//                     _toolButton(
//                       icon: Icons.format_bold,
//                       active: _controller.isBold,
//                       onPressed: _controller.toggleBold,
//                       tooltip: 'Bold',
//                     ),
//                     _toolButton(
//                       icon: Icons.format_italic,
//                       active: _controller.isItalic,
//                       onPressed: _controller.toggleItalic,
//                       tooltip: 'Italic',
//                     ),
//                     _toolButton(
//                       icon: Icons.format_underlined,
//                       active: _controller.isUnderline,
//                       onPressed: _controller.toggleUnderline,
//                       tooltip: 'Underline',
//                     ),
//                     const SizedBox(
//                       height: 24,
//                       child: VerticalDivider(width: 12),
//                     ),
//                     _toolButton(
//                       icon: Icons.format_align_left,
//                       active: _align == TextAlign.left,
//                       onPressed: () => setState(() => _align = TextAlign.left),
//                       tooltip: 'Align left',
//                     ),
//                     _toolButton(
//                       icon: Icons.format_align_center,
//                       active: _align == TextAlign.center,
//                       onPressed:
//                           () => setState(() => _align = TextAlign.center),
//                       tooltip: 'Align center',
//                     ),
//                     _toolButton(
//                       icon: Icons.format_align_right,
//                       active: _align == TextAlign.right,
//                       onPressed: () => setState(() => _align = TextAlign.right),
//                       tooltip: 'Align right',
//                     ),
//                     _toolButton(
//                       icon: Icons.format_align_justify,
//                       active: _align == TextAlign.justify,
//                       onPressed:
//                           () => setState(() => _align = TextAlign.justify),
//                       tooltip: 'Justify',
//                     ),
//                   ],
//                 ),
//           ),
//         ),
//         const SizedBox(height: 8),
//         TextField(
//           controller: _controller,
//           textAlign: _align,
//           keyboardType: TextInputType.multiline,
//           minLines: widget.minLines,
//           maxLines: null,
//           style: widget.textStyle ?? const TextStyle(fontSize: 16, height: 1.4),
//           decoration: InputDecoration(
//             hintText: widget.hintText,
//             border: const OutlineInputBorder(),
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'dart:math' as math;
import 'package:flutter/material.dart';

enum NodeType { terminator, process, decision, io, connector }

extension NodeTypeX on NodeType {
  String get label => switch (this) {
    NodeType.terminator => 'Start / End',
    NodeType.process => 'Process',
    NodeType.decision => 'Decision',
    NodeType.io => 'Input / Output',
    NodeType.connector => 'Connector',
  };

  Size get size => switch (this) {
    NodeType.terminator => const Size(120, 56),
    NodeType.process => const Size(130, 64),
    NodeType.decision => const Size(140, 90),
    NodeType.io => const Size(140, 64),
    NodeType.connector => const Size(56, 56),
  };

  Color get color => switch (this) {
    NodeType.terminator => const Color(0xFF2E7D32),
    NodeType.process => const Color(0xFF1565C0),
    NodeType.decision => const Color(0xFFEF6C00),
    NodeType.io => const Color(0xFF6A1B9A),
    NodeType.connector => const Color(0xFF455A64),
  };

  String get defaultText => switch (this) {
    NodeType.terminator => 'Start',
    NodeType.process => 'Process',
    NodeType.decision => 'Condition?',
    NodeType.io => 'Input',
    NodeType.connector => 'A',
  };
}

class FlowNode {
  final int id;
  final NodeType type;
  Offset pos; // top-left
  String text;
  FlowNode(this.id, this.type, this.pos, this.text);

  Size get size => type.size;
  Offset get center => pos + Offset(size.width / 2, size.height / 2);
  Rect get rect => pos & size;
}

class FlowEdge {
  final int from;
  final int to;
  String label;
  FlowEdge(this.from, this.to, [this.label = '']);
}

class FlowchartPage extends StatefulWidget {
  const FlowchartPage({super.key});

  @override
  State<FlowchartPage> createState() => _FlowchartPageState();
}

class _FlowchartPageState extends State<FlowchartPage> {
  final _canvasKey = GlobalKey();
  final List<FlowNode> _nodes = [];
  final List<FlowEdge> _edges = [];
  int _idCounter = 0;

  int? _selectedNode;
  FlowEdge? _selectedEdge;
  bool _connectMode = false;
  int? _connectFrom;

  FlowNode? _node(int id) {
    for (final n in _nodes) {
      if (n.id == id) return n;
    }
    return null;
  }

  void _addNode(NodeType type, Offset topLeft) {
    final s = type.size;
    final p = Offset(math.max(0, topLeft.dx), math.max(0, topLeft.dy));
    setState(() {
      final n = FlowNode(++_idCounter, type, p, type.defaultText);
      _nodes.add(n);
      _selectedNode = n.id;
      _selectedEdge = null;
    });
    // ignore: unused_local_variable
    final _ = s;
  }

  void _onNodeTap(FlowNode n) {
    setState(() {
      if (_connectMode) {
        if (_connectFrom == null) {
          _connectFrom = n.id;
        } else if (_connectFrom != n.id) {
          final exists = _edges.any(
            (e) => e.from == _connectFrom && e.to == n.id,
          );
          if (!exists) _edges.add(FlowEdge(_connectFrom!, n.id));
          _connectFrom = null;
        }
      }
      _selectedNode = n.id;
      _selectedEdge = null;
    });
  }

  Future<String?> _askText(String title, String initial) {
    final c = TextEditingController(text: initial);
    return showDialog<String>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text(title),
            content: TextField(
              controller: c,
              autofocus: true,
              maxLines: 3,
              minLines: 1,
              onSubmitted: (v) => Navigator.pop(ctx, v),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, c.text),
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  Future<void> _editNode(FlowNode n) async {
    final r = await _askText('Edit text', n.text);
    if (r != null) setState(() => n.text = r);
  }

  Future<void> _editEdgeLabel() async {
    final e = _selectedEdge;
    if (e == null) return;
    final r = await _askText('Arrow label (e.g. Yes / No)', e.label);
    if (r != null) setState(() => e.label = r);
  }

  void _deleteSelected() {
    setState(() {
      if (_selectedNode != null) {
        final id = _selectedNode!;
        _nodes.removeWhere((n) => n.id == id);
        _edges.removeWhere((e) => e.from == id || e.to == id);
        _selectedNode = null;
        _connectFrom = null;
      } else if (_selectedEdge != null) {
        _edges.remove(_selectedEdge);
        _selectedEdge = null;
      }
    });
  }

  void _clearAll() {
    setState(() {
      _nodes.clear();
      _edges.clear();
      _selectedNode = null;
      _selectedEdge = null;
      _connectFrom = null;
    });
  }

  void _onBackgroundTap(Offset p) {
    FlowEdge? hit;
    double best = 10;
    for (final e in _edges) {
      final a = _node(e.from), b = _node(e.to);
      if (a == null || b == null) continue;
      final s = anchorPoint(a, b.center);
      final t = anchorPoint(b, a.center);
      final d = _distToSegment(p, s, t);
      if (d < best) {
        best = d;
        hit = e;
      }
    }
    setState(() {
      _selectedEdge = hit;
      _selectedNode = null;
      if (!_connectMode) _connectFrom = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasSelection = _selectedNode != null || _selectedEdge != null;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Flowchart Builder'),
        actions: [
          Tooltip(
            message: 'Connect mode: tap source node, then target node',
            child: TextButton.icon(
              onPressed:
                  () => setState(() {
                    _connectMode = !_connectMode;
                    _connectFrom = null;
                  }),
              icon: Icon(
                Icons.timeline,
                color: _connectMode ? Colors.amber : Colors.white70,
              ),
              label: Text(
                _connectMode ? 'Connect: ON' : 'Connect: OFF',
                style: TextStyle(
                  color: _connectMode ? Colors.amber : Colors.white70,
                ),
              ),
            ),
          ),
          if (_selectedEdge != null)
            IconButton(
              tooltip: 'Edit arrow label',
              icon: const Icon(Icons.label_outline),
              onPressed: _editEdgeLabel,
            ),
          IconButton(
            tooltip: 'Delete selected',
            icon: const Icon(Icons.delete_outline),
            onPressed: hasSelection ? _deleteSelected : null,
          ),
          IconButton(
            tooltip: 'Clear all',
            icon: const Icon(Icons.layers_clear_outlined),
            onPressed: _nodes.isEmpty ? null : _clearAll,
          ),
        ],
      ),
      body: Row(
        children: [
          _palette(),
          const VerticalDivider(width: 1),
          Expanded(child: _canvas()),
        ],
      ),
    );
  }

  Widget _palette() {
    return Container(
      width: 150,
      color: Colors.white,
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          const Text(
            'Shapes',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            'Drag to canvas',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 12),
          for (final t in NodeType.values) ...[
            Draggable<NodeType>(
              data: t,
              feedback: Material(
                color: Colors.transparent,
                child: Opacity(
                  opacity: 0.8,
                  child: _ShapeView(
                    type: t,
                    text: t.defaultText,
                    selected: false,
                    highlighted: false,
                  ),
                ),
              ),
              childWhenDragging: Opacity(opacity: 0.35, child: _paletteItem(t)),
              child: _paletteItem(t),
            ),
            const SizedBox(height: 12),
          ],
          const Divider(),
          Text(
            '• Double-tap shape = edit text\n'
            '• Connect: ON → tap 2 shapes\n'
            '• Tap arrow = select / label\n'
            '• Delete icon = remove',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _paletteItem(NodeType t) {
    return Column(
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: _ShapeView(
            type: t,
            text: '',
            selected: false,
            highlighted: false,
            scale: 0.8,
          ),
        ),
        const SizedBox(height: 4),
        Text(t.label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }

  Widget _canvas() {
    return DragTarget<NodeType>(
      onAcceptWithDetails: (d) {
        final box = _canvasKey.currentContext!.findRenderObject() as RenderBox;
        _addNode(d.data, box.globalToLocal(d.offset));
      },
      builder: (context, _, __) {
        return ClipRect(
          child: Container(
            key: _canvasKey,
            color: Colors.white,
            child: Stack(
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTapDown: (d) => _onBackgroundTap(d.localPosition),
                    child: CustomPaint(
                      painter: _CanvasPainter(
                        nodes: _nodes,
                        edges: _edges,
                        selectedEdge: _selectedEdge,
                      ),
                    ),
                  ),
                ),
                for (final n in _nodes)
                  Positioned(
                    left: n.pos.dx,
                    top: n.pos.dy,
                    child: GestureDetector(
                      onTap: () => _onNodeTap(n),
                      onDoubleTap: () => _editNode(n),
                      onPanStart:
                          (_) => setState(() {
                            _selectedNode = n.id;
                            _selectedEdge = null;
                          }),
                      onPanUpdate:
                          (d) => setState(() {
                            final np = n.pos + d.delta;
                            n.pos = Offset(
                              math.max(0, np.dx),
                              math.max(0, np.dy),
                            );
                          }),
                      child: _ShapeView(
                        type: n.type,
                        text: n.text,
                        selected: _selectedNode == n.id,
                        highlighted: _connectFrom == n.id,
                      ),
                    ),
                  ),
                if (_nodes.isEmpty)
                  Center(
                    child: Text(
                      'Drag shapes here',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 18,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ───────────────────────── Shape widget ─────────────────────────

class _ShapeView extends StatelessWidget {
  final NodeType type;
  final String text;
  final bool selected;
  final bool highlighted;
  final double scale;

  const _ShapeView({
    required this.type,
    required this.text,
    required this.selected,
    required this.highlighted,
    this.scale = 1,
  });

  @override
  Widget build(BuildContext context) {
    final s = type.size * scale;
    return SizedBox(
      width: s.width,
      height: s.height,
      child: CustomPaint(
        painter: _ShapePainter(type, selected, highlighted),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal:
                  type == NodeType.decision || type == NodeType.io ? 26 : 10,
            ),
            child: Text(
              text,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12 * scale,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ShapePainter extends CustomPainter {
  final NodeType type;
  final bool selected;
  final bool highlighted;
  _ShapePainter(this.type, this.selected, this.highlighted);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final path = Path();
    switch (type) {
      case NodeType.terminator:
        path.addRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(0, 0, w, h),
            Radius.circular(h / 2),
          ),
        );
        break;
      case NodeType.process:
        path.addRect(Rect.fromLTWH(0, 0, w, h));
        break;
      case NodeType.decision:
        path
          ..moveTo(w / 2, 0)
          ..lineTo(w, h / 2)
          ..lineTo(w / 2, h)
          ..lineTo(0, h / 2)
          ..close();
        break;
      case NodeType.io:
        final k = size.width * 0.16;
        path
          ..moveTo(k, 0)
          ..lineTo(w, 0)
          ..lineTo(w - k, h)
          ..lineTo(0, h)
          ..close();
        break;
      case NodeType.connector:
        path.addOval(Rect.fromLTWH(0, 0, w, h));
        break;
    }

    final fill =
        Paint()
          ..style = PaintingStyle.fill
          ..color = type.color.withValues(alpha: 0.15);
    final stroke =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = selected || highlighted ? 3 : 2
          ..color =
              highlighted
                  ? Colors.amber.shade700
                  : selected
                  ? Colors.black87
                  : type.color;
    canvas.drawPath(path, fill);
    canvas.drawPath(path, stroke);
  }

  @override
  bool shouldRepaint(covariant _ShapePainter old) =>
      old.type != type ||
      old.selected != selected ||
      old.highlighted != highlighted;
}

// ───────────────────────── Canvas painter (grid + arrows) ─────────────────────────

Offset anchorPoint(FlowNode n, Offset toward) {
  final c = n.center;
  final d = toward - c;
  final w = n.size.width, h = n.size.height;
  if (d.dx.abs() / w > d.dy.abs() / h) {
    return Offset(d.dx > 0 ? n.pos.dx + w : n.pos.dx, c.dy);
  }
  return Offset(c.dx, d.dy > 0 ? n.pos.dy + h : n.pos.dy);
}

double _distToSegment(Offset p, Offset a, Offset b) {
  final ab = b - a;
  final len2 = ab.dx * ab.dx + ab.dy * ab.dy;
  if (len2 == 0) return (p - a).distance;
  var t = ((p - a).dx * ab.dx + (p - a).dy * ab.dy) / len2;
  t = t.clamp(0.0, 1.0);
  final proj = a + ab * t;
  return (p - proj).distance;
}

class _CanvasPainter extends CustomPainter {
  final List<FlowNode> nodes;
  final List<FlowEdge> edges;
  final FlowEdge? selectedEdge;

  _CanvasPainter({
    required this.nodes,
    required this.edges,
    required this.selectedEdge,
  });

  FlowNode? _find(int id) {
    for (final n in nodes) {
      if (n.id == id) return n;
    }
    return null;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // dot grid
    final dot = Paint()..color = Colors.grey.shade300;
    for (double x = 0; x < size.width; x += 24) {
      for (double y = 0; y < size.height; y += 24) {
        canvas.drawCircle(Offset(x, y), 1, dot);
      }
    }

    for (final e in edges) {
      final a = _find(e.from), b = _find(e.to);
      if (a == null || b == null) continue;
      final s = anchorPoint(a, b.center);
      final t = anchorPoint(b, a.center);
      final isSel = identical(e, selectedEdge);
      final color = isSel ? Colors.redAccent : Colors.black87;

      final line =
          Paint()
            ..color = color
            ..strokeWidth = isSel ? 3 : 2
            ..style = PaintingStyle.stroke;
      canvas.drawLine(s, t, line);

      // arrow head
      final ang = math.atan2(t.dy - s.dy, t.dx - s.dx);
      const len = 12.0;
      final p1 = t - Offset(math.cos(ang - 0.4), math.sin(ang - 0.4)) * len;
      final p2 = t - Offset(math.cos(ang + 0.4), math.sin(ang + 0.4)) * len;
      final head =
          Path()
            ..moveTo(t.dx, t.dy)
            ..lineTo(p1.dx, p1.dy)
            ..lineTo(p2.dx, p2.dy)
            ..close();
      canvas.drawPath(head, Paint()..color = color);

      // label
      if (e.label.isNotEmpty) {
        final mid = Offset((s.dx + t.dx) / 2, (s.dy + t.dy) / 2);
        final tp = TextPainter(
          text: TextSpan(
            text: e.label,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        final r = Rect.fromCenter(
          center: mid,
          width: tp.width + 10,
          height: tp.height + 4,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(r, const Radius.circular(6)),
          Paint()..color = Colors.white,
        );
        tp.paint(canvas, mid - Offset(tp.width / 2, tp.height / 2));
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CanvasPainter old) => true;
}
