import 'package:dio/dio.dart';

import 'package:imis/audit/iqa_signatory/model/iqa_signatory_template.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';

class IQASignatoryTemplateService {
  final Dio dio;

  IQASignatoryTemplateService(this.dio);

  /// Same host/prefix as the other endpoints: takes the known-good
  /// `ApiEndpoint().auditProgramme` URL and swaps its last path segment.
  /// Replace the body with `ApiEndpoint().iqaSignatoryTemplate` once that
  /// getter exists in ApiEndpoint.
  String get _baseUrl {
    var root = ApiEndpoint().auditProgramme;
    while (root.endsWith('/')) {
      root = root.substring(0, root.length - 1);
    }
    return Uri.parse(root).resolve('IQASignatoryTemplate').toString();
  }

  // ===========================================================================
  // RESPONSE HELPERS
  // ===========================================================================

  List<dynamic> _asList(Response response, String url) {
    final data = response.data;
    if (data is List) return data;
    throw Exception(
      'Expected a JSON list from $url but got ${data.runtimeType}. '
      'Request URI: ${response.requestOptions.uri}.',
    );
  }

  Map<String, dynamic> _asMap(Response response, String url) {
    final data = response.data;
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    throw Exception(
      'Expected a JSON object from $url but got ${data.runtimeType}. '
      'Request URI: ${response.requestOptions.uri}.',
    );
  }

  String _extractErrorMessage(Response? response, String fallback) {
    final data = response?.data;
    if (data is String && data.isNotEmpty) return data;
    if (data is Map && data['message'] != null) return data['message'].toString();
    return fallback;
  }

  // ===========================================================================
  // READ METHODS
  // ===========================================================================

  /// `GET /IQASignatoryTemplate` (204 => empty list).
  Future<List<IQASignatoryTemplate>> getAll() async {
    final url = _baseUrl;
    try {
      final response = await AuthenticatedRequest.get(dio, url);
      if (response.statusCode == 200 && response.data != null) {
        return IQASignatoryTemplate.listFromJson(_asList(response, url));
      }
      return [];
    } on DioException catch (e) {
      if (e.response?.statusCode == 204) return [];
      rethrow;
    }
  }

  /// `GET /IQASignatoryTemplate/{id}`.
  Future<IQASignatoryTemplate?> getById(int id) async {
    final url = '$_baseUrl/$id';
    try {
      final response = await AuthenticatedRequest.get(dio, url);
      if (response.statusCode == 200 && response.data != null) {
        return IQASignatoryTemplate.fromJson(_asMap(response, url));
      }
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      rethrow;
    }
  }

  /// `GET /IQASignatoryTemplate/type/{auditEntityType}`.
  Future<List<IQASignatoryTemplate>> getByAuditEntityType(
    String auditEntityType,
  ) async {
    final url = '$_baseUrl/type/${Uri.encodeComponent(auditEntityType)}';
    try {
      final response = await AuthenticatedRequest.get(dio, url);
      if (response.statusCode == 200 && response.data != null) {
        return IQASignatoryTemplate.listFromJson(_asList(response, url));
      }
      return [];
    } on DioException catch (e) {
      if (e.response?.statusCode == 204) return [];
      rethrow;
    }
  }

  /// `GET /IQASignatoryTemplate/office/{officeId}`.
  Future<List<IQASignatoryTemplate>> getByOfficeId(int officeId) async {
    final url = '$_baseUrl/office/$officeId';
    try {
      final response = await AuthenticatedRequest.get(dio, url);
      if (response.statusCode == 200 && response.data != null) {
        return IQASignatoryTemplate.listFromJson(_asList(response, url));
      }
      return [];
    } on DioException catch (e) {
      if (e.response?.statusCode == 204) return [];
      rethrow;
    }
  }

  // ===========================================================================
  // WRITE METHODS
  // ===========================================================================

  /// Create (id == 0) or update via the single `POST /IQASignatoryTemplate`.
  Future<IQASignatoryTemplate> saveOrUpdate(
    IQASignatoryTemplate template,
  ) async {
    final url = _baseUrl;
    try {
      final response = await AuthenticatedRequest.post(
        dio,
        url,
        data: template.toJson(),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return IQASignatoryTemplate.fromJson(_asMap(response, url));
      }
      throw Exception('Failed to save signatory template.');
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is String && data.isNotEmpty) throw Exception(data);
      if (data is Map && data['message'] != null) {
        throw Exception(data['message'].toString());
      }
      rethrow;
    }
  }

  /// Soft delete via `DELETE /IQASignatoryTemplate/{id}`.
  Future<void> softDelete(int id) async {
    final url = '$_baseUrl/$id';
    try {
      final response = await AuthenticatedRequest.delete(dio, url);
      if (response.statusCode != 200) {
        throw Exception(
          _extractErrorMessage(response, 'Failed to delete signatory template.'),
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Signatory template not found.');
      }
      rethrow;
    }
  }
}