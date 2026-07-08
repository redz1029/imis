import 'package:dio/dio.dart';
import 'package:imis/auditor/models/auditor.dart';
import 'package:imis/auditor_team/models/auditor_team_member.dart';
import 'package:imis/office/models/office.dart';
import 'package:imis/performance_governance_system/models/pgs_deliverables.dart';
import 'package:imis/performance_governance_system/pgs_signatory_template/models/pgs_signatory.dart';
import 'package:imis/performance_governance_system/process_core_support/models/key_result_area.dart';
import 'package:imis/performance_governance_system/pgs_period/models/pgs_period.dart';
import 'package:imis/performance_validation_tool/performance_validation_tool_period/models/performance_validation_tool_period.dart';
import 'package:imis/roadmap/kra_period_roadmap/models/kra_roadmap_period.dart';
import 'package:imis/roles/models/roles.dart';
import 'package:imis/strategy_review_report/strategy_review_period/models/strategy_review_period.dart';
import 'package:imis/team/models/team.dart';
import 'package:imis/user/models/user.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';

class CommonService {
  final Dio dio;

  CommonService(this.dio);

  Future<List<T>> _fetchList<T>(
    String url,
    T Function(Map<String, dynamic>) fromJson,
    String errorMessage,
  ) async {
    final response = await AuthenticatedRequest.get(dio, url);

    if (response.statusCode == 200 && response.data is List) {
      return (response.data as List)
          .map((e) => fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(errorMessage);
    }
  }

  Future<void> loadData<T>({
    required List<T> list,
    required Future<List<T>> Function() fetchFunction,
    required Function(bool) setLoading,
    required Function(List<T>) setList,
  }) async {
    if (list.isNotEmpty) return;

    setLoading(true);

    try {
      final response = await fetchFunction();
      setList(response);
    } finally {
      setLoading(false);
    }
  }

  Future<T> _fetchSingle<T>(
    String url,
    T Function(Map<String, dynamic>) fromJson,
    String errorMessage,
  ) async {
    final response = await AuthenticatedRequest.get(dio, url);

    if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
      return fromJson(response.data as Map<String, dynamic>);
    } else {
      throw Exception(errorMessage);
    }
  }

  Future<List<Office>> fetchOffices() => _fetchList(
    ApiEndpoint().office,
    (e) => Office.fromJson(e),
    'Failed to fetch offices',
  );

  Future<List<Office>> fetchAlloffices() => _fetchList(
    ApiEndpoint().allOffices,
    (e) => Office.fromJson(e),
    'Failed to fetch offices',
  );

  Future<List<Office>> fetchService() => _fetchList(
    ApiEndpoint().officeServices,
    (e) => Office.fromJson(e),
    'Failed to fetch service',
  );
  Future<List<PgsSignatory>> fetchPgsSignatories(int pgsId) => _fetchList(
    '${ApiEndpoint().performanceValidationTool}/PgsSignatory?pgsSignatoryId=$pgsId',
    (e) => PgsSignatory.fromJson(e),
    'Failed to fetch PGS signatories',
  );
  Future<List<User>> fetchUsers() => _fetchList(
    ApiEndpoint().users,
    (e) => User.fromJson(e),
    'Failed to fetch users',
  );

  Future<List<Auditor>> fetchAuditors() => _fetchList(
    ApiEndpoint().auditor,
    (e) => Auditor.fromJson(e),
    'Failed to fetch auditors',
  );

  Future<List<PgsPeriod>> fetchPgsPeriod() => _fetchList(
    ApiEndpoint().pgsperiod,
    (e) => PgsPeriod.fromJson(e),
    'Failed to fetch periods',
  );

  Future<List<KeyResultArea>> fetchKra() => _fetchList(
    ApiEndpoint().keyresult,
    (e) => KeyResultArea.fromJson(e),
    'Failed to fetch key result areas',
  );

  Future<List<Team>> fetchTeam() => _fetchList(
    ApiEndpoint().team,
    (e) => Team.fromJson(e),
    'Failed to fetch team',
  );

  Future<List<KraRoadmapPeriod>> fetchKraPeriod() => _fetchList(
    ApiEndpoint().kraRoadMapPeriod,
    (e) => KraRoadmapPeriod.fromJson(e),
    'Failed to fetch kra period',
  );

  Future<List<Roles>> fetchRoles() => _fetchList(
    ApiEndpoint().roles,
    (e) => Roles.fromJson(e),
    'Failed to fetch roles',
  );

  Future<List<PgsPeriod>> fetchPeriod() => _fetchList(
    ApiEndpoint().pgsperiod,
    (e) => PgsPeriod.fromJson(e),
    'Failed to fetch kra period',
  );

  Future<List<StrategyReviewPeriod>> fetchStrategyReviewPeriod() => _fetchList(
    ApiEndpoint().strategyReviewPeriod,
    (e) => StrategyReviewPeriod.fromJson(e),
    'Failed to fetch strategy review period',
  );

  Future<List<StrategyReviewPeriod>> fetchSrategyPeriod() => _fetchList(
    ApiEndpoint().strategyReviewPeriod,
    (e) => StrategyReviewPeriod.fromJson(e),
    'Failed to fetch kra period',
  );

  Future<List<PerformanceValidationToolPeriod>> fetchValidationPeriod() =>
      _fetchList(
        ApiEndpoint().performanceValidationToolPeriod,
        (e) => PerformanceValidationToolPeriod.fromjson(e),
        'Failed to fetch validation period',
      );

  Future<List<PgsDeliverables>> fetchValidationToolDeliverables(
    int pgsId,
  ) async {
    final response = await AuthenticatedRequest.get(
      dio,
      '${ApiEndpoint().performancegovernancesystem}/$pgsId',
    );

    if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
      final raw =
          (response.data as Map<String, dynamic>)['pgsDeliverables'] as List?;
      if (raw == null) return [];
      return raw
          .map((e) => PgsDeliverables.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to fetch validation deliverables');
    }
  }

  Future<Office> getOfficeById(String id) async {
    final response = await AuthenticatedRequest.get(
      dio,
      '${ApiEndpoint().office}/$id',
    );
    return Office.fromJson(response.data);
  }

  Future<AuditorTeamDetail> fetchAuditorTeamByTeamId(int teamId) =>
      _fetchSingle(
        '${ApiEndpoint().auditorteam}/teamid/$teamId',
        (e) => AuditorTeamDetail.fromJson(e),
        'Failed to fetch auditor team members',
      );

  Future<Office?> getParentOffice(int officeId) async {
    final response = await dio.get(
      '${ApiEndpoint.baseUrl}/office/$officeId/parent',
    );

    if (response.statusCode == 200) {
      return Office.fromJson(response.data);
    }

    return null;
  }

  Future<Team> fetchTeamByUserId(String userId) => _fetchSingle(
    '${ApiEndpoint.baseUrl}/auditors/user/$userId',
    (e) => Team.fromJson(e),
    'Failed to fetch team for current user',
  );
}
