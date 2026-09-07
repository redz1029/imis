import 'package:dio/dio.dart';
import 'package:imis/performance_governance_system/pgs_swot/models/swot.dart';
import 'package:imis/performance_governance_system/pgs_swot/models/swot_service_head.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/utils/page_list.dart';
import 'package:imis/utils/pagination_util.dart';

class SwotServiceHeadService {
  final Dio dio;

  SwotServiceHeadService(this.dio);
  Future<PageList<Swot>> getSwotServiceHead({
    int page = 1,
    int pageSize = 15,
    String? searchQuery,
    required String userId,
    required String roleId,
    int? officeId,
  }) async {
    final paginationUtil = PaginationUtil(dio);

    return await paginationUtil.fetchPaginatedData(
      endpoint: '${ApiEndpoint().sWOTAnalysisServiceHead}/page',
      page: page,
      pageSize: pageSize,
      searchQuery: searchQuery,
      additionalParams: {
        'userId': userId,
        'roleId': roleId,
        if (officeId != null) 'officeId': officeId,
      },
      fromJson: (json) => Swot.fromJson(json),
    );
  }

  Future<void> createSwotServiceHead(SwotServiceHead swot) async {
    final url = ApiEndpoint().sWOTAnalysisServiceHead;
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

  Future<void> deleteSwotServiceHead(String swotId) async {
    final url = '${ApiEndpoint().sWOTAnalysisServiceHead}/$swotId';
    await AuthenticatedRequest.delete(dio, url);
  }

  Future<SwotServiceHead> getSwotById(String swotId) async {
    final url = '${ApiEndpoint().sWOTAnalysisServiceHead}/$swotId';

    final response = await AuthenticatedRequest.get(dio, url);

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return SwotServiceHead.fromJson(data);
      }
      throw Exception('Unexpected response shape for SWOT by ID');
    } else {
      throw Exception(
        'Failed to fetch SWOT by ID (status: ${response.statusCode})',
      );
    }
  }
}
