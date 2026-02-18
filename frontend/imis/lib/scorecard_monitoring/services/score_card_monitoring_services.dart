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

  Future<void> saveKRAAccomplishment(FormData formData) async {
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

  Future<void> saveKPIAccomplishment(FormData formData) async {
    final id =
        formData.fields
            .firstWhere((f) => f.key == 'id', orElse: () => MapEntry('id', ''))
            .value;
    final url =
        ApiEndpoint().kraroadmapkpiAccomplishment +
        (id.isNotEmpty ? '/$id' : '');

    final response =
        id.isNotEmpty
            ? await AuthenticatedRequest.put(dio, url, data: formData)
            : await AuthenticatedRequest.post(dio, url, data: formData);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create/update KPI accomplishment');
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
    int? fromYear,
    int? toYear,
  }) async {
    final endpoint = '${ApiEndpoint().scorecardMonitoringFilter}/kra-year';
    final Map<String, dynamic> queryParams = {};
    if (kraId != null) {
      queryParams['kraid'] = kraId;
    }
    if (fromYear != null) {
      queryParams['fromYear'] = fromYear;
    }
    if (toYear != null) {
      queryParams['toYear'] = toYear;
    }

    final response = await AuthenticatedRequest.get(
      dio,
      endpoint,
      queryParameters: queryParams.isEmpty ? null : queryParams,
    );

    if (response.statusCode == 200) {
      final data = response.data;
      final outerList = data["deliverables"] as List<dynamic>? ?? [];

      final allItems =
          outerList.expand((outer) {
            final startDate = outer['startDate'];
            final endDate = outer['endDate'];

            final innerList = outer["deliverables"] as List<dynamic>? ?? [];

            return innerList.map(
              (item) => {
                'id': item['id'],
                'kraDescription': item['kraDescription'] ?? '',
                'deliverableName': item['deliverableDescription'] ?? '',
                'year': item['year']?.toString() ?? '',
                'startDate': startDate,
                'endDate': endDate,
                'kra': item['kraDescription'] ?? '',
              },
            );
          }).toList();

      return allItems;
    } else {
      throw Exception('Failed to fetch roadmap filtered data');
    }
  }

  Future<List<Map<String, dynamic>>> fetchKpiFiltered({
    int? kraId,
    int? fromYear,
    int? toYear,
  }) async {
    final endpoint = '${ApiEndpoint().scorecardMonitoringFilter}/kra';
    final Map<String, dynamic> queryParams = {};
    if (kraId != null) {
      queryParams['kraid'] = kraId;
    }
    if (fromYear != null) {
      queryParams['fromYear'] = fromYear;
    }
    if (toYear != null) {
      queryParams['toYear'] = toYear;
    }

    final response = await AuthenticatedRequest.get(
      dio,
      endpoint,
      queryParameters: queryParams.isEmpty ? null : queryParams,
    );

    if (response.statusCode == 200) {
      final data = response.data;
      final outerList = data["deliverables"] as List<dynamic>? ?? [];

      final allItems =
          outerList.expand((outer) {
            final startDate = outer['startDate'];
            final endDate = outer['endDate'];

            final innerList = outer["kpiDeliverable"] as List<dynamic>? ?? [];

            return innerList.map(
              (item) => {
                'id': item['id'],
                'kpiDescription': item['kpiDescription'] ?? '',
                'startDate': startDate,
                'endDate': endDate,
              },
            );
          }).toList();

      return allItems;
    } else {
      throw Exception('Failed to fetch KPI data');
    }
  }
}
