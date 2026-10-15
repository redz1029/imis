import 'package:dio/dio.dart';

import 'package:imis/audit/iqa_signatory/model/iqa_signatory.dart';
import 'package:imis/audit/iqa_signatory/model/iqa_signatory_template.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';

class IQASignatoryService {
  final Dio dio;

  IQASignatoryService(this.dio);

  /// Same host/prefix as the working endpoints: takes the known-good
  /// `ApiEndpoint().auditProgramme` URL and swaps its last path segment.
  /// Replace the body with `ApiEndpoint().iqaSignatory` once that getter
  /// exists in ApiEndpoint.
  String get _baseUrl {
    var root = ApiEndpoint().auditProgramme;
    while (root.endsWith('/')) {
      root = root.substring(0, root.length - 1);
    }
    return Uri.parse(root).resolve('IQASignatory').toString();
  }

  String _withQuery(String path, Map<String, dynamic> query) {
    final uri = Uri.parse('$_baseUrl$path');
    return uri
        .replace(
          queryParameters: query.map((k, v) => MapEntry(k, v.toString())),
        )
        .toString();
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

  /// Backend failures are either a plain string (`Results.BadRequest("...")`)
  /// or `{ message: "..." }` (`Results.NotFound(new { message = ... })`).
  String _errorMessage(DioException e, String fallback) {
    final data = e.response?.data;
    if (data is String && data.isNotEmpty) return data;
    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }
    return fallback;
  }

  // ===========================================================================
  // READ METHODS
  // ===========================================================================

  /// `GET /IQASignatory/type/{auditEntityType}` (204 => empty list).
  Future<List<IQASignatory>> getAllByAuditEntityType(
    String auditEntityType,
  ) async {
    final url = '$_baseUrl/type/${Uri.encodeComponent(auditEntityType)}';
    try {
      final response = await AuthenticatedRequest.get(dio, url);
      if (response.statusCode == 200 && response.data != null) {
        return IQASignatory.listFromJson(_asList(response, url));
      }
      return [];
    } on DioException catch (e) {
      if (e.response?.statusCode == 204) return [];
      rethrow;
    }
  }

  /// `GET /IQASignatory/entity/{auditEntityType}/{auditEntityId}`
  /// (204 => empty list). All signatories of one audit entity, in signing order.
  Future<List<IQASignatory>> getByAuditEntityId(
    String auditEntityType,
    int auditEntityId,
  ) async {
    final url =
        '$_baseUrl/entity/${Uri.encodeComponent(auditEntityType)}/$auditEntityId';
    try {
      final response = await AuthenticatedRequest.get(dio, url);
      if (response.statusCode == 200 && response.data != null) {
        return IQASignatory.listFromJson(_asList(response, url));
      }
      return [];
    } on DioException catch (e) {
      if (e.response?.statusCode == 204) return [];
      rethrow;
    }
  }

  /// `GET /IQASignatory/templates/inherited?officeId=&auditEntityType=`
  /// Templates for the office, or the nearest parent office that has some
  /// (204 => empty list).
  Future<List<IQASignatoryTemplate>> getInheritedTemplates({
    required int officeId,
    required String auditEntityType,
  }) async {
    final url = _withQuery('/templates/inherited', {
      'officeId': officeId,
      'auditEntityType': auditEntityType,
    });
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

  /// `GET /IQASignatory/process?auditEntityType=&auditEntityId=&userId=`
  /// Read-only computation; returns null on 404.
  Future<IQASignatory?> processSignatories({
    required String auditEntityType,
    required int auditEntityId,
    required String userId,
  }) async {
    final url = _withQuery('/process', {
      'auditEntityType': auditEntityType,
      'auditEntityId': auditEntityId,
      'userId': userId,
    });
    try {
      final response = await AuthenticatedRequest.get(dio, url);
      if (response.statusCode == 200 && response.data != null) {
        return IQASignatory.fromJson(_asMap(response, url));
      }
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      rethrow;
    }
  }

  /// `GET /IQASignatory/next?auditEntityType=&auditEntityId=`
  /// The next pending signatory, or null when none (204).
  Future<IQASignatory?> getNextSignatory({
    required String auditEntityType,
    required int auditEntityId,
  }) async {
    final url = _withQuery('/next', {
      'auditEntityType': auditEntityType,
      'auditEntityId': auditEntityId,
    });
    try {
      final response = await AuthenticatedRequest.get(dio, url);
      if (response.statusCode == 200 && response.data != null) {
        return IQASignatory.fromJson(_asMap(response, url));
      }
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 204) return null;
      rethrow;
    }
  }

