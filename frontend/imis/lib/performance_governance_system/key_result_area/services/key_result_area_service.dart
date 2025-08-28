import 'package:dio/dio.dart';
import 'package:imis/performance_governance_system/key_result_area/models/key_result_area.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/utils/page_list.dart';
import 'package:imis/utils/pagination_util.dart';

class KeyResultAreaService {
  final Dio dio;

  KeyResultAreaService(this.dio);
  Future<PageList<KeyResultArea>> getKRA({
    int page = 1,
    int pageSize = 15,
    String? searchQuery,
  }) async {
    final paginationUtil = PaginationUtil(dio);
    return await paginationUtil.fetchPaginatedData<KeyResultArea>(
      endpoint: ApiEndpoint().keyresult,
      page: page,
      pageSize: pageSize,
      searchQuery: searchQuery,
      fromJson: (json) => KeyResultArea.fromJson(json),
    );
  }

  Future<void> createOrUpdateKra(KeyResultArea kra) async {
    var url = ApiEndpoint().keyresult;
    final Map<String, dynamic> requestData = kra.toJson();
    final response = await AuthenticatedRequest.post(
      dio,
      url,
      data: requestData,
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create kra');
    }
  }
}
