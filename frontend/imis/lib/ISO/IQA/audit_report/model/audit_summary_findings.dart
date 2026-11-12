import 'package:json_annotation/json_annotation.dart';

part 'audit_summary_findings.g.dart';

@JsonSerializable(explicitToJson: true)
class AuditSummaryFindings {
  @JsonKey(defaultValue: 0)
  int id;
  bool? isDeleted;
  String? rowVersion;

  int no;
  String findings;
  int? auditNcarStatusId;

  /// The audit checklist row a fetched line was raised from; null on a line
  /// the auditor added by hand.
  int? auditChecklistId;

  /// The criteria as printed (the clause). Null on lines saved before the
  /// Summary of Findings became editable.
  String? criteriaText;

  /// Reference number of the NCAR raised for a fetched line.
  String? ncarReferenceNumber;

  AuditSummaryFindings({
    this.id = 0,
    this.isDeleted = false,
    this.rowVersion = "",
    required this.no,
    required this.findings,
    this.auditNcarStatusId,
    this.auditChecklistId,
    this.criteriaText,
    this.ncarReferenceNumber,
  });

  factory AuditSummaryFindings.fromJson(Map<String, dynamic> json) =>
      _$AuditSummaryFindingsFromJson(json);

  Map<String, dynamic> toJson() => _$AuditSummaryFindingsToJson(this);
}
