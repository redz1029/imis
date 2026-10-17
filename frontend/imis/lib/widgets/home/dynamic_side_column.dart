import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/widgets/home/announcement_widget.dart';
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
    return LayoutBuilder(
      builder: (context, constraints) {
        // Desktop passes a fixed height (matched to the left column), so we
        // stretch the announcement list to fill it. Mobile has no bounded
        // height here (it's inside a scrolling Column), so fall back to a
        // fixed height like before.
        final bool hasBoundedHeight = constraints.hasBoundedHeight;

        final calendar = TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: focusedDay,
          calendarFormat: calendarFormat,
          selectedDayPredicate: (day) => isSameDay(selectedDay, day),
          onDaySelected: onDaySelected,
          onFormatChanged: onFormatChanged,
          rowHeight: 34,
          daysOfWeekHeight: 24,
          calendarStyle: CalendarStyle(
            outsideDaysVisible: true,
            defaultTextStyle: const TextStyle(
              fontSize: 13,
              color: Color(0xFF2A2A3C),
            ),
            weekendTextStyle: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade500,
            ),
            outsideTextStyle: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade300,
            ),
            selectedDecoration: const BoxDecoration(
              color: kAccent,
              shape: BoxShape.circle,
            ),
            selectedTextStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            todayDecoration: BoxDecoration(
              color: kAccent.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            todayTextStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: kAccent,
            ),
            cellMargin: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade400,
            ),
            weekendStyle: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade400,
            ),
          ),
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: false,
            leftChevronVisible: true,
            rightChevronVisible: true,
            headerPadding: const EdgeInsets.only(bottom: 12),
            titleTextFormatter:
                (date, locale) =>
                    '${DateFormat.MMM(locale).format(date)}, ${date.year}',
            titleTextStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E),
            ),
            leftChevronIcon: Icon(
              Icons.chevron_left,
              size: 20,
              color: Colors.grey.shade400,
            ),
            rightChevronIcon: Icon(
              Icons.chevron_right,
              size: 20,
              color: Colors.grey.shade400,
            ),
            leftChevronPadding: EdgeInsets.zero,
            rightChevronPadding: EdgeInsets.zero,
          ),
        );

        return Container(
          width: double.infinity,
          height: hasBoundedHeight ? double.infinity : null,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize:
                hasBoundedHeight ? MainAxisSize.max : MainAxisSize.min,
            children: [
              calendar,
              const SizedBox(height: 16),
              Divider(color: Colors.grey.shade200, height: 1),
              const SizedBox(height: 16),
              hasBoundedHeight
                  ? const Expanded(child: AnnouncementList())
                  : const SizedBox(height: 420, child: AnnouncementList()),
            ],
          ),
        );
      },
    );
  }

  bool isSameDay(DateTime? a, DateTime? b) {
    return a?.compareTo(b!) == 0;
  }
}
