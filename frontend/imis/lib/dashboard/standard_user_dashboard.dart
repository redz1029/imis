import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/performance_governance_system/enum/pgs_status.dart';
import 'package:imis/performance_governance_system/models/pgs_deliverables.dart';
import 'package:imis/user/models/user_registration.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/auth_util.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/widgets/dynamic_side_column.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class StandardUserDashboard extends StatefulWidget {
  const StandardUserDashboard({super.key});

  @override
  StandardUserDashboardtate createState() => StandardUserDashboardtate();
}

class StandardUserDashboardtate extends State<StandardUserDashboard> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<PgsDeliverables> deliverablesList = [];
  List<String> office = [];
  String firstName = "firstName";
  final dio = Dio();
  int _currentImageIndex = 0;
  late Timer imageTimer;
  final List<String> rotatingImages = [
    'assets/image3.png',
    'assets/image4.png',
  ];

  @override
  void initState() {
    super.initState();
    loadUserNames();
    loadDeliverables();
    imageTimer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (mounted) {
        setState(() {
          _currentImageIndex = (_currentImageIndex + 1) % rotatingImages.length;
        });
      }
    });
    _loadUserName();
    _loadOffice();
  }

  @override
  void dispose() {
    imageTimer.cancel();
    super.dispose();
  }

  Future<void> _loadOffice() async {
    UserRegistration? user = await AuthUtil.fetchLoggedUser();
    List<String>? officeName = await AuthUtil.fetchOfficeNames();

    if (user != null) {
      setState(() {
        office = officeName ?? [];
      });
    }
  }

  Future<void> loadDeliverables() async {
    setState(() => deliverablesList = []);

    try {
      UserRegistration? user = await AuthUtil.fetchLoggedUser();
      if (user == null) return;

      final prefs = await SharedPreferences.getInstance();
      final String? selectedRoleName = prefs.getString('selectedRole');
      final roles = await AuthUtil.fetchRoles();

      if (roles == null || roles.isEmpty) return;

      var currentRole = roles.first;

      if (selectedRoleName != null) {
        try {
          currentRole = roles.firstWhere((r) => r.name == selectedRoleName);
        } catch (_) {
          // keep first
        }
      }

      final response = await AuthenticatedRequest.get(
        dio,
        "${ApiEndpoint().performancegovernancesystem}/user/${user.id}",
        queryParameters: {
          "roleId": currentRole.id,
          "page": 1,
          "pageSize": 10000,
        },
      );

      if (response.statusCode == 200) {
        final List data = response.data;

        final List<PgsDeliverables> allDeliverables =
            data
                .expand((item) => (item['pgsDeliverables'] as List))
                .map((d) => PgsDeliverables.fromJson(d))
                .toList();

        setState(() {
          deliverablesList = allDeliverables;
        });
      }
    } catch (e) {
      debugPrint("Error loading deliverables");
    }
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

  Future<void> loadUserNames() async {
    UserRegistration? user = await AuthUtil.fetchLoggedUser();
    List<String>? officeName = await AuthUtil.fetchOfficeNames();

    if (user != null) {
      setState(() {
        office = officeName ?? [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 600;
    final bool isTablet = width >= 600 && width < 1024;

    return Scaffold(
      backgroundColor: mainBgColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            isMobile
                ? _buildMobileLayout()
                : isTablet
                ? _buildTabletLayout()
                : _buildDesktopLayout(),
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
                    _buildStrategicMap(),
                  ],
                ),
              ),
              SizedBox(width: 20),
              DynamicSideColumn1(
                /// Tablet layout: stack main content and side column vertically
                /// to avoid overly narrow cards while still using available width.
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

  Widget _buildTabletLayout() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          gap16px,
          _buildWelcome(),
          gap32px,
          _buildStatsRow(),
          gap32px,
          _buildStrategicMap(),
          gap24px,
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
              _buildStrategicMap(),
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
    int total = deliverablesList.length;
    int direct = deliverablesList.where((d) => d.isDirect).length;
    int indirect = deliverablesList.where((d) => !d.isDirect).length;
    int completed =
        deliverablesList.where((d) => d.status == PgsStatus.completed).length;
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isNarrow = constraints.maxWidth < 400;

        if (isNarrow) {
          return Column(
            children: [
              buildDashboardBox(
                title: "Total Deliverables",
                subtitle: office.join(', '),
                count: "$total",
                color: Colors.black,
                icon: Icons.show_chart,
              ),

              buildDashboardBox(
                title: "Direct Deliverables",
                count: "$direct",
                color: primaryColor,
                icon: Icons.directions_outlined,
                progress: total > 0 ? direct / total : 0,
              ),
              buildDashboardBox(
                title: "Indirect Deliverables",
                count: "$indirect",
                color: Colors.orange,
                icon: Icons.alt_route,
                progress: total > 0 ? indirect / total : 0,
              ),
              buildDashboardBox(
                title: "Total Deliverables",
                subtitle: "$completed of $total completed",
                count:
                    total > 0
                        ? "${((completed / total) * 100).toStringAsFixed(0)}%"
                        : "0%",
                color: Colors.green,
                icon: Icons.check_circle_outline,
              ),
            ],
          );
        } else {
          return Row(
            children: [
              Expanded(
                child: buildDashboardBox(
                  title: "Total Deliverables",
                  subtitle: office.join(', '),
                  count: "$total",
                  color: Colors.black,
                  icon: Icons.inventory_outlined,
                ),
              ),

              Expanded(
                child: buildDashboardBox(
                  title: "Direct Deliverables",
                  count: "$direct",
                  color: primaryColor,
                  icon: Icons.directions_outlined,
                  progress: total > 0 ? direct / total : 0,
                ),
              ),

              Expanded(
                child: buildDashboardBox(
                  title: "Indirect Deliverables",
                  count: "$indirect",
                  color: Colors.orange,
                  icon: Icons.alt_route,
                  progress: total > 0 ? indirect / total : 0,
                ),
              ),

              Expanded(
                child: buildDashboardBox(
                  title: "Completion Rate",
                  subtitle: "$completed of $total completed",
                  count:
                      total > 0
                          ? "${((completed / total) * 100).toStringAsFixed(0)}%"
                          : "0%",
                  color: Colors.green,
                  icon: Icons.check_circle_outline,
                ),
              ),
            ],
          );
        }
      },
    );
  }
}

Widget _buildStrategicMap() {
  return LayoutBuilder(
    builder: (context, constraints) {
      final double maxWidth = constraints.maxWidth;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Image.asset(
                'assets/strat_roadmap.jpg',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      );
    },
  );
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
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 160),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color.fromARGB(129, 0, 0, 0),
                  ),
                ),
              ),
              const SizedBox(width: 8),
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
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ],
      ),
    ),
  );
}

