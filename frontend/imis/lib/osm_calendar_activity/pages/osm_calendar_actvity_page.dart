import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/constant/permissions.dart';
import 'package:imis/osm_calendar_activity/models/osm_calendar_activity.dart';
import 'package:imis/osm_calendar_activity/pages/calendar_event.dart';
import 'package:imis/osm_calendar_activity/pages/event_dialog.dart'
    show EventDetailDialog, AddEditEventDialog;

import 'package:imis/osm_calendar_activity/services/osm_calendar_activity_services.dart';
import 'package:imis/widgets/permission/permission_widget.dart';

class OsmCalendarActvityPage extends StatefulWidget {
  const OsmCalendarActvityPage({super.key});

  @override
  State<OsmCalendarActvityPage> createState() => OsmCalendarActvityPageState();
}

class OsmCalendarActvityPageState extends State<OsmCalendarActvityPage> {
  DateTime _visibleMonth = DateTime(DateTime.now().year, DateTime.now().month);
  List<OsmCalendarActivity> _events = [];

  final _service = OsmCalendarActivityServices(Dio());

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    setState(() {});
    try {
      final events = await _service.getOsmActivities();
      if (mounted) {
        setState(() {
          _events = events;
        });
      }
    } catch (e) {
      debugPrint('LOAD EVENTS ERROR: $e');
      if (mounted) {
        setState(() {});
      }
    }
  }

  static const List<String> _weekdayLabels = [
    'MON',
    'TUE',
    'WED',
    'THU',
    'FRI',
    'SAT',
    'SUN',
  ];

  List<OsmCalendarActivity> _eventsForDay(DateTime day) {
    return _events
        .where(
          (e) =>
              e.dateOnly.year == day.year &&
              e.dateOnly.month == day.month &&
              e.dateOnly.day == day.day,
        )
        .toList();
  }

  void _changeMonth(int delta) {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + delta);
    });
  }

  void _goToToday() {
    setState(() {
      _visibleMonth = DateTime(DateTime.now().year, DateTime.now().month);
    });
  }

  Future<void> _openAddDialog({DateTime? forDate}) async {
    final result = await showDialog<OsmCalendarActivity>(
      context: context,
      builder:
          (_) => AddEditEventDialog(initialDate: forDate ?? DateTime.now()),
    );
    if (result != null) {
      await _loadEvents();
    }
  }

  Future<void> _openEditDialog(OsmCalendarActivity event) async {
    final result = await showDialog<OsmCalendarActivity>(
      context: context,
      builder:
          (_) =>
              AddEditEventDialog(initialDate: event.dateOnly, existing: event),
    );
    if (result != null) {
      await _loadEvents();
    }
  }

  void _deleteEvent(OsmCalendarActivity event) {
    setState(() => _events.removeWhere((e) => e.id == event.id));
  }

  Future<void> _openDetailDialog(OsmCalendarActivity event) async {
    try {
      final freshEvent = await _service.getOsmActivityById(event.id);

      if (!mounted) return;

      showDialog(
        context: context,
        builder:
            (_) => EventDetailDialog(
              event: freshEvent,
              onEdit: () => _openEditDialog(freshEvent),
              onDelete: () => _deleteEvent(freshEvent),
            ),
      );
    } catch (e) {
      debugPrint('GET BY ID ERROR: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load event details')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      floatingActionButton: PermissionWidget(
        permission: AppPermissions.addCalendarActivity,
        child: FloatingActionButton.extended(
          onPressed: () => _openAddDialog(forDate: DateTime.now()),
          backgroundColor: primaryColor,
          icon: const Icon(Icons.add, color: Colors.white),
          label: Text(
            'Add Event',
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              _buildWeekdayRow(),
              const SizedBox(height: 4),
              Expanded(child: _buildMonthGrid()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    const weekdayNames = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    final today = DateTime.now();
    final todayLabel =
        '${weekdayNames[today.weekday - 1]}, ${months[today.month - 1]} ${today.day}, ${today.year}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '${months[_visibleMonth.month - 1]}, ${_visibleMonth.year}',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: kText,
              ),
            ),
            const SizedBox(width: 12),
            IconButton(
              icon: const Icon(Icons.chevron_left, color: kMuted),
              onPressed: () => _changeMonth(-1),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right, color: kMuted),
              onPressed: () => _changeMonth(1),
            ),
            const Spacer(),
            OutlinedButton(
              onPressed: _goToToday,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: kBorder),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Today',
                style: GoogleFonts.plusJakartaSans(color: kText, fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Padding(
          padding: const EdgeInsets.only(left: 2),
          child: Text(
            todayLabel,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: kMuted,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeekdayRow() {
    return Row(
      children:
          _weekdayLabels
              .map(
                (d) => Expanded(
                  child: Center(
                    child: Text(
                      d,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: kMuted,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
    );
  }

  Widget _buildMonthGrid() {
    final firstOfMonth = DateTime(_visibleMonth.year, _visibleMonth.month, 1);

    final leadingBlanks = firstOfMonth.weekday - 1;
    final daysInMonth =
        DateTime(_visibleMonth.year, _visibleMonth.month + 1, 0).day;
    final totalCells = leadingBlanks + daysInMonth;
    final rowCount = (totalCells / 7).ceil();

    return LayoutBuilder(
      builder: (context, constraints) {
        const crossAxisSpacing = 0.0;
        const mainAxisSpacing = 0.0;
        final cellWidth = (constraints.maxWidth - crossAxisSpacing * 6) / 7;
        final cellHeight =
            (constraints.maxHeight - mainAxisSpacing * (rowCount - 1)) /
            rowCount;
        final aspectRatio = cellWidth / cellHeight;

        return GridView.builder(
          itemCount: rowCount * 7,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: aspectRatio,
            crossAxisSpacing: crossAxisSpacing,
            mainAxisSpacing: mainAxisSpacing,
          ),
          itemBuilder: (context, index) {
            final dayNumber = index - leadingBlanks + 1;
            final isValidDay = dayNumber >= 1 && dayNumber <= daysInMonth;
            if (!isValidDay) {
              return Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(border: Border.all(color: kBorder)),
              );
            }
            final day = DateTime(
              _visibleMonth.year,
              _visibleMonth.month,
              dayNumber,
            );
            final isToday = _isSameDay(day, DateTime.now());
            final dayEvents = _eventsForDay(day);

            return GestureDetector(
              onTap: () => _openAddDialog(forDate: day),
              child: Container(
                margin: const EdgeInsets.all(2),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: kSurface,
                  border: Border.all(color: kBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 22,
                        height: 22,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isToday ? primaryColor : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '$dayNumber',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isToday ? Colors.white : kText,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          for (final e in dayEvents.take(3))
                            Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () => _openDetailDialog(e),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: e.displayColor,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      (e.isAllDay ?? false)
                                          ? e.title
                                          : '${e.title}  ${e.timeLabel}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          if (dayEvents.length > 3)
                            Padding(
                              padding: const EdgeInsets.only(top: 1),
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap:
                                      () => _openDayEventsList(day, dayEvents),
                                  child: Text(
                                    '+${dayEvents.length - 3} more',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                      color: kMuted,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _openDayEventsList(DateTime day, List<OsmCalendarActivity> events) {
    showDialog(
      context: context,
      builder:
          (_) => Dialog(
            backgroundColor: kSurface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 380, maxHeight: 480),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${day.month}/${day.day}/${day.year}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: kText,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            size: 20,
                            color: kMuted,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: events.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 6),
                        itemBuilder: (context, i) {
                          final e = events[i];
                          return GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              _openDetailDialog(e);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: e.displayColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      e.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    (e.isAllDay ?? false)
                                        ? 'All day'
                                        : e.timeLabel,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
