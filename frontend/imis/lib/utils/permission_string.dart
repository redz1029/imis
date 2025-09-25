class PermissionString {
  static const String roleAdmin = 'Administrator';
  static const String roleStandardUser = 'Standard User';
  static const String pgsAuditor = 'PGS Auditor';
  static const String pgsHead = 'PGS Auditor';
  static const String serviceHead = 'Service Head';
  static const String mcc = 'MCC';
  static const String osm = 'OSM';
  static const String coreTeam = 'PGS Core Team';
  static const String headAuditor = 'PGS Auditor Head';
  // Team
  static const String addTeam = 'AddTeam';
  static const String viewTeam = 'ViewTeam';
  static const String editTeam = 'EditTeam';

  // KRA
  static const String addKra = 'AddKra';
  static const String viewKra = 'ViewKra';
  static const String editKra = 'EditKra';

  // Period
  static const String addPeriod = 'AddPeriod';
  static const String viewPeriod = 'ViewPeriod';
  static const String editPeriod = 'EditPeriod';

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

  // Deliverable Monitor
  static const String viewPgsDeliverableMonitor = 'ViewPgsDeliverableMonitor';
  static const String scorePgsDeliverableMonitor = 'ScorePgsDeliverableMonitor';

  // Deliverable Score History
  static const String viewPgsDeliverableScoreHistory =
      'ViewPgsDeliverableScoreHistory';
  static const String scorePgsDeliverableScoreHistory =
      'ScorePgsDeliverableScoreHistory';

  // Signatory Template
  static const String addPgsSignatoryTemplate = 'AddPgsSignatoryTemplate';
  static const String viewPgsSignatoryTemplate = 'ViewPgsSignatoryTemplate';
  static const String editPgsSignatoryTemplate = 'EditPgsSignatoryTemplate';

  // Office
  static const String addOffice = 'AddOffice';
  static const String viewOffice = 'ViewOffice';
  static const String editOffice = 'EditOffice';

  // User Office
  static const String addUserOffice = 'AddUserOffice';
  static const String viewUserOffice = 'ViewUserOffice';
  static const String editUserOffice = 'EditUserOffice';

  // Audit Schedule
  static const String addAuditSchedule = 'AddAuditSchedule';
  static const String viewAuditSchedule = 'ViewAuditSchedule';
  static const String editAuditSchedule = 'EditAuditSchedule';

  // Auditor Team
  static const String addAuditorTeam = 'AddAuditorTeam';
  static const String viewAuditorTeam = 'ViewAuditorTeam';
  static const String editAuditorTeam = 'EditAuditorTeam';

  // Auditor
  static const String addAuditor = 'AddAuditor';
  static const String viewAuditor = 'ViewAuditor';
  static const String editAuditor = 'EditAuditor';
}
