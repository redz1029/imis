import 'package:dio/dio.dart';
import 'package:imis/performance_governance_system/models/performance_governance_system.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/page_list.dart';
import 'package:imis/utils/pagination_util.dart';

class OperationReviewProtocolServices {
  final Dio dio;

  OperationReviewProtocolServices(this.dio);
  Future<PageList<PerformanceGovernanceSystem>> getOperationReviewProtocolList({
    int page = 1,
    int pageSize = 15,
    String? searchQuery,
    required String roleId,
  }) async {
    final paginationUtil = PaginationUtil(dio);
    return await paginationUtil.fetchPaginatedData(
      endpoint: '${ApiEndpoint().pgsAuditorOperationReview}/$roleId',
      page: page,
      pageSize: pageSize,
      searchQuery: searchQuery,
      fromJson: (json) => PerformanceGovernanceSystem.fromJson(json),
    );
  }
}
