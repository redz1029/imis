import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/user_guide/road_map_guide_page.dart';

class UserGuidePage extends StatefulWidget {
  const UserGuidePage({super.key});

  @override
  UserGuidePageState createState() => UserGuidePageState();
}

class UserGuidePageState extends State<UserGuidePage> {
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
            // Header
            _buildHeader(),

            // Main Content
            Padding(
              padding: EdgeInsets.all(32.0),
              child: Column(
                children: [
                  _buildWelcomeSection(),
                  SizedBox(height: 24),

                  _buildProjectsOverview(),
                  SizedBox(height: 24),

                  _buildModulesOverview(),
                  SizedBox(height: 24),

                  _buildModulesTable(),

                  if (selectedModule != null) ...[
                    SizedBox(height: 24),
                    // _buildSelectedModule(),
                  ],
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

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: primaryColor,
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.book, color: Colors.white, size: 32),
              SizedBox(width: 12),
              Text(
                'User Guide',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'CPeMS Documentation',
            style: TextStyle(
              color: const Color.fromARGB(183, 255, 255, 255),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Welcome to the CPeMS User Guide',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        Divider(),
        gap8px,
        Text(
          'This guide covers all of CPeMS\'s functionalities from a user\'s perspective.',
          style: TextStyle(fontSize: 16, color: Colors.grey[600], height: 1.5),
        ),
      ],
    );
  }

  Widget _buildProjectsOverview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.folder_open, color: primaryColor, size: 24),
            SizedBox(width: 12),
            Text(
              'Overview of Projects in CPeMS',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        Divider(),
        gap8px,
        Text(
          'Your work within CPeMS can be organized into multiple projects, each with a distinct set of members and their respective roles in that project. In turn, each project can be individually configured with regards to the enabled features, called Modules in CPeMS.',
          style: TextStyle(fontSize: 16, color: Colors.grey[600], height: 1.5),
        ),
        SizedBox(height: 12),
        Text(
          'This distinction between projects provides you with a lot of flexibility to set up your work, and control what users are allowed to view and/or collaborate on in each individual project.',
          style: TextStyle(fontSize: 16, color: Colors.grey[600], height: 1.5),
        ),
      ],
    );
  }

  Widget _buildModulesOverview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.grid_view, color: primaryColor, size: 24),
            SizedBox(width: 12),
            Text(
              'Overview of Modules in CPeMS',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        Divider(),
        gap8px,
        Text(
          'Module is defined as an independent unit of functionality that can be used to extend and improve the existing core functions.',
          style: TextStyle(fontSize: 16, color: Colors.grey[600], height: 1.5),
        ),
        SizedBox(height: 12),
        Text(
          'Within a project Modules can be activated and deactivated under "Modules" in the project settings menu by project members who have sufficient permissions to adjust project settings. Which modules or single functionalities will be available within projects is controlled in the global Administration settings (please see System admin guide to see how this is done).',
          style: TextStyle(fontSize: 16, color: Colors.grey[600], height: 1.5),
        ),
        SizedBox(height: 12),
        Text(
          'Please choose the module or feature you want to learn more about.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
            fontWeight: FontWeight.w600,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildModulesTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          // Table Header
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(45, 192, 81, 77),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Module',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Text(
                    'Description',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Table Rows
          ...modules.map((module) => _buildModuleRow(module)).toList(),
        ],
      ),
    );
  }

  Widget _buildModuleRow(ModuleItem module) {
    return InkWell(
      onTap: () {
        if (module.name == 'ROADMAP') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RoadMapGuidePage()),
          );
        } else {
          setState(() {
            selectedModule = module.name;
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Colors.grey[200]!, width: 1),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Icon(module.icon, color: primaryColor, size: 24),
                  SizedBox(width: 12),
                  Text(
                    module.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: Text(
                module.description,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
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
