import 'package:dio/dio.dart';
import 'package:imis/audit/audit_plan_status/models/audit_plan_status.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/utils/page_list.dart';
import 'package:imis/utils/pagination_util.dart';

class AuditPlanStatusService {
  final Dio dio;

  AuditPlanStatusService(this.dio);

  Future<List<AuditPlanStatus>> getAll() async {
    final response = await AuthenticatedRequest.get(
      dio,
      ApiEndpoint().auditPlanStatus,
    );

    if (response.statusCode == 200 && response.data is List) {
      return (response.data as List)
          .map((e) => AuditPlanStatus.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<PageList<AuditPlanStatus>> getPaginated({
    int page = 1,
    int pageSize = 15,
  }) async {
    final paginationUtil = PaginationUtil(dio);
    return await paginationUtil.fetchPaginatedData(
      endpoint: '${ApiEndpoint().auditPlanStatus}/page',
      page: page,
      pageSize: pageSize,
      fromJson: (json) => AuditPlanStatus.fromJson(json),
    );
  }

  // Backend keys create vs update off dto.Id — POST and PUT both hit "/".
  Future<void> saveAuditPlanStatus(AuditPlanStatus status) async {
    final url = ApiEndpoint().auditPlanStatus;
    final response = status.id == 0
        ? await AuthenticatedRequest.post(dio, url, data: status.toJson())
        : await AuthenticatedRequest.put(dio, url, data: status.toJson());

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to save audit plan status.');
    }
  }

  Future<void> deleteAuditPlanStatus(int id) async {
    final url = '${ApiEndpoint().auditPlanStatus}/$id';
    final response = await AuthenticatedRequest.delete(dio, url);

    if (response.statusCode != 200) {
      final data = response.data;
      final message = data is Map && data['error'] != null
          ? data['error'].toString()
          : 'Failed to delete audit plan status.';
      throw Exception(message);
    }
  }
}
