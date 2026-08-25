import 'package:dio/dio.dart';
import 'package:imis/roadmap/models/kra_roadmap_filter.dart';
import 'package:imis/roadmap/models/kra_roadmap_role.dart';
import 'package:imis/roadmap/models/roadmap.dart';
import 'package:imis/roadmap/models/roadmap_history.dart';
import 'package:imis/roadmap_kpi_sequence/models/roadmap_kpi_sequence.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/utils/page_list.dart';
import 'package:imis/utils/pagination_util.dart';

class RoadmapService {
  final Dio dio;

  RoadmapService(this.dio);

  Future<PageList<Roadmap>> getRoadmap({
    required String roleId,
    int page = 1,
    int pageSize = 15,
    String? searchQuery,
  }) async {
    final paginationUtil = PaginationUtil(dio);
    return await paginationUtil.fetchPaginatedData<Roadmap>(
      endpoint: '${ApiEndpoint().kraRoadMap}/roleid/$roleId',
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

  Future<Roadmap> getRoadmapId(int id) async {
    final url = '${ApiEndpoint().kraRoadMap}/$id';

    final response = await AuthenticatedRequest.get(dio, url);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch roadmap');
    }

    return Roadmap.fromJson(response.data);
  }

  Future<void> deleteRoadmap(String roadMap) async {
    final url = '${ApiEndpoint().kraRoadMap}/$roadMap';
    await AuthenticatedRequest.delete(dio, url);
  }

  Future<List<RoadmapHistory>> getRoadmapHistory(String id) async {
    final url = '${ApiEndpoint().roadmapidlist}/?roadmapid=$id';

    final response = await AuthenticatedRequest.get(dio, url);

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data
          .map((json) => RoadmapHistory.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to fetch roadmap history');
    }
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

  Future<List<KraRoadmapRole>> getKraRoadmapByRoleId() async {
    final url = ApiEndpoint().kraRoadmapRole;

    final response = await AuthenticatedRequest.get(dio, url);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch KRA roadmap by role');
    }

    return List<KraRoadmapRole>.from(
      response.data.map((data) => KraRoadmapRole.fromJson(data)),
    );
  }

  Future<List<RoadmapKpiSequence>> getRoadmapSequence() async {
    final response = await AuthenticatedRequest.get(
      dio,
      ApiEndpoint().kraRoadmapKPISequence,
    );
    return (response.data as List)
        .map((e) => RoadmapKpiSequence.fromJson(e))
        .toList();
  }
}
