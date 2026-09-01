import 'package:imis/audit/audit_plan/models/audit_plan.dart';
import 'package:imis/utils/date_time_converter.dart';
import 'package:json_annotation/json_annotation.dart';

// FIX: Import the real AuditPlanProcess model (the one with processName)
// instead of relying on the stale duplicate class that used to be declared
// further down in this same file. It lives right in this same folder.
import 'audit_plan_process.dart';

part 'audit_plan_entry.g.dart';

@JsonSerializable(explicitToJson: true)
class AuditPlanEntry {
  int id;
  bool isDeleted;
  String rowVersion;

  int auditPlanId;
  AuditPlan? auditPlan;

  int dayNumber;

  @DateTimeConverter()
  DateTime time;

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

// Nested Models
@JsonSerializable()
class IsoAuditProcess {
  int id;
  String? name;
  bool? isActive;

  IsoAuditProcess({this.id = 0, this.name, this.isActive});

  factory IsoAuditProcess.fromJson(Map<String, dynamic> json) =>
      _$IsoAuditProcessFromJson(json);

  Map<String, dynamic> toJson() => _$IsoAuditProcessToJson(this);
}

@JsonSerializable()
class AuditPlanPersonResponsible {
  int id;
  int? auditPlanEntryId;
  String? personResponsibleId;

  AuditPlanPersonResponsible({
    this.id = 0,
    this.auditPlanEntryId,
    this.personResponsibleId,
  });

  factory AuditPlanPersonResponsible.fromJson(Map<String, dynamic> json) =>
      _$AuditPlanPersonResponsibleFromJson(json);

  get name => null;

  Map<String, dynamic> toJson() => _$AuditPlanPersonResponsibleToJson(this);
}

@JsonSerializable()
class IsoAuditor {
  int id;
  int? teamId;
  String? auditorId;

  IsoAuditor({this.id = 0, this.teamId, this.auditorId});

  factory IsoAuditor.fromJson(Map<String, dynamic> json) =>
      _$IsoAuditorFromJson(json);

  Map<String, dynamic> toJson() => _$IsoAuditorToJson(this);
}

@JsonSerializable()
class IsoStandardAuditPlan {
  int id;
  int? isoStandardId;

  IsoStandardAuditPlan({this.id = 0, this.isoStandardId});

  factory IsoStandardAuditPlan.fromJson(Map<String, dynamic> json) =>
      _$IsoStandardAuditPlanFromJson(json);

  Map<String, dynamic> toJson() => _$IsoStandardAuditPlanToJson(this);
}

// REMOVED: the stale local `class AuditPlanProcess { int id; int? officeId; }`
// that used to be declared here. It shadowed the real, correct
// AuditPlanProcess (with officeId + processName) imported above, which is
// exactly why processName was being silently dropped on every save.