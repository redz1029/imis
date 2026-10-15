import 'package:json_annotation/json_annotation.dart';

part 'audit_plan_person_responsible.g.dart';

@JsonSerializable(explicitToJson: true)
class AuditPlanPersonResponsible {
  @JsonKey(defaultValue: 0)
  final int id;

  @JsonKey(defaultValue: '')
  final String name;

  @JsonKey(defaultValue: 0)
  final int auditPlanEntryId;

  AuditPlanPersonResponsible({
    this.id = 0,
    this.name = '',
    this.auditPlanEntryId = 0,
  });

  factory AuditPlanPersonResponsible.fromJson(Map<String, dynamic> json) =>
      _$AuditPlanPersonResponsibleFromJson(json);

  Map<String, dynamic> toJson() => _$AuditPlanPersonResponsibleToJson(this);
}