import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';

class ToolKitPage extends StatefulWidget {
  const ToolKitPage({super.key});

  @override
  State<ToolKitPage> createState() => _ToolKitPageState();
}

class _ToolKitPageState extends State<ToolKitPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBgColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.all(32.0),
              child: Column(children: [_buildFirstRow()]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFirstRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Frequently Asked Questions',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ],
        ),
        Divider(),
        gap8px,
        Text(
          '1. What is PGS?',
          style: TextStyle(fontSize: 18, color: primaryColor, height: 1.5),
        ),
        SizedBox(height: 12),
        Text(
          'The Performance Governance System (PGS) is a comprehensive framework that guides organizations to improve performance, promote, accountability, and ensure continous service improvement. PGS helps CRMC do things better, measure results, and deliver excellent service to patients and the community.',
          style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.5),
        ),
        SizedBox(height: 12),
        Center(
          child: Image.asset(
            'assets/strat_roadmap.jpg',
            width: 1500,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}
