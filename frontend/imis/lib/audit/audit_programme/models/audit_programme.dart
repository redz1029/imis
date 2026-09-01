import 'package:json_annotation/json_annotation.dart';
import 'audit_programme_objective.dart';
import 'package:imis/audit/audit_plan/models/audit_plan.dart';

part 'audit_programme.g.dart';

@JsonSerializable(explicitToJson: true)
class AuditProgramme {
  @JsonKey(defaultValue: 0)
  int id;

  @JsonKey(defaultValue: false)
  bool isDeleted;

  @JsonKey(defaultValue: '')
  String rowVersion;

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

  AuditProgramme({
    this.id = 0,
    this.isDeleted = false,
    this.rowVersion = "",
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
  });

  factory AuditProgramme.fromJson(Map<String, dynamic> json) =>
      _$AuditProgrammeFromJson(json);

  get forField => null;

  Map<String, dynamic> toJson() => _$AuditProgrammeToJson(this);
}