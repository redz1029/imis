import 'package:dio/dio.dart';
import 'package:imis/performance_validation_tool/performance_validation_tool_signatory/models/pvt_signatory_template.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/utils/page_list.dart';
import 'package:imis/utils/pagination_util.dart';

class PvtSignatoryTemplateService {
  final Dio dio;

  PvtSignatoryTemplateService(this.dio);

  Future<PageList<PvtSignatoryTemplate>> getSignatoryTemplate({
    int page = 1,
    int pageSize = 15,
    String? searchQuery,
  }) async {
    final paginationUtil = PaginationUtil(dio);
    return await paginationUtil.fetchPaginatedData<PvtSignatoryTemplate>(
      endpoint: ApiEndpoint().performanceValidationToolSignatoryTemplate,
      page: page,
      pageSize: pageSize,
      searchQuery: searchQuery,
      fromJson: (json) => PvtSignatoryTemplate.fromJson(json),
    );
  }

  Future<void> deleteSignatory(String id) async {
    final url =
        '${ApiEndpoint().performanceValidationToolSignatoryTemplate}/$id';
    await AuthenticatedRequest.delete(dio, url);
  }
}
