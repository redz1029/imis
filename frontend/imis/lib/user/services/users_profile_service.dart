import 'package:dio/dio.dart';
import 'package:imis/user/models/user_registration.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/utils/page_list.dart';
import 'package:imis/utils/pagination_util.dart';

class UsersProfileService {
  final Dio dio;

  UsersProfileService(this.dio);
  Future<PageList<UserRegistration>> getUsers({
    int page = 1,
    int pageSize = 15,
    String? searchQuery,
  }) async {
    final paginationUtil = PaginationUtil(dio);
    return await paginationUtil.fetchPaginatedData(
      endpoint: ApiEndpoint().getUser,
      page: page,
      pageSize: pageSize,
      searchQuery: searchQuery,
      fromJson: (json) => UserRegistration.fromJson(json),
    );
  }

  Future<void> createUser(UserRegistration userProfile) async {
    var url = ApiEndpoint().register;
    final Map<String, dynamic> requestData = userProfile.toJson();
    final response = await AuthenticatedRequest.post(
      dio,
      url,
      data: requestData,
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create user');
    }
  }

  Future<bool> checkUsernameExists(String username) async {
    try {
      await dio.get(
        ApiEndpoint().register,
        queryParameters: {"username": username},
      );

      return false;
    } on DioException catch (e) {
      if (e.response != null && e.response?.statusCode == 400) {
        final errors = e.response?.data["errors"];
        if (errors != null && errors["DuplicateUserName"] != null) {
          return true;
        }
      }
      return false;
    }
  }

  Future<void> updateUser(UserRegistration userProfile) async {
    var url = ApiEndpoint().updateUser;
    final Map<String, dynamic> requestData = userProfile.toJson();
    final response = await AuthenticatedRequest.put(
      dio,
      url,
      data: requestData,
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create user');
    }
  }
}
