import 'package:dio/dio.dart';
import 'package:imis/auditor_offices/models/auditor_offices.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/page_list.dart';
import 'package:imis/utils/pagination_util.dart';
import '../../utils/http_util.dart';

class AuditorOfficesService {
  final Dio dio;

  AuditorOfficesService(this.dio);

  Future<PageList<AuditorOffices>> getAuditorOffice({
    int page = 1,
    int pageSize = 15,
    String? searchQuery,
  }) async {
    final paginationUtil = PaginationUtil(dio);
    return await paginationUtil.fetchPaginatedData(
      endpoint: ApiEndpoint().auditorOffice,
      page: page,
      pageSize: pageSize,
      searchQuery: searchQuery,
      fromJson: (json) => AuditorOffices.fromJson(json),
    );
  }

  Future<void> addAuditorOffice(AuditorOffices auditorOffice) async {
    final url = ApiEndpoint().auditorOffice;
    final isUpdating = auditorOffice.id != 0;
    final Map<String, dynamic> requestData = auditorOffice.toJson();

    final response =
        isUpdating
            ? await AuthenticatedRequest.put(
              dio,
              '$url/${auditorOffice.id}',
              data: requestData,
            )
            : await AuthenticatedRequest.post(dio, url, data: requestData);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create/update auditor office');
    }
  }

  Future<void> deleteAuditorOffice(String auditorOffice) async {
    final url = '${ApiEndpoint().auditorOffice}/$auditorOffice';
    await AuthenticatedRequest.delete(dio, url);
  }
}
