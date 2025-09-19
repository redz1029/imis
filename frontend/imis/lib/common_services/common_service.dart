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

  Future<List<Office>> fetchOffices() async {
    var url = ApiEndpoint().office;

    final response = await AuthenticatedRequest.get(dio, url);

    if (response.statusCode == 200 && response.data is List) {
      return (response.data as List).map((e) => Office.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch offices');
    }
  }

  Future<List<User>> fetchUsers() async {
    var url = ApiEndpoint().users;

    final response = await AuthenticatedRequest.get(dio, url);

    if (response.statusCode == 200 && response.data is List) {
      return (response.data as List).map((e) => User.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch users');
    }
  }

  Future<List<Auditor>> fetchAuditors() async {
    var url = ApiEndpoint().auditor;

    final response = await AuthenticatedRequest.get(dio, url);

    if (response.statusCode == 200 && response.data is List) {
      return (response.data as List).map((e) => Auditor.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch auditor');
    }
  }

  Future<List<PgsPeriod>> fetchPgsPeriod() async {
    var url = ApiEndpoint().pgsperiod;

    final response = await AuthenticatedRequest.get(dio, url);

    if (response.statusCode == 200 && response.data is List) {
      return (response.data as List).map((e) => PgsPeriod.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch period');
    }
  }

  Future<List<KeyResultArea>> fetchKra() async {
    var url = ApiEndpoint().keyresult;

    final response = await AuthenticatedRequest.get(dio, url);

    if (response.statusCode == 200 && response.data is List) {
      return (response.data as List)
          .map((e) => KeyResultArea.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to fetch key result area');
    }
  }
}
