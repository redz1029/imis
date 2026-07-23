import 'package:flutter/material.dart';
import 'package:imis/osm_calendar_activity/models/osm_calendar_activity.dart';

const List<Color> kCalendarColorPalette = [
  Color(0xFFdb5e80), // pgsColor
  Color(0xFF64aae3), // Iso color
];

extension OsmCalendarActivityUi on OsmCalendarActivity {
  Color get displayColor {
    try {
      final hex = (color ?? '').replaceFirst('#', '');
      if (hex.isEmpty) return kCalendarColorPalette.first;
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return kCalendarColorPalette.first;
    }
  }

  DateTime get dateOnly =>
      DateTime(startDate.year, startDate.month, startDate.day);

  TimeOfDay? get startTimeOfDay => _parseTimeString(startTime);
  TimeOfDay? get endTimeOfDay => _parseTimeString(endTime);

  String get timeLabel {
    if (isAllDay == true) return 'All day';
    final start = startTimeOfDay;
    if (start == null) return '';
    final startLabel = _formatTimeOfDay(start);
    final end = endTimeOfDay;
    if (end == null) return startLabel;
    return '$startLabel - ${_formatTimeOfDay(end)}';
  }

  String? get attachmentName =>
      (attachmentPath != null && attachmentPath!.isNotEmpty)
          ? attachmentPath!.split('/').last
          : null;
}

String _formatTimeOfDay(TimeOfDay t) {
  final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
  final minute = t.minute.toString().padLeft(2, '0');
  final period = t.period == DayPeriod.am ? 'AM' : 'PM';
  return '$hour:$minute $period';
}

TimeOfDay? _parseTimeString(String? value) {
  if (value == null) return null;
  final parts = value.split(':');
  if (parts.length < 2) return null;
  final hour = int.tryParse(parts[0]);
  final minute = int.tryParse(parts[1]);
  if (hour == null || minute == null) return null;
  return TimeOfDay(hour: hour, minute: minute);
}
