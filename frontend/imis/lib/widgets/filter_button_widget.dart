import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';

class FilterButton extends StatelessWidget {
  final String label;
  final bool isActive;

  const FilterButton({super.key, required this.label, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color:
            isActive ? primaryColor.withValues(alpha: 0.1) : Colors.transparent,
        border: Border.all(
          color: isActive ? primaryColor : Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Text(label, style: TextStyle(color: Colors.black)),
          const SizedBox(width: 4),
          Icon(Icons.arrow_drop_down, size: 16, color: Colors.black54),
        ],
      ),
    );
  }
}
