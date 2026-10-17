// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auditable_offices.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditableOffices _$AuditableOfficesFromJson(Map<String, dynamic> json) =>
    AuditableOffices(
      id: (json['id'] as num).toInt(),
      auditScheduleId: (json['auditScheduleId'] as num).toInt(),
      officeId: (json['officeId'] as num).toInt(),
      isDeleted: json['isDeleted'] as bool,
      rowVersion: json['rowVersion'] as String?,
    );

Map<String, dynamic> _$AuditableOfficesToJson(AuditableOffices instance) =>
    <String, dynamic>{
      'id': instance.id,
      'auditScheduleId': instance.auditScheduleId,
      'officeId': instance.officeId,
      'isDeleted': instance.isDeleted,
      'rowVersion': instance.rowVersion,
    };
