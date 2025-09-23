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

  Future<dynamic> getSummaryNarrativeById(int id) async {
    final url = "${ApiEndpoint().summaryNarrative}/$id";
    final response = await AuthenticatedRequest.get(dio, url);

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception("Failed to fetch summary narrative by ID");
    }
  }

  Future<void> updateSummaryNarrative(
    int id,
    PgsSummaryNarrative pgsSummaryNarrative,
  ) async {
    final url = "${ApiEndpoint().summaryNarrative}/$id";
    final Map<String, dynamic> requestData = pgsSummaryNarrative.toJson();

    final response = await AuthenticatedRequest.put(
      dio,
      url,
      data: requestData,
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to update summary narrative');
    }
  }

  Future<PgsPeriod> getPeriodDates(int periodId) async {
    final url = ApiEndpoint().pgsperiod;

    final response = await AuthenticatedRequest.get(dio, url);

    if (response.statusCode == 200 && response.data is List) {
      final periods =
          (response.data as List).map((e) => PgsPeriod.fromJson(e)).toList();

      return periods.firstWhere(
        (p) => p.id == periodId,
        orElse: () => throw Exception('Period not found'),
      );
    } else {
      throw Exception('Failed to fetch period list');
    }
  }

  Future<PgsSummaryNarrative?> checkIfPeriodHasNarrative(int periodId) async {
    final url = ApiEndpoint().summaryNarrative;

    try {
      final response = await AuthenticatedRequest.get(
        dio,
        url,
        queryParameters: {'pgsPeriodId': periodId},
      );

      if (response.data is List && response.data.isNotEmpty) {
        final item = response.data.first;
        final existingPeriodId = item['pgsPeriodId'] as int?;
        if (existingPeriodId == periodId) {
          return PgsSummaryNarrative.fromJson(item);
        }
      }
      // ignore: empty_catches
    } catch (e) {}

    return null;
  }

  Future<List<dynamic>> getSummaryNarratives() async {
    final url = ApiEndpoint().summaryNarrative;

    final response = await AuthenticatedRequest.get(dio, url);

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to fetch summary narratives');
    }
  }
}
