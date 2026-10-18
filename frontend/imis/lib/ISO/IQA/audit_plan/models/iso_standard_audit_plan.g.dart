// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iso_standard_audit_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IsoStandardAuditPlan _$IsoStandardAuditPlanFromJson(
  Map<String, dynamic> json,
) => IsoStandardAuditPlan(
  id: (json['id'] as num?)?.toInt() ?? 0,
  isoStandardId: (json['isoStandardId'] as num?)?.toInt() ?? 0,
  auditPlanEntryId: (json['auditPlanEntryId'] as num?)?.toInt() ?? 0,
  isoStandard:
      json['isoStandard'] == null
          ? null
          : IsoStandard.fromJson(json['isoStandard'] as Map<String, dynamic>),
  auditPlanEntry:
      json['auditPlanEntry'] == null
          ? null
          : AuditPlanEntry.fromJson(
            json['auditPlanEntry'] as Map<String, dynamic>,
          ),
);

Map<String, dynamic> _$IsoStandardAuditPlanToJson(
  IsoStandardAuditPlan instance,
) => <String, dynamic>{
  'id': instance.id,
  'isoStandardId': instance.isoStandardId,
  'auditPlanEntryId': instance.auditPlanEntryId,
  'isoStandard': instance.isoStandard?.toJson(),
  'auditPlanEntry': instance.auditPlanEntry?.toJson(),
};
