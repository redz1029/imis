import 'package:dio/dio.dart';
import 'package:imis/performance_governance_system/pgs_swot/models/swot.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/utils/page_list.dart';
import 'package:imis/utils/pagination_util.dart';

class SwotService {
  final Dio dio;

  SwotService(this.dio);
  Future<PageList<Swot>> getSwot({
    int page = 1,
    int pageSize = 15,
    String? searchQuery,
    required String userId,
    int? officeId,
  }) async {
    final paginationUtil = PaginationUtil(dio);

    return await paginationUtil.fetchPaginatedData(
      endpoint: '${ApiEndpoint().swotAnalysis}/page',
      page: page,
      pageSize: pageSize,
      searchQuery: searchQuery,
      additionalParams: {
        'userId': userId,
        if (officeId != null) 'officeId': officeId,
      },
      fromJson: (json) => Swot.fromJson(json),
    );
  }

  Future<void> createSwot(Swot swot) async {
    final url = ApiEndpoint().swotAnalysis;
    final Map<String, dynamic> requestData = swot.toJson();
    final response = await AuthenticatedRequest.post(
      dio,
      url,
      data: requestData,
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create swot');
    }
  }

  Future<void> deleteSwot(String swotId) async {
    final url = '${ApiEndpoint().swotAnalysis}/$swotId';
    await AuthenticatedRequest.delete(dio, url);
  }

  Future<Swot> getSwotById(String swotId) async {
    final url = '${ApiEndpoint().swotAnalysis}/$swotId';

    final response = await AuthenticatedRequest.get(dio, url);

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data;
      if (data is Map<String, dynamic>) {
        // No manual normalization needed anymore -- Swot.fromJson
        // coerces int-vs-String fields itself via @JsonKey(fromJson:).
        return Swot.fromJson(data);
      }
      throw Exception('Unexpected response shape for SWOT by ID');
    } else {
      throw Exception(
        'Failed to fetch SWOT by ID (status: ${response.statusCode})',
      );
    }
  }
}
