import 'package:imis/utils/page_list.dart';

import 'package:dio/dio.dart';

import 'http_util.dart';

class PaginationUtil {
  final Dio dio;

  PaginationUtil(this.dio);

  Future<PageList<T>> fetchPaginatedData<T>({
    required String endpoint,
    int page = 1,
    int pageSize = 15,
    String? searchQuery,
    Map<String, dynamic>? additionalParams,

    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final queryParams = {
        'page': page,
        'pageSize': pageSize,
        if (searchQuery != null && searchQuery.isNotEmpty)
          'search': searchQuery,
        ...?additionalParams,
      };

      final response = await AuthenticatedRequest.get(
        dio,
        endpoint,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        List<dynamic> allItems = response.data is List ? response.data : [];
        int totalCount = allItems.length;

        int startIndex = (page - 1) * pageSize;
        int endIndex = (startIndex + pageSize).clamp(0, totalCount);

        List<dynamic> pageItems = allItems.sublist(startIndex, endIndex);

        return PageList.fromJSON({
          'items': pageItems,
          'page': page,
          'pageSize': pageSize,
          'totalCount': totalCount,
          'hasNextPage': endIndex < totalCount,
          'hasPreviousPage': page > 1,
        }, fromJson);
      } else {
        throw Exception('Failed to load data');
      }
    } on DioException {
      throw Exception('Dio error');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
