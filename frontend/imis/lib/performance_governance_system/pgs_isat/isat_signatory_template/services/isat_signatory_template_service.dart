import 'package:dio/dio.dart';
import 'package:imis/performance_governance_system/pgs_isat/isat_signatory_template/models/isat_signatory_template.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/utils/page_list.dart';
import 'package:imis/utils/pagination_util.dart';

class IsatSignatoryTemplateService {
  final Dio dio;

  IsatSignatoryTemplateService(this.dio);

  Future<PageList<IsatSignatoryTemplate>> getSignatoryTemplate({
    int page = 1,
    int pageSize = 15,
    String? searchQuery,
  }) async {
    final paginationUtil = PaginationUtil(dio);
    return await paginationUtil.fetchPaginatedData<IsatSignatoryTemplate>(
      endpoint: ApiEndpoint().iSATSignatoryTemplate,
      page: page,
      pageSize: pageSize,
      searchQuery: searchQuery,
      fromJson: (json) => IsatSignatoryTemplate.fromJson(json),
    );
  }

  Future<bool> saveTemplates(List<IsatSignatoryTemplate> items) async {
    final res = await AuthenticatedRequest.post(
      dio,
      ApiEndpoint().iSATSignatoryTemplate,
      data: items.map((s) => s.toJson()).toList(),
    );
    return res.statusCode == 200 || res.statusCode == 201;
  }

  Future<void> deleteSignatory(String id) async {
    final url = '${ApiEndpoint().iSATSignatoryTemplate}/$id';
    await AuthenticatedRequest.delete(dio, url);
  }
}
