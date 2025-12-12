import 'package:dio/dio.dart';
import 'package:imis/roadmap/kra_period_roadmap/models/kra_roadmap_period.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/utils/page_list.dart';
import 'package:imis/utils/pagination_util.dart';

class KraPeriodRoadmapService {
  final Dio dio;

  KraPeriodRoadmapService(this.dio);
  Future<PageList<KraRoadmapPeriod>> getKraPeriod({
    int page = 1,
    int pageSize = 15,
    String? searchQuery,
  }) async {
    final paginationUtil = PaginationUtil(dio);
    return await paginationUtil.fetchPaginatedData(
      endpoint: ApiEndpoint().kraRoadMapPeriod,
      page: page,
      pageSize: pageSize,
      searchQuery: searchQuery,
      fromJson: (json) => KraRoadmapPeriod.fromJson(json),
    );
  }

  Future<void> createOrUpdateKraPeriod(KraRoadmapPeriod period) async {
    var url = ApiEndpoint().kraRoadMapPeriod;
    final Map<String, dynamic> requestData = period.toJson();
    final response = await AuthenticatedRequest.post(
      dio,
      url,
      data: requestData,
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create kraRoadMapPeriod');
    }
  }

  Future<void> deleteKraPeriod(String kraPeriod) async {
    final url = '${ApiEndpoint().kraRoadMapPeriod}/$kraPeriod';
    await AuthenticatedRequest.delete(dio, url);
  }
}
