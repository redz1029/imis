import 'package:dio/dio.dart';
import 'package:imis/auditor_team/models/auditor_team.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/page_list.dart';
import 'package:imis/utils/pagination_util.dart';

import '../../utils/http_util.dart';

class AuditorTeamService {
  final Dio dio;

  AuditorTeamService(this.dio);
  Future<PageList<AuditorTeam>> getAuditorTeam({
    int page = 1,
    int pageSize = 15,
    String? searchQuery,
  }) async {
    final paginationUtil = PaginationUtil(dio);
    return await paginationUtil.fetchPaginatedData<AuditorTeam>(
      endpoint: ApiEndpoint().auditorteam,
      page: page,
      pageSize: pageSize,
      searchQuery: searchQuery,
      fromJson: (json) => AuditorTeam.fromJson(json),
    );
  }

  Future<void> createOrUpdateAuditorTeam(AuditorTeam auditorTeam) async {
    var url = ApiEndpoint().auditorteam;

    try {
      final Map<String, dynamic> requestData = auditorTeam.toJson();
      final response = await AuthenticatedRequest.post(
        dio,
        url,
        data: requestData,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception("Failed to add/audito team");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteAuditorTeam(String teamId) async {
    final url = '${ApiEndpoint().auditorteam}/$teamId';
    await AuthenticatedRequest.delete(dio, url);
  }
}
