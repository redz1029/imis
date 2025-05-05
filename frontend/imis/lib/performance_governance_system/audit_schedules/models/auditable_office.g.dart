// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auditable_office.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditableOffice _$AuditableOfficeFromJson(Map<String, dynamic> json) =>
    AuditableOffice(
      auditScheduleId: (json['auditScheduleId'] as num?)?.toInt(),
      officeId: (json['officeId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AuditableOfficeToJson(AuditableOffice instance) =>
    <String, dynamic>{
      'auditScheduleId': instance.auditScheduleId,
      'officeId': instance.officeId,
    };
