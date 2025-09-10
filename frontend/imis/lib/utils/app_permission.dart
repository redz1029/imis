class AppPermission {
  // Team
  static const String addTeam = 'AddTeam';
  static const String viewTeam = 'ViewTeam';
  static const String editTeam = 'EditTeam';
  static const List<String> teamPermissions = [addTeam, viewTeam, editTeam];

  // KRA
  static const String addKra = 'AddKra';
  static const String viewKra = 'ViewKra';
  static const String editKra = 'EditKra';
  static const List<String> kraPermissions = [addKra, viewKra, editKra];

  // Period
  static const String addPeriod = 'AddPeriod';
  static const String viewPeriod = 'ViewPeriod';
  static const String editPeriod = 'EditPeriod';
  static const List<String> periodPermissions = [
    addPeriod,
    viewPeriod,
    editPeriod,
  ];

  // Performance Governance System (PGS)
  static const String addPerformanceGovernanceSystem =
      'AddPerformanceGovernanceSystem';
  static const String viewPerformanceGovernanceSystem =
      'ViewPerformanceGovernanceSystem';
  static const String editPerformanceGovernanceSystem =
      'EditPerformanceGovernanceSystem';
  static const List<String> pgsPermissions = [
    addPerformanceGovernanceSystem,
    viewPerformanceGovernanceSystem,
    editPerformanceGovernanceSystem,
  ];

  // Deliverables
  static const String addPgsDeliverable = 'AddPgsDeliverable';
  static const String viewPgsDeliverable = 'ViewPgsDeliverable';
  static const String editPgsDeliverable = 'EditPgsDeliverable';
  static const String scorePgsDeliverable = 'ScorePgsDeliverable';
  static const List<String> pgsDeliverablePermissions = [
    addPgsDeliverable,
    viewPgsDeliverable,
    editPgsDeliverable,
    scorePgsDeliverable,
  ];

  // Deliverable Monitor
  static const String viewPgsDeliverableMonitor = 'ViewPgsDeliverableMonitor';
  static const String scorePgsDeliverableMonitor = 'ScorePgsDeliverableMonitor';
  static const List<String> deliverableMonitorPermissions = [
    viewPgsDeliverableMonitor,
    scorePgsDeliverableMonitor,
  ];

  // Deliverable Score History
  static const String viewPgsDeliverableScoreHistory =
      'ViewPgsDeliverableScoreHistory';
  static const String scorePgsDeliverableScoreHistory =
      'ScorePgsDeliverableScoreHistory';
  static const List<String> deliverableScoreHistoryPermissions = [
    viewPgsDeliverableScoreHistory,
    scorePgsDeliverableScoreHistory,
  ];

  // Signatory Template
  static const String addPgsSignatoryTemplate = 'AddPgsSignatoryTemplate';
  static const String viewPgsSignatoryTemplate = 'ViewPgsSignatoryTemplate';
  static const String editPgsSignatoryTemplate = 'EditPgsSignatoryTemplate';
  static const List<String> signatoryTemplatePermissions = [
    addPgsSignatoryTemplate,
    viewPgsSignatoryTemplate,
    editPgsSignatoryTemplate,
  ];

  // Office
  static const String addOffice = 'AddOffice';
  static const String viewOffice = 'ViewOffice';
  static const String editOffice = 'EditOffice';
  static const List<String> officePermissions = [
    addOffice,
    viewOffice,
    editOffice,
  ];

  // User Office
  static const String addUserOffice = 'AddUserOffice';
  static const String viewUserOffice = 'ViewUserOffice';
  static const String editUserOffice = 'EditUserOffice';
  static const List<String> userOfficePermissions = [
    addUserOffice,
    viewUserOffice,
    editUserOffice,
  ];

  // Audit Schedule
  static const String addAuditSchedule = 'AddAuditSchedule';
  static const String viewAuditSchedule = 'ViewAuditSchedule';
  static const String editAuditSchedule = 'EditAuditSchedule';
  static const List<String> auditSchedulePermissions = [
    addAuditSchedule,
    viewAuditSchedule,
    editAuditSchedule,
  ];

  // Auditor Team
  static const String addAuditorTeam = 'AddAuditorTeam';
  static const String viewAuditorTeam = 'ViewAuditorTeam';
  static const String editAuditorTeam = 'EditAuditorTeam';
  static const List<String> auditorTeamPermissions = [
    addAuditorTeam,
    viewAuditorTeam,
    editAuditorTeam,
  ];

  // Auditor
  static const String addAuditor = 'AddAuditor';
  static const String viewAuditor = 'ViewAuditor';
  static const String editAuditor = 'EditAuditor';
  static const List<String> auditorPermissions = [
    addAuditor,
    viewAuditor,
    editAuditor,
  ];

  static const List<String> allPermissions = [
    ...teamPermissions,
    ...kraPermissions,
    ...periodPermissions,
    ...pgsPermissions,
    ...pgsDeliverablePermissions,
    ...deliverableMonitorPermissions,
    ...deliverableScoreHistoryPermissions,
    ...signatoryTemplatePermissions,
    ...officePermissions,
    ...userOfficePermissions,
    ...auditorPermissions,
  ];
}

