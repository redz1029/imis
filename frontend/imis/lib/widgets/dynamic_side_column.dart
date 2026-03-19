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

  const DynamicSideColumn1({
    super.key,
    required this.focusedDay,
    required this.selectedDay,
    required this.calendarFormat,
    required this.onDaySelected,
    required this.onFormatChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          color: Theme.of(context).cardColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Calendar', style: TextStyle(fontSize: 12)),
                const Divider(height: 8),
                SizedBox(
                  width: 220,
                  height: 240,
                  child: TableCalendar(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: focusedDay,
                    calendarFormat: calendarFormat,
                    selectedDayPredicate: (day) => isSameDay(selectedDay, day),
                    onDaySelected: onDaySelected,
                    onFormatChanged: onFormatChanged,
                    rowHeight: 28, // smaller row height
                    calendarStyle: CalendarStyle(
                      defaultTextStyle: const TextStyle(
                        fontSize: 10,
                      ), // small numbers
                      weekendTextStyle: const TextStyle(fontSize: 10),
                      selectedDecoration: BoxDecoration(
                        color: primaryTextColor,
                        shape: BoxShape.circle,
                      ),
                      selectedTextStyle: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                      ),
                      todayDecoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                      todayTextStyle: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                    daysOfWeekStyle: const DaysOfWeekStyle(
                      weekdayStyle: TextStyle(fontSize: 10),
                      weekendStyle: TextStyle(fontSize: 10),
                    ),
                    headerStyle: const HeaderStyle(
                      titleTextStyle: TextStyle(
                        fontSize: 12, // small header
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
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(width: 280, height: 350, child: AnnouncementList()),
          ),
        ),
      ],
    );
  }

  bool isSameDay(DateTime? a, DateTime? b) {
    return a?.compareTo(b!) == 0;
  }
}
