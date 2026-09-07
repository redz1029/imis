// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditPlan _$AuditPlanFromJson(Map<String, dynamic> json) => AuditPlan(
  id: (json['id'] as num).toInt(),
  isDeleted: json['isDeleted'] as bool,
  rowVersion: json['rowVersion'] as String?,
  auditProgrammeId: (json['auditProgrammeId'] as num).toInt(),
  planStatus: json['planStatus'] as String,
  startDate: const DateTimeConverter().fromJson(json['startDate'] as String),
  endDate: const DateTimeConverter().fromJson(json['endDate'] as String),
  entries:
      (json['entries'] as List<dynamic>)
          .map((e) => AuditPlanEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$AuditPlanToJson(AuditPlan instance) => <String, dynamic>{
  'id': instance.id,
  'isDeleted': instance.isDeleted,
  'rowVersion': instance.rowVersion,
  'auditProgrammeId': instance.auditProgrammeId,
  'planStatus': instance.planStatus,
  'startDate': const DateTimeConverter().toJson(instance.startDate),
  'endDate': const DateTimeConverter().toJson(instance.endDate),
  'entries': instance.entries,
};
