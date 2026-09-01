import 'package:json_annotation/json_annotation.dart';
import 'package:imis/iso_standard/models/iso_standard.dart';

part 'iso_standard_audit_plan.g.dart';

@JsonSerializable(explicitToJson: true)
class IsoStandardAuditPlan {
  final int id;
  final int? isoStandardId;
  final IsoStandard? isoStandard;
  final int? auditPlanEntryId;

  IsoStandardAuditPlan({
    this.id = 0,
    this.isoStandardId,
    this.isoStandard,
    this.auditPlanEntryId,
  });

  factory IsoStandardAuditPlan.fromJson(Map<String, dynamic> json) =>
      _$IsoStandardAuditPlanFromJson(json);

  Map<String, dynamic> toJson() => _$IsoStandardAuditPlanToJson(this);
}