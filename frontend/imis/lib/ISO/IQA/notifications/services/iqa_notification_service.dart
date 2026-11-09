import 'package:dio/dio.dart';
import 'package:imis/ISO/IQA/notifications/models/iqa_notification.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/auth_util.dart';

/// The IQA notifications of the signed-in user (the bell).
///
/// These calls run quietly in the background (the bell asks again every
/// minute), so they deliberately do not go through AuthenticatedRequest: that
/// helper sends the whole app to the "No Connection" page on any connection
/// error, which must never happen because of a notification refresh.
class IqaNotificationService {
  IqaNotificationService(this.dio);

  final Dio dio;

  String get _base => ApiEndpoint().iqaNotifications;

  Future<Options?> _authorized() async {
    final user = await AuthUtil.processTokenValidity(dio);
    final token = user?.accessToken;
    if (token == null || token.isEmpty) return null;
    return Options(
      headers: {'Authorization': 'Bearer $token'},
      // Never throw for an HTTP status; the caller checks it.
      validateStatus: (_) => true,
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
    );
  }

  /// GET /iqaNotifications — the newest notifications and the unread count.
  /// Throws when they cannot be loaded, so the bell can keep what it shows.
  Future<IqaNotificationList> getNotifications({int limit = 30}) async {
    final options = await _authorized();
    if (options == null) {
      throw Exception('Not signed in.');
    }
    final response = await dio.get('$_base?limit=$limit', options: options);
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
    final options = await _authorized();
    if (options == null) return;
    await dio.put('$_base/$id/read', options: options);
  }

  /// PUT /iqaNotifications/read-all
  Future<void> markAllRead() async {
    final options = await _authorized();
    if (options == null) return;
    await dio.put('$_base/read-all', options: options);
  }
}
