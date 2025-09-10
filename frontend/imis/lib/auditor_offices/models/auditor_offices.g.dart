// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auditor_offices.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditorOffices _$AuditorOfficesFromJson(Map<String, dynamic> json) =>
    AuditorOffices(
      (json['id'] as num).toInt(),
      (json['auditorId'] as num).toInt(),
      (json['officeId'] as num).toInt(),
      (json['pgsPeriodId'] as num).toInt(),
      isDeleted: json['isDeleted'] as bool?,
      rowVersion: json['rowVersion'] as String?,
    );

Map<String, dynamic> _$AuditorOfficesToJson(AuditorOffices instance) =>
    <String, dynamic>{
      'id': instance.id,
      'auditorId': instance.auditorId,
      'officeId': instance.officeId,
      'pgsPeriodId': instance.pgsPeriodId,
      'isDeleted': instance.isDeleted,
      'rowVersion': instance.rowVersion,
    };
