/// One free start time of an audit team.
class AuditSlot {
  const AuditSlot({
    required this.time,
    required this.start,
    required this.label,
    required this.period,
  });

  /// "HH:mm".
  final String time;

  /// The day and time the audit would start (the user's wall-clock time).
  final DateTime start;

  /// "9:00 AM".
  final String label;

  /// "Morning" or "Afternoon".
  final String period;

  factory AuditSlot.fromJson(Map<String, dynamic> json) {
    final start = DateTime.tryParse((json['start'] ?? '').toString());
    return AuditSlot(
      time: (json['time'] ?? '').toString(),
      start: start ?? DateTime.now(),
      label: (json['label'] ?? '').toString(),
      period: (json['period'] ?? '').toString(),
    );
  }
}

/// The free start times of one day of the audit plan.
class AuditSlotDay {
  const AuditSlotDay({
    required this.date,
    required this.dayNumber,
    required this.slots,
  });

  final DateTime date;
  final int dayNumber;
  final List<AuditSlot> slots;

  factory AuditSlotDay.fromJson(Map<String, dynamic> json) {
    final date = DateTime.tryParse((json['date'] ?? '').toString());
    final raw = json['slots'];
    return AuditSlotDay(
      date: date == null ? DateTime.now() : DateTime(date.year, date.month, date.day),
      dayNumber: (json['dayNumber'] as num?)?.toInt() ?? 0,
      slots: [
        if (raw is List)
          for (final s in raw)
            if (s is Map) AuditSlot.fromJson(Map<String, dynamic>.from(s)),
      ],
    );
  }
}

/// When the audit team (and the audited office) are free: the only times a
/// Department Head may ask an audit to be moved to.
class AuditSlotAvailability {
  const AuditSlotAvailability({
    required this.auditScheduleId,
    required this.currentStart,
    required this.days,
    required this.hasFreeSlots,
    this.officeName,
    this.teamName,
    this.message,
  });

  final int auditScheduleId;
  final String? officeName;
  final String? teamName;

  /// When the audit is scheduled now.
  final DateTime currentStart;
  final List<AuditSlotDay> days;
  final bool hasFreeSlots;

  /// Why nothing is offered, when nothing is.
  final String? message;

  factory AuditSlotAvailability.fromJson(Map<String, dynamic> json) {
    final current = DateTime.tryParse((json['currentStart'] ?? '').toString());
    final raw = json['days'];
    final days = [
      if (raw is List)
        for (final d in raw)
          if (d is Map) AuditSlotDay.fromJson(Map<String, dynamic>.from(d)),
    ];
    return AuditSlotAvailability(
      auditScheduleId: (json['auditScheduleId'] as num?)?.toInt() ?? 0,
      officeName: json['officeName']?.toString(),
      teamName: json['teamName']?.toString(),
      currentStart: current ?? DateTime.now(),
      days: days,
      hasFreeSlots: days.any((d) => d.slots.isNotEmpty),
      message: json['message']?.toString(),
    );
  }
}
