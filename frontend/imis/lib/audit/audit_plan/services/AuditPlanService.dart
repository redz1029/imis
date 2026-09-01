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

  /// Fetch Audit Plan by Programme ID from `/auditProgramme/{programmeId}/auditPlan`
  Future<AuditPlan?> getAuditPlanByProgrammeId(int programmeId) async {
    final url = '${ApiEndpoint().auditProgramme}/$programmeId/auditPlan';
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
      debugPrint('Error fetching audit plan for programme $programmeId: ${e.message}');
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  /// Save (POST) or Update (PUT) an Audit Plan
  Future<AuditPlan> saveAuditPlan(AuditPlan auditPlan) async {
    final bool isUpdate = auditPlan.id > 0;
    final url = isUpdate
        ? '${ApiEndpoint().auditProgramme}/auditPlan/${auditPlan.id}'
        : '${ApiEndpoint().auditProgramme}/auditPlan';

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
    );
  }
}