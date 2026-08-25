import 'package:dio/dio.dart';
import 'package:imis/scorecard/impact_strategic_goal_scorecard_period/models/impact_strategic_goal_scorecard_period.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/page_list.dart';
import 'package:imis/utils/pagination_util.dart';
import '../../../utils/http_util.dart';

class ImpacStrategicGoalScorecardPeriodService {
  final Dio dio;

  ImpacStrategicGoalScorecardPeriodService(this.dio);

  Future<PageList<ImpactStrategicGoalScorecardPeriod>> getImpactPeriod({
    int page = 1,
    int pageSize = 15,
    String? searchQuery,
  }) async {
    final paginationUtil = PaginationUtil(dio);
    return await paginationUtil.fetchPaginatedData(
      endpoint: '${ApiEndpoint().impactStrategicGoalScoreCardPeriod}/page',
      page: page,
      pageSize: pageSize,
      searchQuery: searchQuery,
      fromJson: (json) => ImpactStrategicGoalScorecardPeriod.fromJson(json),
    );
  }

  Future<void> createOrUpdateImpactPeriod(
    ImpactStrategicGoalScorecardPeriod period,
  ) async {
    var url = ApiEndpoint().impactStrategicGoalScoreCardPeriod;
    final Map<String, dynamic> requestData = period.toJson();
    final response = await AuthenticatedRequest.post(
      dio,
      url,
      data: requestData,
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create period');
    }
  }

  Future<void> deletePeriod(String period) async {
    final url = '${ApiEndpoint().impactStrategicGoalScoreCardPeriod}/period';
    await AuthenticatedRequest.delete(dio, url);
  }
}
