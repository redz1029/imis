import 'package:dio/dio.dart';
import 'package:imis/team/models/improvement_type.dart';
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

  Future<void> createTeam(Team team) async {
    final url = ApiEndpoint().team;
    final Map<String, dynamic> requestData = team.toJson();
    final response = await AuthenticatedRequest.post(
      dio,
      url,
      data: requestData,
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create team');
    }
  }

  Future<List<ImprovementType>> getImprovementType() async {
    var url = ApiEndpoint().improvementtype;

    try {
      final response = await AuthenticatedRequest.get(dio, url);

      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .map((improvementType) => ImprovementType.fromJson(improvementType))
            .toList();
      } else {
        throw Exception("Failed to fetch improvement types.");
      }
    } on DioException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
  
   String getImprovementTypeName(int id, List<Map<String, dynamic>> improvementTypeList) {
    final improvementType = improvementTypeList.firstWhere(
      (type) => type['id'] == id,
      orElse: () => {'name': 'Unknown'},
    );
    return improvementType['name'];
  }

 


  Future<void> deleteTeam(String teamId) async {
    final url = '${ApiEndpoint().team}/$teamId';
    await AuthenticatedRequest.delete(dio, url);
  }
}
