import 'package:dio/dio.dart';
import 'package:imis/utils/api_endpoint.dart';

import '../../utils/http_util.dart';

class PerformanceGovernanceSystemService {
  final Dio dio;

  PerformanceGovernanceSystemService(this.dio);

  Future<List<T>> _fetchList<T>(
    String url,
    T Function(Map<String, dynamic>) fromJson,
    String errorMessage,
  ) async {
    final response = await AuthenticatedRequest.get(dio, url);

    if (response.statusCode == 200 && response.data is List) {
      return (response.data as List)
          .map((e) => fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(errorMessage);
    }
  }

  Future<void> deletePgs(String pgsId) async {
    final url = '${ApiEndpoint().deletePgs}/$pgsId';
    await AuthenticatedRequest.delete(dio, url);
  }
}
