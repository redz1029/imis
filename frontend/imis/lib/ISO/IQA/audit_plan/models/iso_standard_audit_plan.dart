import 'package:json_annotation/json_annotation.dart';
import 'package:imis/audit/iso_standard/models/iso_standard.dart';
import 'package:imis/audit/audit_plan/models/audit_plan_entry.dart'; // Adjust path if needed

part 'iso_standard_audit_plan.g.dart';

@JsonSerializable(explicitToJson: true)
class IsoStandardAuditPlan {
  @JsonKey(defaultValue: 0)
  final int id;

  @JsonKey(defaultValue: 0)
  final int isoStandardId;

  @JsonKey(defaultValue: 0)
  final int auditPlanEntryId;

  final IsoStandard? isoStandard;
  final AuditPlanEntry? auditPlanEntry;

  IsoStandardAuditPlan({
    this.id = 0,
    this.isoStandardId = 0,
    this.auditPlanEntryId = 0,
    this.isoStandard,
    this.auditPlanEntry,
  });

  factory IsoStandardAuditPlan.fromJson(Map<String, dynamic> json) =>
      _$IsoStandardAuditPlanFromJson(json);

  Map<String, dynamic> toJson() => _$IsoStandardAuditPlanToJson(this);
}