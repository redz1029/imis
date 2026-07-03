import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:imis/performance_governance_system/models/performance_governance_system.dart';
import 'package:imis/performance_validation_tool/models/performance_validation_tool.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/page_list.dart';
import 'package:imis/utils/pagination_util.dart';

import '../../utils/auth_util.dart';
import '../../utils/http_util.dart';

class PerformanceValidationServices {
  final Dio dio;

  PerformanceValidationServices(this.dio);
  Future<PageList<PerformanceGovernanceSystem>>
  getPerformanceValidationPageList({
    int page = 1,
    int pageSize = 15,
    String? searchQuery,
    required String roleId,
    String? officeId,
    String? periodId,
  }) async {
    final paginationUtil = PaginationUtil(dio);

    return await paginationUtil.fetchPaginatedData(
      endpoint: '${ApiEndpoint().performanceValidationTool}/pgsAuditor/$roleId',
      page: page,
      pageSize: pageSize,
      searchQuery: searchQuery,
      additionalParams: {
        if (officeId != null) 'officeId': officeId,
        if (periodId != null) 'pgsPeriodId': periodId,
      },
      fromJson: (json) => PerformanceGovernanceSystem.fromJson(json),
    );
  }

  Future<int?> saveAsDraft(PerformanceValidationTool pvt) async {
    final url = ApiEndpoint().performanceValidationTool;
    final response = await AuthenticatedRequest.post(
      dio,
      url,
      data: pvt.toJson(),
    );
    return response.statusCode;
  }

  Future<List<PerformanceValidationTool>> fetchAllPerformanceValidationList({
    required String pgsId,
  }) async {
    try {
      final token = await AuthUtil.getAccessToken();
      if (token == null || token.isEmpty) return [];

      final response = await AuthenticatedRequest.get(
        dio,
        "${ApiEndpoint().performanceValidationTool}/pgsidlist?performanceGovernanceSystemId=$pgsId",
      );

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> jsonList = response.data as List<dynamic>;
        return jsonList
            .map((e) => PerformanceValidationTool.fromjson(e))
            .toList();
      }
    } on DioException {
      debugPrint("Dio error fetchAllProtocols");
    } catch (e) {
      debugPrint("Unexpected error fetchAllProtocols: $e");
    }
    return [];
  }

  Future<PerformanceValidationTool?> fetchPerformanceValidationToolById({
    required int id,
  }) async {
    try {
      final token = await AuthUtil.getAccessToken();
      if (token == null || token.isEmpty) return null;

      final response = await AuthenticatedRequest.get(
        dio,
        "${ApiEndpoint().performanceValidationTool}/$id",
      );

      if (response.statusCode == 200 && response.data != null) {
        return PerformanceValidationTool.fromjson(response.data);
      }
    } on DioException catch (e) {
      debugPrint(
        "Dio error fetchProtocolById: ${e.response?.statusCode} ${e.response?.data ?? e.message}",
      );
    } catch (e, st) {
      debugPrint("Unexpected error fetchProtocolById: $e");
      debugPrint("$st");
    }
    return null;
  }

  Future<int?> submit(PerformanceValidationTool pvt) async {
    final user = await AuthUtil.fetchLoggedUser();
    if (user == null || user.id == null || user.id!.isEmpty) return 401;

    final url =
        '${ApiEndpoint().performanceValidationTool}/submit?userId=${user.id}';
    final response = await AuthenticatedRequest.put(
      dio,
      url,
      data: pvt.toJson(),
    );
    return response.statusCode;
  }

  Future<bool> deletePerformanceValidationTool(int id) async {
    try {
      final url = '${ApiEndpoint().performanceValidationTool}/$id';
      await AuthenticatedRequest.delete(dio, url);
      return true; // walang exception = successful delete
    } on DioException {
      debugPrint("Dio error deletePerformanceValidationTool");
      return false;
    } catch (e) {
      debugPrint("Unexpected error deletePerformanceValidationTool: $e");
      return false;
    }
  }
}
