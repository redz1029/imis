import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBgColor,
      appBar: AppBar(title: Text("Dashboard"), backgroundColor: mainBgColor),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dashboard Summary Boxes
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildDashboardBox(
                              "Rejected",
                              Colors.red,
                              "10",
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: _buildDashboardBox(
                              "Processing",
                              Colors.purple,
                              "25",
                            ),
                          ),
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

                      // Performance Indicators Box
                      _buildPerformanceIndicators(),
                    ],
                  ),
                ),
                SizedBox(width: 20),

                // Calendar Widget
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
              "Readiness Rating-Cancer Care",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
            Divider(color: lightGrey),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCircularIndicator(
                  "Competence",
                  0.4,
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
