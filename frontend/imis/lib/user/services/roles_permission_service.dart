import 'package:dio/dio.dart';
import 'package:imis/user/models/roles_permissions.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';

class RolesPermissionsService {
  final Dio dio = Dio();

  Future<List<RolesPermissions>> fetchRolesPermissions() async {
    try {
      final response = await AuthenticatedRequest.get(
        dio,
        ApiEndpoint().rolesPermissions,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) => RolesPermissions.fromJson(e)).toList();
      } else {
        throw Exception("Failed to load roles permissions");
      }
    } on DioException {
      throw Exception("Dio error");
    }
  }
}
