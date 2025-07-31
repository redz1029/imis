import 'package:flutter/material.dart';

class CustomTooltip extends StatefulWidget {
  final String message;
  final Widget child;
  final Color backgroundColor;
  final TextStyle? textStyle;
  final bool preferBelow;
  final int maxLines;

  const CustomTooltip({
    super.key,
    required this.message,
    required this.child,
    this.backgroundColor = Colors.black54,
    this.textStyle,
    this.preferBelow = true,
    this.maxLines = 4,
  });

  @override
  State<CustomTooltip> createState() => _CustomTooltipState();
}

class _CustomTooltipState extends State<CustomTooltip> {
  OverlayEntry? _overlayEntry;
  final _layerLink = LayerLink();
  bool _isVisible = false;

  @override
  void dispose() {
    _hideTooltip();
    super.dispose();
  }

  void _showTooltip() {
    if (_isVisible) return;
    _isVisible = true;

    final renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            left: offset.dx,
            width: size.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset:
                  widget.preferBelow
                      ? Offset(0, size.height + 8)
                      : Offset(0, -8),
              child: Material(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.8,
                  ),
                  child: TooltipContent(
                    message: widget.message,
                    backgroundColor: widget.backgroundColor,
                    textStyle: widget.textStyle,
                    maxLines: widget.maxLines,
                  ),
                ),
              ),
            ),
          ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideTooltip() {
    if (!_isVisible) return;
    _isVisible = false;
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: MouseRegion(
        onEnter: (event) => _showTooltip(),
        onExit: (event) => _hideTooltip(),
        child: GestureDetector(
          onTapDown: (details) => _showTooltip(),
          onTapUp: (details) => _hideTooltip(),
          onTapCancel: () => _hideTooltip(),
          child: widget.child,
        ),
      ),
    );
  }
}

class TooltipContent extends StatelessWidget {
  final String message;
  final Color backgroundColor;
  final TextStyle? textStyle;
  final int maxLines;

  const TooltipContent({
    super.key,
    required this.message,
    required this.backgroundColor,
    this.textStyle,
    this.maxLines = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        message,
        style: (textStyle ?? const TextStyle(color: Colors.white)).copyWith(
          fontSize: 14,
        ),
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
