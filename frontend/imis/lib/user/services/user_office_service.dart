import 'package:dio/dio.dart';
import 'package:imis/user/models/user_office.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/utils/page_list.dart';
import 'package:imis/utils/pagination_util.dart';

class UserOfficeService {
  final Dio dio;
  UserOfficeService(this.dio);

  Future<PageList<UserOffice>> getPgsPeriod({
    int page = 1,
    int pageSize = 15,
    String? searchQuery,
  }) async {
    final paginationUtil = PaginationUtil(dio);
    return await paginationUtil.fetchPaginatedData(
      endpoint: ApiEndpoint().useroffice,
      page: page,
      pageSize: pageSize,
      searchQuery: searchQuery,
      fromJson: (json) => UserOffice.fromJson(json),
    );
  }

  Future<void> addOrUpdateUserOffice(UserOffice userOffice) async {
    final url = ApiEndpoint().useroffice;
    final isUpdating = userOffice.id != 0;
    final Map<String, dynamic> requestData = userOffice.toJson();

    final response =
        isUpdating
            ? await AuthenticatedRequest.put(
              dio,
              '$url/${userOffice.id}',
              data: requestData,
            )
            : await AuthenticatedRequest.post(dio, url, data: requestData);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create/update user office');
    }
  }

  Future<void> deleteUserOffice(String userOffice) async {
    final url = '${ApiEndpoint().team}/$userOffice';
    await AuthenticatedRequest.delete(dio, url);
  }
}
