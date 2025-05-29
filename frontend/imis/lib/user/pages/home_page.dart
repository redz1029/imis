import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/performance_governance_system/models/pgs_deliverables.dart';
import 'package:imis/user/models/user_registration.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/auth_util.dart';

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
  List<PgsDeliverables> _deliverablesList = [];
  List<String> office = [];

  final int maxDeliverables = 100;
  @override
  void initState() {
    super.initState();
    _loadUserName();
    // fetchDeliverables(pgsId: '250210').then((deliverables) {
    //   setState(() {
    //     _deliverablesList = deliverables;
    //   });
    // });
  }

  final dio = Dio();

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

      final response = await dio.get(
        url,
        options: Options(headers: {"Authorization": "Bearer $token"}),
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
      appBar: AppBar(title: Text("Dashboard"), backgroundColor: mainBgColor),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          office.join(', '),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: primaryTextColor,
                          ),
                        ),
                      ),
                      gap,
                      Row(
                        children: [
                          Expanded(
                            child: _buildDashboardBox(
                              "Submitted",
                              Colors.purple,
                              "25",
                            ),
                          ),
                          Expanded(
                            child: _buildDashboardBox(
                              "Disapproved",
                              Colors.red,
                              "10",
                            ),
                          ),
                          SizedBox(width: 10),

                          SizedBox(width: 10),
                          Expanded(
                            child: _buildDashboardBox(
                              "Approved",
                              Colors.green,
                              "40",
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      _buildPerformanceIndicators(),
                      // SizedBox(height: 20),
                      // _buildTeam(),
                    ],
                  ),
                ),
                SizedBox(width: 20),

                // Right side (calendar and total users card)
                Column(
                  children: [
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
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "75",
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Total of Users",
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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

  Widget _buildTeam() {
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
            // Text(
            //   "Deliverables",
            //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            // ),
            // Divider(color: lightGrey),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Auditor Team",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                _buildAgeBar(" Team 1", 0.23, Colors.pink, "21K", "23%"),
                _buildAgeBar("Team 2", 0.60, Colors.blue, "64K", "60%"),
                _buildAgeBar("Team 3", 0.16, Colors.green, "18K", "16%"),
                _buildAgeBar("Team 4", 0.08, Colors.purple, "5K", "8%"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAgeBar(
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
