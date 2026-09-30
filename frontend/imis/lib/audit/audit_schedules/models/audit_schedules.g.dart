// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_schedules.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditSchedules _$AuditSchedulesFromJson(Map<String, dynamic> json) =>
    AuditSchedules(
      id: (json['id'] as num?)?.toInt() ?? 0,
      purpose: json['purpose'] as String? ?? '',
      activity: json['activity'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? true,
      rowVersion: json['rowVersion'] as String?,
      startDate: const DateTimeConverter().fromJson(
        json['startDate'] as String,
      ),
      endDate: const DateTimeConverter().fromJson(json['endDate'] as String),
      auditPlanId: (json['auditPlanId'] as num?)?.toInt() ?? 0,
      auditPlanEntryId: (json['auditPlanEntryId'] as num?)?.toInt() ?? 0,
      teamId: (json['teamId'] as num?)?.toInt(),
      statusCode: json['statusCode'] as String?,
      statusName: json['statusName'] as String?,
      signatories:
          json['signatories'] == null
              ? []
              : AuditSchedules._signatoriesFromJson(json['signatories']),
    );

Map<String, dynamic> _$AuditSchedulesToJson(AuditSchedules instance) =>
    <String, dynamic>{
      'id': instance.id,
      'purpose': instance.purpose,
      'activity': instance.activity,
      'isActive': instance.isActive,
      'rowVersion': instance.rowVersion,
      'startDate': const DateTimeConverter().toJson(instance.startDate),
      'endDate': const DateTimeConverter().toJson(instance.endDate),
      'auditPlanId': instance.auditPlanId,
      'auditPlanEntryId': instance.auditPlanEntryId,
      'teamId': instance.teamId,
      'statusCode': instance.statusCode,
      'statusName': instance.statusName,
    };
