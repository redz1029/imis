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
  late String signatoryTemplate;
  late String generatePdf;
  late String refresh;
  late String filterBy;
  late String pgsScoreMonitoring;
  late String pgsDeliverableScoreHistory;
  late String pgsDeliverableScoreHistoryGrouped;
  late String officetype;
  late String pgsSubmit;
  late String fetchPGSUserId;
  late String performancegovernancesystemFilter;
  late String disapprovePgs;
  late String pgsDeliverableHistory;
  late String pgsSaveAsDraft;
  late String auditorOffice;
  late String officePgsAuditor;
  late String rolesPermissions;
  late String summaryNarrative;
  late String pgsSummaryNarrativeListReport;
  late String pgsDeliverableAccomplishment;
  late String downloadFile;
  late String announcement;
  late String announcementActive;
  late String summaryNarrativeAuditorHead;
  late String deletePgs;
  late String breakThroughScoring;
  late String swotAnalysis;
  late String kraRoadMapPeriod;
  late String kraRoadMap;
  late String kraRoadMapRoleId;
  late String kraRoadMapReport;
  late String kraRoadmapRole;
  late String standardVersion;
  late String scorecardMonitoringFilter;
  late String kraroadmapAccomplishment;
  ApiEndpoint() {
    login = '$baseUrl/login';
    register = '$baseUrl/register';
    changepassword = '$baseUrl/changePassword';
    keyresult = '$baseUrl/KeyResultArea';
    auditor = '$baseUrl/auditors';
    pgsperiod = '$baseUrl/PgsPeriod';
    deliverables = '$baseUrl/deliverables';
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
    signatoryTemplate = '$baseUrl/pgsSignatoryTemplate';
    pgsSaveAsDraft = "$baseUrl/pgs/draft";
    generatePdf = '$baseUrl/pgs/list-report/pdf';
    refresh = '$baseUrl/refresh';
    filterBy = '$baseUrl/deliverables/filter';
    pgsScoreMonitoring = '$baseUrl/deliverables/filter/update';
    pgsDeliverableScoreHistory = '$baseUrl/pgsDeliverableScoreHistory';
    pgsDeliverableScoreHistoryGrouped =
        '$baseUrl/pgsDeliverableScoreHistory/grouped';
    officetype = '$baseUrl/officetype';
    pgsSubmit = '$baseUrl/pgs/submit';
    fetchPGSUserId = '$baseUrl/pgs/submit/userId';
    performancegovernancesystemFilter = '$baseUrl/pgs/filter';
    disapprovePgs = '$baseUrl/pgs/disapprove';
    pgsDeliverableHistory = '$baseUrl/pgsDeliverableHistory';
    auditorOffice = '$baseUrl/auditorsOffices';
    officePgsAuditor = '$baseUrl/office/pgs-auditor';
    rolesPermissions = '$baseUrl/roles/permissions';
    summaryNarrative = '$baseUrl/pgsSummaryNarrative';
    pgsSummaryNarrativeListReport =
        '$baseUrl/pgsSummaryNarrative/list-report/pdf';
    pgsDeliverableAccomplishment = '$baseUrl/pgsDeliverableAccomplishment';
    downloadFile = '$baseUrl/download';
    announcement = '$baseUrl/announcement';
    announcementActive = '$baseUrl/announcement/Active';
    summaryNarrativeAuditorHead = '$baseUrl/pgsSummaryNarrativeAuditorHead';
    deletePgs = '$baseUrl/pgs/deliverable';
    breakThroughScoring = '$baseUrl/BreakThroughScoring';
    swotAnalysis = '$baseUrl/swotAnalysis';
    kraRoadMapPeriod = '$baseUrl/kraRoadMapPeriod';
    kraRoadMap = '$baseUrl/kraRoadMap';
    kraRoadMapRoleId = '$baseUrl/KRARoadmapRole/roleid';
    kraRoadMapReport = '$baseUrl/kraRoadMap/list-report/pdf';
    kraRoadmapRole = '$baseUrl/kraRoadmapRole/roleid';
    standardVersion = '$baseUrl/api/standardVersion';
    scorecardMonitoringFilter = '$baseUrl/kraRoadMap/filter';
    kraroadmapAccomplishment = '$baseUrl/kraRoadmapAccomplishment';
  }
  static Future<void> setBaseUrl() async {
    if (kDebugMode) {
      baseUrl = 'https://localhost:7273';
    } else if (kReleaseMode) {
      baseUrl = 'https://api.cpems.crmc.ph';
    } else {
      throw Exception("Test base Url is not specified!");
    }
  }
}
