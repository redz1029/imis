import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/logo.png', width: 300),
        Text('CPeMS', style: TextStyle(fontSize: 32, color: primaryColor)),
      ],
    );
  }
}
