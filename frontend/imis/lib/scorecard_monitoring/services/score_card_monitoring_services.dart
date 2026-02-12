import 'package:dio/dio.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';
import '../models/score_card_monitoring_accomplishment.dart';

class ScoreCardMonitoringServices {
  final Dio dio;

  ScoreCardMonitoringServices(this.dio);
  Future<void> saveData(List<dynamic> items) async {
    final url = ApiEndpoint().kraroadmapAccomplishment;
    await AuthenticatedRequest.put(dio, url, data: {'items': items});
  }

  Future<void> saveAccomplishment(FormData formData) async {
    final id =
        formData.fields
            .firstWhere((f) => f.key == 'id', orElse: () => MapEntry('id', ''))
            .value;
    final url =
        ApiEndpoint().kraroadmapAccomplishment + (id.isNotEmpty ? '/$id' : '');

    final response =
        id.isNotEmpty
            ? await AuthenticatedRequest.put(dio, url, data: formData)
            : await AuthenticatedRequest.post(dio, url, data: formData);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create/update scorecard accomplishment');
    }
  }

  Future<List<ScoreCardMonitoringAccomplishment>> fetchAccomplishments(
    int kraRoadmapId,
  ) async {
    final url = "${ApiEndpoint().kraroadmapAccomplishment}/$kraRoadmapId";
    final response = await AuthenticatedRequest.get(dio, url);

    if (response.statusCode == 200) {
      final data = response.data as List;
      return data
          .map((json) => ScoreCardMonitoringAccomplishment.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to fetch scorecard accomplishments');
    }
  }

  Future<List<Map<String, dynamic>>> fetchRoadmapFiltered({
    int? kraId,
    String? year,
  }) async {
    final endpoint = '${ApiEndpoint().scorecardMonitoringFilter}/kra-year';
    Map<String, dynamic>? queryParams;

    if (kraId != null && year != null && year.isNotEmpty) {
      queryParams = {'kraid': kraId, 'year': year};
    } else if (kraId != null) {
      queryParams = {'kraid': kraId};
    } else if (year != null && year.isNotEmpty) {
      queryParams = {'year': year};
    } else {
      queryParams = null;
    }

    final response = await AuthenticatedRequest.get(
      dio,
      endpoint,
      queryParameters: queryParams,
    );

    if (response.statusCode == 200) {
      final data = response.data;
      final items = data["deliverables"] as List<dynamic>? ?? [];
      return items
          .map(
            (item) => {
              'id': item['id'],
              'kraDescription': item['kraDescription'] ?? '',
              'deliverableName': item['deliverableDescription'] ?? '',
              'year': (item['year']?.toString() ?? ''),
              'kra': item['kraDescription'] ?? item['kra'],
            },
          )
          .toList();
    } else {
      throw Exception('Failed to fetch roadmap filtered data');
    }
  }

  Future<List<Map<String, dynamic>>> fetchKpiFiltered({int? kraId}) async {
    final endpoint = '${ApiEndpoint().scorecardMonitoringFilter}/kra';
    Map<String, dynamic>? queryParams;

    if (kraId != null) {
      queryParams = {'kraid': kraId};
    } else {
      queryParams = null;
    }

    final response = await AuthenticatedRequest.get(
      dio,
      endpoint,
      queryParameters: queryParams,
    );

    if (response.statusCode == 200) {
      final data = response.data;
      final items = data["deliverables"] as List<dynamic>? ?? [];
      return items
          .map((item) => {'kpiDescription': item['kpiDescription'] ?? ''})
          .toList();
    } else {
      throw Exception('Failed to fetch KPI data');
    }
  }
}
