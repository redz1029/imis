import 'package:dio/dio.dart';
import 'package:http/http.dart' as AuthenticatedRequest;
import 'package:imis/audit/audit_schedules/models/audit_schedules.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/page_list.dart';
import 'package:imis/utils/pagination_util.dart';

class AuditSchedulesService {
  final Dio dio;

  AuditSchedulesService(this.dio);

  // TODO: add an `auditSchedule` getter to ApiEndpoint pointing at your
  // backend's "/auditSchedule" route (same pattern as `.auditorOffice`,
  // `.auditorteam`, etc. already do). This service assumes it exists as
  // `ApiEndpoint().auditSchedule`.

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

  /// Fetches every AuditSchedule by paging through the existing paginated
  /// endpoint until all records have been collected.
  Future<List<AuditSchedules>> getAuditSchedules() async {
    final List<AuditSchedules> all = [];
    int page = 1;
    const pageSize = 100;

    while (true) {
      final pageList = await getAuditSchedule(page: page, pageSize: pageSize);
      all.addAll(pageList.items);
      if (all.length >= pageList.totalCount || pageList.items.isEmpty) break;
      page++;
    }

    return all;
  }

  Future<AuditSchedules?> getAuditScheduleById(int id) async {
    final url = '${ApiEndpoint().auditSchedule}/$id';
    final response = await dio.get(url);

    if (response.statusCode == 200 && response.data != null) {
      return AuditSchedules.fromJson(response.data as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> addAuditSchedule(AuditSchedules auditSchedule) async {
    final url = ApiEndpoint().auditSchedule;
    final isUpdating = auditSchedule.id != 0;
    final Map<String, dynamic> requestData = auditSchedule.toJson();

    final response =
        isUpdating
            ? await AuthenticatedRequest.put(
              Uri.parse('$url/${auditSchedule.id}'),
              body: requestData,
            )
            : await AuthenticatedRequest.post(Uri.parse(url), body: requestData);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create/update audit schedule');
    }
  }

  Future<void> deleteAuditSchedule(int auditScheduleId) async {
    final url = '${ApiEndpoint().auditSchedule}/$auditScheduleId';
    await AuthenticatedRequest.delete(dio as Uri, body: url);
  }
}