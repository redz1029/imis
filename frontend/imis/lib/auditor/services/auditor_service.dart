import 'package:dio/dio.dart';
import 'package:imis/auditor/models/auditor.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/utils/page_list.dart';
import 'package:imis/utils/pagination_util.dart';

class AuditorService {
  final Dio dio;

  AuditorService(this.dio);

  Future<PageList<Auditor>> getAuditor({
    int page = 1,
    int pageSize = 15,
    String? searchQuery,
  }) async {
    final paginationUtil = PaginationUtil(dio);
    return await paginationUtil.fetchPaginatedData<Auditor>(
      endpoint: ApiEndpoint().auditor,
      page: page,
      pageSize: pageSize,
      searchQuery: searchQuery,
      fromJson: (json) => Auditor.fromJson(json),
    );
  }

  Future<void> addOrUpdateAuditor(Auditor auditor) async {
    var url = ApiEndpoint().auditor;

    try {
      final Map<String, dynamic> requestData = auditor.toJson();
      final response = await AuthenticatedRequest.post(
        dio,
        url,
        data: requestData,
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to add/update auditor');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteAuditor(String auditorId) async {
    final url = '${ApiEndpoint().auditor}/$auditorId';
    await AuthenticatedRequest.delete(dio, url);
  }
}