// Widget _buildPieChart(List<PgsDeliverables> deliverablesList) {
//   final statusCounts = countStatuses(deliverablesList);

//   final Map<PgsStatus, Color> statusColors = {
//     PgsStatus.notStarted: Colors.grey.shade300,

//     PgsStatus.onGoing: Colors.deepOrange,

//     PgsStatus.completed: Colors.green,
//   };

//   final List<PgsStatus> statusesToDisplay = [
//     PgsStatus.notStarted,
//     PgsStatus.onGoing,
//     PgsStatus.completed,
//   ];

//   final int totalCount = statusesToDisplay.fold(
//     0,
//     (sum, status) => sum + (statusCounts[status] ?? 0),
//   );

//   final sections =
//       statusesToDisplay
//           .map((status) {
//             final count = statusCounts[status] ?? 0;
//             final percentage =
//                 totalCount > 0 ? (count / totalCount) * 100 : 0.0;
//             if (count == 0) return null;

//             return PieChartSectionData(
//               color: statusColors[status],
//               value: percentage,
//               title: '${percentage.toStringAsFixed(0)}%',
//               radius: 40,
//               titleStyle: const TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             );
//           })
//           .where((section) => section != null)
//           .toList();

//   return SizedBox(
//     width: 200,
//     height: 200,
//     child: PieChart(
//       PieChartData(
//         centerSpaceRadius: 45,
//         sectionsSpace: 3,
//         sections: sections.cast<PieChartSectionData>(),
//       ),
//     ),
//   );
// }

