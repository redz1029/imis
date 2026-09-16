// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_plan_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditPlanStatus _$AuditPlanStatusFromJson(Map<String, dynamic> json) =>
    AuditPlanStatus(
      id: (json['id'] as num?)?.toInt() ?? 0,
      code: json['code'] as String,
      name: json['name'] as String,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      isActive: json['isActive'] as bool? ?? true,
      isDeleted: json['isDeleted'] as bool? ?? false,
      rowVersion: json['rowVersion'] as String?,
    );

Map<String, dynamic> _$AuditPlanStatusToJson(AuditPlanStatus instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'sortOrder': instance.sortOrder,
      'isActive': instance.isActive,
      'isDeleted': instance.isDeleted,
      'rowVersion': instance.rowVersion,
    };
