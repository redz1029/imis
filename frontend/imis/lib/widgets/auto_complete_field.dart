// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PgsAutocompleteField extends StatefulWidget {
  final TextEditingController controller;
  final bool readOnly;
  final String hintText;
  final List<String> suggestions;
  final String? Function(String?)? validator;
  final int? maxLines;
  final InputDecoration? decoration;
  final TextStyle? style;

  const PgsAutocompleteField({
    super.key,
    required this.controller,
    required this.suggestions,
    this.readOnly = false,
    this.hintText = '',
    this.validator,
    this.maxLines,
    this.decoration,
    this.style,
  });

  @override
  State<PgsAutocompleteField> createState() => _PgsAutocompleteFieldState();
}

class _PgsAutocompleteFieldState extends State<PgsAutocompleteField> {
  final FocusNode _focus = FocusNode();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlay;
  List<String> _matched = [];
  int _highlighted = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
    _focus.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _removeOverlay();
    widget.controller.removeListener(_onTextChanged);
    _focus.removeListener(_onFocusChanged);
    _focus.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (!_focus.hasFocus) {
      Future.delayed(const Duration(milliseconds: 150), _removeOverlay);
    }
  }

  void _onTextChanged() {
    final text = widget.controller.text.trim();
    if (text.isEmpty || widget.readOnly) {
      _removeOverlay();
      return;
    }

    final lower = text.toLowerCase();
    final matched =
        widget.suggestions
            .where(
              (s) =>
                  s.isNotEmpty &&
                  s.toLowerCase().contains(lower) &&
                  s.toLowerCase() != lower,
            )
            .toSet() // deduplicate
            .toList();

    if (matched.isEmpty) {
      _removeOverlay();
      return;
    }

    setState(() {
      _matched = matched;
      _highlighted = 0;
    });

    if (_overlay == null) {
      _showOverlay();
    } else {
      _overlay!.markNeedsBuild();
    }
  }

  void _showOverlay() {
    final overlay = Overlay.of(context);
    _overlay = OverlayEntry(builder: (_) => _buildOverlay());
    overlay.insert(_overlay!);
  }

  void _removeOverlay() {
    _overlay?.remove();
    _overlay = null;
    _matched = [];
  }

  void _accept(String value) {
    widget.controller.text = value;
    widget.controller.selection = TextSelection.fromPosition(
      TextPosition(offset: value.length),
    );
    _removeOverlay();
  }

  Widget _buildOverlay() {
    return Positioned(
      width: 400,
      child: CompositedTransformFollower(
        link: _layerLink,
        showWhenUnlinked: false,
        offset: const Offset(0, 42),
        child: Material(
          elevation: 6,
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 220),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header hint
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F4FF),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(8),
                    ),
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        size: 12,
                        color: Colors.blue.shade400,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Suggestions  •  Tab/↑↓ to navigate  •  Enter to accept',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Suggestion list
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: _matched.length,
                    separatorBuilder:
                        (_, __) =>
                            Divider(height: 1, color: Colors.grey.shade100),
                    itemBuilder: (_, idx) {
                      final isHighlighted = idx == _highlighted;
                      return InkWell(
                        onTap: () => _accept(_matched[idx]),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 100),
                          color:
                              isHighlighted
                                  ? const Color(0xFFE8F0FE)
                                  : Colors.transparent,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 9,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.history_rounded,
                                size: 13,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child:
                                    _highlighted ==
                                            idx // highlight matched portion
                                        ? _highlightedText(
                                          _matched[idx],
                                          widget.controller.text.trim(),
                                        )
                                        : Text(
                                          _matched[idx],
                                          style: const TextStyle(fontSize: 12),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: null,
                                        ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _highlightedText(String full, String query) {
    final lower = full.toLowerCase();
    final queryLower = query.toLowerCase();
    final start = lower.indexOf(queryLower);
    if (start == -1) {
      return Text(full, style: const TextStyle(fontSize: 12));
    }
    final end = start + queryLower.length;
    return RichText(
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
      text: TextSpan(
        style: const TextStyle(fontSize: 12, color: Colors.black87),
        children: [
          if (start > 0) TextSpan(text: full.substring(0, start)),
          TextSpan(
            text: full.substring(start, end),
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A73E8),
              backgroundColor: Color(0xFFE8F0FE),
            ),
          ),
          if (end < full.length) TextSpan(text: full.substring(end)),
        ],
      ),
    );
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    if (_overlay == null || _matched.isEmpty) return KeyEventResult.ignored;

    switch (event.logicalKey) {
      case LogicalKeyboardKey.tab:
        final shiftHeld =
            HardwareKeyboard.instance.logicalKeysPressed.contains(
              LogicalKeyboardKey.shiftLeft,
            ) ||
            HardwareKeyboard.instance.logicalKeysPressed.contains(
              LogicalKeyboardKey.shiftRight,
            );
        setState(() {
          _highlighted =
              shiftHeld
                  ? (_highlighted - 1 + _matched.length) % _matched.length
                  : (_highlighted + 1) % _matched.length;
        });
        _overlay?.markNeedsBuild();
        return KeyEventResult.handled;

      case LogicalKeyboardKey.arrowDown:
        setState(() {
          _highlighted = (_highlighted + 1) % _matched.length;
        });
        _overlay?.markNeedsBuild();
        return KeyEventResult.handled;

      case LogicalKeyboardKey.arrowUp:
        setState(() {
          _highlighted = (_highlighted - 1 + _matched.length) % _matched.length;
        });
        _overlay?.markNeedsBuild();
        return KeyEventResult.handled;

      case LogicalKeyboardKey.enter:
        _accept(_matched[_highlighted]);
        return KeyEventResult.handled;

      case LogicalKeyboardKey.escape:
        _removeOverlay();
        return KeyEventResult.handled;

      default:
        return KeyEventResult.ignored;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Focus(
        focusNode: FocusNode(skipTraversal: true),
        onKeyEvent: _handleKey,
        child: TextFormField(
          controller: widget.controller,
          focusNode: _focus,
          readOnly: widget.readOnly,
          maxLines: widget.maxLines,
          style:
              widget.style ??
              const TextStyle(fontSize: 12, color: Color(0xFF1A1D23)),
          decoration:
              widget.decoration ??
              InputDecoration(
                hintText: widget.hintText,
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
                isDense: true,
              ),
          validator: widget.validator,
        ),
      ),
    );
  }
}
