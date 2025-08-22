import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:imis/auditor/models/auditor.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/office/models/office.dart';
import 'package:imis/performance_governance_system/key_result_area/models/key_result_area.dart';
import 'package:imis/performance_governance_system/models/pgs_deliverables.dart';
import 'package:imis/team/models/team.dart';
import 'package:imis/user/models/user.dart';
import 'package:imis/user/models/user_registration.dart';
import 'package:imis/user/services/home_service.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/auth_util.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../performance_governance_system/enum/pgs_status.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<PgsDeliverables> deliverablesList = [];
  List<PgsDeliverables> filteredDeliverables = [];

  List<KeyResultArea> kraList = [];
  List<KeyResultArea> filteredKra = [];

  List<User> userList = [];
  List<User> filteredListUser = [];
  int totalUsers = 0;

  List<String> office = [];

  List<Office> officeList = [];
  List<Office> filteredListOffice = [];
  int totalOffices = 0;

  List<Team> teamList = [];
  List<Team> filteredListTeam = [];
  int totalTeam = 0;

  List<Auditor> auditorList = [];
  List<Auditor> filteredListAuditor = [];
  int totalAuditor = 0;

  final int maxDeliverables = 100;
  int _currentImageIndex = 0;
  late Timer imageTimer;
  final List<String> rotatingImages = ['assets/pic1.jpg', 'assets/pic2.jpg'];

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _fetchAllData();
    imageTimer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (mounted) {
        setState(() {
          _currentImageIndex = (_currentImageIndex + 1) % rotatingImages.length;
        });
      }
    });
  }

  @override
  void dispose() {
    imageTimer.cancel();
    super.dispose();
  }

  Future<void> _fetchAllData() async {
    final service = HomeService();
    try {
      final data = await service.fetchAll(
        usersEndpoint: ApiEndpoint().users,
        officeEndpoint: ApiEndpoint().office,
        teamEndpoint: ApiEndpoint().team,
        auditorEndpoint: ApiEndpoint().auditor,
        deliverablesEndpoint: ApiEndpoint().deliverables,
        kraEndpoint: ApiEndpoint().keyresult,
      );

      if (mounted) {
        setState(() {
          userList = data.users;
          filteredListUser = List.from(data.users);
          totalUsers = data.users.length;

          officeList = data.offices;
          filteredListOffice = List.from(data.offices);
          totalOffices = data.offices.length;

          teamList = data.teams;
          filteredListTeam = List.from(data.teams);
          totalTeam = data.teams.length;

          auditorList = data.auditors;
          filteredListAuditor = List.from(data.auditors);
          totalAuditor = data.auditors.length;

          deliverablesList = data.deliverables;
          filteredDeliverables = List.from(data.deliverables);

          kraList = data.kras;
          filteredKra = List.from(data.kras);
        });
      }
    } catch (e) {
      if (mounted) {}
    }
  }

  Future<void> _loadUserName() async {
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
                    Text("Analytical Overview", style: TextStyle(fontSize: 20)),
                    gap,
                    _buildStatsRow(),
                    gap3,
                    _buildPerformanceChart(kraList, deliverablesList),
                    gap7,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Align(
                        alignment: Alignment.center,
                        child: _buildStatusWidget(deliverablesList),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20),
              _buildSideColumn(),
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
              Text("Analytical Overview", style: TextStyle(fontSize: 20)),
              gap,
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        office.join(', '),
                        style: TextStyle(fontSize: 14, color: grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 16),
                    PopupMenuButton<String>(
                      color: mainBgColor,
                      onSelected: (String value) {
                        // Handle selection here
                      },
                      itemBuilder:
                          (BuildContext context) => <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'Option 1',
                              child: Text('Option 1'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'Option 2',
                              child: Text('Option 2'),
                            ),
                          ],
                      offset: Offset(0, 30),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: mainBgColor,
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.filter_list, size: 16, color: grey),
                            SizedBox(width: 4),
                            Text("Filter by", style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              gap,
              _buildStatsRow(),
              _buildPerformanceChart(kraList, deliverablesList),
              gap7,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.center,
                  child: _buildStatusWidget(deliverablesList),
                ),
              ),
              gap,
              _buildSideColumn(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isNarrow = constraints.maxWidth < 400;

        if (isNarrow) {
          return Column(
            children: [
              _buildDashboardBox(
                "Total Users",
                Colors.blue,
                totalUsers.toString(),
                'assets/users.png',
              ),
              SizedBox(height: 10),
              _buildDashboardBox(
                "Total Auditors",
                Colors.green,
                totalAuditor.toString(),
                'assets/auditor.png',
              ),
              SizedBox(height: 10),
              _buildDashboardBox(
                "Total Teams",
                Colors.purple,
                totalTeam.toString(),
                'assets/team.png',
              ),
              SizedBox(height: 10),
              _buildDashboardBox(
                "Total Offices",
                const Color.fromARGB(255, 194, 106, 47),
                totalOffices.toString(),
                'assets/office.png',
              ),
            ],
          );
        } else {
          return Row(
            children: [
              Expanded(
                child: _buildDashboardBox(
                  "Total Users",
                  Colors.blue,
                  totalUsers.toString(),
                  'assets/users.png',
                ),
              ),
              Expanded(
                child: _buildDashboardBox(
                  "Total Auditors",
                  Colors.green,
                  totalAuditor.toString(),
                  'assets/auditor.png',
                ),
              ),
              Expanded(
                child: _buildDashboardBox(
                  "Total Teams",
                  Colors.purple,
                  totalTeam.toString(),
                  'assets/team.png',
                ),
              ),
              Expanded(
                child: _buildDashboardBox(
                  "Total Offices",
                  const Color.fromARGB(255, 194, 106, 47),
                  totalOffices.toString(),
                  'assets/office.png',
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildSideColumn() {
    return Column(
      children: [
        Card(
          color: mainBgColor,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Calendar",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Divider(),
                SizedBox(
                  width: 280,
                  height: 320,
                  child: TableCalendar(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: _focusedDay,
                    calendarFormat: _calendarFormat,
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
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
                    rowHeight: 40,
                    calendarStyle: CalendarStyle(
                      defaultTextStyle: TextStyle(fontSize: 12),
                      weekendTextStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                      disabledTextStyle: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      outsideTextStyle: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: secondaryBgButton,
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: TextStyle(fontSize: 12),
                      weekendStyle: TextStyle(fontSize: 12),
                    ),
                    headerStyle: HeaderStyle(
                      formatButtonTextStyle: TextStyle(fontSize: 12),
                      titleTextStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
        Card(
          color: mainBgColor,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 280,
                  height: 350,
                  child: Image.asset(
                    rotatingImages[_currentImageIndex],
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceChart(
    List<KeyResultArea> kraList,
    List<PgsDeliverables> deliverablesList,
  ) {
    final Map<int, double> kraPercentTotals = {};
    for (var deliverable in deliverablesList) {
      kraPercentTotals[deliverable.kra!.id] =
          (kraPercentTotals[deliverable.kra!.id] ?? 0) +
          (deliverable.percentDeliverables / 100);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        final chartHeight = isMobile ? 350.0 : 250.0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Center(
                child: Text(
                  'Performance Chart',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              height: chartHeight,
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 24 : 8,
                vertical: 8,
              ),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.blueGrey.withAlpha(200),
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${rod.toY.toStringAsFixed(1)}%',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 20,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: 4,
                            child: Text(
                              value.toInt().toString(),
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        reservedSize: 100,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          int index = value.toInt();
                          if (index >= 0 && index < kraList.length) {
                            final kra = kraList[index];
                            return Transform.translate(
                              offset: const Offset(0, 80),
                              child: Transform.rotate(
                                angle: -0.872, // ~50° rotation
                                alignment: Alignment.center,
                                child: Text(
                                  kra.name,
                                  style: TextStyle(
                                    fontSize: isMobile ? 8 : 10,
                                    color: Colors.black87,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                  barGroups: List.generate(kraList.length, (index) {
                    final kra = kraList[index];
                    double percent = kraPercentTotals[kra.id] ?? 0;
                    percent = percent.clamp(0.0, 100.0);

                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: percent,
                          color: primaryLightColor,
                          width: 20,
                          borderRadius: BorderRadius.circular(4),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: 100,
                            color: Colors.grey.shade200,
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Widget _buildDashboardBox(
  //   String title,
  //   Color color,
  //   String count,
  //   String iconAsset,
  // ) {
  //   return Card(
  //     elevation: 4,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //     child: Container(
  //       height: 130,
  //       padding: EdgeInsets.all(16),
  //       decoration: BoxDecoration(
  //         color: color.withValues(alpha: 0.1),
  //         borderRadius: BorderRadius.circular(10),
  //       ),
  //       child: Row(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Text(
  //                 count,
  //                 style: TextStyle(
  //                   fontSize: 24,
  //                   fontWeight: FontWeight.bold,
  //                   color: color,
  //                 ),
  //               ),
  //               SizedBox(height: 8),
  //               Text(
  //                 title,
  //                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
  //               ),
  //             ],
  //           ),
  //           SizedBox(width: 40),
  //           Image.asset(iconAsset, width: 70, height: 70),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildDashboardBox(
    String title,
    Color color,
    String count,
    String iconAsset,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        height: 130,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    count,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Image.asset(iconAsset),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<PgsStatus, int> _countStatuses(List<PgsDeliverables> deliverablesList) {
    final Map<PgsStatus, int> statusCounts = {};

    for (var deliverable in deliverablesList) {
      final status = deliverable.status;
      statusCounts[status] = (statusCounts[status] ?? 0) + 1;
    }

    return statusCounts;
  }

  String getStatusLabel(PgsStatus status) {
    switch (status) {
      case PgsStatus.notStarted:
        return "Not Started";
      case PgsStatus.inProgress:
        return "In Progress";
      case PgsStatus.onTrack:
        return "On Track";
      case PgsStatus.delayed:
        return "Delayed";
      case PgsStatus.needsImprovement:
        return "Needs Improvement";
      case PgsStatus.completed:
        return "Completed";
      case PgsStatus.exceeded:
        return "Exceeded";
      case PgsStatus.onHold:
        return "On Hold";
      case PgsStatus.cancelled:
        return "Cancelled";
    }
  }

  Widget _buildStatusWidget(List<PgsDeliverables> deliverablesList) {
    final statusCounts = _countStatuses(deliverablesList);

    int getCount(PgsStatus status) => statusCounts[status] ?? 0;

    final List<PgsStatus> statusesToDisplay = [
      PgsStatus.notStarted,
      PgsStatus.exceeded,
      PgsStatus.inProgress,
      PgsStatus.onHold,
      PgsStatus.onTrack,
      PgsStatus.cancelled,
      PgsStatus.delayed,
      PgsStatus.needsImprovement,
      PgsStatus.completed,
    ];

    final Map<PgsStatus, Color> statusColors = {
      PgsStatus.notStarted: Colors.grey,
      PgsStatus.inProgress: const Color(0xFFC7A50B),
      PgsStatus.onTrack: Colors.blue,
      PgsStatus.delayed: Colors.orange,
      PgsStatus.needsImprovement: Colors.deepOrange,
      PgsStatus.completed: Colors.green,
      PgsStatus.exceeded: Colors.teal,
      PgsStatus.onHold: Colors.purple,
      PgsStatus.cancelled: Colors.redAccent,
    };

    List<Widget> buildStatusRows() {
      List<Widget> rows = [];
      for (int i = 0; i < statusesToDisplay.length; i += 3) {
        final status1 = statusesToDisplay[i];
        final status2 =
            (i + 1 < statusesToDisplay.length)
                ? statusesToDisplay[i + 1]
                : null;
        final status3 =
            (i + 2 < statusesToDisplay.length)
                ? statusesToDisplay[i + 2]
                : null;
        final int totalCount = statusesToDisplay.fold(
          0,
          (sum, status) => sum + getCount(status),
        );

        rows.add(
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getStatusLabel(status1),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: statusColors[status1] ?? Colors.black,
                      ),
                    ),

                    Text(
                      totalCount > 0
                          ? "${((getCount(status1) / totalCount) * 100).toStringAsFixed(0)}% (${getCount(status1)})"
                          : "0% (0)",
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
              // Status 2
              Expanded(
                child:
                    status2 != null
                        ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getStatusLabel(status2),
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: statusColors[status2] ?? Colors.black,
                              ),
                            ),
                            Text(
                              totalCount > 0
                                  ? "${((getCount(status2) / totalCount) * 100).toStringAsFixed(0)}% (${getCount(status2)})"
                                  : "0% (0)",
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ],
                        )
                        : Container(),
              ),

              Expanded(
                child:
                    status3 != null
                        ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getStatusLabel(status3),
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: statusColors[status3] ?? Colors.black,
                              ),
                            ),
                            Text(
                              totalCount > 0
                                  ? "${((getCount(status3) / totalCount) * 100).toStringAsFixed(0)}% (${getCount(status3)})"
                                  : "0% (0)",
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ],
                        )
                        : Container(),
              ),
            ],
          ),
        );
        rows.add(const SizedBox(height: 16));
      }
      return rows;
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: mainBgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "PGS Status",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ...buildStatusRows(),
                ],
              ),
            ),
            const SizedBox(width: 16),

            _buildPieChart(deliverablesList),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart(List<PgsDeliverables> deliverablesList) {
    final statusCounts = _countStatuses(deliverablesList);

    final Map<PgsStatus, Color> statusColors = {
      PgsStatus.notStarted: Colors.grey,
      PgsStatus.inProgress: const Color(0xFFC7A50B),
      PgsStatus.onTrack: Colors.blue,
      PgsStatus.delayed: Colors.orange,
      PgsStatus.needsImprovement: Colors.deepOrange,
      PgsStatus.completed: Colors.green,
      PgsStatus.exceeded: Colors.teal,
      PgsStatus.onHold: Colors.purple,
      PgsStatus.cancelled: Colors.redAccent,
    };

    final List<PgsStatus> statusesToDisplay = [
      PgsStatus.notStarted,
      PgsStatus.exceeded,
      PgsStatus.inProgress,
      PgsStatus.onHold,
      PgsStatus.onTrack,
      PgsStatus.cancelled,
      PgsStatus.delayed,
      PgsStatus.needsImprovement,
      PgsStatus.completed,
    ];

    final int totalCount = statusesToDisplay.fold(
      0,
      (sum, status) => sum + (statusCounts[status] ?? 0),
    );

    final sections =
        statusesToDisplay
            .map((status) {
              final count = statusCounts[status] ?? 0;
              final percentage =
                  totalCount > 0 ? (count / totalCount) * 100 : 0.0;
              if (count == 0) return null;

              return PieChartSectionData(
                color: statusColors[status],
                value: percentage,
                title: '${percentage.toStringAsFixed(0)}%',
                radius: 40,
                titleStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              );
            })
            .where((section) => section != null)
            .toList();

    return SizedBox(
      width: 200,
      height: 200,
      child: PieChart(
        PieChartData(
          centerSpaceRadius: 45,
          sectionsSpace: 3,
          sections: sections.cast<PieChartSectionData>(),
        ),
      ),
    );
  }
}
