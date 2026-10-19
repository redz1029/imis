import 'package:json_annotation/json_annotation.dart';

part 'audit_programme_objective.g.dart';

@JsonSerializable()
class AuditProgrammeObjective {
  int id;
  bool isDeleted;
  String rowVersion;
  int auditProgrammeId;
  int sortOrder;
  String description;

  AuditProgrammeObjective({
    this.id = 0,
    this.isDeleted = false,
    this.rowVersion = "",
    this.auditProgrammeId = 0,
    this.sortOrder = 0,
    this.description = "",
  });

  factory AuditProgrammeObjective.fromJson(Map<String, dynamic> json) =>
      _$AuditProgrammeObjectiveFromJson(json);

  Map<String, dynamic> toJson() => _$AuditProgrammeObjectiveToJson(this);
}