import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';

class SwotGuidePage extends StatefulWidget {
  const SwotGuidePage({super.key});

  @override
  SwotGuidePageState createState() => SwotGuidePageState();
}

class SwotGuidePageState extends State<SwotGuidePage> {
  String? selectedModule;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.all(32.0),
              child: Column(
                children: [
                  _buildTitleProject(),
                  SizedBox(height: 24),

                  _buildModulesOverview(),
                  SizedBox(height: 24),

                  if (selectedModule != null) ...[SizedBox(height: 24)],
                ],
              ),
            ),

            // Footer
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleProject() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SWOT',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        Divider(),
        gap8px,
        Text(
          'The SWOT module is accessible only to the Standard User assigned to create it. The PGS Core Team, Service Head, and OSM have view-only access.',
          style: TextStyle(fontSize: 16, color: Colors.grey[600], height: 1.5),
        ),
      ],
    );
  }

  Widget _buildModulesOverview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create a new SWOT',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        Divider(),
        gap8px,
        Text.rich(
          TextSpan(
            text: 'Click ',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
            children: [
              TextSpan(
                text: 'SWOT ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              TextSpan(
                text: ' on the left sidebar to take you to the SWOT module.',
              ),
            ],
          ),
        ),
        gap8px,
        Center(
          child: Image.asset(
            'assets/swot1.png',
            width: 1500,
            fit: BoxFit.contain,
          ),
        ),
        gap16px,
        Text.rich(
          TextSpan(
            text:
                '• Once clicking the SWOT button, you can create a new SWOT by clicking ',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
            children: [
              TextSpan(
                text: '+ Add New',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              TextSpan(text: ' at the top right corner.'),
            ],
          ),
        ),
        gap8px,
        Center(
          child: Image.asset(
            'assets/swot2.png',
            width: 1500,
            fit: BoxFit.contain,
          ),
        ),
        gap16px,
        Text.rich(
          TextSpan(
            text: '• You are currently in the ',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
            children: [
              TextSpan(
                text: 'SWOT',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              TextSpan(text: ' template'),
            ],
          ),
        ),
        gap8px,
        Center(
          child: Image.asset(
            'assets/swot3.png',
            width: 1500,
            fit: BoxFit.contain,
          ),
        ),
        gap16px,
        Text.rich(
          TextSpan(
            text: '• Complete all fields before proceeding and click ',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
            children: [
              TextSpan(
                text: 'Save',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
        gap8px,
        Center(
          child: Image.asset(
            'assets/swot4.png',
            width: 1500,
            fit: BoxFit.contain,
          ),
        ),

        gap16px,
        Text.rich(
          TextSpan(
            text: '• Click ',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
            children: [
              TextSpan(
                text: 'Yes',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
        gap8px,
        Center(
          child: Image.asset(
            'assets/swot5.png',
            width: 1500,
            fit: BoxFit.contain,
          ),
        ),
        gap16px,
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      color: Colors.grey[800],
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Center(
        child: Text(
          '© 2026 CPeMS. All rights reserved.',
          style: TextStyle(color: Colors.grey[400], fontSize: 14),
        ),
      ),
    );
  }
}

class ModuleItem {
  final String name;
  final IconData icon;
  final String description;

  ModuleItem({
    required this.name,
    required this.icon,
    required this.description,
  });
}
