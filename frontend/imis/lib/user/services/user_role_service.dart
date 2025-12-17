import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
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
    await AuthenticatedRequest.post(dio, url, data: [userRole.toJson()]);
  }

  Future<void> updateRole(String userId, List<RoleAssignment> roles) async {
    final url = ApiEndpoint().updateUserRole;

    final body = {
      "userId": userId,
      "roles": roles.map((r) => r.toJson()).toList(),
    };

    await AuthenticatedRequest.put(dio, url, data: body);
  }

  Future<void> deleteUserRole(String userRole) async {
    final url = '${ApiEndpoint().userRole}/$userRole';
    await AuthenticatedRequest.delete(dio, url);
  }

  Future<void> updatePermission(
    String userId,
    String userName,
    List<dynamic> permissions,
  ) async {
    final url = '${ApiEndpoint().users}/$userId/permissions';

    final body = {
      "userId": userId,
      "userName": userName,
      "permissions": permissions,
    };

    try {
      final response = await AuthenticatedRequest.put(dio, url, data: body);

      if (response.statusCode == 200) {
        debugPrint('Permission updated successfully');
      }
    } catch (e) {
      debugPrint('Error updating permission: $e');
    }
  }

  Future<List<dynamic>?> fetchPermissions(String userId, String roleId) async {
    final url = '${ApiEndpoint().users}/$userId/permissions?roleId=$roleId';

    try {
      final response = await AuthenticatedRequest.get(dio, url);

      if (response.statusCode == 200) {
        return response.data['permissions'];
      }
    } catch (e) {
      debugPrint('Failed to fetch permission');
    }
    return null;
  }
}
