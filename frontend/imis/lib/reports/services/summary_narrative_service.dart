import 'package:dio/dio.dart';
import 'package:imis/reports/models/pgs_summary_narrative.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';

class SummaryNarrativeService {
  final Dio dio;

  SummaryNarrativeService(this.dio);

  Future<void> addSummaryNarrative(
    PgsSummaryNarrative pgsSummaryNarrative,
  ) async {
    final url = ApiEndpoint().summaryNarrative;
    final Map<String, dynamic> requestData = pgsSummaryNarrative.toJson();
    final response = await AuthenticatedRequest.post(
      dio,
      url,
      data: requestData,
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create summary narrative');
    }
  }

  Future<List<dynamic>> getSummaryNarratives() async {
    final url = ApiEndpoint().summaryNarrative;

    final response = await AuthenticatedRequest.get(dio, url);

    if (response.statusCode == 200) {
      // Assuming API returns a JSON array
      return response.data;
    } else {
      throw Exception('Failed to fetch summary narratives');
    }
  }
}
