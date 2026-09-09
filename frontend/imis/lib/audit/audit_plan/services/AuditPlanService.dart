// ignore_for_file: file_names

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:imis/audit/audit_plan/models/audit_plan.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';

class AuditPlanService {
  final Dio _dio;

  AuditPlanService(this._dio);

  // ===========================================================================
  // AUDIT PLAN CRUD METHODS
  // ===========================================================================

  /// Derives the top-level /auditPlan base URL from ApiEndpoint().auditProgramme,
  /// since ApiEndpoint doesn't (yet) expose an `auditPlan` getter of its own.
  /// If one gets added to ApiEndpoint, replace this with that getter directly.
  ///
  /// Confirmed against AuditPlanEndPoints.cs: the Audit Plan module is a
  /// SIBLING top-level route (base("/auditPlan")), NOT nested under
  /// /auditProgramme — the old '${ApiEndpoint().auditProgramme}/auditPlan'
  /// construction was hitting a route that returned 405 Method Not Allowed.
  String get _auditPlanBaseUrl {
    final programmeUrl = ApiEndpoint().auditProgramme;
    final root = programmeUrl.replaceFirst(RegExp(r'/auditProgramme/?$'), '');
    return '$root/auditPlan';
  }

  /// Fetch the Audit Plan tied to a specific Programme, via
  /// GET /auditPlan/programme/{programmeId} — matches the new backend
  /// endpoint (IAuditPlanService.GetByProgrammeIdAsync). The old URL
  /// (`/auditProgramme/{programmeId}/auditPlan`) had no matching route at
  /// all on the server.
  Future<AuditPlan?> getAuditPlanByProgrammeId(int programmeId) async {
    final url = '$_auditPlanBaseUrl/programme/$programmeId';
    try {
      final response = await AuthenticatedRequest.get(_dio, url);
      if (response.statusCode == 200 && response.data != null) {
        return AuditPlan.fromJson(response.data as Map<String, dynamic>);
      }
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }
      debugPrint(
        'Error fetching audit plan for programme $programmeId: ${e.message}',
      );
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  /// Save (POST) or Update (PUT) an Audit Plan.
  ///
  /// POST goes to /auditPlan (create), PUT goes to /auditPlan/{id} (update)
  /// — matching AuditPlanEndPoints.cs's MapPost("/") and MapPut("/{id:int}")
  /// exactly. The old URLs incorrectly nested both under /auditProgramme,
  /// which doesn't exist on the server (hence the 405).
  Future<AuditPlan> saveAuditPlan(AuditPlan auditPlan) async {
    final bool isUpdate = auditPlan.id > 0;
    final url = isUpdate
        ? '$_auditPlanBaseUrl/${auditPlan.id}'
        : _auditPlanBaseUrl;

    try {
      final Map<String, dynamic> requestData = auditPlan.toJson();

      final response = isUpdate
          ? await AuthenticatedRequest.put(_dio, url, data: requestData)
          : await AuthenticatedRequest.post(_dio, url, data: requestData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuditPlan.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception(
          isUpdate
              ? 'Failed to update Audit Plan'
              : 'Failed to create Audit Plan',
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        final data = e.response?.data;
        debugPrint('ASP.NET Validation Error Payload: $data');

        if (data is Map<String, dynamic>) {
          if (data.containsKey('Errors') && data['Errors'] is List) {
            final List errors = data['Errors'];
            throw Exception(errors.join('\n'));
          } else if (data.containsKey('errors') && data['errors'] is Map) {
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
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  /// Create a draft plan template pre-populated from Programme data
  AuditPlan createDraftFromProgramme({
    required int programmeId,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return AuditPlan(
      id: 0,
      auditProgrammeId: programmeId,
      planStatus: 'Draft',
      startDate: startDate,
      endDate: endDate,
      entries: [],
      isDeleted: false,
    );
  }
    /// Fetch all Audit Plans — GET /auditPlan (list). Assumed to exist as the
  /// counterpart to the confirmed POST /auditPlan (create) route, following
  /// standard REST convention. If this 404s/405s, the backend doesn't have
  /// this route yet and it needs to be added to AuditPlanEndPoints.cs.
  Future<List<AuditPlan>> getAllAuditPlans() async {
    try {
      final response = await AuthenticatedRequest.get(_dio, _auditPlanBaseUrl);
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as List;
        return data
            .map((e) => AuditPlan.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      debugPrint('Error fetching all audit plans: ${e.message}');
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  /// Fetch a single Audit Plan by its own id — GET /auditPlan/{id}. Assumed
  /// to exist as the counterpart to the confirmed PUT /auditPlan/{id:int}
  /// (update) route, following standard REST convention. If this 404s/405s,
  /// the backend doesn't have this route yet and it needs to be added to
  /// AuditPlanEndPoints.cs.
  Future<AuditPlan?> getAuditPlanById(int id) async {
    final url = '$_auditPlanBaseUrl/$id';
    try {
      final response = await AuthenticatedRequest.get(_dio, url);
      if (response.statusCode == 200 && response.data != null) {
        return AuditPlan.fromJson(response.data as Map<String, dynamic>);
      }
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }
      debugPrint('Error fetching audit plan $id: ${e.message}');
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}