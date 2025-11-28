import 'package:dio/dio.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';

class RolesPermissionsService {
  final Dio dio = Dio();

  Future<List<dynamic>?> fetchUserRolePermissions(
    String userId,
    String roleId,
  ) async {
    final url = "${ApiEndpoint().users}/$userId/permissions?roleId=$roleId";

    try {
      final response = await AuthenticatedRequest.get(dio, url);

      if (response.statusCode == 200) {
        final data = response.data;

        return data['permissions'] as List<dynamic>;
      }

      return null;
    } on DioException catch (e) {
      return null;
    } catch (e) {
      return null;
    }
  }
}
