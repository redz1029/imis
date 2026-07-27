// lib/user/pages/home_service.dart
import 'package:dio/dio.dart';
import 'package:imis/user/models/user.dart';
import 'package:imis/office/models/office.dart';
import 'package:imis/team/models/team.dart';
import 'package:imis/auditor/models/auditor.dart';
import 'package:imis/performance_governance_system/models/pgs_deliverables.dart';
import 'package:imis/performance_governance_system/key_result_area/models/key_result_area.dart';
import 'package:imis/utils/http_util.dart';

class HomeService {
  final dio = Dio();

  Future<HomeData> fetchAll({
    required String usersEndpoint,
    required String officeEndpoint,
    required String teamEndpoint,
    required String auditorEndpoint,
    required String deliverablesEndpoint,
    required String kraEndpoint,
  }) async {
    final users = await _fetchData<User>(
      usersEndpoint,
      (json) => User.fromJson(json),
    );
    final offices = await _fetchData<Office>(
      officeEndpoint,
      (json) => Office.fromJson(json),
    );
    final teams = await _fetchData<Team>(
      teamEndpoint,
      (json) => Team.fromJson(json),
    );
    final auditors = await _fetchData<Auditor>(
      auditorEndpoint,
      (json) => Auditor.fromJson(json),
    );
    final deliverables = await _fetchData<PgsDeliverables>(
      deliverablesEndpoint,
      (json) => PgsDeliverables.fromJson(json),
    );
    final kras = await _fetchData<KeyResultArea>(
      kraEndpoint,
      (json) => KeyResultArea.fromJson(json),
    );

    return HomeData(
      users: users,
      offices: offices,
      teams: teams,
      auditors: auditors,
      deliverables: deliverables,
      kras: kras,
    );
  }

  Future<List<T>> _fetchData<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final response = await AuthenticatedRequest.get(dio, endpoint);
    if (response.statusCode == 200 && response.data is List) {
      return (response.data as List)
          .map((json) => fromJson(json as Map<String, dynamic>))
          .toList();
    }
    throw Exception("Failed to load data from $endpoint");
  }
}

class HomeData {
  final List<User> users;
  final List<Office> offices;
  final List<Team> teams;
  final List<Auditor> auditors;
  final List<PgsDeliverables> deliverables;
  final List<KeyResultArea> kras;

  HomeData({
    required this.users,
    required this.offices,
    required this.teams,
    required this.auditors,
    required this.deliverables,
    required this.kras,
  });
}
