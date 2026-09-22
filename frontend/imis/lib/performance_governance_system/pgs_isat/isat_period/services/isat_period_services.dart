import 'package:dio/dio.dart';
import 'package:imis/performance_governance_system/pgs_isat/isat_period/models/isat_period.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/utils/page_list.dart';
import 'package:imis/utils/pagination_util.dart';

class IsatPeriodServices {
  final Dio dio;

  IsatPeriodServices(this.dio);
  Future<PageList<IsatPeriod>> getIsatPeriodList({
    int page = 1,
    int pageSize = 15,
    String? searchQuery,
  }) async {
    final paginationUtil = PaginationUtil(dio);
    return await paginationUtil.fetchPaginatedData(
      endpoint: '${ApiEndpoint().isatPeriod}/page',
      searchQuery: searchQuery,
      fromJson: (json) => IsatPeriod.fromJson(json),
    );
  }

  Future<void> createOrUpdateIsatPeriod(IsatPeriod period) async {
    var url = ApiEndpoint().isatPeriod;
    final Map<String, dynamic> requestData = period.toJson();
    final response = await AuthenticatedRequest.post(
      dio,
      url,
      data: requestData,
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create isat period');
    }
  }

  Future<void> deleteIsatPeriod(String period) async {
    final url = '${ApiEndpoint().isatPeriod}/$period';
    await AuthenticatedRequest.delete(dio, url);
  }
}
