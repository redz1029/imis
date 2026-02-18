import 'package:dio/dio.dart';
import 'package:imis/auditor_team/models/auditor_team.dart';
import 'package:imis/team/models/improvement_type.dart';
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

  Future<void> deleteAuditorTeam(int teamId) async {
    final url = '${ApiEndpoint().auditorteam}/$teamId';
    try {
      final response = await AuthenticatedRequest.delete(dio, url);
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete auditor team with teamId: $teamId');
      }
    } catch (e) {
      rethrow;
    }
  }
}
