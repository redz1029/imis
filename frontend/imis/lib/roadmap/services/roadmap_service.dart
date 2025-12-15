import 'package:dio/dio.dart';
import 'package:imis/roadmap/models/roadmap.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/utils/page_list.dart';
import 'package:imis/utils/pagination_util.dart';

class RoadmapService {
  final Dio dio;

  RoadmapService(this.dio);

  Future<PageList<Roadmap>> getRoadmap({
    int page = 1,
    int pageSize = 15,
    String? searchQuery,
  }) async {
    final paginationUtil = PaginationUtil(dio);
    return await paginationUtil.fetchPaginatedData<Roadmap>(
      endpoint: ApiEndpoint().kraRoadMap,
      page: page,
      pageSize: pageSize,
      searchQuery: searchQuery,
      fromJson: (json) => Roadmap.fromJson(json),
    );
  }

  Future<void> createRoadmap(Roadmap roadmap) async {
    final url = ApiEndpoint().kraRoadMap;
    final Map<String, dynamic> requestData = roadmap.toJson();
    final response = await AuthenticatedRequest.post(
      dio,
      url,
      data: requestData,
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create roadmap');
    }
  }
}
