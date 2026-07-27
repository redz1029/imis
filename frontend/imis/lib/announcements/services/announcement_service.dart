import 'package:dio/dio.dart';
import 'package:imis/announcements/models/announcement.dart';
import 'package:imis/utils/page_list.dart';
import 'package:imis/utils/pagination_util.dart';

import '../../utils/api_endpoint.dart';
import '../../utils/http_util.dart';

class AnnouncementService {
  final Dio dio;
  AnnouncementService(this.dio);

  Future<PageList<Announcement>> getAnnouncement({
    int page = 1,
    int pageSize = 15,
    String? searchQuery,
  }) async {
    final paginationUtil = PaginationUtil(dio);
    return await paginationUtil.fetchPaginatedData<Announcement>(
      endpoint: ApiEndpoint().announcement,
      page: page,
      pageSize: pageSize,
      searchQuery: searchQuery,
      fromJson: (json) => Announcement.fromJson(json),
    );
  }

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

  Future<List<Announcement>> getAnnouncements() async {
    final url = ApiEndpoint().announcementActive;
    final response = await AuthenticatedRequest.get(dio, url);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch announcements');
    }

    final List<dynamic> data = response.data;
    return data.map((json) => Announcement.fromJson(json)).toList();
  }

  Future<List<Announcement>> getAnnouncementsFromEndpoint(String url) async {
    final response = await AuthenticatedRequest.get(dio, url);
    final List data =
        response.data is List ? response.data : response.data['data'];
    return data.map((json) => Announcement.fromJson(json)).toList();
  }

  Future<void> updateAnnouncement(Announcement a) async {
    if (a.id == 0) {
      throw Exception('Announcement ID is required for update.');
    }

    final url = '${ApiEndpoint().announcement}/${a.id}';
    final Map<String, dynamic> requestData = a.toJson();

    final response = await AuthenticatedRequest.put(
      dio,
      url,
      data: requestData,
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to update announcement');
    }
  }

  Future<void> deleteAnnouncement(String announcement) async {
    final url = '${ApiEndpoint().announcement}/$announcement';
    await AuthenticatedRequest.delete(dio, url);
  }
}
