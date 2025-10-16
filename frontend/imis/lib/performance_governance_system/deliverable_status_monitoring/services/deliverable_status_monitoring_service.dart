import 'package:dio/dio.dart';
import 'package:imis/office/models/office.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';
import '../models/breakthrough_scoring.dart';
import '../models/pgs_deliverable_accomplishment.dart';

class DeliverableStatusMonitoringService {
  final Dio dio;

  DeliverableStatusMonitoringService(this.dio);
  Future<void> saveData(List<dynamic> items) async {
    final url = ApiEndpoint().pgsScoreMonitoring;
    await AuthenticatedRequest.put(dio, url, data: {'items': items});
  }

  Future<List<Office>> fetchOffices() async {
    var url = ApiEndpoint().officePgsAuditor;

    final response = await AuthenticatedRequest.get(dio, url);

    if (response.statusCode == 200 && response.data is List) {
      return (response.data as List).map((e) => Office.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch offices');
    }
  }

  Future<void> saveAccomplishment(FormData formData) async {
    final id =
        formData.fields
            .firstWhere((f) => f.key == 'id', orElse: () => MapEntry('id', ''))
            .value;
    final url =
        ApiEndpoint().pgsDeliverableAccomplishment +
        (id.isNotEmpty ? '/$id' : '');

    final response =
        id.isNotEmpty
            ? await AuthenticatedRequest.put(dio, url, data: formData)
            : await AuthenticatedRequest.post(dio, url, data: formData);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create/update PGS accomplishment');
    }
  }

  Future<List<PgsDeliverableAccomplishment>> fetchAccomplishments(
    int deliverableId,
  ) async {
    final url = "${ApiEndpoint.baseUrl}/$deliverableId";
    final response = await AuthenticatedRequest.get(dio, url);

    if (response.statusCode == 200) {
      final data = response.data as List;
      return data
          .map((json) => PgsDeliverableAccomplishment.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to fetch PGS accomplishments');
    }
  }

  Future<BreakthroughScoring> fetchBreakthrough(int deliverableId) async {
    final url = "${ApiEndpoint().breakThroughScoring}/$deliverableId";
    final response = await AuthenticatedRequest.get(dio, url);

    if (response.statusCode == 200) {
      final data = response.data;
      return BreakthroughScoring.fromJson(data);
    } else {
      throw Exception('Failed to fetch breakthrough');
    }
  }

  Future<BreakthroughScoring> updateBreakthrough(
    int id, {
    required int pgsDeliverableId,
    required int percentAccomplishment,
    required int target,
    required int strategic,
    required int breakThrough,
    required double finalScore,
  }) async {
    final url = "${ApiEndpoint().breakThroughScoring}/$id";

    final response = await AuthenticatedRequest.put(
      dio,
      url,
      data: {
        "id": id,
        "pgsDeliverableId": pgsDeliverableId,
        "percentAccomplishment": percentAccomplishment,
        "target": target,
        "strategic": strategic,
        "breakThrough": breakThrough,
        "finalScore": finalScore,
      },
    );

    if (response.statusCode == 200) {
      return BreakthroughScoring.fromJson(response.data);
    } else {
      throw Exception('Failed to update breakthrough');
    }
  }
}
