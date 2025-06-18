import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:imis/auditor/models/auditor.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/office/models/office.dart';
import 'package:imis/performance_governance_system/models/pgs_deliverables.dart';
import 'package:imis/team/models/team.dart';
import 'package:imis/user/models/user.dart';
import 'package:imis/user/models/user_registration.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/auth_util.dart';
import 'package:imis/utils/http_util.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final List<PgsDeliverables> _deliverablesList = [];

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

  final dio = Dio();

  //fetch Users
  Future<void> fetchUser() async {
    var url = ApiEndpoint().users;
    try {
      final response = await AuthenticatedRequest.get(dio, url);

      if (response.statusCode == 200 && response.data is List) {
        List<User> data =
            (response.data as List)
                .map(
                  (userJson) => User.fromJson(userJson as Map<String, dynamic>),
                )
                .toList();

        if (mounted) {
          setState(() {
            userList = data;
            filteredListUser = List.from(userList);
            totalUsers = userList.length;
          });
        }
      } else {
        debugPrint("Unexpected response format");
      }
    } catch (e) {
      debugPrint("Error fetching user: $e");
    }
  }

  //fetch office
  Future<void> fecthOffice() async {
    var url = ApiEndpoint().office;
    try {
      final response = await AuthenticatedRequest.get(dio, url);

      if (response.statusCode == 200 && response.data is List) {
        List<Office> data =
            (response.data as List)
                .map(
                  (userJson) =>
                      Office.fromJson(userJson as Map<String, dynamic>),
                )
                .toList();

        if (mounted) {
          setState(() {
            officeList = data;
            filteredListOffice = List.from(officeList);
            totalOffices = officeList.length;
          });
        }
      } else {
        debugPrint("Unexpected response format");
      }
    } catch (e) {
      debugPrint("Error fetching user: $e");
    }
  }

  //team
  Future<void> fetchTeam() async {
    var url = ApiEndpoint().team;
    try {
      final response = await AuthenticatedRequest.get(dio, url);

      if (response.statusCode == 200 && response.data is List) {
        List<Team> data =
            (response.data as List)
                .map(
                  (userJson) => Team.fromJson(userJson as Map<String, dynamic>),
                )
                .toList();

        if (mounted) {
          setState(() {
            teamList = data;
            filteredListTeam = List.from(teamList);
            totalTeam = teamList.length;
          });
        }
      } else {
        debugPrint("Unexpected response format");
      }
    } catch (e) {
      debugPrint("Error fetching user: $e");
    }
  }

  //Auditors
  Future<void> fetchAuditors() async {
    var url = ApiEndpoint().auditor;
    try {
      final response = await AuthenticatedRequest.get(dio, url);

      if (response.statusCode == 200 && response.data is List) {
        List<Auditor> data =
            (response.data as List)
                .map(
                  (userJson) =>
                      Auditor.fromJson(userJson as Map<String, dynamic>),
                )
                .toList();

        if (mounted) {
          setState(() {
            auditorList = data;
            filteredListAuditor = List.from(auditorList);
            totalAuditor = auditorList.length;
          });
        }
      } else {
        debugPrint("Unexpected response format");
      }
    } catch (e) {
      debugPrint("Error fetching user: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserName();
    fetchUser();
    fecthOffice();
    fetchTeam();
    fetchAuditors();

    // fetchDeliverables(pgsId: '250210').then((deliverables) {
    //   setState(() {
    //     _deliverablesList = deliverables;
    //   });
    // });
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

  Future<List<PgsDeliverables>> fetchDeliverables({String? pgsId}) async {
    List<PgsDeliverables> deliverablesList = [];
    final url = "${ApiEndpoint().performancegovernancesystem}/$pgsId";

    debugPrint("Fetching deliverables for PGS ID: $pgsId");

    try {
      String? token = await AuthUtil.fetchAccessToken();

      if (token == null || token.isEmpty) {
        debugPrint("Error: Access token is missing!");
        return deliverablesList;
      }

      final response = await AuthenticatedRequest.get(
        dio,
        url,
        // options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final pgsDataList = data is List ? data : [data];

        for (var pgsJson in pgsDataList) {
          final deliverables =
              (pgsJson['pgsDeliverables'] as List)
                  .map((d) => PgsDeliverables.fromJson(d))
                  .where((d) => d.id != null)
                  .toList();

          deliverablesList.addAll(deliverables);
        }

        for (var d in deliverablesList) {
          debugPrint("Deliverable: ${d.toJson()}");
        }
      } else {
        debugPrint("Failed to fetch deliverables: ${response.statusCode}");
      }
    } on DioException catch (e) {
      debugPrint("Dio error: ${e.response?.data ?? e.message}");
    } catch (e) {
      debugPrint("Unexpected error: $e");
    }

    return deliverablesList;
  }

  double get _kraProgress =>
      (_deliverablesList.length / maxDeliverables).clamp(0.0, 1.0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBgColor,

      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                      Text(
                        "Analytical Overview",
                        style: TextStyle(fontSize: 20),
                      ),
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
                            SizedBox(width: 16), // space from the edge
                            PopupMenuButton<String>(
                              color: mainBgColor,
                              onSelected: (String value) {
                                // Handle selection here
                              },
                              itemBuilder:
                                  (BuildContext context) =>
                                      <PopupMenuEntry<String>>[
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
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.filter_list,
                                      size: 16,
                                      color: grey,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      "Filter by",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      gap,
                      Row(
                        children: [
                          Expanded(
                            child: _buildDashboardBox(
                              "Total Users",
                              Colors.blue,
                              totalUsers.toString(),
                            ),
                          ),
                          Expanded(
                            child: _buildDashboardBox(
                              "Total Auditors",
                              Colors.green,
                              totalAuditor.toString(),
                            ),
                          ),
                          Expanded(
                            child: _buildDashboardBox(
                              "Total Teams",
                              Colors.purple,
                              totalTeam.toString(),
                            ),
                          ),
                          Expanded(
                            child: _buildDashboardBox(
                              "Total Offices",
                              const Color.fromARGB(255, 194, 106, 47),
                              totalOffices.toString(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      _buildPerformanceIndicators(),
                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: 500,
                          child: _buildStatusWidget(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20),

                Column(
                  children: [
                    SizedBox(height: 40),
                    Card(
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
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
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
                                  formatButtonTextStyle: TextStyle(
                                    fontSize: 12,
                                  ),
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
                    SizedBox(height: 10),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Dashboard Box Widget
  Widget _buildDashboardBox(String title, Color color, String count) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        height: 100,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }

  // Performance Indicators Box
  Widget _buildPerformanceIndicators() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: mainBgColor, // Dark background for sleek design
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              "Deliverables",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
            Divider(color: lightGrey),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCircularIndicator(
                  "KRA",
                  _kraProgress,
                  const Color.fromARGB(139, 33, 149, 243),
                ),

                _buildCircularIndicator(
                  "Resource Availability",
                  0.7,
                  const Color.fromARGB(255, 207, 193, 66),
                ),
                _buildCircularIndicator(
                  "Confidence to Deliver",
                  0.9,
                  const Color.fromARGB(255, 103, 155, 105),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusWidget() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: mainBgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status list
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Status",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  _buildStatus(
                    "Approved",
                    0.23,
                    const Color.fromARGB(255, 78, 151, 79),
                    "21K",
                    "23%",
                  ),
                  _buildStatus(
                    "Disapproved",
                    0.60,
                    const Color.fromARGB(255, 165, 88, 82),
                    "64K",
                    "60%",
                  ),
                  _buildStatus(
                    "In Progress",
                    0.16,
                    const Color.fromARGB(255, 199, 165, 11),
                    "18K",
                    "16%",
                  ),
                ],
              ),
            ),
            SizedBox(width: 16),
            // Chart
            _buildPieChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatus(
    String label,
    double percentage,
    Color color,
    String value,
    String percentText,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(width: 10),
          Expanded(child: Text(label, style: TextStyle(fontSize: 14))),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 10),
          Text(percentText, style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildPieChart() {
    return SizedBox(
      width: 150,
      height: 150,
      child: PieChart(
        PieChartData(
          centerSpaceRadius: 35,
          sectionsSpace: 3,
          sections: [
            PieChartSectionData(
              color: const Color.fromARGB(255, 78, 151, 79),
              value: 23,
              title: '23%',
              radius: 40,
              titleStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            PieChartSectionData(
              color: const Color.fromARGB(255, 170, 77, 72),
              value: 60,
              title: '60%',
              radius: 40,
              titleStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            PieChartSectionData(
              color: const Color.fromARGB(255, 199, 165, 11),
              value: 16,
              title: '16%',
              radius: 40,
              titleStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Circular Indicator Widget
  Widget _buildCircularIndicator(String label, double value, Color color) {
    return Column(
      children: [
        CircularPercentIndicator(
          radius: 60.0,
          lineWidth: 10.0,
          percent: value,
          center: Text(
            "${(value * 100).toInt()}%",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          progressColor: color,
          backgroundColor: lightGrey,
          circularStrokeCap: CircularStrokeCap.round,
        ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 16)),
      ],
    );
  }
}