// Widget _buildStatusWidget(List<PgsDeliverables> deliverablesList) {
//   final statusCounts = countStatuses(deliverablesList);

//   int getCount(PgsStatus status) => statusCounts[status] ?? 0;

//   final List<PgsStatus> statusesToDisplay = [
//     PgsStatus.notStarted,
//     PgsStatus.onGoing,
//     PgsStatus.completed,
//   ];

//   final Map<PgsStatus, Color> statusColors = {
//     PgsStatus.notStarted: Colors.grey.shade700,

//     PgsStatus.completed: Colors.green,
//     PgsStatus.onGoing: Colors.deepOrange,
//   };

  // List<Widget> buildStatusRows() {
  //   List<Widget> rows = [];
  //   for (int i = 0; i < statusesToDisplay.length; i += 3) {
  //     final status1 = statusesToDisplay[i];
  //     final status2 =
  //         (i + 1 < statusesToDisplay.length) ? statusesToDisplay[i + 1] : null;
  //     final status3 =
  //         (i + 2 < statusesToDisplay.length) ? statusesToDisplay[i + 2] : null;
  //     final int totalCount = statusesToDisplay.fold(
  //       0,
  //       (sum, status) => sum + getCount(status),
  //     );

  //     rows.add(
  //       Row(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Expanded(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   getStatusLabel(status1),
  //                   style: TextStyle(
  //                     fontWeight: FontWeight.w500,
  //                     color: statusColors[status1] ?? Colors.black,
  //                   ),
  //                 ),

  //                 Text(
  //                   totalCount > 0
  //                       ? "${((getCount(status1) / totalCount) * 100).toStringAsFixed(0)}% (${getCount(status1)})"
  //                       : "0% (0)",
  //                   style: const TextStyle(color: Colors.black54),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           // Status 2
  //           Expanded(
  //             child:
  //                 status2 != null
  //                     ? Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text(
  //                           getStatusLabel(status2),
  //                           style: TextStyle(
  //                             fontWeight: FontWeight.w500,
  //                             color: statusColors[status2] ?? Colors.black,
  //                           ),
  //                         ),
  //                         Text(
  //                           totalCount > 0
  //                               ? "${((getCount(status2) / totalCount) * 100).toStringAsFixed(0)}% (${getCount(status2)})"
  //                               : "0% (0)",
  //                           style: const TextStyle(color: Colors.black54),
  //                         ),
  //                       ],
  //                     )
  //                     : Container(),
  //           ),

  //           Expanded(
  //             child:
  //                 status3 != null
  //                     ? Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text(
  //                           getStatusLabel(status3),
  //                           style: TextStyle(
  //                             fontWeight: FontWeight.w500,
  //                             color: statusColors[status3] ?? Colors.black,
  //                           ),
  //                         ),
  //                         Text(
  //                           totalCount > 0
  //                               ? "${((getCount(status3) / totalCount) * 100).toStringAsFixed(0)}% (${getCount(status3)})"
  //                               : "0% (0)",
  //                           style: const TextStyle(color: Colors.black54),
  //                         ),
  //                       ],
  //                     )
  //                     : Container(),
  //           ),
  //         ],
  //       ),
  //     );
  //     rows.add(const SizedBox(height: 16));
  //   }
  //   return rows;
  // }

  // return Card(
  //   elevation: 0,
  //   shape: RoundedRectangleBorder(
  //     borderRadius: BorderRadius.circular(12),
  //     side: BorderSide(color: Colors.grey.shade300, width: 1),
  //   ),
  //   child: Container(
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: mainBgColor,
  //       borderRadius: BorderRadius.circular(10),
  //     ),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Expanded(
  //           flex: 3,
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               const Text(
  //                 "PGS Status",
  //                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //               ),
  //               const SizedBox(height: 16),
  //               ...buildStatusRows(),
  //             ],
  //           ),
  //         ),
  //         const SizedBox(width: 16),

  //         _buildPieChart(deliverablesList),
  //       ],
  //     ),
  //   ),
  // );

