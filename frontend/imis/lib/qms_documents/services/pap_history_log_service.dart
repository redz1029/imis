// import 'package:dio/dio.dart';
// import 'package:imis/qms_documents/models/pap_history_log.dart';
// import 'package:imis/utils/api_endpoint.dart';
// import 'package:imis/utils/http_util.dart';

// class PapHistoryLogService {
//   final Dio dio;

//   PapHistoryLogService(this.dio);

//   Future<PapHistoryLog> getHistoryLog(int id) async {
//     final url = '${ApiEndpoint().policyAndProcedureHistoryLog}/$id';
//     try {
//       final response = await AuthenticatedRequest.get(dio, url);
//       if (response.statusCode != 200) {
//         throw Exception('Failed to load history log.');
//       }
//       return PapHistoryLog.fromJson(response.data as Map<String, dynamic>);
//     } on DioException {
//       throw Exception('Failed to load history log.');
//     }
//   }
// }
import 'package:dio/dio.dart';
import 'package:imis/qms_documents/models/pap_history_log.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';

class PapHistoryLogService {
  final Dio dio;

  PapHistoryLogService(this.dio);

  Future<PapHistoryLog> getHistoryLog(int id) async {
    final url = '${ApiEndpoint().policyAndProcedureHistoryLog}/$id';
    try {
      final response = await AuthenticatedRequest.get(dio, url);
      if (response.statusCode != 200) {
        throw Exception('Failed to load history log.');
      }
      return PapHistoryLog.fromJson(response.data as Map<String, dynamic>);
    } on DioException {
      throw Exception('Failed to load history log.');
    }
  }

  Future<void> saveHistoryLog(Map<String, dynamic> body) async {
    final url = ApiEndpoint().policyAndProcedureHistoryLog;
    try {
      final response = await AuthenticatedRequest.post(dio, url, data: body);
      final code = response.statusCode ?? 0;
      if (code != 200 && code != 201 && code != 204) {
        throw Exception('Failed to save history log.');
      }
    } on DioException catch (e) {
      final data = e.response?.data;
      final msg = data is Map ? data['message']?.toString() : null;
      throw Exception(msg ?? 'Failed to save history log.');
    }
  }
}
