// lib/navigation/navigation_screen_factory.dart
import 'package:flutter/material.dart';
import 'package:imis/audit_schedules/pages/audit_schedules_page.dart';
import 'package:imis/auditor/pages/auditor_page.dart';
import 'package:imis/auditor_team/pages/auditor_team_page.dart';
import 'package:imis/office/pages/office_page.dart';
import 'package:imis/performance_governance_system/key_result_area/pages/key_result_area_page.dart';
import 'package:imis/performance_governance_system/pages/performance_governance_system_page.dart';
import 'package:imis/performance_governance_system/pgs_period/pages/pgs_period_page.dart';
import 'package:imis/performance_governance_system/pgs_signatory_template/pages/pgs_signatory_template_page.dart';
import 'package:imis/reports/pages/create_summary_narrative_report_page.dart';
import 'package:imis/reports/pages/manage_summary_narrative_report_page.dart';
import 'package:imis/reports/pages/pgs_report_page.dart';
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
      case 2:
        return PerformanceGovernanceSystemPage(key: roleKey);
      case 4:
        return AuditSchedulesPage(key: roleKey);
      case 5:
        return AuditorPage(key: roleKey);
      case 6:
        return AuditorTeamPage(key: roleKey);
      case 7:
        return KeyResultAreaPage(key: roleKey);
      case 8:
        return OfficePage(key: roleKey);
      case 9:
        return PgsSignatoryTemplatePage(key: roleKey);
      case 10:
        return PgsPeriodPage(key: roleKey);
      case 12:
        return RolesPage(key: roleKey);
      case 13:
        return TeamPage(key: roleKey);
      case 14:
        return UserProfilePage(key: roleKey);
      case 15:
        return UserOfficePage(key: roleKey);
      case 16:
        return UserRolePage(key: roleKey);
      case 17:
        return PgsReportPage(key: roleKey);
      case 18:
        return ManageSummaryNarrativeReportPage(key: roleKey);
      case 19:
        return ViewSummaryNarrativeReportPage(key: roleKey);
      case 20:
        return CreateSummaryNarrativeReportPage(key: roleKey, periodId: 0);
      case 22:
        return Container(key: roleKey);
      default:
        return HomePage();
    }
  }
}
