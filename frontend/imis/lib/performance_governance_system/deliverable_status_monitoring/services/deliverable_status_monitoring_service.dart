import 'package:dio/dio.dart';
import 'package:imis/office/models/office.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';

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

  Future<void> saveAccomplishment(List<Map<String, dynamic>> data) async {
    final url = ApiEndpoint().pgsDeliverableAccomplishment;

    final response = await AuthenticatedRequest.post(dio, url, data: data);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create/update PGS accomplishment');
    }
  }
}
