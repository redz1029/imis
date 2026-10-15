import 'package:imis/audit/audit_plan/models/audit_plan.dart';
import 'package:imis/utils/date_time_converter.dart';
import 'package:json_annotation/json_annotation.dart';

import 'audit_plan_process.dart';
import 'audit_plan_person_responsible.dart';
import 'iso_auditor.dart';
import 'iso_standard_audit_plan.dart';

part 'audit_plan_entry.g.dart';

@JsonSerializable(explicitToJson: true)
class AuditPlanEntry {
  int id;
  bool? isDeleted;
  String? rowVersion;

  int auditPlanId;
  AuditPlan? auditPlan;

  int dayNumber;

  @DateTimeConverter()
  DateTime time;

  // Must be present for entry.standardText to compile.
  String? standardText;

  List<IsoAuditProcess>? isoAuditProcesses;
  List<AuditPlanPersonResponsible>? responsiblePersons;
  List<IsoAuditor>? isoAuditors;
  List<IsoStandardAuditPlan>? isoStandardAuditPlans;
  List<AuditPlanProcess>? auditPlanProcesses;

  AuditPlanEntry({
    this.id = 0,
    this.isDeleted = false,
    this.rowVersion = "",
    required this.auditPlanId,
    this.auditPlan,
    required this.dayNumber,
    required this.time,
    this.standardText,
    this.isoAuditProcesses,
    this.responsiblePersons,
    this.isoAuditors,
    this.isoStandardAuditPlans,
    this.auditPlanProcesses,
  });

  factory AuditPlanEntry.fromJson(Map<String, dynamic> json) =>
      _$AuditPlanEntryFromJson(json);

  Map<String, dynamic> toJson() => _$AuditPlanEntryToJson(this);
}

@JsonSerializable()
class IsoAuditProcess {
  @JsonKey(defaultValue: 0)
  int id;
  String? name;
  bool? isActive;

  IsoAuditProcess({this.id = 0, this.name, this.isActive});

  factory IsoAuditProcess.fromJson(Map<String, dynamic> json) =>
      _$IsoAuditProcessFromJson(json);

  Map<String, dynamic> toJson() => _$IsoAuditProcessToJson(this);
}