import 'package:dio/dio.dart';
import 'package:imis/performance_validation_tool/performance_validation_tool_period/models/performance_validation_tool_period.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/utils/page_list.dart';
import 'package:imis/utils/pagination_util.dart';

class PerformanceValidationToolService {
  final Dio dio;

  PerformanceValidationToolService(this.dio);
  Future<PageList<PerformanceValidationToolPeriod>>
  getPerformanceValidationToolPeriod({
    int page = 1,
    int pageSize = 15,
    String? searchQuery,
  }) async {
    final paginationUtil = PaginationUtil(dio);
    return await paginationUtil.fetchPaginatedData(
      endpoint: '${ApiEndpoint().performanceValidationToolPeriod}/page',
      page: page,
      pageSize: pageSize,
      searchQuery: searchQuery,
      fromJson: (json) => PerformanceValidationToolPeriod.fromJson(json),
    );
  }

  Future<void> createOrUpdatePerformanceValidationToolPeriod(
    PerformanceValidationToolPeriod validationPeriod,
  ) async {
    var url = ApiEndpoint().performanceValidationToolPeriod;
    final Map<String, dynamic> requestData = validationPeriod.toJson();
    final response = await AuthenticatedRequest.post(
      dio,
      url,
      data: requestData,
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create performance validation tool period');
    }
  }

  Future<PerformanceValidationToolPeriod?>
  getPerformanceValidationToolPeriodById(int id) async {
    final response = await AuthenticatedRequest.get(
      dio,
      '${ApiEndpoint().performanceValidationToolPeriod}/$id',
    );

    if (response.statusCode == 200) {
      return PerformanceValidationToolPeriod.fromJson(response.data);
    }

    return null;
  }

  Future<void> deleteValidationPeriod(String? id) async {
    final url = "${ApiEndpoint().performanceValidationToolPeriod}/$id";
    await AuthenticatedRequest.delete(dio, url);
  }
}
