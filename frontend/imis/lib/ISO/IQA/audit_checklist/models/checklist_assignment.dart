/// Clause assignment board of one audit schedule's checklist: which auditor of
/// the team answers which clause of the audit plan entry. For an auditor it
/// only holds their own clauses and [canAssign] is false.
class ChecklistAssignments {
  final int auditScheduleId;
  final int? teamId;
  final String? teamName;
  final bool canAssign;

  /// True for an auditor of the team: they only see and answer their own clauses.
  final bool ownClausesOnly;
  final List<ChecklistClauseAssignment> clauses;
  final List<ChecklistAuditor> auditors;

  const ChecklistAssignments({
    required this.auditScheduleId,
    this.teamId,
    this.teamName,
    this.canAssign = false,
    this.ownClausesOnly = false,
    this.clauses = const [],
    this.auditors = const [],
  });

  factory ChecklistAssignments.fromJson(Map<String, dynamic> json) {
    List<T> list<T>(dynamic raw, T Function(Map<String, dynamic>) map) =>
        (raw as List? ?? [])
            .map((e) => map(Map<String, dynamic>.from(e as Map)))
            .toList();

    return ChecklistAssignments(
      auditScheduleId: (json['auditScheduleId'] as num?)?.toInt() ?? 0,
      teamId: (json['teamId'] as num?)?.toInt(),
      teamName: json['teamName'] as String?,
      canAssign: json['canAssign'] == true,
      ownClausesOnly: json['ownClausesOnly'] == true,
      clauses: list(json['clauses'], ChecklistClauseAssignment.fromJson),
      auditors: list(json['auditors'], ChecklistAuditor.fromJson),
    );
  }
}

class ChecklistClauseAssignment {
  final int isoStandardId;
  final String clauseRef;
  final String? particulars;
  final int? assignedAuditorId;
  final String? assignedAuditorName;
  final int questionCount;
  final int answeredCount;

  const ChecklistClauseAssignment({
    required this.isoStandardId,
    required this.clauseRef,
    this.particulars,
    this.assignedAuditorId,
    this.assignedAuditorName,
    this.questionCount = 0,
    this.answeredCount = 0,
  });

  factory ChecklistClauseAssignment.fromJson(Map<String, dynamic> json) =>
      ChecklistClauseAssignment(
        isoStandardId: (json['isoStandardId'] as num?)?.toInt() ?? 0,
        clauseRef: (json['clauseRef'] as String?) ?? '',
        particulars: json['particulars'] as String?,
        assignedAuditorId: (json['assignedAuditorId'] as num?)?.toInt(),
        assignedAuditorName: json['assignedAuditorName'] as String?,
        questionCount: (json['questionCount'] as num?)?.toInt() ?? 0,
        answeredCount: (json['answeredCount'] as num?)?.toInt() ?? 0,
      );
}

class ChecklistAuditor {
  final int auditorId;
  final String name;
  final bool isTeamLeader;
  final int assignedClauseCount;
  final int questionCount;
  final int answeredCount;

  const ChecklistAuditor({
    required this.auditorId,
    required this.name,
    this.isTeamLeader = false,
    this.assignedClauseCount = 0,
    this.questionCount = 0,
    this.answeredCount = 0,
  });

  factory ChecklistAuditor.fromJson(Map<String, dynamic> json) =>
      ChecklistAuditor(
        auditorId: (json['auditorId'] as num?)?.toInt() ?? 0,
        name: (json['name'] as String?) ?? '',
        isTeamLeader: json['isTeamLeader'] == true,
        assignedClauseCount: (json['assignedClauseCount'] as num?)?.toInt() ?? 0,
        questionCount: (json['questionCount'] as num?)?.toInt() ?? 0,
        answeredCount: (json['answeredCount'] as num?)?.toInt() ?? 0,
      );
}
