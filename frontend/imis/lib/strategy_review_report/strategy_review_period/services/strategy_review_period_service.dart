import 'package:dio/dio.dart';
import 'package:imis/strategy_review_report/strategy_review_period/models/strategy_review_period.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/utils/page_list.dart';
import 'package:imis/utils/pagination_util.dart';

class StrategyReviewPeriodService {
  final Dio dio;

  StrategyReviewPeriodService(this.dio);
  Future<PageList<StrategyReviewPeriod>> getPgsPeriod({
    int page = 1,
    int pageSize = 15,
    String? searchQuery,
  }) async {
    final paginationUtil = PaginationUtil(dio);
    return await paginationUtil.fetchPaginatedData(
      endpoint: '${ApiEndpoint().strategyReviewPeriod}/page',
      page: page,
      pageSize: pageSize,
      searchQuery: searchQuery,
      fromJson: (json) => StrategyReviewPeriod.fromJson(json),
    );
  }

  Future<void> createOrUpdatePgsPeriod(StrategyReviewPeriod period) async {
    var url = ApiEndpoint().strategyReviewPeriod;
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

  Future<void> deletePeriod(String period) async {
    final url = '${ApiEndpoint().strategyReviewPeriod}/$period';
    await AuthenticatedRequest.delete(dio, url);
  }
}
