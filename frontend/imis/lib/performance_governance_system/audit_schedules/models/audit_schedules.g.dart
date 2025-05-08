// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_schedules.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditSchedules _$AuditSchedulesFromJson(Map<String, dynamic> json) =>
    AuditSchedules(
      (json['id'] as num).toInt(),
      json['isDeleted'] as bool,
      json['rowVersion'] as String,
      json['auditTitle'] as String,
      const DateTimeConverter().fromJson(json['startDate'] as String),
      const DateTimeConverter().fromJson(json['endDate'] as String),
      json['isActive'] as bool,
      (json['offices'] as List<dynamic>)
          .map((e) => Office.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['auditableOffices'] as List<dynamic>)
          .map((e) => AuditableOffice.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['auditSchduleDetails'] as List<dynamic>)
          .map((e) => AuditScheduleDetails.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AuditSchedulesToJson(AuditSchedules instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isDeleted': instance.isDeleted,
      'rowVersion': instance.rowVersion,
      'auditTitle': instance.auditTitle,
      'startDate': const DateTimeConverter().toJson(instance.startDate),
      'endDate': const DateTimeConverter().toJson(instance.endDate),
      'isActive': instance.isActive,
      'offices': instance.offices,
      'auditableOffices': instance.auditableOffices,
      'auditSchduleDetails': instance.auditSchduleDetails,
    };
