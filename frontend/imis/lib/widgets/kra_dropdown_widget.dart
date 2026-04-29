import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';

class KraDropdown extends StatefulWidget {
  final List<String> options;
  final bool hasEditPermission;
  final bool autoOpen;
  final ValueChanged<String?> onChanged;

  const KraDropdown({
    super.key,
    required this.options,
    required this.hasEditPermission,
    required this.autoOpen,
    required this.onChanged,
  });

  @override
  State<KraDropdown> createState() => _KraDropdownState();
}

class _KraDropdownState extends State<KraDropdown> {
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.autoOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _triggerOpen();
      });
    }
  }

  void _triggerOpen() {
    final ctx = _key.currentContext;
    if (ctx == null) return;
    // Find the EditableText or InkWell inside DropdownButtonFormField and tap it
    ctx.visitChildElements((element) {
      element.visitChildElements((e2) {
        final widget = e2.widget;
        if (widget is GestureDetector || widget is InkWell) {
          (e2).markNeedsBuild();
        }
      });
    });

    // More reliable: send a tap event at the widget center
    final RenderBox? box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return;
    final offset = box.localToGlobal(box.size.center(Offset.zero));
    WidgetsBinding.instance.handlePointerEvent(
      PointerDownEvent(position: offset),
    );
    WidgetsBinding.instance.handlePointerEvent(
      PointerUpEvent(position: offset),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      key: _key,
      initialValue: null,
      isExpanded: true,
      hint: const Text('-- Select KRA --', style: TextStyle(fontSize: 11)),
      items:
          widget.options.map((opt) {
            final isOthersOpt = opt == 'Others';
            return DropdownMenuItem(
              value: opt,
              child: Row(
                children: [
                  if (isOthersOpt)
                    const Icon(Icons.edit, size: 14, color: Colors.blueAccent),
                  if (isOthersOpt) const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      opt,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: isOthersOpt ? Colors.blueAccent : kText,
                        fontStyle:
                            isOthersOpt ? FontStyle.italic : FontStyle.normal,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
      onChanged: !widget.hasEditPermission ? null : widget.onChanged,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        isDense: true,
      ),
    );
  }
}
