// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditPlan _$AuditPlanFromJson(Map<String, dynamic> json) => AuditPlan(
  id: (json['id'] as num?)?.toInt() ?? 0,
  isDeleted: json['isDeleted'] as bool? ?? false,
  rowVersion: json['rowVersion'] as String?,
  auditProgrammeId: (json['auditProgrammeId'] as num?)?.toInt() ?? 0,
  planStatus: json['planStatus'] as String? ?? "Draft",
  startDate: _$JsonConverterFromJson<String, DateTime>(
    json['startDate'],
    const DateTimeConverter().fromJson,
  ),
  endDate: _$JsonConverterFromJson<String, DateTime>(
    json['endDate'],
    const DateTimeConverter().fromJson,
  ),
  entries: (json['entries'] as List<dynamic>?)
      ?.map((e) => AuditPlanEntry.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$AuditPlanToJson(AuditPlan instance) => <String, dynamic>{
  'id': instance.id,
  'isDeleted': instance.isDeleted,
  'rowVersion': ?instance.rowVersion,
  'auditProgrammeId': instance.auditProgrammeId,
  'planStatus': instance.planStatus,
  'startDate': const DateTimeConverter().toJson(instance.startDate),
  'endDate': const DateTimeConverter().toJson(instance.endDate),
  'entries': instance.entries.map((e) => e.toJson()).toList(),
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);
