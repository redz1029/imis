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
            text: '• Select ',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
            children: [
              TextSpan(
                text: 'Process (Core & Support)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              TextSpan(text: ' from the panel.'),
            ],
          ),
        ),
        gap8px,
        Center(
          child: Image.asset(
            'assets/roadmap3.png',
            width: 1500,
            fit: BoxFit.contain,
          ),
        ),
        gap16px,
        Text.rich(
          TextSpan(
            text: '• Select ',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
            children: [
              TextSpan(
                text: 'Roadmap Period.',
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
            'assets/roadmap4.png',
            width: 1500,
            fit: BoxFit.contain,
          ),
        ),

        gap16px,
        Text.rich(
          TextSpan(
            text: '• Roadmap panel displayed. First, create a minimum of ',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
            children: [
              TextSpan(
                text: '2 KPIs',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              TextSpan(
                text: '. Click ',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              TextSpan(
                text: '‘Add KPI’ ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              TextSpan(
                text: ' to add additional ones. ',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        gap8px,
        Center(
          child: Image.asset(
            'assets/roadmap5.png',
            width: 1500,
            fit: BoxFit.contain,
          ),
        ),
        gap16px,
        Text.rich(
          TextSpan(
            text:
                '• Type your KRA and deliverables per year. After completing the entries, click ',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
            children: [
              TextSpan(
                text: 'Add Row',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              TextSpan(
                text: ' if you want to include more items.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        gap8px,
        Center(
          child: Image.asset(
            'assets/roadmap6.png',
            width: 1500,
            fit: BoxFit.contain,
          ),
        ),
        gap16px,
        Text.rich(
          TextSpan(
            text: '• After you finish typing your entries, click ',
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
            'assets/roadmap7.png',
            width: 1500,
            fit: BoxFit.contain,
          ),
        ),
        gap16px,
        Text.rich(
          TextSpan(
            text: '• Then click ',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
            children: [
              TextSpan(
                text: 'Confirm',
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
            'assets/roadmap8.png',
            width: 1500,
            fit: BoxFit.contain,
          ),
        ),
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