  /// `GET /IQASignatory/pending?roleId=&page=&pageSize=`
  /// The backend currently returns an empty list for this endpoint.
  Future<List<dynamic>> getPendingForRole({
    required String roleId,
    int page = 1,
    int pageSize = 10,
  }) async {
    final url = _withQuery('/pending', {
      'roleId': roleId,
      'page': page,
      'pageSize': pageSize,
    });
    try {
      final response = await AuthenticatedRequest.get(dio, url);
      if (response.statusCode == 200 && response.data != null) {
        return _asList(response, url);
      }
      return [];
    } on DioException catch (e) {
      if (e.response?.statusCode == 204) return [];
      rethrow;
    }
  }

  /// `GET /IQASignatory/isdraft?auditEntityType=&auditEntityId=`
  /// True when no signatory rows exist yet for this entity.
  Future<bool> isDraft({
    required String auditEntityType,
    required int auditEntityId,
  }) async {
    final url = _withQuery('/isdraft', {
      'auditEntityType': auditEntityType,
      'auditEntityId': auditEntityId,
    });
    final response = await AuthenticatedRequest.get(dio, url);
    if (response.statusCode == 200 && response.data != null) {
      return _asMap(response, url)['isDraft'] == true;
    }
    return true;
  }

  // ===========================================================================
  // WRITE METHODS
  // ===========================================================================

  /// `POST /IQASignatory` (create when id == 0, otherwise update).
  Future<IQASignatory> saveOrUpdate(IQASignatory signatory) async {
    final url = _baseUrl;
    try {
      final response = await AuthenticatedRequest.post(
        dio,
        url,
        data: signatory.toJson(),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return IQASignatory.fromJson(_asMap(response, url));
      }
      throw Exception('Failed to save signatory.');
    } on DioException catch (e) {
      throw Exception(_errorMessage(e, 'Failed to save signatory.'));
    }
  }

  // ===========================================================================
  // APPROVAL WORKFLOW
  // ===========================================================================

  /// `POST /IQASignatory/submit`
  /// Creates one Pending row per active template for the entity type.
  Future<void> submitForApproval({
    required String auditEntityType,
    required int auditEntityId,
    required String userId,
  }) async {
    final url = '$_baseUrl/submit';
    try {
      final response = await AuthenticatedRequest.post(
        dio,
        url,
        data: {
          'auditEntityType': auditEntityType,
          'auditEntityId': auditEntityId,
          'userId': userId,
        },
      );
      if (response.statusCode != 200) {
        throw Exception('Unable to submit for approval.');
      }
    } on DioException catch (e) {
      throw Exception(_errorMessage(e, 'Unable to submit for approval.'));
    }
  }

  /// `POST /IQASignatory/decide`
  /// Approves or disapproves the pending row that belongs to [signatoryId].
  Future<void> decide({
    required String auditEntityType,
    required int auditEntityId,
    required String signatoryId,
    required bool approve,
    String? remarks,
  }) async {
    final url = '$_baseUrl/decide';
    try {
      final response = await AuthenticatedRequest.post(
        dio,
        url,
        data: {
          'auditEntityType': auditEntityType,
          'auditEntityId': auditEntityId,
          'signatoryId': signatoryId,
          'approve': approve,
          'remarks': remarks,
        },
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to record the decision.');
      }
    } on DioException catch (e) {
      throw Exception(_errorMessage(e, 'Failed to record the decision.'));
    }
  }

  /// `POST /IQASignatory/reset`
  /// Soft-deletes every signatory row of the entity (start over).
  Future<void> resetApprovalChain({
    required String auditEntityType,
    required int auditEntityId,
  }) async {
    final url = '$_baseUrl/reset';
    try {
      final response = await AuthenticatedRequest.post(
        dio,
        url,
        data: {
          'auditEntityType': auditEntityType,
          'auditEntityId': auditEntityId,
        },
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to reset the approval chain.');
      }
    } on DioException catch (e) {
      throw Exception(_errorMessage(e, 'Failed to reset the approval chain.'));
    }
  }
}