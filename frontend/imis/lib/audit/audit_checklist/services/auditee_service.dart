// lib/audit/audit_checklist/services/auditee_service.dart
import 'package:dio/dio.dart';

import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';

import '../models/auditee.dart';

class AuditeeService {
  final Dio dio;

  AuditeeService(this.dio);

  /// All linked-user auditees — used to populate the AUDITEE/S
  /// typeahead suggestions.
  Future<List<Auditee>> getAll() async {
    final url = '${ApiEndpoint().auditee}/';
    try {
      final response = await AuthenticatedRequest.get(dio, url);
      if (response.statusCode == 204) return [];
      if (response.statusCode == 200 && response.data != null) {
        final List list = response.data;
        return list
            .map((e) => Auditee.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }
}