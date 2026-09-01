// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_schedules.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditSchedules _$AuditSchedulesFromJson(
  Map<String, dynamic> json,
) => AuditSchedules(
  id: (json['id'] as num).toInt(),
  purpose: json['purpose'] as String,
  auditTitle: json['auditTitle'] as String,
  startDate: const DateTimeConverter().fromJson(json['startDate'] as String),
  endDate: const DateTimeConverter().fromJson(json['endDate'] as String),
  isActive: json['isActive'] as bool,
  isDeleted: json['isDeleted'] as bool,
  rowVersion: json['rowVersion'] as String?,
  auditPlanId: (json['auditPlanId'] as num).toInt(),
  auditorTeams: json['auditorTeams'] == null
      ? null
      : AuditorTeam.fromJson(json['auditorTeams'] as Map<String, dynamic>),
  offices: (json['offices'] as List<dynamic>?)
      ?.map((e) => Office.fromJson(e as Map<String, dynamic>))
      .toList(),
  auditableOffices:
      (json['auditableOffices'] as List<dynamic>?)
          ?.map((e) => AuditableOffices.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  auditSchduleDetails:
      (json['auditSchduleDetails'] as List<dynamic>?)
          ?.map((e) => AuditScheduleDetails.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$AuditSchedulesToJson(
  AuditSchedules instance,
) => <String, dynamic>{
  'id': instance.id,
  'purpose': instance.purpose,
  'auditTitle': instance.auditTitle,
  'startDate': const DateTimeConverter().toJson(instance.startDate),
  'endDate': const DateTimeConverter().toJson(instance.endDate),
  'isActive': instance.isActive,
  'isDeleted': instance.isDeleted,
  'rowVersion': instance.rowVersion,
  'auditPlanId': instance.auditPlanId,
  'auditorTeams': instance.auditorTeams?.toJson(),
  'offices': instance.offices?.map((e) => e.toJson()).toList(),
  'auditableOffices': instance.auditableOffices.map((e) => e.toJson()).toList(),
  'auditSchduleDetails': instance.auditSchduleDetails
      .map((e) => e.toJson())
      .toList(),
};
