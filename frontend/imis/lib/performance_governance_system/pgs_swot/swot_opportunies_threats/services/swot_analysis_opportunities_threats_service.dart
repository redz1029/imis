import 'package:dio/dio.dart';
import 'package:imis/performance_validation_tool/pgs_swot/swot_opportunies_threats/models/swot_analysis_opportunities_threats.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/utils/page_list.dart';
import 'package:imis/utils/pagination_util.dart';

class SwotAnalysisOpportunitiesThreatsService {
  final Dio dio;

  SwotAnalysisOpportunitiesThreatsService(this.dio);
  Future<PageList<SwotAnalysisOpportunitiesThreats>>
  getSwotOpportunitiesThreats({
    int page = 1,
    int pageSize = 15,
    String? searchQuery,
  }) async {
    final paginationUtil = PaginationUtil(dio);
    return await paginationUtil
        .fetchPaginatedData<SwotAnalysisOpportunitiesThreats>(
          endpoint: '${ApiEndpoint().sWOTAnalysisOpportunitiesThreats}/page',
          page: page,
          pageSize: pageSize,
          searchQuery: searchQuery,
          fromJson: (json) => SwotAnalysisOpportunitiesThreats.fromJson(json),
        );
  }

  Future<void> createOrUpdateSwotOpportunitiesThreats(
    SwotAnalysisOpportunitiesThreats swot,
  ) async {
    var url = ApiEndpoint().sWOTAnalysisOpportunitiesThreats;
    final Map<String, dynamic> requestData = swot.toJson();
    final response = await AuthenticatedRequest.post(
      dio,
      url,
      data: requestData,
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create kra');
    }
  }

  Future<List<SwotAnalysisOpportunitiesThreats>>
  getAllOpportunitiesThreats() async {
    final url = ApiEndpoint().sWOTAnalysisOpportunitiesThreats;
    final response = await AuthenticatedRequest.get(dio, url);

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data
          .map((json) => SwotAnalysisOpportunitiesThreats.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to fetch opportunities and threats');
    }
  }

  Future<void> deleteSwotStrengthWeakness(String swot) async {
    final url = '${ApiEndpoint().sWOTAnalysisOpportunitiesThreats}/$swot';
    await AuthenticatedRequest.delete(dio, url);
  }
}
