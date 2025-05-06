import 'package:flutter/foundation.dart';

/// This class shall contain the collection of endpoints.
/// Do not ever set the URL's in each page as you would end up doing it multiple times.
class ApiEndpoint {
  static String baseUrl = '';

  late String login;
  late String register;
  late String changepassword;
  late String keyresult;
  late String auditor;
  late String pgsperiod;
  late String deliverables;
  late String performancegovernancesystem;
  late String office;
  late String team;
  late String auditorteam;
  late String userRole;
  late String roles;
  late String users;
  late String useroffice;
  late String updateUserRole;
  late String getUser;
  late String updateUser;
  late String auditSchedule;
  ApiEndpoint() {
    login = '$baseUrl/login';
    register = '$baseUrl/register';
    changepassword = '$baseUrl/changePassword';
    keyresult = '$baseUrl/KeyResultArea';
    auditor = '$baseUrl/auditors';
    pgsperiod = '$baseUrl/PgsPeriod';
    deliverables = '$baseUrl/Deliverable';
    performancegovernancesystem = '$baseUrl/pgs';
    office = '$baseUrl/Office';
    team = '$baseUrl/Team';
    auditorteam = '$baseUrl/auditorTeam';
    userRole = '$baseUrl/userRoles';
    roles = '$baseUrl/roles';
    users = '$baseUrl/users';
    useroffice = '$baseUrl/userOffice';
    updateUserRole = '$baseUrl/updateUserRole';
    getUser = '$baseUrl/getUser';
    updateUser = '$baseUrl/updateUser';
    auditSchedule = '$baseUrl/auditSchedule';
  }

  static Future<void> setBaseUrl() async {
    if (kDebugMode) {
      baseUrl = 'https://localhost:7273';
    } else if (kReleaseMode) {
      throw Exception("Release base Url is not specified!");
    } else {
      throw Exception("Test base Url is not specified!");
    }
  }
}
