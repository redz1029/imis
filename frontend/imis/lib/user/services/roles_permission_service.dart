import 'package:dio/dio.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';

class RolesPermissionsService {
  final Dio dio = Dio();

  Future<Map<String, dynamic>?> fetchUserRolePermissions(
    String userId,
    String roleId,
  ) async {
    final url = "${ApiEndpoint().users}/$userId/permissions?roleId=$roleId";

    try {
      final response = await AuthenticatedRequest.get(dio, url);

      if (response.statusCode == 200) {
        return response.data;
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}
