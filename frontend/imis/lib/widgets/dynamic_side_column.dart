import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/widgets/announcement_widget.dart';
import 'package:table_calendar/table_calendar.dart';

class DynamicSideColumn1 extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final CalendarFormat calendarFormat;
  final Function(DateTime selectedDay, DateTime focusedDay) onDaySelected;
  final Function(CalendarFormat format) onFormatChanged;
  final int currentImageIndex;
  final List<String> rotatingImages;

  const DynamicSideColumn1({
    super.key,
    required this.focusedDay,
    required this.selectedDay,
    required this.calendarFormat,
    required this.onDaySelected,
    required this.onFormatChanged,
    required this.currentImageIndex,
    required this.rotatingImages,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          color: const Color(0xFFeeeeee),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Calendar', style: TextStyle(fontSize: 14)),
                const Divider(),
                SizedBox(
                  width: 280,
                  height: 320,
                  child: TableCalendar(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: focusedDay,
                    calendarFormat: calendarFormat,
                    selectedDayPredicate: (day) => isSameDay(selectedDay, day),
                    onDaySelected: onDaySelected,
                    onFormatChanged: onFormatChanged,
                    rowHeight: 40,
                    calendarStyle: const CalendarStyle(
                      defaultTextStyle: TextStyle(fontSize: 12),
                      weekendTextStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: primaryTextColor,
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    headerStyle: const HeaderStyle(
                      titleTextStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      formatButtonVisible: false,
                      titleCentered: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Card(
          color: const Color(0xFFeeeeee),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              width: 280,
              height: 350,
              child: SingleChildScrollView(child: AnnouncementList()),
            ),
          ),
        ),
      ],
    );
  }

  bool isSameDay(DateTime? a, DateTime? b) {
    return a?.compareTo(b!) == 0;
  }
}
