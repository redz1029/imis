import 'package:dio/dio.dart';
import 'package:imis/performance_governance_system/pgs_period/models/pgs_period.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/utils/page_list.dart';
import 'package:imis/utils/pagination_util.dart';

class PgsPeriodService {
  final Dio dio;

  PgsPeriodService(this.dio);
  Future<PageList<PgsPeriod>> getPgsPeriod({
    int page = 1,
    int pageSize = 15,
    String? searchQuery,
  }) async {
    final paginationUtil = PaginationUtil(dio);
    return await paginationUtil.fetchPaginatedData(
      endpoint: ApiEndpoint().pgsperiod,
      page: page,
      pageSize: pageSize,
      searchQuery: searchQuery,
      fromJson: (json) => PgsPeriod.fromJson(json),
    );
  }

  Future<void> createOrUpdatePgsPeriod(PgsPeriod period) async {
    var url = ApiEndpoint().pgsperiod;
    final Map<String, dynamic> requestData = period.toJson();
    final response = await AuthenticatedRequest.post(
      dio,
      url,
      data: requestData,
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create pgsPeriod');
    }
  }
}
