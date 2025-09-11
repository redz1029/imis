// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auditor_offices.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditorOffices _$AuditorOfficesFromJson(Map<String, dynamic> json) =>
    AuditorOffices(
      id: (json['id'] as num).toInt(),
      auditorId: (json['auditorId'] as num).toInt(),
      officeId: (json['officeId'] as num).toInt(),
      pgsPeriodId: (json['pgsPeriodId'] as num).toInt(),
      isOfficeHead: json['isOfficeHead'] as bool?,
      isDeleted: json['isDeleted'] as bool?,
      rowVersion: json['rowVersion'] as String?,
    );

Map<String, dynamic> _$AuditorOfficesToJson(AuditorOffices instance) =>
    <String, dynamic>{
      'id': instance.id,
      'auditorId': instance.auditorId,
      'officeId': instance.officeId,
      'pgsPeriodId': instance.pgsPeriodId,
      'isOfficeHead': instance.isOfficeHead,
      'isDeleted': instance.isDeleted,
      'rowVersion': instance.rowVersion,
    };
