import 'package:dio/dio.dart';
import 'package:imis/performance_governance_system/pgs_scorecard/models/impact_strategic_goal_scorecard.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/utils/page_list.dart';
import 'package:imis/utils/pagination_util.dart';

class ImpactStrategyScorecardService {
  final Dio dio;

  ImpactStrategyScorecardService(this.dio);

  Future<PageList<ImpactStrategicGoalScoreCard>>
  getImpactStrategicGoalScorecard({
    required int periodId,
    int page = 1,
    int pageSize = 15,
    String? searchQuery,
  }) async {
    final paginationUtil = PaginationUtil(dio);

    return await paginationUtil.fetchPaginatedData(
      endpoint:
          '${ApiEndpoint().impactStrategicGoalScoreCard}/page/period/$periodId',
      page: page,
      pageSize: pageSize,
      searchQuery: searchQuery,
      additionalParams: {},
      fromJson: (json) => ImpactStrategicGoalScoreCard.fromJson(json),
    );
  }

  Future<void> saveScorecard(ImpactStrategicGoalScoreCard scorecard) async {
    final isEdit = scorecard.id > 0;
    final url =
        ApiEndpoint().impactStrategicGoalScoreCard +
        (isEdit ? '/${scorecard.id}' : '');

    final response =
        isEdit
            ? await AuthenticatedRequest.put(dio, url, data: scorecard.toJson())
            : await AuthenticatedRequest.post(
              dio,
              url,
              data: scorecard.toJson(),
            );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to save impact strategy scorecard');
    }
  }

  Future<ImpactStrategicGoalScoreCard?> fetchByPeriodId(int periodId) async {
    final pageList = await getImpactStrategicGoalScorecard(
      periodId: periodId,
      page: 1,
      pageSize: 1,
    );

    if (pageList.items.isEmpty) return null;
    return pageList.items.first;
  }

  Future<ImpactStrategicGoalScoreCard?> fetchById(int id) async {
    final url = '${ApiEndpoint().impactStrategicGoalScoreCard}/$id';
    final response = await AuthenticatedRequest.get(dio, url);

    if (response.statusCode == 200) {
      if (response.data == null) return null;
      return ImpactStrategicGoalScoreCard.fromJson(response.data);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to fetch impact strategy scorecard');
    }
  }

  Future<void> deleteImpactStratgyGoalScorecard(
    String impactStrategyGoal,
  ) async {
    final url =
        '${ApiEndpoint().impactStrategicGoalScoreCard}/$impactStrategyGoal';
    await AuthenticatedRequest.delete(dio, url);
  }
}
