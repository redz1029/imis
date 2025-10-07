import 'package:dio/dio.dart';
import 'package:imis/announcements/models/announcement.dart';

import '../../utils/api_endpoint.dart';
import '../../utils/http_util.dart';

class AnnouncementService {
  final Dio dio;
  AnnouncementService(this.dio);

  Future<void> createAnnouncement(Announcement a) async {
    final url = ApiEndpoint().announcement;
    final Map<String, dynamic> requestData = a.toJson();
    final response = await AuthenticatedRequest.post(
      dio,
      url,
      data: requestData,
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create announcement');
    }
  }
}
