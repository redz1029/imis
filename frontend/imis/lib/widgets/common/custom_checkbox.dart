import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';

Widget customCheckbox({
  required bool value,
  required bool enabled,
  required ValueChanged<bool> onTap,
}) {
  return GestureDetector(
    onTap: enabled ? () => onTap(!value) : null,
    child: Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color:
            value
                ? (enabled ? primaryColor : primaryColor.withValues(alpha: 0.5))
                : Colors.transparent,
        border: Border.all(
          color: enabled ? primaryColor : primaryColor.withValues(alpha: 0.5),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child:
          value ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
    ),
  );
}
