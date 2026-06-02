import 'package:dio/dio.dart';
import 'package:imis/roadmap/models/kra_roadmap_role.dart';
import 'package:imis/strategy_review_report/models/strategy_review_deliverable.dart';
import 'package:imis/strategy_review_report/models/strategy_review_kpi.dart';
import 'package:imis/strategy_review_report/models/strategy_review_report.dart';
import 'package:imis/team/models/team.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/utils/page_list.dart';
import 'package:imis/utils/pagination_util.dart';

class StrategyReviewReportServices {
  final Dio dio;

  StrategyReviewReportServices(this.dio);

  Future<PageList<Team>> getStrategyReviewReport({
    int page = 1,
    int pageSize = 15,
    String? searchQuery,
  }) async {
    final paginationUtil = PaginationUtil(dio);
    return await paginationUtil.fetchPaginatedData<Team>(
      endpoint: '${ApiEndpoint().team}/page',
      page: page,
      pageSize: pageSize,
      searchQuery: searchQuery,
      fromJson: (json) => Team.fromJson(json),
    );
  }

  Future<List<KraRoadmapRole>> getStrategyReviewByPeriod(int periodId) async {
    final url =
        '${ApiEndpoint.baseUrl}/KRARoadmapRole/strategyreview/roleid/$periodId';
    final response = await AuthenticatedRequest.get(dio, url);
    final List data = response.data as List;
    return data.map((e) => KraRoadmapRole.fromJson(e)).toList();
  }

  Future<StrategyReviewDeliverableItem?> getStrategyReviewDeliverables(
    int kraRoadMapId,
    int year,
  ) async {
    final url =
        '${ApiEndpoint.baseUrl}/strategyReview/deliverables/$kraRoadMapId/$year';
    final response = await AuthenticatedRequest.get(dio, url);
    final List data = response.data as List;
    if (data.isEmpty) return null;
    return StrategyReviewDeliverableItem.fromJson(data.first);
  }

  Future<StrategyReviewKpiItem?> getStrategyReviewKpis(
    int kraRoadMapId,
    int year,
  ) async {
    final url =
        '${ApiEndpoint.baseUrl}/strategyReview/kpis/$kraRoadMapId/$year';
    final response = await AuthenticatedRequest.get(dio, url);
    final List data = response.data as List;
    if (data.isEmpty) return null;
    return StrategyReviewKpiItem.fromJson(data.first);
  }

  Future<void> saveStrategyReview(StrategyReviewSaveRequest request) async {
    final url = '${ApiEndpoint.baseUrl}/strategyReview';
    final response = await AuthenticatedRequest.post(
      dio,
      url,
      data: request.toJson(),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to save strategy review');
    }
  }

  Future<void> updateStrategyReview(StrategyReviewSaveRequest request) async {
    final url = '${ApiEndpoint.baseUrl}/strategyReview/update';
    final response = await AuthenticatedRequest.put(
      dio,
      url,
      data: request.toJson(),
    );
    final statusCode = response.statusCode ?? 0;
    if (statusCode < 200 || statusCode >= 300) {
      throw Exception('Failed to update strategy review: $statusCode');
    }
  }

  Future<List<StrategyReviewReport>> getStrategyReviews() async {
    final url = '${ApiEndpoint.baseUrl}/strategyReview';
    final response = await AuthenticatedRequest.get(dio, url);
    final List data = response.data as List;
    return data.map((e) => StrategyReviewReport.fromJson(e)).toList();
  }

  Future<StrategyReviewReport> getStrategyReviewById(int id) async {
    final url = '${ApiEndpoint.baseUrl}/strategyReview/$id';
    final response = await AuthenticatedRequest.get(dio, url);
    return StrategyReviewReport.fromJson(response.data);
  }
}
