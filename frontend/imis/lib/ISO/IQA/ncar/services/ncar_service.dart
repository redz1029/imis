import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';
import '../models/nonconforming_action_report.dart';
import '../models/ncar_monitoring_log.dart';

class NcarService {
  final Dio dio;

  NcarService(this.dio);

  // ===========================================================================
  // NCAR (NonconformingActionReport) Methods
  // ===========================================================================

  Future<List<NonconformingActionReport>> getAllNcars({int page = 1, int pageSize = 50}) async {
    final url = '${ApiEndpoint().ncar}/page?page=$page&pageSize=$pageSize';
    try {
      final response = await AuthenticatedRequest.get(dio, url);
      if (response.statusCode == 200 && response.data != null) {
        dynamic data = response.data;
        List<dynamic> items = [];
        if (data is Map && data['items'] != null) {
          items = data['items'];
        } else if (data is List) {
          items = data;
        }
        return items
            .map((e) => NonconformingActionReport.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error getting NCARs: $e');
      return [];
    }
  }

  Future<NonconformingActionReport?> getNcarById(int id) async {
    final url = '${ApiEndpoint().ncar}/$id';
    try {
      final response = await AuthenticatedRequest.get(dio, url);
      if (response.statusCode == 200 && response.data != null) {
        return NonconformingActionReport.fromJson(response.data as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting NCAR by ID: $e');
      return null;
    }
  }

  Future<NonconformingActionReport> saveNcar(NonconformingActionReport ncar) async {
    final isUpdate = ncar.id > 0;
    final url = ApiEndpoint().ncar;
    final response = isUpdate
        ? await AuthenticatedRequest.put(dio, url, data: ncar.toJson())
        : await AuthenticatedRequest.post(dio, url, data: ncar.toJson());

    if (response.statusCode == 200 || response.statusCode == 201) {
      return NonconformingActionReport.fromJson(response.data as Map<String, dynamic>);
    }
    throw Exception('Failed to save NCAR.');
  }

  Future<bool> deleteNcar(int id) async {
    final url = '${ApiEndpoint().ncar}/$id';
    final response = await AuthenticatedRequest.delete(dio, url);
    return response.statusCode == 200 || response.statusCode == 204;
  }

  // ===========================================================================
  // NCAR Monitoring Log Methods
  // ===========================================================================

  Future<List<NcarMonitoringLog>> getMonitoringLogs({int page = 1, int pageSize = 50}) async {
    final url = '${ApiEndpoint().ncarMonitoring}/paginated?page=$page&pageSize=$pageSize';
    try {
      final response = await AuthenticatedRequest.get(dio, url);
      if (response.statusCode == 200 && response.data != null) {
        dynamic data = response.data;
        List<dynamic> items = [];
        if (data is Map && data['items'] != null) {
          items = data['items'];
        } else if (data is List) {
          items = data;
        }
        return items
            .map((e) => NcarMonitoringLog.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error getting NCAR monitoring logs: $e');
      return [];
    }
  }

  Future<void> syncFromNcar({
    required int ncarId,
    required String deptSectionUnit,
    required DateTime dateIssued,
    required String issuedByName,
    required String itemNoRelevantStandard,
    required String auditeeName,
  }) async {
    final url = '${ApiEndpoint().ncarMonitoring}/sync/$ncarId';
    await AuthenticatedRequest.post(dio, url, data: {
      'deptSectionUnit': deptSectionUnit,
      'dateIssued': dateIssued.toIso8601String(),
      'issuedByName': issuedByName,
      'itemNoRelevantStandard': itemNoRelevantStandard,
      'auditeeName': auditeeName,
    });
  }

  Future<void> updateVerification({
    required int monitoringLogId,
    required DateTime dateVerified,
    required String verifiedByAuditorName,
  }) async {
    final url = '${ApiEndpoint().ncarMonitoring}/$monitoringLogId/verify';
    await AuthenticatedRequest.put(dio, url, data: {
      'dateVerified': dateVerified.toIso8601String(),
      'verifiedByAuditorName': verifiedByAuditorName,
    });
  }

  Future<void> updateValidation({
    required int monitoringLogId,
    required DateTime dateValidated,
  }) async {
    final url = '${ApiEndpoint().ncarMonitoring}/$monitoringLogId/validate';
    await AuthenticatedRequest.put(dio, url, data: {
      'dateValidated': dateValidated.toIso8601String(),
    });
  }
}
