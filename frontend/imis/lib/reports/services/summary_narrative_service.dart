import 'package:dio/dio.dart';
import 'package:imis/performance_governance_system/pgs_period/models/pgs_period.dart';
import 'package:imis/reports/models/pgs_summary_narrative.dart';
import 'package:imis/user/models/user_registration.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/auth_util.dart';
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
    int? periodId,
    int? officeId,
  }) async {
    final paginationUtil = PaginationUtil(dio);
    UserRegistration? user = await AuthUtil.fetchLoggedUser();
    if (user == null) {
      throw Exception("User not logged in");
    }

    final queryParams = <String, String>{};
    if (periodId != null) queryParams['periodId'] = periodId.toString();
    if (officeId != null) queryParams['office'] = officeId.toString();

    final queryString = queryParams.entries
        .map((e) => '${e.key}=${e.value}')
        .join('&');

    final endpoint =
        "${ApiEndpoint().summaryNarrative}/byAuditor${queryString.isNotEmpty ? '?$queryString' : ''}";

    return await paginationUtil.fetchPaginatedData<PgsSummaryNarrative>(
      endpoint: endpoint,
      page: page,
      pageSize: pageSize,
      searchQuery: searchQuery,
      fromJson: (json) => PgsSummaryNarrative.fromJson(json),
    );
  }

  Future<PageList<PgsSummaryNarrative>> getSummaryNarrativeHeadAuditor({
    int page = 1,
    int pageSize = 15,
    String? searchQuery,
    int? periodId,
    int? officeId,
  }) async {
    final paginationUtil = PaginationUtil(dio);
    UserRegistration? user = await AuthUtil.fetchLoggedUser();
    if (user == null) {
      throw Exception("User not logged in");
    }

    final queryParams = <String, String>{};
    if (periodId != null) queryParams['periodId'] = periodId.toString();
    if (officeId != null) queryParams['office'] = officeId.toString();

    final queryString = queryParams.entries
        .map((e) => '${e.key}=${e.value}')
        .join('&');

    final endpoint =
        "${ApiEndpoint().summaryNarrativeAuditorHead}/byHeadAuditor${queryString.isNotEmpty ? '?$queryString' : ''}";

    return await paginationUtil.fetchPaginatedData<PgsSummaryNarrative>(
      endpoint: endpoint,
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

  Future<void> addSummaryNarrativeAuditorHead(
    PgsSummaryNarrative pgsSummaryNarrative,
  ) async {
    final url = ApiEndpoint().summaryNarrativeAuditorHead;
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
        final item = (response.data as List)
            .cast<Map<String, dynamic>>()
            .firstWhere(
              (element) => element['pgsPeriodId'] == periodId,
              orElse: () => {},
            );

        if (item.isNotEmpty) {
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

  Future<bool> checkExistingSummaryNarrative(int periodId, int officeId) async {
    final response = await AuthenticatedRequest.get(
      dio,
      '${ApiEndpoint().summaryNarrative}?periodId=$periodId&officeId=$officeId',
    );

    final data = response.data;

    if (data == null) return false;

    if (data is List) {
      return data.any((item) {
        final p = int.tryParse(item['periodId'].toString()) ?? 0;
        final o = int.tryParse(item['officeId'].toString()) ?? 0;

        return p == periodId && o == officeId;
      });
    } else if (data is Map) {
      final p = int.tryParse(data['periodId'].toString()) ?? 0;
      final o = int.tryParse(data['officeId'].toString()) ?? 0;
      return p == periodId && o == officeId;
    }

    return false;
  }
}
