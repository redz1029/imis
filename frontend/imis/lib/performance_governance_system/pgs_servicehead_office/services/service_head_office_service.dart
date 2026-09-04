import 'package:dio/dio.dart';
import 'package:imis/performance_governance_system/pgs_servicehead_office/models/service_head_office.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/utils/page_list.dart';
import 'package:imis/utils/pagination_util.dart';

class ServiceHeadOfficeService {
  final Dio dio;
  ServiceHeadOfficeService(this.dio);

  Future<PageList<ServiceHeadOffice>> getPgsPeriod({
    int page = 1,
    int pageSize = 15,
    String? searchQuery,
  }) async {
    final paginationUtil = PaginationUtil(dio);
    return await paginationUtil.fetchPaginatedData(
      endpoint: ApiEndpoint().serviceHeadOffices,
      page: page,
      pageSize: pageSize,
      searchQuery: searchQuery,
      fromJson: (json) => ServiceHeadOffice.fromJson(json),
    );
  }

  Future<void> addOrUpdateServiceHeadOffice(
    ServiceHeadOffice serviceHeadOffices,
  ) async {
    final url = ApiEndpoint().serviceHeadOffices;
    final isUpdating = serviceHeadOffices.id != 0;
    final Map<String, dynamic> requestData = serviceHeadOffices.toJson();

    final response =
        isUpdating
            ? await AuthenticatedRequest.put(
              dio,
              '$url/${serviceHeadOffices.id}',
              data: requestData,
            )
            : await AuthenticatedRequest.post(dio, url, data: requestData);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create/update user office');
    }
  }

  Future<void> deleteServiceHeadOffice(String serviceHeadOffices) async {
    final url = '${ApiEndpoint().serviceHeadOffices}/$serviceHeadOffices';
    await AuthenticatedRequest.delete(dio, url);
  }
}
