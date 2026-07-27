import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:imis/constant/constant.dart';

class DottedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Widget? prefixIcon;

  const DottedButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: Radius.circular(4),
      dashPattern: [4, 3],
      color: primaryColor,
      strokeWidth: 1,
      child: InkWell(
        onTap: onPressed,
        splashColor: primaryColor.withValues(alpha: 0.1),
        highlightColor: primaryColor.withValues(alpha: 0.2),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (prefixIcon != null)
                Icon((prefixIcon as Icon).icon, color: primaryColor),
              SizedBox(width: 8),
              Text(text, style: TextStyle(color: primaryColor, fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}
