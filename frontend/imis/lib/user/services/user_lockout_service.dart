import 'package:dio/dio.dart';
import 'package:imis/user/models/pending_approval_user.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/utils/page_list.dart';
import 'package:imis/utils/pagination_util.dart';

class UserLockoutService {
  final Dio dio;
  UserLockoutService(this.dio);

  Future<PageList<PendingApprovalUser>> getPendingApprovalUsers({
    int page = 1,
    int pageSize = 15,
    String? searchQuery,
  }) async {
    final paginationUtil = PaginationUtil(dio);
    return await paginationUtil.fetchPaginatedData<PendingApprovalUser>(
      endpoint: '${ApiEndpoint().users}/pending-approval',
      page: page,
      pageSize: pageSize,
      searchQuery: searchQuery,
      fromJson: (json) => PendingApprovalUser.fromJson(json),
    );
  }

  Future<PageList<PendingApprovalUser>> getActiveUsers({
    int page = 1,
    int pageSize = 15,
    String? searchQuery,
  }) async {
    final paginationUtil = PaginationUtil(dio);
    return await paginationUtil.fetchPaginatedData<PendingApprovalUser>(
      endpoint: ApiEndpoint().getUser,
      page: page,
      pageSize: pageSize,
      searchQuery: searchQuery,
      fromJson: (json) => PendingApprovalUser.fromJson(json),
    );
  }

  Future<void> unlockUser(String userId) async {
    final url = '${ApiEndpoint().users}/$userId/unlock';
    await AuthenticatedRequest.put(dio, url);
  }

  Future<void> lockUser(
    String userId, {
    DateTime? lockoutEnd,
    bool permanent = false,
  }) async {
    final end =
        permanent
            ? DateTime.utc(9999, 12, 31, 23, 59, 59)
            : (lockoutEnd ?? DateTime.now().toUtc());

    final url = '${ApiEndpoint().users}/$userId/lockout';

    await AuthenticatedRequest.put(
      dio,
      url,
      data: {'lockoutEnabled': true, 'lockoutEnd': end.toIso8601String()},
    );
  }
}
