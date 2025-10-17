import 'package:dio/dio.dart';
import 'package:imis/performance_governance_system/pgs_signatory_template/models/pgs_signatory_template.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/utils/page_list.dart';
import 'package:imis/utils/pagination_util.dart';

class PgsSignatoryTemplateService {
  final Dio dio;

  PgsSignatoryTemplateService(this.dio);

  Future<PageList<PgsSignatoryTemplate>> getSignatoryTemplate({
    int page = 1,
    int pageSize = 15,
    String? searchQuery,
  }) async {
    final paginationUtil = PaginationUtil(dio);
    return await paginationUtil.fetchPaginatedData<PgsSignatoryTemplate>(
      endpoint: ApiEndpoint().signatoryTemplate,
      page: page,
      pageSize: pageSize,
      searchQuery: searchQuery,
      fromJson: (json) => PgsSignatoryTemplate.fromJson(json),
    );
  }

  Future<void> deleteSignatory(String id) async {
    final url = '${ApiEndpoint().signatoryTemplate}/$id';
    await AuthenticatedRequest.delete(dio, url);
  }
}
