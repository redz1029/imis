import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';
import '../models/ncar_attachment.dart';
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

  /// Moves an NCAR through its lifecycle: PENDING_VERIFICATION -> ACTIVE ->
  /// CLOSED. The backend rejects any other transition.
  Future<void> changeNcarStatus(
    int id, {
    required String status,
    String? comments,
  }) async {
    final url = '${ApiEndpoint().ncar}/$id/status';
    final response = await AuthenticatedRequest.put(dio, url, data: {
      'status': status,
      if (comments != null) 'comments': comments,
    });
    if (response.statusCode != 200) {
      final data = response.data;
      final message = (data is Map && data['error'] != null)
          ? data['error'].toString()
          : 'Failed to change NCAR status.';
      throw Exception(message);
    }
  }

  // ===========================================================================
  // NCAR attachments (pictures printed on page 2 of the form)
  // ===========================================================================

  String _attachmentsUrl(int ncarId) => '${ApiEndpoint().ncar}/$ncarId/attachments';

  String _errorText(DioException e, String fallback) {
    final data = e.response?.data;
    if (data is String && data.isNotEmpty) return data;
    if (data is Map && data['error'] != null) return data['error'].toString();
    return fallback;
  }

  Future<List<NcarAttachment>> getAttachments(int ncarId) async {
    final response = await AuthenticatedRequest.get(dio, _attachmentsUrl(ncarId));
    final data = response.data;
    if (response.statusCode != 200 || data is! List) {
      throw Exception('Failed to load the attached pictures.');
    }
    return [
      for (final e in data)
        if (e is Map) NcarAttachment.fromJson(Map<String, dynamic>.from(e)),
    ];
  }

  Future<NcarAttachment> addAttachment(
    int ncarId, {
    required Uint8List bytes,
    required String fileName,
    String? caption,
  }) async {
    try {
      final response = await AuthenticatedRequest.post(
        dio,
        _attachmentsUrl(ncarId),
        data: FormData.fromMap({
          'file': MultipartFile.fromBytes(bytes, filename: fileName),
          if (caption != null && caption.trim().isNotEmpty) 'caption': caption.trim(),
        }),
      );
      final data = response.data;
      if ((response.statusCode == 200 || response.statusCode == 201) && data is Map) {
        return NcarAttachment.fromJson(Map<String, dynamic>.from(data));
      }
      final body = response.data;
      throw Exception(body is String && body.isNotEmpty ? body : 'Failed to attach the picture.');
    } on DioException catch (e) {
      throw Exception(_errorText(e, 'Failed to attach the picture.'));
    }
  }

  Future<void> deleteAttachment(int ncarId, int attachmentId) async {
    try {
      final response = await AuthenticatedRequest.delete(
        dio,
        '${_attachmentsUrl(ncarId)}/$attachmentId',
      );
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to remove the picture.');
      }
    } on DioException catch (e) {
      throw Exception(_errorText(e, 'Failed to remove the picture.'));
    }
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
