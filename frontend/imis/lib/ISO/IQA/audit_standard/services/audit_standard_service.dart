import 'package:dio/dio.dart';
import 'package:imis/ISO/IQA/audit_standard/models/audit_standard.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';

class AuditStandardService {
  final Dio _dio;
  AuditStandardService(this._dio);

  String get _baseUrl => ApiEndpoint().standardVersion;

  /// The server's reason for a refusal, else [fallback].
  String _errorMessage(Response<dynamic> response, String fallback) {
    final data = response.data;
    if (data is Map) {
      final m = data['error'] ?? data['message'];
      if (m is String && m.trim().isNotEmpty) return m;
    }
    if (data is String && data.trim().isNotEmpty && data.length < 200) {
      return data;
    }
    return fallback;
  }

  Future<List<AuditStandard>> getAll() async {
    final response = await AuthenticatedRequest.get(_dio, _baseUrl);
    if (response.statusCode == 200 && response.data is List) {
      return (response.data as List)
          .map((j) => AuditStandard.fromJson(Map<String, dynamic>.from(j as Map)))
          .toList()
        ..sort((a, b) => a.id.compareTo(b.id));
    }
    throw Exception(_errorMessage(response, 'Failed to load the audit standards.'));
  }

  /// Creates (id 0) or updates an audit standard.
  Future<void> save(AuditStandard standard) async {
    final response = standard.id == 0
        ? await AuthenticatedRequest.post(
            _dio,
            _baseUrl,
            data: standard.toJson(),
          )
        : await AuthenticatedRequest.put(
            _dio,
            '$_baseUrl/${standard.id}',
            data: standard.toJson(),
          );
    final code = response.statusCode ?? 0;
    if (code < 200 || code >= 300) {
      throw Exception(_errorMessage(response, 'Failed to save the audit standard.'));
    }
  }

  Future<void> delete(int id) async {
    final response = await AuthenticatedRequest.delete(_dio, '$_baseUrl/$id');
    final code = response.statusCode ?? 0;
    if (code < 200 || code >= 300) {
      throw Exception(_errorMessage(response, 'Failed to delete the audit standard.'));
    }
  }
}
