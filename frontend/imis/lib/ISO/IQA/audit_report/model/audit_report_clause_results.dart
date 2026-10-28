/// Every clause result of one audit schedule's checklist (conforming and
/// non-conforming), listed in the Audit Report of the audited office.
class AuditReportClauseResults {
  final int auditScheduleId;
  final int conformingCount;
  final int nonConformingCount;
  final int pendingCount;
  final List<AuditReportClauseResult> items;

  const AuditReportClauseResults({
    required this.auditScheduleId,
    this.conformingCount = 0,
    this.nonConformingCount = 0,
    this.pendingCount = 0,
    this.items = const [],
  });

  factory AuditReportClauseResults.fromJson(Map<String, dynamic> json) =>
      AuditReportClauseResults(
        auditScheduleId: (json['auditScheduleId'] as num?)?.toInt() ?? 0,
        conformingCount: (json['conformingCount'] as num?)?.toInt() ?? 0,
        nonConformingCount: (json['nonConformingCount'] as num?)?.toInt() ?? 0,
        pendingCount: (json['pendingCount'] as num?)?.toInt() ?? 0,
        items: (json['items'] as List? ?? [])
            .map(
              (e) => AuditReportClauseResult.fromJson(
                Map<String, dynamic>.from(e as Map),
              ),
            )
            .toList(),
      );
}

class AuditReportClauseResult {
  final int auditChecklistId;
  final String clauseRef;
  final String question;

  /// true = conforming, false = non-conforming, null = not answered yet.
  final bool? conforming;
  final String? findingAndRemarks;

  /// The NCAR raised for a non-conforming clause.
  final int? ncarId;
  final String? ncarReferenceNumber;
  final String? ncarStatus;

  const AuditReportClauseResult({
    required this.auditChecklistId,
    required this.clauseRef,
    required this.question,
    this.conforming,
    this.findingAndRemarks,
    this.ncarId,
    this.ncarReferenceNumber,
    this.ncarStatus,
  });

  factory AuditReportClauseResult.fromJson(Map<String, dynamic> json) =>
      AuditReportClauseResult(
        auditChecklistId: (json['auditChecklistId'] as num?)?.toInt() ?? 0,
        clauseRef: (json['clauseRef'] as String?) ?? '',
        question: (json['question'] as String?) ?? '',
        conforming: json['conforming'] as bool?,
        findingAndRemarks: json['findingAndRemarks'] as String?,
        ncarId: (json['ncarId'] as num?)?.toInt(),
        ncarReferenceNumber: json['ncarReferenceNumber'] as String?,
        ncarStatus: json['ncarStatus'] as String?,
      );
}
