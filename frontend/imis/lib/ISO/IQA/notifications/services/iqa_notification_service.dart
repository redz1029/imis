import 'package:dio/dio.dart';
import 'package:imis/ISO/IQA/notifications/models/iqa_notification.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';

/// The IQA notifications of the signed-in user (the bell).
class IqaNotificationService {
  IqaNotificationService(this.dio);

  final Dio dio;

  String get _base => ApiEndpoint().iqaNotifications;

  /// GET /iqaNotifications — the newest notifications and the unread count.
  /// Throws when they cannot be loaded, so the bell can keep what it shows.
  Future<IqaNotificationList> getNotifications({int limit = 30}) async {
    final response = await AuthenticatedRequest.get(
      dio,
      '$_base?limit=$limit',
    );
    final data = response.data;
    if (response.statusCode != 200 || data is! Map) {
      throw Exception('Could not load the IQA notifications.');
    }
    final raw = data['items'];
    return IqaNotificationList(
      unreadCount: (data['unreadCount'] as num?)?.toInt() ?? 0,
      items: [
        if (raw is List)
          for (final e in raw)
            if (e is Map)
              IqaNotification.fromJson(Map<String, dynamic>.from(e)),
      ],
    );
  }

  /// PUT /iqaNotifications/{id}/read
  Future<void> markRead(int id) async {
    await AuthenticatedRequest.put(dio, '$_base/$id/read');
  }

  /// PUT /iqaNotifications/read-all
  Future<void> markAllRead() async {
    await AuthenticatedRequest.put(dio, '$_base/read-all');
  }
}
