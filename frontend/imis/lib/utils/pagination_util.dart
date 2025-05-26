import 'package:dio/dio.dart';
import 'package:imis/utils/page_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaginationUtil {
  final Dio dio;

  PaginationUtil(this.dio);

  Future<PageList<T>> fetchPaginatedData<T>({
    required String endpoint,
    int page = 1,
    int pageSize = 15,
    String? searchQuery,
    Map<String, dynamic>? additionalParams,
    Map<String, dynamic>? headers,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      final combinedHeaders = {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
        ...?headers,
      };

      final response = await dio.get(
        endpoint,
        queryParameters: {
          if (searchQuery != null && searchQuery.isNotEmpty)
            'search': searchQuery,
          ...?additionalParams,
        },
        options: Options(headers: combinedHeaders),
      );

      if (response.statusCode == 200) {
        List<dynamic> allItems = response.data is List ? response.data : [];
        int totalCount = allItems.length;

        int startIndex = (page - 1) * pageSize;
        int endIndex = startIndex + pageSize;
        if (endIndex > totalCount) endIndex = totalCount;

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
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
