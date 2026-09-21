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

  AuditSummaryFindings({
    this.id = 0,
    this.isDeleted = false,
    this.rowVersion = "",
    required this.no,
    required this.findings,
  });

  factory AuditSummaryFindings.fromJson(Map<String, dynamic> json) =>
      _$AuditSummaryFindingsFromJson(json);

  Map<String, dynamic> toJson() => _$AuditSummaryFindingsToJson(this);
}