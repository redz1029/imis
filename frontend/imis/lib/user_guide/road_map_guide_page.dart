import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';

class RoadMapGuidePage extends StatefulWidget {
  const RoadMapGuidePage({super.key});

  @override
  RoadMapGuidePageState createState() => RoadMapGuidePageState();
}

class RoadMapGuidePageState extends State<RoadMapGuidePage> {
  String? selectedModule;

  final List<ModuleItem> modules = [
    ModuleItem(
      name: 'ROADMAP',
      icon: Icons.map,
      description: 'How to create and manage project roadmaps and timelines.',
    ),
    ModuleItem(
      name: 'DELIVERABLES',
      icon: Icons.inventory_2_outlined,
      description: 'How to track and manage project deliverables and outcomes.',
    ),
    ModuleItem(
      name: 'SWOT',
      icon: Icons.trending_up_outlined,
      description: 'How to manage SWOT analysis for strategic planning.',
    ),
  ];

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
          'Roadmap',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        Divider(),
        gap8px,
        Text(
          'The Roadmap module is accessible only to the point person assigned to create the roadmap for core and support processes (e.g., training, services, research).',
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
          'Create a new Roadmap',
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
                text: 'Roadmap',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800], // optional, for emphasis
                ),
              ),
              TextSpan(
                text: ' on the left sidebar to take you to the Roadmap module.',
              ),
            ],
          ),
        ),
        gap8px,
        Center(
          child: Image.asset(
            'assets/roadmap1.png',
            width: 1500,
            fit: BoxFit.contain,
          ),
        ),
        gap16px,
        Text.rich(
          TextSpan(
            text:
                '• Once clicking the Roadmap button, you can create a new Roadmap by clicking ',
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
            'assets/roadmap2.png',
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
          '© 2024 CPeMS. All rights reserved.',
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
