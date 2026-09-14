import 'package:dio/dio.dart';
import 'package:imis/performance_governance_system/pgs_roadmap/models/kra_roadmap_filter.dart';
import 'package:imis/performance_governance_system/pgs_roadmap/models/kra_roadmap_role.dart';
import 'package:imis/performance_governance_system/pgs_roadmap/models/roadmap.dart';
import 'package:imis/performance_governance_system/pgs_roadmap/models/roadmap_history.dart';
import 'package:imis/performance_governance_system/pgs_roadmap_kpi_sequence/models/roadmap_kpi_sequence.dart';
import 'package:imis/performance_governance_system/pgs_strategic_change_agenda/models/strategic_change_agenda.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/utils/page_list.dart';
import 'package:imis/utils/pagination_util.dart';

class StrategyChangeAgendaService {
  final Dio dio;

  StrategyChangeAgendaService(this.dio);

  Future<PageList<StrategicChangeAgenda>> getStrategyChangeAgenda({
    int page = 1,
    int pageSize = 15,
    String? searchQuery,
  }) async {
    final paginationUtil = PaginationUtil(dio);
    return await paginationUtil.fetchPaginatedData<StrategicChangeAgenda>(
      endpoint: '${ApiEndpoint().strategicChangeAgenda}/page',
      page: page,
      pageSize: pageSize,
      searchQuery: searchQuery,
      fromJson: (json) => StrategicChangeAgenda.fromJson(json),
    );
  }

  Future<void> createStrategyChange(StrategicChangeAgenda roadmap) async {
    final url = ApiEndpoint().strategicChangeAgenda;
    final Map<String, dynamic> requestData = roadmap.toJson();
    final response = await AuthenticatedRequest.post(
      dio,
      url,
      data: requestData,
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create strategy change agenda');
    }
  }

  Future<StrategicChangeAgenda> getStrategicChangebyId(int id) async {
    final url = '${ApiEndpoint().strategicChangeAgenda}/$id';

    final response = await AuthenticatedRequest.get(dio, url);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch strategy change agenda');
    }

    return StrategicChangeAgenda.fromJson(response.data);
  }

  Future<void> deleteStrategicChangeAgenda(String strategyChange) async {
    final url = '${ApiEndpoint().strategicChangeAgenda}/$strategyChange';
    await AuthenticatedRequest.delete(dio, url);
  }
}
