import 'package:dio/dio.dart';
import 'package:imis/qms_documents/dcrrf/models/pap_dcrrf_history.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';

class PapDcrrfService {
  final Dio dio;

  PapDcrrfService(this.dio);

  Future<PapDcrrfHistory> getHistory(int procedureId) async {
    final url = '${ApiEndpoint().policyAndProcedureDCRRF}/history/$procedureId';
    try {
      final response = await AuthenticatedRequest.get(dio, url);
      final data = response.data;
      if (data is Map<String, dynamic>) return PapDcrrfHistory.fromJson(data);
      return PapDcrrfHistory(policyAndProcedureLogList: []);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return PapDcrrfHistory(policyAndProcedureLogList: []);
      }
      throw Exception(
        'Failed to load DCRRF history (${e.response?.statusCode})',
      );
    }
  }
}
