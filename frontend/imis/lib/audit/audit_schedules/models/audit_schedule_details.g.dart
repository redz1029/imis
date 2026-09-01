// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_schedule_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditScheduleDetails _$AuditScheduleDetailsFromJson(
  Map<String, dynamic> json,
) => AuditScheduleDetails(
  id: (json['id'] as num).toInt(),
  auditPlanEntryId: (json['auditPlanEntryId'] as num).toInt(),
  auditScheduleId: (json['auditScheduleId'] as num).toInt(),
  isDeleted: json['isDeleted'] as bool,
  rowVersion: json['rowVersion'] as String?,
);

Map<String, dynamic> _$AuditScheduleDetailsToJson(
  AuditScheduleDetails instance,
) => <String, dynamic>{
  'id': instance.id,
  'auditPlanEntryId': instance.auditPlanEntryId,
  'auditScheduleId': instance.auditScheduleId,
  'isDeleted': instance.isDeleted,
  'rowVersion': instance.rowVersion,
};
