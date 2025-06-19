import 'package:flutter/material.dart';

class CustomTooltip extends StatelessWidget {
  final String message;
  final Widget child;
  final Color backgroundColor;
  final TextStyle? textStyle;
  final bool preferBelow;

  const CustomTooltip({
    super.key,
    required this.message,
    required this.child,
    this.backgroundColor = Colors.black,
    this.textStyle,
    this.preferBelow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      textStyle: textStyle ?? const TextStyle(color: Colors.white),
      preferBelow: preferBelow,
      child: child,
    );
  }
}
