import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';

class CircleTextWidget extends StatelessWidget {
  final String text;
  final Color color;
  final double size;

  const CircleTextWidget({
    super.key,
    required this.text,
    this.color = primaryColor,
    this.size = 80.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
