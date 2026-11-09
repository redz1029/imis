/// One IQA notification of the signed-in user, shown in the bell.
class IqaNotification {
  IqaNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.entityType,
    required this.entityId,
    required this.targetPage,
    required this.createdAt,
    required this.isRead,
  });

  final int id;

  /// What happened, e.g. "Submitted", "Rejected", "NcarRaised".
  final String type;
  final String title;
  final String message;

  /// "AuditPlan", "AuditReport", "Ncar", ...
  final String entityType;
  final int? entityId;

  /// The ISO sub-page the item is on: 0 Programme, 1 Plan, 2 Schedules,
  /// 3 Checklist, 4 Report, 5 NCAR (the sidebar's sub-page index).
  final int targetPage;

  /// The user's local time.
  final DateTime createdAt;
  bool isRead;

  factory IqaNotification.fromJson(Map<String, dynamic> json) {
    final created = DateTime.tryParse((json['createdAt'] ?? '').toString());
    return IqaNotification(
      id: (json['id'] as num?)?.toInt() ?? 0,
      type: (json['type'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      message: (json['message'] ?? '').toString(),
      entityType: (json['entityType'] ?? '').toString(),
      entityId: (json['entityId'] as num?)?.toInt(),
      targetPage: (json['targetPage'] as num?)?.toInt() ?? 0,
      createdAt: (created ?? DateTime.now()).toLocal(),
      isRead: json['isRead'] == true,
    );
  }
}

/// The latest notifications and how many are unread.
class IqaNotificationList {
  const IqaNotificationList({required this.items, required this.unreadCount});

  final List<IqaNotification> items;
  final int unreadCount;

  static const empty = IqaNotificationList(items: [], unreadCount: 0);
}
