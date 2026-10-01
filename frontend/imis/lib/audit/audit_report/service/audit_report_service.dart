import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

import 'package:imis/audit/audit_plan/models/audit_plan.dart';
import 'package:imis/audit/audit_plan/models/audit_plan_entry.dart';
import 'package:imis/audit/audit_plan/services/AuditPlanService.dart';
import 'package:imis/audit/audit_report/model/audit_report.dart';
import 'package:imis/audit/audit_schedules/models/audit_schedules.dart';
import 'package:imis/audit/audit_schedules/services/audit_schedule_service.dart';
import 'package:imis/audit/iqa_signatory/model/iqa_signatory.dart';
import 'package:imis/audit/iqa_signatory/services/iqa_signatory_service.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';

/// Entity-type discriminator used by the generic IQA signatory approval chain
/// (`IQASignatory/AuditReport/{id}`). The backend stores it verbatim in
/// IQASignatory.AuditEntityType and also matches it against
/// IQASignatoryTemplate.AuditEntityType, so the two must agree exactly —
/// configure the templates with this same value.
const String kAuditReportEntityType = 'AuditReport';

class AuditReportService {
  final Dio dio;

  AuditReportService(this.dio);

  late final IQASignatoryService _signatoryService = IQASignatoryService(dio);
  late final AuditSchedulesService _schedulesService = AuditSchedulesService(
    dio,
  );
  late final AuditPlanService _planService = AuditPlanService(dio);

  String get _baseUrl => ApiEndpoint().auditReport;

  // ===========================================================================
  // ERROR HELPERS
  // ===========================================================================

  /// Backend failures surface as a bare string (`Results.BadRequest("...")`),
  /// `{ message: ... }`, or this codebase's `{ Errors: [...] }` /
  /// `{ errors: {...} }` validation envelopes.
  String _errorMessage(DioException e, String fallback) {
    final data = e.response?.data;
    if (data is String && data.isNotEmpty) return data;
    if (data is Map) {
      if (data['message'] != null) return data['message'].toString();
      if (data['error'] != null) return data['error'].toString();
      final errors = data['Errors'];
      if (errors is List && errors.isNotEmpty) {
        return errors.map((e) => e.toString()).join('\n');
      }
      final errorsMap = data['errors'];
      if (errorsMap is Map) {
        final messages = <String>[];
        errorsMap.forEach((_, value) {
          if (value is List) messages.addAll(value.map((e) => e.toString()));
        });
        if (messages.isNotEmpty) return messages.join('\n');
      }
    }
    return fallback;
  }

  List<AuditReport> _parseReports(dynamic data) {
    if (data is! List) return const [];
    final list = <AuditReport>[];
    for (final e in data) {
      if (e is Map) {
        try {
          list.add(AuditReport.fromJson(Map<String, dynamic>.from(e)));
        } catch (err) {
          debugPrint('Error parsing AuditReport: $err');
        }
      }
    }
    return list;
  }

  // ===========================================================================
  // READ
  // ===========================================================================

  /// GET /auditreport/{id}. Returns null on 404.
  Future<AuditReport?> getById(int id) async {
    final url = '$_baseUrl/$id';
    try {
      final response = await AuthenticatedRequest.get(dio, url);
      if (response.statusCode == 200 && response.data != null) {
        dynamic data = response.data;
        if (data is String) {
          final trimmed = data.trim();
          if (trimmed.isEmpty || trimmed == 'null') return null;
          try {
            data = jsonDecode(trimmed);
          } catch (_) {
            return null;
          }
        }
        if (data is Map) {
          return AuditReport.fromJson(Map<String, dynamic>.from(data));
        }
      }
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      throw Exception(_errorMessage(e, 'Failed to load audit report.'));
    }
  }

  /// GET /auditreport/page. The endpoint returns an empty body/null (not an envelope)
  /// when there are no rows at all, so we safely handle String/Map/List/null.
  Future<List<AuditReport>> getPage(int page, int pageSize) async {
    try {
      final response = await AuthenticatedRequest.get(
        dio,
        '$_baseUrl/page',
        queryParameters: {'page': page, 'pageSize': pageSize},
      );
      if (response.statusCode != 200 || response.data == null) return [];

      dynamic data = response.data;
      if (data is String) {
        final trimmed = data.trim();
        if (trimmed.isEmpty || trimmed == 'null') return [];
        try {
          data = jsonDecode(trimmed);
        } catch (_) {
          return [];
        }
      }

      if (data is Map) {
        final items =
            data['items'] ?? data['Items'] ?? data['data'] ?? data['result'];
        return _parseReports(items);
      } else if (data is List) {
        return _parseReports(data);
      }
      return [];
    } on DioException catch (e) {
      throw Exception(_errorMessage(e, 'Failed to load audit reports.'));
    } catch (e) {
      debugPrint('Unexpected error in getPage: $e');
      return [];
    }
  }

  /// All audit reports, by paging through /auditreport/page until the server
  /// runs out of rows. The backend has no dedicated GET-all route.
  Future<List<AuditReport>> getAllAuditReports() async {
    final all = <AuditReport>[];
    var page = 1;
    const pageSize = 100;

    while (true) {
      final batch = await getPage(page, pageSize);
      all.addAll(batch);
      if (batch.length < pageSize) break;
      page++;
    }

    return all;
  }

  // ===========================================================================
  // WRITE
  // ===========================================================================

