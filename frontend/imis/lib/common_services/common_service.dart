import 'package:dio/dio.dart';
import 'package:imis/auditor/models/auditor.dart';
import 'package:imis/office/models/office.dart';
import 'package:imis/performance_governance_system/key_result_area/models/key_result_area.dart';
import 'package:imis/performance_governance_system/pgs_period/models/pgs_period.dart';
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

  Future<List<Office>> fetchOffices() => _fetchList(
    ApiEndpoint().office,
    (e) => Office.fromJson(e),
    'Failed to fetch offices',
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
}
