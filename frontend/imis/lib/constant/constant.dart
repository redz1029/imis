import 'package:flutter/material.dart';

//Colors
const primaryColor = Color.fromRGBO(192, 74, 74, 1);
const secondaryBgButton = Color.fromRGBO(192, 74, 74, 0.226);
const primaryLightColor = Color.fromRGBO(192, 74, 74, 0.644);
const secondaryColor = Color.fromRGBO(253, 252, 250, 1);
const mainBgColor = Color.fromRGBO(245, 245, 245, 1);
const grey = Color.fromRGBO(161, 161, 161, 1);
const lightGrey = Color.fromRGBO(217, 217, 217, 1);
const lightGrey1 = Color.fromRGBO(245, 245, 245, 1);
const primaryTextColor = Color.fromRGBO(65, 65, 65, 1);

//Sizing
const gap = SizedBox(height: 16);
const gap1 = SizedBox(height: 14);
const gap2 = SizedBox(height: 4);
const gap3 = SizedBox(height: 32);

//For Logo Widget
class Logo extends StatelessWidget {
  const Logo({super.key}); // Add a const constructor

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [Image.asset('assets/logo.png', width: 300)],
    );
  }
}

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
      padding: const EdgeInsets.all(20.0),
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
