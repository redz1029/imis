import 'package:dio/dio.dart';
import 'package:imis/qms_documents/policy_signatory_template/models/policy_signatory_template.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/utils/page_list.dart';
import 'package:imis/utils/pagination_util.dart';

class PolicySignatoryTemplateService {
  final Dio dio;

  PolicySignatoryTemplateService(this.dio);

  Future<PageList<PolicySignatoryTemplate>> getSignatoryTemplate({
    int page = 1,
    int pageSize = 15,
    String? searchQuery,
  }) async {
    final paginationUtil = PaginationUtil(dio);
    return await paginationUtil.fetchPaginatedData<PolicySignatoryTemplate>(
      endpoint: '${ApiEndpoint().papSignatoryTemplate}/page',
      page: page,
      pageSize: pageSize,
      searchQuery: searchQuery,
      fromJson: (json) => PolicySignatoryTemplate.fromJson(json),
    );
  }

  Future<void> deleteSignatory(String id) async {
    final url = '${ApiEndpoint().papSignatoryTemplate}/$id';
    await AuthenticatedRequest.delete(dio, url);
  }
}
