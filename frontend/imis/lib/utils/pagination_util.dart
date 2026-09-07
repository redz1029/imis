import 'package:imis/utils/page_list.dart';
import 'package:dio/dio.dart';
import 'http_util.dart';

class PaginationUtil {
  final Dio dio;

  PaginationUtil(this.dio);

  int? asInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  bool? asBool(dynamic value) {
    if (value is bool) return value;
    if (value is String) {
      final lower = value.toLowerCase();
      if (lower == 'true') return true;
      if (lower == 'false') return false;
    }
    return null;
  }

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
        final data = response.data;

        // Case 1: Backend already returns a paged envelope
        if (data is Map<String, dynamic>) {
          // Expecting keys like: items, page, pageSize, totalCount, hasNextPage, hasPreviousPage
          return PageList.fromJSON(data, fromJson);
        }

        // Case 2: Backend returns just a List<T> for the current page
        if (data is List) {
          final items = data;
          final _ = items.length;

          // Heuristic: assume there may be a next page only when we got a full page
          final hasNextPage = items.length == pageSize;
          final hasPreviousPage = page > 1;

          // Approximate total count when we don't have it from the server
          final effectiveTotalCount =
              hasNextPage
                  ? page * pageSize +
                      1 // "at least" this many
                  : (page - 1) * pageSize + items.length;

          return PageList.fromJSON({
            'items': items,
            'page': page,
            'pageSize': pageSize,
            'totalCount': effectiveTotalCount,
            'hasNextPage': hasNextPage,
            'hasPreviousPage': hasPreviousPage,
          }, fromJson);
        }

        throw Exception('Unexpected response format');
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
