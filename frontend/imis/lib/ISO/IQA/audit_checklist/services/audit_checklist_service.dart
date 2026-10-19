// lib/audit/audit_checklist/services/audit_checklist_service.dart
import 'package:dio/dio.dart';

import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';

import '../models/audit_checklist.dart';

class AuditChecklistService {
  final Dio dio;

  AuditChecklistService(this.dio);

  /// Fetches a list of schedules (teams) that actually have checklist data —
  /// dynamically generated from the Audit Schedule records, in schedule
  /// order. The team name is display-only; AuditScheduleId is the identity.
  Future<List<AuditChecklistSummary>> getSchedulesWithChecklistData() async {
    final url = '${ApiEndpoint().auditChecklist}/schedules';
    try {
      final response = await AuthenticatedRequest.get(dio, url);
      if (response.statusCode == 200 && response.data != null) {
        final List list = response.data;
        return list
            .map((e) => AuditChecklistSummary.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  /// Fetches the checklist for an audit SCHEDULE, generating it server-side
  /// from the schedule's ISO standards on first request. The schedule ID is
  /// the unique key — never the team name.
  Future<List<AuditChecklist>> getOrGenerateForAuditSchedule(
      int auditScheduleId) async {
    final url = '${ApiEndpoint().auditChecklist}/schedule/$auditScheduleId';
    try {
      final response = await AuthenticatedRequest.get(dio, url);
      if (response.statusCode == 200 && response.data != null) {
        final List list = response.data;
        return list
            .map((e) => AuditChecklist.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  /// Fetches the checklist for an audit plan entry, generating it
  /// server-side from the entry's ISO standards on first request.
  Future<List<AuditChecklist>> getOrGenerateForAuditPlanEntry(
      int auditPlanEntryId) async {
    final url = '${ApiEndpoint().auditChecklist}/planentry/$auditPlanEntryId';
    try {
      final response = await AuthenticatedRequest.get(dio, url);
      if (response.statusCode == 200 && response.data != null) {
        final List list = response.data;
        return list
            .map((e) => AuditChecklist.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<AuditChecklist?> getById(int id) async {
    final url = '${ApiEndpoint().auditChecklist}/$id';
    try {
      final response = await AuthenticatedRequest.get(dio, url);
      if (response.statusCode == 200 && response.data != null) {
        return AuditChecklist.fromJson(response.data as Map<String, dynamic>);
      }
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  /// Create or update — the backend's POST and PUT handlers both call
  /// SaveOrUpdateAsync, so either verb works; POST is used consistently.
  Future<AuditChecklist> save(AuditChecklist checklist) async {
    final url = '${ApiEndpoint().auditChecklist}/';
    try {
      final response = await AuthenticatedRequest.post(
        dio,
        url,
        data: checklist.toJson(),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuditChecklist.fromJson(response.data as Map<String, dynamic>);
      }
      throw Exception('Failed to save Audit Checklist item.');
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> softDelete(int id) async {
    final url = '${ApiEndpoint().auditChecklist}/$id';
    try {
      final response = await AuthenticatedRequest.delete(dio, url);
      return response.statusCode == 200 || response.statusCode == 204;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return false;
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}