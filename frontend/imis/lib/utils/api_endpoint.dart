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
  late String pgsauditdetails;

  ApiEndpoint() {
    login = '$baseUrl/login';
    register = '$baseUrl/register';
    changepassword = '$baseUrl/changePassword';
    keyresult = '$baseUrl/Kra';
    auditor = '$baseUrl/auditors';
    pgsperiod = '$baseUrl/PgsPeriod';
    deliverables = '$baseUrl/Deliverable';
    pgsauditdetails = '$baseUrl/PgsAuditDetails';
  }

  static Future<void> setBaseUrl() async {
    if (kDebugMode) {
      baseUrl = 'https://localhost:7273';
    } else if (kReleaseMode) {
      // TODO: We will be specifying this when released.
      throw Exception("Release base Url is not specified!");
    } else {
      // TODO: We will be specifying this when testing environment is alive.
      throw Exception("Test base Url is not specified!");
    }
  }
}
