import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/roadmap/services/roadmap_service.dart';
import 'package:imis/user/models/user_registration.dart';
import 'package:imis/utils/auth_util.dart';
import 'package:imis/widgets/dynamic_side_column.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:imis/roadmap/models/roadmap.dart';
import 'package:table_calendar/table_calendar.dart';

class OfficerDashboard extends StatefulWidget {
  const OfficerDashboard({super.key});

  @override
  State<OfficerDashboard> createState() => _OfficerDashboardState();
}

class _OfficerDashboardState extends State<OfficerDashboard> {
  List<Roadmap> roadmapList = [];
  final _roadmapService = RoadmapService(Dio());
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<String> office = [];
  String firstName = "firstName";
  final dio = Dio();
  int _currentImageIndex = 0;
  late Timer imageTimer;
  final List<String> rotatingImages = [
    'assets/image3.png',
    'assets/image4.png',
  ];
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  @override
  void initState() {
    super.initState();
    _loadRoadmaps();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    UserRegistration? user = await AuthUtil.fetchLoggedUser();

    if (user != null) {
      setState(() {
        final rawName = (user.firstName ?? "firstName").trim();

        firstName = rawName.toLowerCase().replaceFirstMapped(
          RegExp(r'^[a-z]'),
          (m) => m.group(0)!.toUpperCase(),
        );
      });
    }
  }

  Future<void> _loadRoadmaps() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? selectedRoleName = prefs.getString('selectedRole');
      final roles = await AuthUtil.fetchRoles();

      String roleId = '';
      if (roles != null && roles.isNotEmpty) {
        var currentRole = roles.first;
        if (selectedRoleName != null) {
          try {
            currentRole = roles.firstWhere((r) => r.name == selectedRoleName);
          } catch (_) {}
        }
        roleId = currentRole.id;
      }

      if (roleId.isEmpty) {
        if (mounted) setState(() => roadmapList = []);
        return;
      }