class RolePermissions {
  static const Map<String, List<String>> rolePermissionMap = {
    'Administrator': [
      // Team
      AppPermission.viewTeam,
      AppPermission.editTeam,

      // KRA
      AppPermission.addKra,
      AppPermission.viewKra,
      AppPermission.editKra,

      // Period
      AppPermission.addPeriod,
      AppPermission.viewPeriod,
      AppPermission.editPeriod,

      // PGS
      AppPermission.addPerformanceGovernanceSystem,
      AppPermission.viewPerformanceGovernanceSystem,
      AppPermission.editPerformanceGovernanceSystem,

      // Deliverables
      AppPermission.addPgsDeliverable,
      AppPermission.viewPgsDeliverable,
      AppPermission.editPgsDeliverable,
      AppPermission.scorePgsDeliverable,

      // Deliverable Monitor
      AppPermission.viewPgsDeliverableMonitor,

      // Deliverable Score History
      AppPermission.viewPgsDeliverableScoreHistory,
      AppPermission.scorePgsDeliverableScoreHistory,

      // Signatory Template
      AppPermission.addPgsSignatoryTemplate,
      AppPermission.viewPgsSignatoryTemplate,
      AppPermission.editPgsSignatoryTemplate,

      // Office
      AppPermission.addOffice,
      AppPermission.viewOffice,
      AppPermission.editOffice,

      // User Office
      AppPermission.addUserOffice,
      AppPermission.viewUserOffice,
      AppPermission.editUserOffice,

      // Audit
      AppPermission.addAuditSchedule,
      AppPermission.viewAuditSchedule,
      AppPermission.editAuditSchedule,
      AppPermission.addAuditorTeam,
      AppPermission.viewAuditorTeam,
      AppPermission.editAuditorTeam,
      AppPermission.addAuditor,
      AppPermission.viewAuditor,
      AppPermission.editAuditor,
    ],

    'Standard User': [AppPermission.viewPerformanceGovernanceSystem],

    'PGS Core Team': [AppPermission.viewPgsDeliverableMonitor],

    'Service Head': [
      AppPermission.viewPgsDeliverableMonitor,
      AppPermission.viewPerformanceGovernanceSystem,
    ],

    'PGS Auditor': [
      AppPermission.editPgsDeliverable,
      AppPermission.scorePgsDeliverable,
      AppPermission.viewPgsDeliverableMonitor,
      AppPermission.scorePgsDeliverableMonitor,
    ],

    'PGS Head': [AppPermission.viewPgsDeliverableMonitor],

    'MCC': [AppPermission.viewPgsDeliverableMonitor],

    'OSM': [
      AppPermission.scorePgsDeliverable,
      AppPermission.viewPgsDeliverableMonitor,
      AppPermission.viewPerformanceGovernanceSystem,
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
