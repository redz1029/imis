import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';

class FilterButton extends StatelessWidget {
  final String label;
  const FilterButton({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: mainBgColor,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(Icons.filter_list, size: 16, color: grey),
          SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
