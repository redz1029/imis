import 'package:dio/dio.dart';
import 'package:imis/audit_schedules/models/audit_schedules.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/utils/page_list.dart';
import 'package:imis/utils/pagination_util.dart';

class AuditSchedulesService {
  final Dio dio;

  AuditSchedulesService(this.dio);

  Future<PageList<AuditSchedules>> getAuditSchedule({
    int page = 1,
    int pageSize = 15,
    String? searchQuery,
  }) async {
    final paginationUtil = PaginationUtil(dio);
    return await paginationUtil.fetchPaginatedData(
      endpoint: ApiEndpoint().auditSchedule,
      page: page,
      pageSize: pageSize,
      searchQuery: searchQuery,
      fromJson: (json) => AuditSchedules.fromJson(json),
    );
  }

  Future<void> deleteAuditSchedule(String auditSchedule) async {
    final url = '${ApiEndpoint().auditSchedule}/$auditSchedule';
    await AuthenticatedRequest.delete(dio, url);
  }
}
