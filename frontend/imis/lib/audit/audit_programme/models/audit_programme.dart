import 'package:json_annotation/json_annotation.dart';
import 'audit_programme_objective.dart';
import 'package:imis/audit/audit_plan/models/audit_plan.dart';
import 'package:imis/audit/iqa_signatory/model/iqa_approval_history.dart';
import 'package:imis/audit/iqa_signatory/model/iqa_signatory.dart';

part 'audit_programme.g.dart';

@JsonSerializable(explicitToJson: true)
class AuditProgramme {
  @JsonKey(defaultValue: 0)
  int id;

  @JsonKey(defaultValue: false)
  bool isDeleted;

  @JsonKey(defaultValue: '')
  String rowVersion;

  // Status is server-authoritative — only the approval flow changes it.
  @JsonKey(defaultValue: 1)
  int auditStatusId;

  String? statusCode;
  String? statusName;

  @JsonKey(defaultValue: 0)
  int year;

  @JsonKey(name: 'for', defaultValue: '')
  String forUser;

  @JsonKey(name: 'from', defaultValue: '')
  String fromUser;

  @JsonKey(defaultValue: '')
  String purpose;

  @JsonKey(defaultValue: [])
  List<AuditProgrammeObjective> objectives;

  @JsonKey(defaultValue: '')
  String scopeAndFreqAudit;

  @JsonKey(defaultValue: '')
  String internalAuditSched;

  @JsonKey(defaultValue: '')
  String auditPlanObjective;

  @JsonKey(defaultValue: '')
  String scopeOfAudit;

  @JsonKey(defaultValue: '')
  String auditCriteria;

  @JsonKey(defaultValue: '')
  String auditMethodology;

  @JsonKey(defaultValue: '')
  String selectionAndEvaluationOfAuditors;

  @JsonKey(defaultValue: '')
  String reporting;

  @JsonKey(defaultValue: '')
  String verificationOfPreviousNonconformities;

  @JsonKey(defaultValue: '')
  String auditLimitations;

  @JsonKey(name: 'auditPlan', defaultValue: [])
  List<AuditPlan> auditPlans;

  @JsonKey(includeFromJson: false, includeToJson: false)
  List<IQASignatory> signatories;

  @JsonKey(includeFromJson: false, includeToJson: false)
  List<IQAApprovalHistory> approvalHistory;

  @JsonKey(includeFromJson: false, includeToJson: false)
  RejectionDetails? latestRejection;

  AuditProgramme({
    this.id = 0,
    this.isDeleted = false,
    this.rowVersion = "",
    this.auditStatusId = 1,
    this.statusCode,
    this.statusName,
    this.year = 0,
    this.forUser = "",
    this.fromUser = "",
    this.purpose = "",
    this.objectives = const [],
    this.scopeAndFreqAudit = "",
    this.internalAuditSched = "",
    this.auditPlanObjective = "",
    this.scopeOfAudit = "",
    this.auditCriteria = "",
    this.auditMethodology = "",
    this.selectionAndEvaluationOfAuditors = "",
    this.reporting = "",
    this.verificationOfPreviousNonconformities = "",
    this.auditLimitations = "",
    this.auditPlans = const [],
    this.signatories = const [],
    this.approvalHistory = const [],
    this.latestRejection,
  });

  factory AuditProgramme.fromJson(Map<String, dynamic> json) {
    final prog = _$AuditProgrammeFromJson(json);
    prog.signatories = IQASignatory.listFromJson(
      json['signatories'] ?? json['Signatories'],
    );
    prog.approvalHistory = IQAApprovalHistory.listFromJson(
      json['approvalHistory'] ?? json['ApprovalHistory'],
    );
    final rejRaw = json['latestRejection'] ?? json['LatestRejection'];
    if (rejRaw is Map<String, dynamic>) {
      prog.latestRejection = RejectionDetails.fromJson(rejRaw);
    } else if (rejRaw is Map) {
      prog.latestRejection =
          RejectionDetails.fromJson(Map<String, dynamic>.from(rejRaw));
    }
    return prog;
  }

  get forField => null;

  Map<String, dynamic> toJson() => _$AuditProgrammeToJson(this);

  /// Falls back to "Draft" while a record has no resolved status name.
  String get effectiveStatusName => statusName ?? 'Draft';
}