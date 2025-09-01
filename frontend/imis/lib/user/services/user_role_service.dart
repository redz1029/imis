import 'package:dio/dio.dart';
import 'package:imis/roles/models/roles.dart';
import 'package:imis/user/models/user_role.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/page_list.dart';
import '../../utils/http_util.dart';
import '../../utils/pagination_util.dart';

class UserRoleService {
  final Dio dio;

  UserRoleService(this.dio);
  Future<PageList<UserRoles>> getUserRoles({
    int page = 1,
    int pageSize = 50,
    String? searchQuery,
  }) async {
    final paginationUtil = PaginationUtil(dio);

    return await paginationUtil.fetchPaginatedData(
      endpoint: ApiEndpoint().userRole,
      page: page,
      pageSize: pageSize,
      searchQuery: searchQuery,
      fromJson: (json) {
        final List<UserRoles> roles = [];
        final String userId = json['userId'];

        if (json['roles'] != null && json['roles'] is List) {
          for (var role in json['roles']) {
            roles.add(UserRoles(userId: userId, roleId: role['roleId']));
          }
        }
        return roles.isNotEmpty
            ? roles.first
            : UserRoles(userId: userId, roleId: "");
      },
    );
  }

  Future<List<Roles>> fetchRoles() async {
    var url = ApiEndpoint().roles;

    final response = await AuthenticatedRequest.get(dio, url);

    if (response.statusCode == 200 && response.data is List) {
      return (response.data as List).map((e) => Roles.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch roles');
    }
  }

  Future<void> addUserRoles(UserRoles userRole) async {
    final url = ApiEndpoint().userRole;
    await AuthenticatedRequest.post(dio, url, data: userRole.toJson());
  }

  Future<void> updateRole(String userId, String roleId) async {
    final url =
        '${ApiEndpoint().updateUserRole}?userId=$userId&newRoleId=$roleId';

    await AuthenticatedRequest.put(dio, url);
  }

  Future<void> deleteUserRole(String userRole) async {
    final url = '${ApiEndpoint().userRole}/$userRole';
    await AuthenticatedRequest.delete(dio, url);
  }
}
