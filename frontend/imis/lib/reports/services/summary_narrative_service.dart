import 'package:dio/dio.dart';
import 'package:imis/performance_governance_system/pgs_period/models/pgs_period.dart';
import 'package:imis/reports/models/pgs_summary_narrative.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/utils/page_list.dart';
import 'package:imis/utils/pagination_util.dart';

class SummaryNarrativeService {
  final Dio dio;

  SummaryNarrativeService(this.dio);

  Future<PageList<PgsSummaryNarrative>> getSummaryNarrative({
    int page = 1,
    int pageSize = 15,
    String? searchQuery,
  }) async {
    final paginationUtil = PaginationUtil(dio);
    return await paginationUtil.fetchPaginatedData<PgsSummaryNarrative>(
      endpoint: ApiEndpoint().summaryNarrative,
      page: page,
      pageSize: pageSize,
      searchQuery: searchQuery,
      fromJson: (json) => PgsSummaryNarrative.fromJson(json),
    );
  }

  Future<void> addSummaryNarrative(
    PgsSummaryNarrative pgsSummaryNarrative,
  ) async {
    final url = ApiEndpoint().summaryNarrative;
    final Map<String, dynamic> requestData = pgsSummaryNarrative.toJson();
    final response = await AuthenticatedRequest.post(
      dio,
      url,
      data: requestData,
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create summary narrative');
    }
  }

  Future<PgsPeriod> getPeriodDates(int periodId) async {
    final url = ApiEndpoint().pgsperiod;
    final response = await AuthenticatedRequest.get(
      dio,
      url,
    ); // Adjust API path accordingly

    if (response.statusCode == 200) {
      final data = response.data;
      return PgsPeriod(0, false, DateTime.now(), DateTime.now(), 'remarks');
    } else {
      throw Exception('Failed to fetch period dates');
    }
  }

  Future<List<dynamic>> getSummaryNarratives() async {
    final url = ApiEndpoint().summaryNarrative;

    final response = await AuthenticatedRequest.get(dio, url);

    if (response.statusCode == 200) {
      // Assuming API returns a JSON array
      return response.data;
    } else {
      throw Exception('Failed to fetch summary narratives');
    }
  }
}
