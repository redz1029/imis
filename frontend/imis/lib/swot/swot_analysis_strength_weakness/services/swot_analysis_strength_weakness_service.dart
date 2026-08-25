import 'package:dio/dio.dart';
import 'package:imis/swot/swot_analysis_strength_weakness/models/swot_analysis_strength_weakness.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/utils/page_list.dart';
import 'package:imis/utils/pagination_util.dart';

class SwotAnalysisStrengthWeaknessService {
  final Dio dio;

  SwotAnalysisStrengthWeaknessService(this.dio);
  Future<PageList<SwotAnalysisStrengthWeakness>> getSwotStrengthWeakness({
    int page = 1,
    int pageSize = 15,
    String? searchQuery,
  }) async {
    final paginationUtil = PaginationUtil(dio);
    return await paginationUtil
        .fetchPaginatedData<SwotAnalysisStrengthWeakness>(
          endpoint: '${ApiEndpoint().sWOTAnalysisStrengthWeakness}/page',
          page: page,
          pageSize: pageSize,
          searchQuery: searchQuery,
          fromJson: (json) => SwotAnalysisStrengthWeakness.fromJson(json),
        );
  }

  Future<void> createOrUpdateKra(SwotAnalysisStrengthWeakness swot) async {
    var url = ApiEndpoint().sWOTAnalysisStrengthWeakness;
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

  Future<List<SwotAnalysisStrengthWeakness>>
  getAllOpportunitiesThreats() async {
    final url = ApiEndpoint().sWOTAnalysisStrengthWeakness;
    final response = await AuthenticatedRequest.get(dio, url);

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data
          .map((json) => SwotAnalysisStrengthWeakness.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to fetch opportunities and threats');
    }
  }

  Future<void> deleteSwotStrengthWeakness(String swot) async {
    final url = '${ApiEndpoint().sWOTAnalysisStrengthWeakness}/$swot';
    await AuthenticatedRequest.delete(dio, url);
  }
}
