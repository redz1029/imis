import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';

class FilterButton extends StatelessWidget {
  final String label;
  final String floatingLabel;
  const FilterButton({
    super.key,
    required this.label,
    required this.floatingLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          margin: EdgeInsets.only(top: 8),
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
        ),
        // Floating label
        Positioned(
          left: 16,
          top: 0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4),
            color: mainBgColor,
            child: Text(
              floatingLabel,
              style: TextStyle(fontSize: 12, color: grey),
            ),
          ),
        ),
      ],
    );
  }
}
