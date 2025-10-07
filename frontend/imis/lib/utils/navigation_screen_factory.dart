// lib/navigation/navigation_screen_factory.dart
import 'package:flutter/material.dart';
import 'package:imis/audit_schedules/pages/audit_schedules_page.dart';
import 'package:imis/auditor/pages/auditor_page.dart';
import 'package:imis/auditor_team/pages/auditor_team_page.dart';
import 'package:imis/office/pages/office_page.dart';
import 'package:imis/performance_governance_system/deliverable_status_monitoring/pages/deliverable_status_monitoring_page.dart';
import 'package:imis/performance_governance_system/key_result_area/pages/key_result_area_page.dart';
import 'package:imis/performance_governance_system/pages/performance_governance_system_page.dart';
import 'package:imis/performance_governance_system/pgs_period/pages/pgs_period_page.dart';
import 'package:imis/performance_governance_system/pgs_signatory_template/pages/pgs_signatory_template_page.dart';
import 'package:imis/reports/pages/manage_summary_narrative_report_page.dart';
import 'package:imis/reports/pages/view_summary_narrative_report_page.dart';
import 'package:imis/roles/pages/roles_page.dart';
import 'package:imis/team/pages/team_page.dart';
import 'package:imis/user/pages/home_page.dart';
import 'package:imis/user/pages/user_office_page.dart';
import 'package:imis/user/pages/user_profile_page.dart';
import 'package:imis/user/pages/user_role_page.dart';

class NavigationScreenFactory {
  static Widget getScreenByIndex(int index, String selectedRole) {
    final roleKey = ValueKey(selectedRole);
    switch (index) {
      case 0:
        return HomePage();

      case 1:
        return PerformanceGovernanceSystemPage(key: roleKey);
      case 2:
        return AuditSchedulesPage(key: roleKey);
      case 3:
        return AuditorPage(key: roleKey);
      case 4:
        return AuditorTeamPage(key: roleKey);
      case 5:
        return KeyResultAreaPage(key: roleKey);
      case 6:
        return OfficePage(key: roleKey);
      case 7:
        return PgsSignatoryTemplatePage(key: roleKey);
      case 8:
        return PgsPeriodPage(key: roleKey);
      case 9:
        return RolesPage(key: roleKey);
      case 10:
        return TeamPage(key: roleKey);
      case 11:
        return UserProfilePage(key: roleKey);
      case 12:
        return UserOfficePage(key: roleKey);
      case 13:
        return UserRolePage(key: roleKey);
      case 14:
        return ManageSummaryNarrativeReportPage(key: roleKey);
      case 15:
        return ViewSummaryNarrativeReportPage(key: roleKey);
      case 16:
        return DeliverableStatusMonitoringPage(key: roleKey);
      case 17:
        return Container(key: roleKey);
      default:
        return HomePage();
    }
  }
}
