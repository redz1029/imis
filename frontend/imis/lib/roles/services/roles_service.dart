import 'package:dio/dio.dart';
import 'package:imis/roles/models/roles.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/page_list.dart';
import 'package:imis/utils/pagination_util.dart';
import 'package:imis/utils/http_util.dart';

class RolesService {
  final Dio dio;

  RolesService(this.dio);

  Future<PageList<Roles>> getRoles({
    int page = 1,
    int pageSize = 15,
    String? searchQuery,
  }) async {
    final paginationUtil = PaginationUtil(dio);
    return await paginationUtil.fetchPaginatedData<Roles>(
      endpoint: ApiEndpoint().roles,
      page: page,
      pageSize: pageSize,
      searchQuery: searchQuery,
      fromJson: (json) => Roles.fromJson(json),
    );
  }

  Future<void> createRole(String roleName) async {
    final url = ApiEndpoint().roles;
    await AuthenticatedRequest.post(dio, url, data: '"$roleName"');
  }

  Future<void> updateRole(String roleId, String newRoleName) async {
    final url = '${ApiEndpoint().roles}/$roleId';
    await AuthenticatedRequest.put(dio, url, data: '"$newRoleName"');
  }

  Future<void> deleteRole(String roleId) async {
    final url = '${ApiEndpoint().roles}/$roleId';
    await AuthenticatedRequest.delete(dio, url);
  }
}
