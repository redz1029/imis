import 'package:dio/dio.dart';
import 'package:imis/roadmap/models/kra_roadmap_filter.dart';
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

  Future<void> deleteRoadmap(String roadMap) async {
    final url = '${ApiEndpoint().kraRoadMap}/$roadMap';
    await AuthenticatedRequest.delete(dio, url);
  }

  Future<List<dynamic>> getAllKraDescriptions({required int kraId}) async {
    final url =
        '${ApiEndpoint().kraRoadMap}/getAllkraDescriptions?kraId=$kraId';

    final response = await AuthenticatedRequest.get(dio, url);

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to fetch KRA descriptions');
    }
  }

  Future<List<dynamic>> kraRoadmapFilter(KraRoadmapFilter filter) async {
    final queryParams = {
      'kraId': filter.kraId.toString(),
      'year': filter.year.toString(),
      'kraDescription': filter.kraDescription,
      'isDirect': filter.isDirect.toString(),
    };

    final uri = Uri.parse(
      '${ApiEndpoint().kraRoadMap}/filter',
    ).replace(queryParameters: queryParams);

    final response = await AuthenticatedRequest.get(dio, uri.toString());

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to filter KRA roadmap');
    }

    return List<Map<String, dynamic>>.from(response.data);
  }
}
