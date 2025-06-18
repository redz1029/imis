class AppPermission {
  static const String viewPgsDeliverableMonitor = 'ViewPgsDeliverableMonitor';
  static const String scorePgsDeliverableMonitor = 'ScorePgsDeliverableMonitor';
  static const String addTeam = 'AddTeam';
  static const String viewTeam = 'ViewTeam';

  static const String viewSettings = 'viewSettings';
  static const String scorePgsDeliverable = 'ScorePgs Deliverable';
  static const String editTeam = 'EditTeam';
  static const String addPerformanceGovernanceSystem =
      'AddPerformanceGovernanceSystem';
  static const String viewPerformanceGovernanceSystem =
      'ViewPerformanceGovernanceSystem';
  static const String editPerformanceGovernanceSystem =
      '  EditPerformanceGovernanceSystem';
}

class RolePermissions {
  static const Map<String, List<String>> rolePermissionMap = {
    'Administrator': [
      AppPermission.editTeam,
      AppPermission.viewPerformanceGovernanceSystem,
      AppPermission.scorePgsDeliverable,
    ],

    'Pgs Auditor': [AppPermission.scorePgsDeliverable],
    'Standard User': [AppPermission.viewPerformanceGovernanceSystem],

    'Pgs Manager': [
      AppPermission.viewPerformanceGovernanceSystem,
      AppPermission.editPerformanceGovernanceSystem,
      AppPermission.addPerformanceGovernanceSystem,
    ],
  };

  static List<String> getPermissionsForRoles(List<String> roles) {
    final permissions = <String>[];
    for (final role in roles) {
      if (rolePermissionMap.containsKey(role)) {
        permissions.addAll(rolePermissionMap[role]!);
      }
    }
    return permissions.toSet().toList();
  }
}
