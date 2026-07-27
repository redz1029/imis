import 'package:flutter/material.dart';

class BuildHeaderCell extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final FontStyle fontStyle;

  const BuildHeaderCell({
    super.key,
    required this.text,
    this.color = Colors.black,
    this.fontSize = 15,
    this.fontStyle = FontStyle.normal,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
            color: color,
            fontStyle: fontStyle,
          ),
        ),
      ),
    );
  }
}
