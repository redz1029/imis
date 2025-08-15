import 'package:dio/dio.dart';
import 'package:imis/team/models/team.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/utils/page_list.dart';
import 'package:imis/utils/pagination_util.dart';

class TeamService {
  final Dio dio;

  TeamService(this.dio);

  Future<PageList<Team>> getTeam({
    int page = 1,
    int pageSize = 15,
    String? searchQuery,
  }) async {
    final paginationUtil = PaginationUtil(dio);
    return await paginationUtil.fetchPaginatedData<Team>(
      endpoint: ApiEndpoint().team,
      page: page,
      pageSize: pageSize,
      searchQuery: searchQuery,
      fromJson: (json) => Team.fromJson(json),
    );
  }

  Future<void> addOrUpdateTeam(Team team) async {
    try {
      if (team.id == 0) {
        await createTeam(team);
      } else {
        await updateTeam(team);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createTeam(Team team) async {
    final url = ApiEndpoint().team;
    final response = await AuthenticatedRequest.post(
      dio,
      url,
      data: team.toJson(),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create team');
    }
  }

  Future<void> updateTeam(Team team) async {
    final response = await AuthenticatedRequest.put(
      dio,
      '${ApiEndpoint().team}/${team.id}',
      data: team.toJson(),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update team');
    }
  }

  Future<void> deleteTeam(String teamId) async {
    final url = '${ApiEndpoint().team}/$teamId';
    await AuthenticatedRequest.delete(dio, url);
  }
}