      final pageList = await _roadmapService.getRoadmap(
        roleId: roleId,
        pageSize: 50,
      );
      if (!mounted) return;
      setState(() {
        roadmapList = pageList.items;
      });
    } catch (e) {
      if (mounted) setState(() => roadmapList = []);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: mainBgColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    gap16px,
                    _buildWelcome(),
                    gap32px,
                    _buildStatsRow(),
                    gap32px,
                  ],
                ),
              ),
              SizedBox(width: 20),
              DynamicSideColumn1(
                focusedDay: _focusedDay,
                selectedDay: _selectedDay,
                calendarFormat: _calendarFormat,
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                currentImageIndex: _currentImageIndex,
                rotatingImages: rotatingImages,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              gap16px,
              _buildWelcome(),
              gap32px,
              _buildStatsRow(),
              gap12px,

              gap16px,
              DynamicSideColumn1(
                focusedDay: _focusedDay,
                selectedDay: _selectedDay,
                calendarFormat: _calendarFormat,
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                currentImageIndex: _currentImageIndex,
                rotatingImages: rotatingImages,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWelcome() {
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 185, 123, 121),
        borderRadius: BorderRadius.circular(12),
      ),
      child:
          isMobile
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${_getGreeting()}, ${firstName.trim().split(' ')[0].toLowerCase().replaceFirstMapped(RegExp(r'^[a-z]'), (m) => m.group(0)!.toUpperCase())}",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  gap8px,
                  Text(
                    "Welcome to CPeMS - Centralized Performance Electronic Management System! Together, we track progress and build a culture of accountability and continuous improvement.",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 14,
                    ),
                  ),
                  gap16px,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Image.asset(
                          'assets/image1.png',
                          height: 120,
                          fit: BoxFit.contain,
                        ),
                      ),
                      gap12px,
                      Expanded(
                        child: Image.asset(
                          'assets/image2.png',
                          height: 120,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ],
              )
              : Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${_getGreeting()}, ${firstName.toLowerCase().split(' ').map((word) => word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '').join(' ')}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        gap8px,
                        Text(
                          "Welcome to CPeMS - Centralized Performance Electronic Management System! Together, we track progress and build a culture of accountability and continuous improvement.",
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  gap16px,
                  Image.asset(
                    'assets/image1.png',
                    height: 180,
                    fit: BoxFit.contain,
                  ),
                  gap12px,
                  Image.asset(
                    'assets/image2.png',
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
    );
  }

  Widget _buildStatsRow() {
    int total = roadmapList.fold(
      0,
      (sum, r) => sum + (r.deliverables?.length ?? 0),
    );

    int totalEnablers = 0;
    int totalUnenablers = 0;
    int totalRoadmaps = roadmapList.length;
    for (var roadmap in roadmapList) {
      if (roadmap.deliverables != null) {
        for (var deliverable in roadmap.deliverables!) {
          if (deliverable.items != null && deliverable.items!.isNotEmpty) {
            final firstItem = deliverable.items!.first;
            if (firstItem.isEnabler == true) {
              totalEnablers++;
            } else if (firstItem.isEnabler == false) {
              totalUnenablers++;
            }
          }
        }
      }
    }

    int totalDeliverableItems = totalEnablers + totalUnenablers;

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isNarrow = constraints.maxWidth < 400;

        if (isNarrow) {
          return Column(
            children: [
              buildDashboardBox(
                title: "Total KRA",

                count: "$total",
                color: Colors.black,
                icon: Icons.show_chart,
              ),

              buildDashboardBox(
                title: "Total Enablers",
                count: "$totalEnablers",
                color: primaryColor,
                icon: Icons.directions_outlined,
                progress:
                    totalDeliverableItems > 0
                        ? totalEnablers / totalDeliverableItems
                        : 0,
              ),
              buildDashboardBox(
                title: "Total Unenablers",
                count: "$totalUnenablers",
                color: Colors.orange,
                icon: Icons.alt_route,
                progress:
                    totalDeliverableItems > 0
                        ? totalUnenablers / totalDeliverableItems
                        : 0,
              ),
            ],
          );
        } else {
          return Row(
            children: [
              Expanded(
                child: buildDashboardBox(
                  title: "Total KRA",
                  subtitle: office.join(', '),
                  count: "$total",
                  color: Colors.black,
                  icon: Icons.inventory_outlined,
                ),
              ),

              Expanded(
                child: buildDashboardBox(
                  title: "Total Enablers",
                  count: "$totalEnablers",
                  color: primaryColor,
                  icon: Icons.directions_outlined,
                  progress:
                      totalDeliverableItems > 0
                          ? totalEnablers / totalDeliverableItems
                          : 0,
                ),
              ),

              Expanded(
                child: buildDashboardBox(
                  title: "Total Unenablers",
                  count: "$totalUnenablers",
                  color: Colors.orange,
                  icon: Icons.alt_route,
                  progress:
                      totalDeliverableItems > 0
                          ? totalUnenablers / totalDeliverableItems
                          : 0,
                ),
              ),

              Expanded(
                child: buildDashboardBox(
                  title: "Total Roadmaps",
                  subtitle: totalRoadmaps > 0 ? "100%" : "0%",
                  count: "$totalRoadmaps",
                  color: Colors.green,
                  icon: Icons.map,
                ),
              ),
            ],
          );
        }
      },
    );
  }
}

Widget buildDashboardBox({
  required String title,
  required String count,
  String? subtitle,
  required Color color,
  required IconData icon,
  double? progress,
}) {
  return Card(
    color: mainBgColor,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: Colors.grey.shade300, width: 1),
    ),
    child: Container(
      width: 317,
      height: 170,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color.fromARGB(129, 0, 0, 0),
                ),
              ),
              Icon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: 12),

          Text(
            count,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),

          if (progress != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey.shade300,
                    color: color,
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "${(progress * 100).toStringAsFixed(1)}%",
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ],

          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ],
      ),
    ),
  );
}
