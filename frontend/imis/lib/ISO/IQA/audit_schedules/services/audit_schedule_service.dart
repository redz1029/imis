import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:imis/audit/audit_schedules/models/audit_schedules.dart';
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
    try {
      final response = await AuthenticatedRequest.get(dio, url);
      if (response.statusCode == 200 && response.data != null) {
        return AuditSchedules.fromJson(response.data as Map<String, dynamic>);
      }
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      rethrow;
    }
  }

  Future<List<AuditSchedules>> getAuditSchedulesByPlanId(int planId) async {
    final url = '${ApiEndpoint().auditSchedule}/plan/$planId';
    try {
      final response = await AuthenticatedRequest.get(dio, url);
      if (response.statusCode == 200 && response.data != null) {
        final List list = response.data;
        return list
            .map((e) => AuditSchedules.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('Failed to get schedules by plan id: $e');
      return [];
    }
  }

  /// Fetches only confirmed/approved schedules (Workflow Gate for Checklist/Report).
  Future<List<AuditSchedules>> getConfirmedAuditSchedules() async {
    final url = '${ApiEndpoint().auditSchedule}/confirmed';
    try {
      final response = await AuthenticatedRequest.get(dio, url);
      if (response.statusCode == 200 && response.data != null) {
        final List list = response.data;
        return list
            .map((e) => AuditSchedules.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('Failed to get confirmed schedules: $e');
      return [];
    }
  }

  /// POST handles both create (id == 0) and update — same save-or-update
  /// pattern as every other service built alongside this one; if the
  /// backend's AuditSchedule endpoint really does expose a separate PUT
  /// route, tell me and I'll split this back into two calls.
  Future<AuditSchedules> addAuditSchedule(AuditSchedules auditSchedule) async {
    final url = ApiEndpoint().auditSchedule;
    try {
      final response = await AuthenticatedRequest.post(
        dio,
        url,
        data: auditSchedule.toJson(),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuditSchedules.fromJson(response.data as Map<String, dynamic>);
      }
      throw Exception('Failed to create/update audit schedule.');
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is String && data.isNotEmpty) throw Exception(data);
      if (data is Map && data['message'] != null) {
        throw Exception(data['message'].toString());
      }
      rethrow;
    }
  }

  Future<void> deleteAuditSchedule(int auditScheduleId) async {
    final url = '${ApiEndpoint().auditSchedule}/$auditScheduleId';
    try {
      final response = await AuthenticatedRequest.delete(dio, url);
      if (response.statusCode != 200) {
        throw Exception('Failed to delete audit schedule.');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Audit schedule not found.');
      }
      rethrow;
    }
  }

  String _extractErrorMessage(Response response, String fallback) {
    final data = response.data;
    if (data is Map && data['error'] != null) return data['error'].toString();
    return fallback;
  }

  Future<void> submitAuditSchedule(
    int id, {
    String? userId,
    String? comments,
  }) async {
    final url = '${ApiEndpoint().auditSchedule}/$id/submit';
    final response = await AuthenticatedRequest.put(
      dio,
      url,
      data: {
        if (userId != null) 'userId': userId,
        if (comments != null) 'comments': comments,
      },
    );
    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(response, 'Failed to submit audit schedule.'),
      );
    }
  }

  Future<void> decideAuditSchedule(
    int id, {
    required String approverId,
    String? action,
    bool? approve,
    String? comments,
    String? officeName,
  }) async {
    final url = '${ApiEndpoint().auditSchedule}/$id/decide';
    final response = await AuthenticatedRequest.put(
      dio,
      url,
      data: {
        'approverId': approverId,
        'action': action ?? ((approve ?? false) ? 'Confirm' : 'Reject'),
        'approve': approve ?? (action?.toLowerCase() != 'reject'),
        'comments': comments,
        'officeName': officeName,
      },
    );
    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(response, 'Failed to decide on audit schedule.'),
      );
    }
  }
}