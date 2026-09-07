import 'package:dio/dio.dart';
import 'package:imis/standard_version/models/standard_version.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/utils/page_list.dart';
import 'package:imis/utils/pagination_util.dart';

class StandardVersionService {
  final Dio dio;

  StandardVersionService(this.dio);

  Future<PageList<StandardVersion>> getStandardVersions({
    int page = 1,
    int pageSize = 15,
    String? searchQuery,
  }) async {
    final paginationUtil = PaginationUtil(dio);
    return await paginationUtil.fetchPaginatedData<StandardVersion>(
      endpoint: ApiEndpoint().standardVersion,
      page: page,
      pageSize: pageSize,
      searchQuery: searchQuery,
      fromJson: (json) => StandardVersion.fromJson(json),
    );
  }

  Future<void> createOrUpdateStandardVersion(
    StandardVersion standardVersion,
  ) async {
    var url = ApiEndpoint().standardVersion;

    try {
      final Map<String, dynamic> requestData = standardVersion.toJson();
      final response = await AuthenticatedRequest.post(
        dio,
        url,
        data: requestData,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception("Failed to add/update Standard Version.");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteStandardVersion(String id) async {
    var url = '${ApiEndpoint().standardVersion}/$id';

    try {
      final response = await AuthenticatedRequest.delete(dio, url);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception("Failed to delete Standard Version.");
      }
    } catch (e) {
      rethrow;
    }
  }
}
