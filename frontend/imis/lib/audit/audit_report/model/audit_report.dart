import 'package:json_annotation/json_annotation.dart';

import 'package:imis/audit/audit_plan/models/audit_plan_entry.dart';
import 'audit_com_findings.dart';
import 'audit_scope.dart';
import 'audit_summary_findings.dart';

part 'audit_report.g.dart';

@JsonSerializable(explicitToJson: true)
class AuditReport {
  int id;
  bool? isDeleted;
  String? rowVersion;

  String auditPurpose;
  String auditConclusions;

  // Office/Process Audited
  int? officeAuditedId;
  String? officeAuditedName;

  // ISO Standard
  int? auditStandardISOId;
  String? auditStandardISOName;

  // Auditee (single reference — see the unresolved multi-auditee
  // question from earlier; unchanged here since it wasn't settled)
  int? auditeeId;
  String? auditeeName;

  // Links this report to the specific plan entry it was generated from —
  // Office/Process, Auditors and Standards for the plan side are fetched
  // through here, same as AuditChecklist does.
  int? auditPlanEntryId;
  AuditPlanEntry? auditPlanEntry;

  List<AuditComFindings>? auditComFindings;
  List<AuditScope>? auditScope;
  List<AuditSummaryFindings>? auditSummaryFindings;

  AuditReport({
    this.id = 0,
    this.isDeleted = false,
    this.rowVersion = "",
    required this.auditPurpose,
    required this.auditConclusions,
    this.officeAuditedId,
    this.officeAuditedName,
    this.auditStandardISOId,
    this.auditStandardISOName,
    this.auditeeId,
    this.auditeeName,
    this.auditPlanEntryId,
    this.auditPlanEntry,
    this.auditComFindings,
    this.auditScope,
    this.auditSummaryFindings,
  });

  factory AuditReport.fromJson(Map<String, dynamic> json) =>
      _$AuditReportFromJson(json);

  Map<String, dynamic> toJson() => _$AuditReportToJson(this);
}