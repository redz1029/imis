import 'package:dio/dio.dart';
import 'package:imis/roles/models/roles.dart';
import 'package:imis/user/models/user_role.dart';
import 'package:imis/utils/api_endpoint.dart';
import '../../utils/http_util.dart';

class UserRoleService {
  final Dio dio;

  UserRoleService(this.dio);

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
