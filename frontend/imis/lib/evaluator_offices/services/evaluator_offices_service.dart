import 'package:dio/dio.dart';
import 'package:imis/evaluator_offices/models/evaluator_offices.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/page_list.dart';
import 'package:imis/utils/pagination_util.dart';
import '../../utils/http_util.dart';

class EvaluatorOfficesService {
  final Dio dio;

  EvaluatorOfficesService(this.dio);

  Future<PageList<EvaluatorOffices>> getEvalutorsOffice({
    int page = 1,
    int pageSize = 15,
    String? searchQuery,
  }) async {
    final paginationUtil = PaginationUtil(dio);
    return await paginationUtil.fetchPaginatedData(
      endpoint: '${ApiEndpoint().evaluatorOffices}/page',
      page: page,
      pageSize: pageSize,
      searchQuery: searchQuery,
      fromJson: (json) => EvaluatorOffices.fromJson(json),
    );
  }

  Future<void> addEvaluatorsOffice(EvaluatorOffices evaluatorOffice) async {
    final url = ApiEndpoint().evaluatorOffices;
    final isUpdating = evaluatorOffice.id != 0;
    final Map<String, dynamic> requestData = evaluatorOffice.toJson();

    final response =
        isUpdating
            ? await AuthenticatedRequest.put(
              dio,
              '$url/${evaluatorOffice.id}',
              data: requestData,
            )
            : await AuthenticatedRequest.post(dio, url, data: requestData);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create/update auditor office');
    }
  }

  Future<void> deleteEvaluatorsOffice(String evaluatorOffice) async {
    final url = '${ApiEndpoint().auditorOffice}/$evaluatorOffice';
    await AuthenticatedRequest.delete(dio, url);
  }
}
