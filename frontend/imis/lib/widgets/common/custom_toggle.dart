import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';

class CustomToggle extends StatelessWidget {
  final String label;
  final bool value;
  final Color activeColor;
  final Color inactiveColor;
  final ValueChanged<bool> onChanged;

  const CustomToggle({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.activeColor = primaryColor,
    this.inactiveColor = grey,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 450,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          GestureDetector(
            onTap: () => onChanged(!value),
            child: Container(
              width: 50,
              height: 28,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: value ? activeColor : inactiveColor,
              ),
              child: AnimatedAlign(
                duration: Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 24,
                  height: 24,
                  margin: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