  /// POST /auditreport (create) or PUT /auditreport (update) — both routes sit
  /// at the collection root, with the id carried in the body.
  Future<AuditReport> addOrUpdate(AuditReport report) async {
    final url = _baseUrl;
    try {
      final response =
          report.id > 0
              ? await AuthenticatedRequest.put(dio, url, data: report.toJson())
              : await AuthenticatedRequest.post(
                dio,
                url,
                data: report.toJson(),
              );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null) {
        dynamic data = response.data;
        if (data is String) {
          final trimmed = data.trim();
          if (trimmed.isNotEmpty && trimmed != 'null') {
            try {
              data = jsonDecode(trimmed);
            } catch (_) {}
          }
        }
        if (data is Map) {
          return AuditReport.fromJson(Map<String, dynamic>.from(data));
        }
        return report;
      }
      throw Exception(
        report.id > 0
            ? 'Failed to update audit report.'
            : 'Failed to create audit report.',
      );
    } on DioException catch (e) {
      throw Exception(
        _errorMessage(
          e,
          report.id > 0
              ? 'Failed to update audit report.'
              : 'Failed to create audit report.',
        ),
      );
    }
  }

  /// DELETE /auditreport/{id} — soft delete.
  Future<void> delete(int id) async {
    try {
      final response = await AuthenticatedRequest.delete(dio, '$_baseUrl/$id');
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete audit report.');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Audit report not found.');
      }
      throw Exception(_errorMessage(e, 'Failed to delete audit report.'));
    }
  }

  // ===========================================================================
  // PICKER LOOKUPS (plan -> plan entry -> schedule)
  // ===========================================================================

  Future<List<AuditPlan>> getAllAuditPlans() => _planService.getAllAuditPlans();

  /// GET /auditPlanEntry/by-audit-plan/{auditPlanId} — the plan entries of one
  /// plan, with their nested processes/auditors so the header can show the
  /// office/process and audit team.
  Future<List<AuditPlanEntry>> getPlanEntries(int auditPlanId) async {
    final url = '${ApiEndpoint().auditPlanEntry}/by-audit-plan/$auditPlanId';
    try {
      final response = await AuthenticatedRequest.get(dio, url);
      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .map(
              (e) =>
                  AuditPlanEntry.fromJson(Map<String, dynamic>.from(e as Map)),
            )
            .toList();
      }
      return [];
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return [];
      throw Exception(_errorMessage(e, 'Failed to load audit plan entries.'));
    }
  }

  /// Schedules belonging to one plan entry. The /auditSchedule module has no
  /// by-plan-entry route, so the list is fetched and filtered client-side.
  Future<List<AuditSchedules>> getSchedulesForPlanEntry(
    int auditPlanEntryId,
  ) async {
    final all = await _schedulesService.getAuditSchedules();
    return all.where((s) => s.auditPlanEntryId == auditPlanEntryId).toList();
  }

  /// Fetches NCAR status options (NC, OFI) for Summary of Findings.
  Future<List<Map<String, dynamic>>> getNcarStatuses() async {
    final url =
        '${ApiEndpoint.baseUrl}/auditncarstatus/page?page=1&pageSize=50';
    try {
      final response = await AuthenticatedRequest.get(dio, url);
      if (response.statusCode == 200 && response.data != null) {
        dynamic data = response.data;
        if (data is String) {
          try {
            data = jsonDecode(data);
          } catch (_) {
            return [];
          }
        }
        dynamic items;
        if (data is Map) {
          items = data['items'] ?? data['Items'] ?? data['data'] ?? [];
        } else if (data is List) {
          items = data;
        }
        if (items is List) {
          return items
              .whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList();
        }
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  // ===========================================================================
  // APPROVAL WORKFLOW (IQA signatory chain)
  // ===========================================================================

  /// All signatories of this report, in signing order (204 => empty list).
  Future<List<IQASignatory>> getSignatories(int reportId) =>
      _signatoryService.getByAuditEntityId(kAuditReportEntityType, reportId);

  /// True while no signatory row exists yet — i.e. the report has never been
  /// submitted and can still be submitted/edited freely.
  Future<bool> isDraft(int reportId) => _signatoryService.isDraft(
    auditEntityType: kAuditReportEntityType,
    auditEntityId: reportId,
  );

  /// The signatory whose turn it is, or null when the chain has none pending.
  Future<IQASignatory?> getNextSignatory(int reportId) =>
      _signatoryService.getNextSignatory(
        auditEntityType: kAuditReportEntityType,
        auditEntityId: reportId,
      );

  /// Creates one Pending signatory row per active AuditReport template.
  ///
  /// The backend skips any template whose DefaultSignatoryId is empty, so a
  /// template without a default signatory produces no rows and the chain stays
  /// on Draft — set a default signatory on the AuditReport templates first.
  Future<void> submitForApproval(int reportId, String userId) =>
      _signatoryService.submitForApproval(
        auditEntityType: kAuditReportEntityType,
        auditEntityId: reportId,
        userId: userId,
      );

  /// Records the decision for [signatoryId]. A disapproval also resets the
  /// remaining (downstream) signatory rows server-side.
  Future<void> decide({
    required int reportId,
    required String signatoryId,
    required bool approve,
    String? remarks,
  }) => _signatoryService.decide(
    auditEntityType: kAuditReportEntityType,
    auditEntityId: reportId,
    signatoryId: signatoryId,
    approve: approve,
    remarks: remarks,
  );

  /// Soft-deletes every signatory row of the report so it can be resubmitted.
  Future<void> resetApprovalChain(int reportId) =>
      _signatoryService.resetApprovalChain(
        auditEntityType: kAuditReportEntityType,
        auditEntityId: reportId,
      );
}
