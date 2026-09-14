// lib/audit/audit_plan/services/AuditPlanApprovalService.dart

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:imis/audit/audit_approvals/models/audit_plan_approval.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/page_list.dart';
import 'package:imis/utils/pagination_util.dart';

import '../../../utils/http_util.dart';

/// Talks to IMIS.Presentation.AuditPlanApprovalModule.AuditPlanApprovalEndpoint
/// (base route: "/auditPlanApprovals"). Routes below are copied verbatim
/// from that Carter module — do not change verbs/paths without checking it
/// again first.
class AuditPlanApprovalService {
  final Dio dio;

  AuditPlanApprovalService(this.dio);

  /// Derived the same way AuditPlanService derives its base URL: strip
  /// "/auditProgramme" off the configured programme endpoint and re-append
  /// the approvals module's own base route.
  String get _baseUrl {
    final programmeUrl = ApiEndpoint().auditProgramme;
    final root = programmeUrl.replaceFirst(RegExp(r'/auditProgramme/?$'), '');
    return '$root/auditPlanApprovals';
  }

  /// GET /auditPlanApprovals/page — paginated fetch, following the same
  /// PaginationUtil pattern used by AuditorTeamService.getAuditorTeam.
  /// NOTE: only wire this up once the backend module actually exposes a
  /// "/page" route — AuditPlanApprovalEndpoint currently only maps
  /// GET "/", so calling this against an unmodified backend will 404.
  Future<PageList<AuditPlanApproval>> getAuditPlanApprovals({
    int page = 1,
    int pageSize = 15,
    String? searchQuery,
  }) async {
    final paginationUtil = PaginationUtil(dio);
    return await paginationUtil.fetchPaginatedData<AuditPlanApproval>(
      endpoint: '$_baseUrl/page',
      page: page,
      pageSize: pageSize,
      searchQuery: searchQuery,
      fromJson: (json) => AuditPlanApproval.fromJson(json),
    );
  }

  /// GET /auditPlanApprovals — returns every approval (no server-side
  /// filter by plan; filter client-side by auditPlanId as needed).
  Future<List<AuditPlanApproval>> getAll() async {
    try {
      final response = await AuthenticatedRequest.get(dio, _baseUrl);
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as List;
        return data
            .map((e) => AuditPlanApproval.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      debugPrint('Error fetching audit plan approvals: ${e.message}');
      rethrow;
    }
  }

  /// GET /auditPlanApprovals for a specific plan — since the backend has no
  /// filter-by-plan route, this fetches everything and filters here.
  Future<List<AuditPlanApproval>> getByAuditPlanId(int auditPlanId) async {
    final all = await getAll();
    return all.where((a) => a.auditPlanId == auditPlanId).toList();
  }

  /// GET /auditPlanApprovals/{id} — single record. Mirrors
  /// AuditorTeamService.getAuditorTeamById, but the endpoint module has no
  /// dedicated single-item GET mapped yet — add
  /// AuditPlanApprovalEndpoint.MapGet("/{id:int}") on the backend before
  /// relying on this.
  Future<AuditPlanApproval> getById(int id) async {
    final url = '$_baseUrl/$id';
    try {
      final response = await AuthenticatedRequest.get(dio, url);
      return AuditPlanApproval.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException {
      rethrow;
    }
  }

  /// POST /auditPlanApprovals — create. Matches
  /// AuditPlanApprovalEndpoint.MapPost("/").
  Future<AuditPlanApproval> create(AuditPlanApproval approval) async {
    try {
      final response = await AuthenticatedRequest.post(
        dio,
        _baseUrl,
        data: approval.toJson(),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuditPlanApproval.fromJson(
          response.data as Map<String, dynamic>,
        );
      }
      throw Exception('Failed to create Audit Plan Approval');
    } on DioException catch (e) {
      _rethrowWithValidationMessage(e);
    }
  }

  /// PUT /auditPlanApprovals/{id} — update. Matches
  /// AuditPlanApprovalEndpoint.MapPut("/{id:int}").
  Future<AuditPlanApproval> update(AuditPlanApproval approval) async {
    if (approval.id == null || approval.id == 0) {
      throw ArgumentError(
        'update() requires an existing approval id; use create() instead.',
      );
    }
    try {
      final response = await AuthenticatedRequest.put(
        dio,
        '$_baseUrl/${approval.id}',
        data: approval.toJson(),
      );
      if (response.statusCode == 200) {
        return AuditPlanApproval.fromJson(
          response.data as Map<String, dynamic>,
        );
      }
      throw Exception('Failed to update Audit Plan Approval');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Approval not found.');
      }
      _rethrowWithValidationMessage(e);
    }
  }

  /// Save (create or update) based on whether [approval.id] is set.
  /// Named to match the createOrUpdate naming convention used by
  /// AuditorTeamService.createOrUpdateAuditorTeam.
  Future<AuditPlanApproval> createOrUpdateAuditPlanApproval(
    AuditPlanApproval approval,
  ) {
    final isUpdate = approval.id != null && approval.id != 0;
    return isUpdate ? update(approval) : create(approval);
  }

  /// DELETE /auditPlanApprovals/{id} — soft delete. Matches
  /// AuditPlanApprovalEndpoint.MapDelete("/{id:int}").
  Future<bool> delete(int id) async {
    final url = '$_baseUrl/$id';
    try {
      final response = await AuthenticatedRequest.delete(dio, url);
      return response.statusCode == 200;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return false;
      }
      debugPrint('Error deleting audit plan approval $id: ${e.message}');
      rethrow;
    }
  }

  Never _rethrowWithValidationMessage(DioException e) {
    if (e.response?.statusCode == 400) {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        if (data.containsKey('errors') && data['errors'] is Map) {
          final Map errorsMap = data['errors'];
          final List<String> messages = [];
          errorsMap.forEach((_, value) {
            if (value is List) {
              messages.addAll(value.map((e) => e.toString()));
            }
          });
          throw Exception(messages.join('\n'));
        } else if (data.containsKey('message')) {
          throw Exception(data['message'].toString());
        }
      } else if (data is String) {
        throw Exception(data);
      }
    }
    throw e;
  }
}