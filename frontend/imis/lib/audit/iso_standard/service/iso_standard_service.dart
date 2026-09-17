// lib/iso_standard/services/iso_standard_service.dart
import 'package:dio/dio.dart';
import 'package:imis/audit/iso_standard/models/iso_standard.dart';
import 'package:imis/utils/http_util.dart';

class IsoStandardService {
  final Dio _dio;
  IsoStandardService(this._dio);

  // ASSUMPTION: base URL — confirm against your ApiEndpoint class pattern.
  static const String _base = 'https://localhost:7273/IsoStandard';

  Future<List<IsoStandard>> getTree(int versionId) async {
    final response = await AuthenticatedRequest.get(_dio, '$_base/tree/$versionId');
    return (response.data as List)
        .map((j) => IsoStandard.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  Future<List<IsoStandard>> searchByClauseRef(String clauseRef) async {
    final response = await AuthenticatedRequest.get(_dio, '$_base/filter-clause/$clauseRef');
    return (response.data as List)
        .map((j) => IsoStandard.fromJson(j as Map<String, dynamic>))
        .toList();
  }
}