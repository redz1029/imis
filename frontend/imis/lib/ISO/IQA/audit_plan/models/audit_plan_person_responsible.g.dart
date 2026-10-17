// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_plan_person_responsible.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditPlanPersonResponsible _$AuditPlanPersonResponsibleFromJson(
  Map<String, dynamic> json,
) => AuditPlanPersonResponsible(
  id: (json['id'] as num?)?.toInt() ?? 0,
  name: json['name'] as String? ?? '',
  auditPlanEntryId: (json['auditPlanEntryId'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$AuditPlanPersonResponsibleToJson(
  AuditPlanPersonResponsible instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'auditPlanEntryId': instance.auditPlanEntryId,
};
