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
}
