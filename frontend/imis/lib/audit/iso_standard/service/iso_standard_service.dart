import 'package:dio/dio.dart';
import 'package:imis/audit/iso_standard/models/iso_standard.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';

class IsoStandardService {
  final Dio _dio;
  IsoStandardService(this._dio);

  String get _baseUrl => ApiEndpoint().isoStandard;

  Future<List<IsoStandard>> getAll() async {
    try {
      final response = await AuthenticatedRequest.get(_dio, _baseUrl);
      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .map((j) => IsoStandard.fromJson(j as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  Future<List<IsoStandard>> getTree(int versionId) async {
    try {
      final response = await AuthenticatedRequest.get(_dio, '$_baseUrl/tree/$versionId');
      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .map((j) => IsoStandard.fromJson(j as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  Future<List<IsoStandard>> searchByClauseRef(String clauseRef) async {
    try {
      final response = await AuthenticatedRequest.get(_dio, '$_baseUrl/filter-clause/$clauseRef');
      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .map((j) => IsoStandard.fromJson(j as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  Future<bool> deleteStandard(int id) async {
    try {
      final response = await AuthenticatedRequest.delete(_dio, '$_baseUrl/$id');
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (_) {
      return false;
    }
  }
}